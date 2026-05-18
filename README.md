# web 此分支开箱即用

个人网站项目，前台包括博客、代码库、文件下载、留言、登录注册等功能，后台包括上传文件、博客、代码，编辑、删除文章，查看、修改个人资料及邮箱、头像等功能。

交流答疑QQ群：951623031。

[点击加入：Java全栈开发学习交流](//shang.qq.com/wpa/qunwpa?idkey=41068b9adb14521cab1ebfea385e3e4aabf466115ba5278ca4d41a605506c096)

------------

## [点击跳转至postgresql分支开箱即用版](https://github.com/CrazyHusen/web/tree/web-psql) 

------------

## 主要文件结构如下

- `docs` -> 说明文档
- `web-core` -> 后端Java源代码
- `web-mobile` -> 响应式界面源码（在web和移动端是响应式布局）
- `web-pc` -> pc端界面源码（非响应式布局）

------------

## 快速配置方法：

- 1、下载项目源码或者打包好的war包

- 2、安装MySQL数据库（推荐8.0），创建一个数据库(自定义名称，如`web_test`)
    - 创建数据库用户并授权（MySQL 8.0 需指定认证插件）：
    ```sql
    CREATE USER IF NOT EXISTS 'web_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
    GRANT ALL PRIVILEGES ON web_test.* TO 'web_user'@'localhost';
    FLUSH PRIVILEGES;
    ```
    > **注意：** 项目使用的 mysql-connector-java 驱动版本较旧，不支持 MySQL 8.0 默认的 `caching_sha2_password` 认证插件，必须使用 `mysql_native_password`。

- 3、按照`docs/数据库部署`文件夹里面的步骤依次运行SQL脚本（先建表，再导入初始数据）

- 4、修改 `web-pc/config/mysql_connect_info.properties` 和 `web-mobile/config/mysql_connect_info.properties` 中的数据库连接信息（URL、数据库名、用户名、密码）

- 5、修改 `web-pc/config/config.properties` 和 `web-mobile/config/config.properties` 中的邮箱配置（用于站内信功能）

- 6、web-core打成jar包，Idea可参考 https://hacpai.com/article/1571129510972 ，然后放到 `web-pc/WebContent/WEB-INF/lib/` 和 `web-mobile/WebContent/WEB-INF/lib/` 目录下

- 7、打包web-pc/web-mobile成war包，放在Tomcat等容器下运行
    - 并将 `config` 文件夹复制到 `webapps/` 目录下（与你的web项目同级，即 `webapps/config/`）
    - 将war包部署为ROOT应用（去掉项目名称），或直接放到 `webapps/` 目录

- 8、启动Tomcat，访问 http://localhost:8080 即可

- 9、体验账户：用户名 `husen`，密码 `123123`

> 更详细的配置说明请参考 **项目配置运行指南.md**
