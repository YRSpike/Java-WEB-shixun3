# ============================================
# Project Build & Deploy Script (PowerShell)
# ============================================
# Usage:
#   .\build.ps1 build        - Compile backend + deploy frontend + restart
#   .\build.ps1 start        - Start Tomcat server
#   .\build.ps1 stop         - Stop Tomcat server
#   .\build.ps1 restart      - Restart Tomcat server
#   .\build.ps1 status       - Check if server is running
# ============================================

param([string]$action = "build")

$ErrorActionPreference = "Stop"

# ---- Path Config (auto-detect) ----
$PROJECT_ROOT = $PSScriptRoot
$WEB_CORE    = "$PROJECT_ROOT\web-core"
$WEB_PC      = "$PROJECT_ROOT\web-pc"

# JAVA_HOME: use env var if set, else auto-detect from registry
if (-not $env:JAVA_HOME) {
    $jdkDirs = @(
        "C:\Program Files\Java\jdk-23",
        "C:\Program Files\Java\jdk-21",
        "C:\Program Files\Java\jdk-17"
    )
    foreach ($d in $jdkDirs) { if (Test-Path $d) { $env:JAVA_HOME = $d; break } }
    if (-not $env:JAVA_HOME) { throw "JAVA_HOME not set and no JDK found in default paths. Please set JAVA_HOME environment variable." }
}
$JAVA_HOME = $env:JAVA_HOME

# TOMCAT: use env var if set, else check common paths
if (-not $env:CATALINA_HOME) {
    $tomcatDirs = @(
        "E:\tomcat\apache-tomcat-9.0.118",
        "C:\tomcat\apache-tomcat-9.0.118",
        "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
    )
    foreach ($d in $tomcatDirs) { if (Test-Path $d) { $env:CATALINA_HOME = $d; break } }
    if (-not $env:CATALINA_HOME) { throw "CATALINA_HOME not set and Tomcat not found in default paths. Please set CATALINA_HOME environment variable." }
}
$TOMCAT = $env:CATALINA_HOME

$ROOT_DIR      = "$TOMCAT\webapps\ROOT"
$TOMCAT_PORT   = 8080

# Find bash.exe (Git Bash) - common install paths
$BASH_EXE = $null
$bashPaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files (x86)\Git\bin\bash.exe",
    "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe"
)
foreach ($p in $bashPaths) {
    if (Test-Path $p) { $BASH_EXE = $p; break }
}
# Also check PATH
if (-not $BASH_EXE) {
    $fromPath = (Get-Command bash -ErrorAction SilentlyContinue).Source
    if ($fromPath) { $BASH_EXE = $fromPath }
}

# Helper: run a command, suppressing all output including JDK notes
function Invoke-Silent {
    param([string]$Exe, [string]$Arguments)
    $prevEAP = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    if ($Exe -and (Test-Path $Exe)) {
        & $Exe $Arguments.Split(' ') *>&1 | Out-Null
    }
    $ErrorActionPreference = $prevEAP
}

# ============================================
# Build-Backend
# ============================================
function Build-Backend {
    Write-Host "[1/4] Compiling Java sources..." -ForegroundColor Yellow

    $libs = Get-ChildItem "$WEB_CORE\libs\*\*.jar" | ForEach-Object { $_.FullName }
    $classpath = $libs -join ";"

    $sources = Get-ChildItem "$WEB_CORE\src\*.java" -Recurse | ForEach-Object { $_.FullName }
    $sourcesFile = "$env:TEMP\java_sources.txt"
    # Write without BOM to avoid javac parsing issues
    [System.IO.File]::WriteAllLines($sourcesFile, $sources, [System.Text.UTF8Encoding]::new($false))

    $buildDir = "$WEB_CORE\build\classes"
    if (Test-Path $buildDir) { Remove-Item -Recurse -Force $buildDir }
    New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

    $javac = "$JAVA_HOME\bin\javac.exe"
    & $javac -encoding UTF-8 -cp $classpath -d $buildDir "@$sourcesFile"
    if ($LASTEXITCODE -ne 0) { throw "Compilation failed" }
    Write-Host "    OK ($($sources.Count) files compiled)" -ForegroundColor Green

    Write-Host "[2/4] Packaging web-core.jar..." -ForegroundColor Yellow
    $jar = "$JAVA_HOME\bin\jar.exe"
    Push-Location $buildDir
    & $jar cfm "$WEB_CORE\build\web-core.jar" "$WEB_CORE\src\META-INF\MANIFEST.MF" .
    Pop-Location
    Write-Host "    OK" -ForegroundColor Green

    Write-Host "[3/4] Copying JAR..." -ForegroundColor Yellow
    Copy-Item -Force "$WEB_CORE\build\web-core.jar" "$WEB_PC\WebContent\WEB-INF\lib\web-core.jar"
    Copy-Item -Force "$WEB_CORE\build\web-core.jar" "$ROOT_DIR\WEB-INF\lib\web-core.jar"
    Write-Host "    OK" -ForegroundColor Green
}

# ============================================
# Deploy-Frontend
# ============================================
function Deploy-Frontend {
    Write-Host "[4/4] Syncing frontend files..." -ForegroundColor Yellow

    & robocopy "$WEB_PC\WebContent\" "$ROOT_DIR\" /MIR /XD "WEB-INF\lib" /NJH /NJS /NP /NDL /NS 2>$null
    if ($LASTEXITCODE -ge 8) { throw "Sync failed" }

    Remove-Item -Force "$ROOT_DIR\WEB-INF\lib\servlet-api.jar" -ErrorAction SilentlyContinue
    Write-Host "    OK" -ForegroundColor Green
}

# ============================================
# Start / Stop / Restart Tomcat
# ============================================
function Start-Tomcat {
    if (Test-TomcatRunning) {
        Write-Host "Tomcat is already running at http://localhost:$TOMCAT_PORT/" -ForegroundColor Cyan
        return
    }
    Write-Host "Starting Tomcat..." -ForegroundColor Yellow
    $env:JAVA_HOME = $JAVA_HOME
    $env:JRE_HOME  = $JAVA_HOME

    $startupSh = "$TOMCAT\bin\startup.sh"
    $startupBat = "$TOMCAT\bin\startup.bat"

    if ($BASH_EXE -and (Test-Path $startupSh)) {
        Invoke-Silent $BASH_EXE $startupSh
    } elseif (Test-Path $startupBat) {
        Invoke-Silent "cmd.exe" "/c `"$startupBat`""
    } else {
        Write-Host "ERROR: Cannot find startup script" -ForegroundColor Red
        return
    }

    # Wait up to 30 seconds for startup
    $waited = 0
    while ((-not (Test-TomcatRunning)) -and ($waited -lt 30)) {
        Start-Sleep -Seconds 1
        $waited++
    }
    if (Test-TomcatRunning) {
        Write-Host "Tomcat started (${waited}s): http://localhost:$TOMCAT_PORT/" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Tomcat may have failed to start, check logs:" -ForegroundColor Red
        Write-Host "  $TOMCAT\logs\catalina.out" -ForegroundColor Gray
    }
}

function Stop-Tomcat {
    if (-not (Test-TomcatRunning)) {
        Write-Host "Tomcat is not running." -ForegroundColor Cyan
        return
    }
    Write-Host "Stopping Tomcat..." -ForegroundColor Yellow
    $env:JAVA_HOME = $JAVA_HOME
    $env:JRE_HOME  = $JAVA_HOME

    $shutdownSh = "$TOMCAT\bin\shutdown.sh"
    $shutdownBat = "$TOMCAT\bin\shutdown.bat"

    if ($BASH_EXE -and (Test-Path $shutdownSh)) {
        Invoke-Silent $BASH_EXE $shutdownSh
    } elseif (Test-Path $shutdownBat) {
        Invoke-Silent "cmd.exe" "/c `"$shutdownBat`""
    }

    Start-Sleep -Seconds 2

    # If still running, find and kill the Java process
    if (Test-TomcatRunning) {
        # Look for java processes with catalina.home or tomcat
        $javaProcs = Get-Process java -ErrorAction SilentlyContinue | Where-Object {
            $_.Id -ne 0
        }
        if ($javaProcs) {
            Write-Host "    Killing $($javaProcs.Count) Java process(es)..." -ForegroundColor Gray
            $ErrorActionPreference = "Continue"
            $javaProcs | ForEach-Object {
                Write-Host "      PID $($_.Id): $($_.ProcessName)" -ForegroundColor Gray
                Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
            }
            $ErrorActionPreference = "Stop"
            Start-Sleep -Seconds 2
        }
    }

    # Wait up to 10 seconds for shutdown
    $waited = 0
    while ((Test-TomcatRunning) -and ($waited -lt 10)) {
        Start-Sleep -Seconds 1
        $waited++
    }
    if (Test-TomcatRunning) {
        Write-Host "WARNING: Tomcat did not stop gracefully (port $TOMCAT_PORT still in use)" -ForegroundColor Red
        Write-Host "  Run: Get-NetTCPConnection -LocalPort $TOMCAT_PORT" -ForegroundColor Gray
    } else {
        Write-Host "Tomcat stopped." -ForegroundColor Green
    }
}

function Restart-Tomcat {
    Stop-Tomcat
    Start-Tomcat
}

function Test-TomcatRunning {
    try {
        $r = Invoke-WebRequest -Uri "http://localhost:$TOMCAT_PORT/" -TimeoutSec 3 -UseBasicParsing
        return ($r.StatusCode -eq 200)
    } catch {
        return $false
    }
}

function Show-Status {
    if (Test-TomcatRunning) {
        Write-Host "Tomcat: RUNNING  |  http://localhost:$TOMCAT_PORT/" -ForegroundColor Green
    } else {
        Write-Host "Tomcat: STOPPED" -ForegroundColor Red
    }
}

# ============================================
# Main
# ============================================
Write-Host ""
switch ($action) {
    "build" {
        Write-Host "========== BUILD & DEPLOY ==========" -ForegroundColor Cyan
        Build-Backend
        Deploy-Frontend
        Restart-Tomcat
        Write-Host "========== DONE ==========" -ForegroundColor Cyan
        Write-Host "http://localhost:8080/" -ForegroundColor White
    }
    "start" {
        Start-Tomcat
    }
    "stop" {
        Stop-Tomcat
    }
    "restart" {
        Restart-Tomcat
    }
    "status" {
        Show-Status
    }
    default {
        Write-Host "Usage: .\build.ps1 [build|start|stop|restart|status]" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  build   - Compile + deploy + restart" -ForegroundColor White
        Write-Host "  start   - Start Tomcat" -ForegroundColor White
        Write-Host "  stop    - Stop Tomcat" -ForegroundColor White
        Write-Host "  restart - Restart Tomcat" -ForegroundColor White
        Write-Host "  status  - Check if Tomcat is running" -ForegroundColor White
    }
}
Write-Host ""
