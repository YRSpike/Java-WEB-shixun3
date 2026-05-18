<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>NovaTech Blog</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta name="description"
	content="专注于编程、前端、Java、人工智能与开发经验分享的现代技术博客。">
<meta name="keywords"
	content="Java, SpringBoot, 前端开发, Vue, AI, 编程博客">
<meta name="author" content="NovaTech">

<!-- 网站图标 -->
<link rel="shortcut icon" href="/images/favicon.ico">

<!-- jQuery -->
<script src="/plugins/jquery/js/jquery-3.2.1.min.js"></script>

<!-- Bootstrap -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js"></script>

<!-- 自定义CSS -->
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	background: #0f172a;
	color: #fff;
	font-family: "PingFang SC", "Microsoft YaHei", sans-serif;
	overflow-x: hidden;
}

/* ===== 顶部 Banner ===== */
.hero {
	position: relative;
	height: 100vh;
	background:
		linear-gradient(rgba(15, 23, 42, 0.75),
		rgba(15, 23, 42, 0.85)),
		url('/images/banner/banner-1.jpg') center/cover no-repeat;
	display: flex;
	align-items: center;
	justify-content: center;
	text-align: center;
}

.hero-content h1 {
	font-size: 68px;
	font-weight: bold;
	letter-spacing: 3px;
	margin-bottom: 20px;
	background: linear-gradient(90deg, #38bdf8, #818cf8);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
}

.hero-content p {
	font-size: 22px;
	color: #cbd5e1;
	margin-bottom: 35px;
}

.hero-btn {
	display: inline-block;
	padding: 14px 40px;
	border-radius: 40px;
	background: linear-gradient(90deg, #0ea5e9, #6366f1);
	color: white;
	font-size: 18px;
	text-decoration: none;
	transition: 0.3s;
}

.hero-btn:hover {
	transform: translateY(-3px);
	box-shadow: 0 10px 30px rgba(99, 102, 241, 0.5);
	color: white;
	text-decoration: none;
}

/* ===== 内容区域 ===== */
.section {
	padding: 80px 8%;
}

.section-title {
	font-size: 40px;
	font-weight: bold;
	margin-bottom: 50px;
	position: relative;
	display: inline-block;
}

.section-title:after {
	content: "";
	position: absolute;
	left: 0;
	bottom: -10px;
	width: 70%;
	height: 4px;
	background: linear-gradient(90deg, #38bdf8, #818cf8);
	border-radius: 5px;
}

/* ===== 卡片 ===== */
.blog-card {
	background: rgba(255,255,255,0.05);
	border-radius: 24px;
	overflow: hidden;
	backdrop-filter: blur(10px);
	transition: 0.35s;
	margin-bottom: 30px;
	border: 1px solid rgba(255,255,255,0.08);
}

.blog-card:hover {
	transform: translateY(-10px);
	box-shadow: 0 15px 40px rgba(0,0,0,0.4);
}

.blog-card img {
	width: 100%;
	height: 220px;
	object-fit: cover;
}

.blog-content {
	padding: 25px;
}

.blog-content h3 {
	font-size: 24px;
	margin-bottom: 15px;
	font-weight: bold;
}

.blog-content p {
	color: #cbd5e1;
	line-height: 1.8;
	font-size: 15px;
}

.read-btn {
	display: inline-block;
	margin-top: 20px;
	color: #38bdf8;
	text-decoration: none;
	font-weight: bold;
}

.read-btn:hover {
	color: #818cf8;
	text-decoration: none;
}

/* ===== Footer ===== */
.footer {
	padding: 40px;
	text-align: center;
	color: #94a3b8;
	border-top: 1px solid rgba(255,255,255,0.08);
	background: #020617;
}

/* ===== 每日一句 ===== */
.hitokoto-box {
	margin-top: 70px;
	padding: 30px;
	border-radius: 20px;
	background: rgba(255,255,255,0.05);
	text-align: center;
	font-size: 18px;
	color: #e2e8f0;
}
</style>

</head>

<body>

	<!-- Hero Banner -->
	<section class="hero">
		<div class="hero-content">
			<h1>NovaTech Blog</h1>
			<p>探索编程 · 人工智能 · 前端开发 · 技术成长</p>
			<a href="/module/blog.hms" class="hero-btn">开始阅读</a>
		</div>
	</section>

	<!-- 最新博客 -->
	<section class="section">
		<h2 class="section-title">最新技术文章</h2>

		<div class="row">

			<div class="col-md-4">
				<div class="blog-card">
					<img src="/images/blog/blog-1.jpg">
					<div class="blog-content">
						<h3>SpringBoot 微服务架构实践</h3>
						<p>
							从零搭建现代 SpringCloud 微服务体系，包含网关、认证、配置中心与容器部署方案。
						</p>
						<a href="#" class="read-btn">阅读全文 →</a>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="blog-card">
					<img src="/images/blog/blog-2.jpg">
					<div class="blog-content">
						<h3>Vue3 + Vite 高性能前端</h3>
						<p>
							深入理解 Vue3 Composition API，并结合 Vite 构建企业级现代化前端项目。
						</p>
						<a href="#" class="read-btn">阅读全文 →</a>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="blog-card">
					<img src="/images/blog/blog-3.jpg">
					<div class="blog-content">
						<h3>AI 开发工具全面解析</h3>
						<p>
							介绍 Cursor、Copilot、ChatGPT 等 AI 工具如何提升开发效率与代码质量。
						</p>
						<a href="#" class="read-btn">阅读全文 →</a>
					</div>
				</div>
			</div>

		</div>

		<!-- 每日一句 -->
		<div class="hitokoto-box">
			<script
				src="https://api.lwl12.com/hitokoto/main/get?encode=js&charset=utf-8"></script>
			<div id="lwlhitokoto">
				<script>
					lwlhitokoto();
				</script>
			</div>
		</div>

	</section>

	<!-- 最新代码 -->
	<section class="section">
		<h2 class="section-title">热门开源代码</h2>

		<div class="row">

			<div class="col-md-4">
				<div class="blog-card">
					<img src="/images/code/code-1.jpg">
					<div class="blog-content">
						<h3>Java 权限管理系统</h3>
						<p>
							基于 SpringBoot + JWT + MySQL 构建的完整后台权限管理项目。
						</p>
						<a href="#" class="read-btn">查看源码 →</a>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="blog-card">
					<img src="/images/code/code-2.jpg">
					<div class="blog-content">
						<h3>响应式博客模板</h3>
						<p>
							适配 PC 与移动端的现代博客 UI，支持暗黑模式与动态主题切换。
						</p>
						<a href="#" class="read-btn">查看源码 →</a>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="blog-card">
					<img src="/images/code/code-3.jpg">
					<div class="blog-content">
						<h3>AI 智能问答系统</h3>
						<p>
							基于 OpenAI API 构建的智能聊天系统，支持上下文与知识库检索。
						</p>
						<a href="#" class="read-btn">查看源码 →</a>
					</div>
				</div>
			</div>

		</div>
	</section>

	<!-- Footer -->
	<footer class="footer">
		<p>© 2026 NovaTech Blog · Designed with Modern UI</p>
	</footer>

</body>
</html>