## README

- 前后端分离项目目录结构如下：

```shell
├─simpleSystem-Springboot
│  └─src
│      └─main
│          ├─java
│          │  └─cn
│          │      └─simpleSystem
│          │          └─springboot_demo
│          │              ├─config
│          │              ├─controller
│          │              ├─DAO
│          │              ├─entity
│          │              ├─services
│          │              └─utils
│          └─resources
└─simpleSystem-vue
    ├─public
    └─src
        ├─assets
        ├─components
        └─routes
```



- 后端项目放置在`simpleSystem-Springboot`中:

  建议使用`idea`运行，只需配置好`JDK17`，以及``maven`配置，即可直接执行。

  <img src="C:\Users\13030\AppData\Roaming\Typora\typora-user-images\image-20231227195413524.png" alt="image-20231227195413524" style="zoom:50%;" />

  

  可执行文件为`./src/main/java/cn/simpleSystem/springboot_demo/utils/SpringbootDemoApplication.java`

  

  连接数据库的配置在`../resources/application.yaml`中。可设置登陆数据库的地址，用户名，以及密码。

  

- 前端项目放置在`simpleSystem-vue`中：

  在`./simpleSystem-vue`目录下使用`npm install`安装依赖，然后使用`npm run dev`即可运行。

