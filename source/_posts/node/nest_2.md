---
title: nest.js学习（二）
date: 2021-01-29 18:20
index_img: https://fang-kang.gitee.io/blog-img/nest2.png
tags:
 - node
 - nest
categories:
  - node
---

这篇主要内容：

- 项目架构规划
- 入口文件配置说明
- 依赖安装
- 配置模板引擎和静态文件
- 静态模板
- 系统配置和应用配置
- 数据库之用户表
- 注册
- 使用node-mailer发送邮件
- 登录和第三方认证github登录
- session和cookie
- 找回密码和登出

## 项目架构规划设计

一个好的文件结构约定，会让我们开发合作、维护管理，节省很多不必要沟通。

这里我`src`文件规划：

| 文件                   | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| main.ts                | 入口                                                         |
| main.hmr.ts            | 热更新入口                                                   |
| app.service.ts         | APP服务（选择）                                              |
| app.module.ts          | APP模块（根模块，必须）                                      |
| app.controller.ts      | APP控制器（选择）                                            |
| app.controller.spec.ts | APP控制器单元测试用例（选择）                                |
| config                 | 配置模块                                                     |
| core                   | 核心模块（申明过滤器、管道、拦截器、守卫、中间件、全局模块） |
| feature                | 特性模块（主要业务模块）                                     |
| shared                 | 共享模块（共享mongodb、redis封装服务、通用服务）             |
| tools                  | 工具（提供一些小工具函数）                                   |

> 这是我参考我`Angular`项目的结构，写了几个`nest`项目后发现这个很不错。把`mongodb`服务和业务模块分开，还有一个好处就是减少`nest`循环依赖注入深坑，后面会讲怎么解决它。

## 入口文件配置说明

打开`main.ts`文件

```ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
```

`NestFactory` 创建一个app实例，监听`3000`端口。

```ts
/**
 * Creates an instance of the NestApplication
 * @returns {Promise}
 */
create(module: any): Promise<INestApplication & INestExpressApplication>;
create(module: any, options: NestApplicationOptions): Promise<INestApplication & INestExpressApplication>;
create(module: any, httpServer: FastifyAdapter, options?: NestApplicationOptions): Promise<INestApplication & INestFastifyApplication>;
create(module: any, httpServer: HttpServer, options?: NestApplicationOptions): Promise<INestApplication & INestExpressApplication>;
create(module: any, httpServer: any, options?: NestApplicationOptions): Promise<INestApplication & INestExpressApplication>;
```

`create`方法有1-3参数，第一个是入口模块`AppModule`, 第二个是一个`httpServer`,如果要绑定`Express`中间件，需要传递`Express`实例。第三个全局配置：

- logger 打印日志
- cors 跨域配置
- bodyParser post和put解析body中间件配置
- httpsOptions https配置

`app` 带方法有哪些
`INestApplication`下

- init 初始化应用程序，直接调用此方法并非强制。（效果不明）
- use 注册中间件
- enableCors 启用CORS（跨源资源共享）
- listen 启动应用程序。
- listenAsync 同步启动应用程序。
- setGlobalPrefix 注册每个HTTP路由路径的前缀
- useWebSocketAdapter 安装将在网关内部使用的Ws适配器。使用时覆盖，默认`socket.io`库。
- connectMicroservice 将微服务连接到NestApplication实例。 将应用程序转换为混合实例。
- getMicroservices 返回连接到NestApplication的微服务的数组。
- getHttpServer 返回基础的本地HTTP服务器。
- startAllMicroservices 异步启动所有连接的微服务
- startAllMicroservicesAsync 同步启动所有连接的微服务
- useGlobalFilters 将异常过滤器注册为全局过滤器（将在每个HTTP路由处理程序中使用）
- useGlobalPipes 将管道注册为全局管道（将在每个HTTP路由处理程序中使用）
- useGlobalInterceptors 将拦截器注册为全局拦截器（将在每个HTTP路由处理器中使用）
- useGlobalGuards 注册警卫作为全局警卫（将在每个HTTP路由处理程序中使用）
- close 终止应用程序（包括NestApplication，网关和每个连接的微服务）
  `INestExpressApplication`下
- set 围绕本地`express.set()`方法的包装函数。
- engine 围绕本地`express.engine()`方法的包装函数。
- enable 围绕本地`express.enable()`方法的包装函数。
- disable 围绕本地`express.disable()`方法的包装函数。
- useStaticAssets 为静态资源设置基础目录。围绕本地`express.static(path, options)`方法的包装函数。
- setBaseViewsDir 设置模板（视图）的基本目录。围绕本地`express.set('views', path)`方法的包装函数。
- setViewEngine 为模板（视图）设置视图引擎。围绕本地`express.set('view engine', engine)`方法的包装函数。

## 依赖安装

### 核心依赖

因为目前CNode采用`Egg`编写，里面大量使用与`Egg`集成的`egg-xxx`包，这里我把相关的连对应的依赖都一一来出来。

#### 模板引擎

`Egg-CNode`使用`egg-view-ejs`，本项目使用`ejs`包，唯一缺点没有`layout`功能，可以麻烦点，在每个文件引入头和尾即可，也有另外一个包`ejs-mate`，它有`layout`功能，后面会介绍它怎么使用。

#### redis

```bash
Egg-CNode`使用`egg-redis`操作`redis`，其实它是包装的`ioredis`包，我也一直在nodejs里使用这个包，需要安装生产`ioredis`和开发`@types/ioredis
```

#### mongoose

```bash
Egg-CNode`使用`egg-mongoose`操作`mongodb`，`Nest`提供了`@nestjs/mongoose`，需要安装生产`mongoose`和开发`@types/mongoose
```

#### passport

```bash
Egg-CNode`使用`egg-passport、egg-passport-github、egg-passport-local`做身份验证，`Nest`提供了`@nestjs/passport`，需要安装生产`passport、passport-github、passport-local
```

其他依赖在后面用到时候在详细介绍，这几个是比较重要的依赖。

## 配置 Views 视图模板和 public 静态资源

`CNode` 使用的是`egg-ejs`,为了简单点，减少静态文件编写，我也用`ejs`。发现区别就是少了`layout`功能，需要我们拆分`layout/header.ejs`和`layout/footer.ejs`在使用了。
但是有一个包可以做到类似的功能`ejs-mate`，这个是[@JacksonTian](https://github.com/JacksonTian) 朴灵大神的作品。

新建模板存放`views`文件夹(root/views)和静态资源存放`public`文件夹(root/public)

**注意**：`nest-cli`默认只处理`src`里面的ts文件，如有其他文件需要自己写脚本处理，`gulp`或者`webpack`都可以，这里就简单一点，直接把`views`和`public`放在`src`平级的根目录里面了。后面会说怎么处理它们设置问题。

### 模板引擎

安装`ejs-mate`依赖：

```bash
npm install ejs-mate --save
```

用法很简单了，关于文件名后缀，默认使用`.ejs`，`.ejs`虽然会让它语法高亮，有个坑就`html`标签不会自动补全提示。那需要换成`.html`后缀。

设置模板引擎：

```js
import { join } from 'path';
import * as ejsMate from 'ejs-mate';
async function bootstrap() {
    ....
      // 获取根目录 nest-cnode
    const rootDir = join(__dirname, '..');
    // 指定视图引擎 处理.html后缀文件
    app.engine('html', ejsMate);
    // 视图引擎
    app.set('view engine', 'html');
    // 配置模板（视图）的基本目录
    app.setBaseViewsDir(join(rootDir, 'views'));
    ...
}
```

> **注意**：当前启动程序是`src/main.ts`，因为`views`和`public`在根目录，所有我们就需要去获取获取根目录。其他注释已经说明，就不再赘述。

使用模板引擎：

1. 我们在`views`文件夹里面新建一个`layout.html`和一个`index.html`。
2. 写通用的`layout.html`

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我是layout模板</title>
</head>
<body>
    <%- body -%>
</body>
```

1. 写的`index.html`

```html
<% layout('layout') -%>
<h1>我是首页</h1>  
```

1. 渲染模板引擎

```ts
import { Get, Controller, Render } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @Render('index')
  root() {
    return {};
  }
}
```

**注意**：`@Render()`里面一定要写模板文件名(可以省略后缀)，不然访问页面显示是`json`对象。

访问首页`http://localhost:3000/`看结果。

[![3nc4l2 l_nbp_di0fkomamc](https://user-images.githubusercontent.com/6111778/44764383-043ced00-ab82-11e8-8ae4-35d9cedcd26d.png)](https://user-images.githubusercontent.com/6111778/44764383-043ced00-ab82-11e8-8ae4-35d9cedcd26d.png)

`ejs-mate`语法：

`ejs-mate`兼容[ejs](https://ejs.bootcss.com/)语法，语法很简单，这里顺便带一下：

- <% '脚本' 标签，用于流程控制，无输出。
- <%_ 删除其前面的空格符
- <%= 输出数据到模板（输出是转义 HTML 标签）
- <%- 输出非转义的数据到模板
- <%# 注释标签，不执行、不输出内容
- <%% 输出字符串 '<%'
- %> 一般结束标签
- -%> 删除紧随其后的换行符
- _%> 将结束标签后面的空格符删除

说几个常用的写法：

```bash
<% 直接写js代码，不输出：%>

<ul>
  <% users.forEach(function(user){ %>
    <%- include('user/show', {user: user}); %>
  <% }); %>
</ul>

<%# 输出变量：%>

<%= '变量' %>

<%# 输出HTML：%>

<%- '<h1>标题</h1>' %>

<%# 引入其他ejs文件（注意：2个参数，第一个是路径：相对于当前模板路径中的模板片段包含进来；第二个是传递数据对象。）：%>

<%- include('user/show', {user: user}); %>
```

说明：

**注意**：以上语法基本一样，有一样不一样，`include`需要用`partial`代替。他们俩用法一模一样。

`layout`功能，需要在引用的页面，比如`index.html`里面使用`<% layout('layout') -%>`，**注意**：这里`'layout'`是指`layout.html`。

还有一个比较重要的功能是`block`。它是在指定的位置插入自定义内容。类似于`angularjs`的`transclude`，`angular`的`<ng-content select="[xxx]"></ng-content>`，`vue`的`<slot></slot>`。

`slot`写法：

```html
<%- block('head').toString() %>
```

`block('head')`，是一个占位标识符，`toString`是合并所有的插入使用`join`转成字符串。

使用：

```html
<% block('head').append('<link type="text/css" href="/append.css">') %>
<% block('head').prepend('<link type="text/css" href="/prepend.css">') %>
```

`append`和`prepend`是插入的顺序，`append`总是插槽位置插入在最后，`prepend`总是插槽位置插入在最前。

我们来验证一下。

现在`layout.html`的`head`里面写上

```html
<head>
    ...
    <link type="text/css" href="/style.css">
    <%- block('head').toString() %>
</head>
```

`index.html`的结尾写上

```html
...
<% block('head').append('<link type="text/css" href="/append.css">') %>
<% block('head').prepend('<link type="text/css" href="/prepend.css">') %>
<% block('head').prepend('<link type="text/css" href="/prepend2.css">') %>
<% block('head').append('<link type="text/css" href="/append2.css">') %>  
```

访问首页`http://localhost:3000/`看结果。

[![7d kp 0rh t 7 i4](https://user-images.githubusercontent.com/6111778/44764409-1ae34400-ab82-11e8-9177-aba90b3d799d.png)](https://user-images.githubusercontent.com/6111778/44764409-1ae34400-ab82-11e8-9177-aba90b3d799d.png)

**注意**：`index.html`里书写`block('head').append`的位置不影响它显示插槽的位置，只受定义插槽`<%- block('head').toString() %>`

还有一个方法`replace`，没看懂怎么用的，文档里面也没有说明，基本`append`、`prepend`、`toString`就够用了。

总结：`toString`是定义插槽位置，`append`、`prepend`往插槽插入指定的内容。他们主要做什么了，`layout`载入公共的`css`、`js`，如果有的页面有不一样地方，就需要插入当前页面的js了，那么一来这个插槽功能就有用，如果使用`layout`功能插入，就会包含在`layout`位置，无论是语义还是加载都是不合理的。就有了`block`的功能，在另一款模板引擎`Jade`里面也有同样的功能也叫`block`功能。

### 静态资源

`public`文件夹里面内容直接拷贝`egg-cnode`下的`public`的静态资源

还需要安装几个依赖：

```bash
npm i --save loader loader-connect loader-builder
```

这几个模块是加载css和js使用，也是[@JacksonTian](https://github.com/JacksonTian) 朴灵大神的作品。

main.ts配置

```ts
import { join } from 'path';

import * as loaderConnect from 'loader-connect';

async function bootstrap() {
  ...
  // 根目录 nest-cnode
  const rootDir = join(__dirname, '..');
  // 注意：这个要在express.static之前调用，loader2.0之后要使用loader-connect
  // 自动转换less为css
  if (isDevelopment) {
    app.use(loaderConnect.less(rootDir));
  }
  // 所有的静态文件路径都前缀"/public", 需要使用“挂载”功能
  app.use('/public', express.static(join(rootDir, 'public')));
  // 官方指定是这个 默认访问根目录
  // app.useStaticAssets(join(__dirname, '..', 'public'));
  ...
}
```

**注意**：如果静态文件路径都前缀`/public`，需要使用`use`去挂载`express.static`路径。只有`express`是这样的

```ts
  useStaticAssets(path: string, options: ServeStaticOptions) {
    return this.use(express.static(path, options));
  }
```

它的源码是这样写的，如果这样的，你的静态资源路径就是从根目录开始，如果需要加前缀`/public`，就需要`express`提供的[方式](http://expressjs.jser.us/4x_zh-cn/api.html#app.use)

测试我们静态资源路径设置是否正常工作

在`index.html`里面引入`public/images/logo.png`图片

```html
...
<img src="/public/images/logo.png" alt="logo">
...
```

[![l8p0 psc xxuk6 zyea0nvs](https://user-images.githubusercontent.com/6111778/44764424-2e8eaa80-ab82-11e8-9a94-44979c2265e6.png)](https://user-images.githubusercontent.com/6111778/44764424-2e8eaa80-ab82-11e8-9a94-44979c2265e6.png)

如果有问题，请找原因，路径是否正确，设置是否正确，如果都ok，还是不能访问，可以联系我。

关于`loader`使用：

```js
  <!-- style -->
  <%- Loader('/public/stylesheets/index.min.css')
  .css('/public/libs/bootstrap/css/bootstrap.css')
  .css('/public/stylesheets/common.css')
  .css('/public/stylesheets/style.less')
  .css('/public/stylesheets/responsive.css')
  .css('/public/stylesheets/jquery.atwho.css')
  .css('/public/libs/editor/editor.css')
  .css('/public/libs/webuploader/webuploader.css')
  .css('/public/libs/code-prettify/prettify.css')
  .css('/public/libs/font-awesome/css/font-awesome.css')
  .done(assets, config.site_static_host, config.mini_assets)
  %>

  <!-- scripts -->
  <%- Loader('/public/index.min.js')
  .js('/public/libs/jquery-2.1.0.js')
  .js('/public/libs/lodash.compat.js')
  .js('/public/libs/jquery-ujs.js')
  .js('/public/libs/bootstrap/js/bootstrap.js')
  .js('/public/libs/jquery.caret.js')
  .js('/public/libs/jquery.atwho.js')
  .js('/public/libs/markdownit.js')
  .js('/public/libs/code-prettify/prettify.js')
  .js('/public/libs/qrcode.js')
  .js('/public/javascripts/main.js')
  .js('/public/javascripts/responsive.js')
  .done(assets, config.site_static_host, config.mini_assets)
  %>
```

- `Loader`可以加载`.js`方法也可以加载`.coffee`、`.es`类型的文件，`.css`方法可以加载`.less`、`.styl`文件。
- `Loader('/public/index.min.js')`是合并后名字
- `.js('/public/libs/jquery-2.1.0.js')`是加载每一个文件地址
- `.done(assets, config.site_static_host, config.mini_assets)`是处理文件，第一个参数合并压缩后的路径（后面讲解），第二个参数静态文件服务器地址，第三个参数是否压缩

`assets`从哪里来

在`package.json`的`scripts`配置

```json
{
    ...
    "assets": "loader /views /"
}
```

loader的写法是：`loader <views_dir> <output_dir>`。`views_dir`是模板引擎目录，`output_dir`是`assets.json`文件输出的目录，`/`表示根目录。

```bash
npm run assets
```

直接运行会报错，这个问题在`egg-node`有人提[issues](https://github.com/cnodejs/egg-cnode/issues/129)

[![z90d4zb w t t26e_2 l](https://user-images.githubusercontent.com/6111778/44764434-3b130300-ab82-11e8-9322-088c7688949a.png)](https://user-images.githubusercontent.com/6111778/44764434-3b130300-ab82-11e8-9322-088c7688949a.png)

主要是静态资源`css`引用的背景图片和字体地址有错误，需要修改哪些文件：

错误信息：

```bash
no such file or directory, open 'E:\github\nest-cnode\E:\public\img\glyphicons-halflings.png'
```

谁引用了它 `Error! File:/public/libs/bootstrap/css/bootstrap.css`

/public/libs/bootstrap/css/bootstrap.css

```css
...
[class^="icon-"],
[class*=" icon-"] {
    display: inline-block;
    width: 14px;
    height: 14px;
    margin-top: 1px;
    *margin-right: .3em;
    line-height: 14px;
    vertical-align: text-top;
    background-image: url("/public/libs/bootstrap/img/glyphicons-halflings.png");
    background-position: 14px 14px;
    background-repeat: no-repeat;
}
...

.icon-white,
.nav-pills > .active > a > [class^="icon-"],
.nav-pills > .active > a > [class*=" icon-"],
.nav-list > .active > a > [class^="icon-"],
.nav-list > .active > a > [class*=" icon-"],
.navbar-inverse .nav > .active > a > [class^="icon-"],
.navbar-inverse .nav > .active > a > [class*=" icon-"],
.dropdown-menu > li > a:hover > [class^="icon-"],
.dropdown-menu > li > a:focus > [class^="icon-"],
.dropdown-menu > li > a:hover > [class*=" icon-"],
.dropdown-menu > li > a:focus > [class*=" icon-"],
.dropdown-menu > .active > a > [class^="icon-"],
.dropdown-menu > .active > a > [class*=" icon-"],
.dropdown-submenu:hover > a > [class^="icon-"],
.dropdown-submenu:focus > a > [class^="icon-"],
.dropdown-submenu:hover > a > [class*=" icon-"],
.dropdown-submenu:focus > a > [class*=" icon-"] {
    background-image: url("/public/libs/bootstrap/img/glyphicons-halflings-white.png");
}
...
```

大约`2296`和`2320`行位置，你可以用查找搜索`glyphicons-halflings.png`，默认是`background-image: url("../img/glyphicons-halflings.png");`, 替换为上面写法。

/public/stylesheets/style.less

```css
...
.navbar .search-query {
  -webkit-box-shadow: none;
  -moz-box-shadow: none;
  background: #888 url('/public/images/search.png') no-repeat 4px 4px;
  padding: 3px 5px 3px 22px;
  color: #666;
  border: 0px;
  margin-top: 2px;

  &:hover {
    background-color: white;
  }
  transition: all 0.5s;

  &:focus, &.focused {
    background-color: white;
  }
}
...
```

大约`850`行位置

> 简单解释就是换成相对于根目录的路径，后面错误就类似。

[![45 7el q a5ph tf g84r 0](https://user-images.githubusercontent.com/6111778/44764444-45350180-ab82-11e8-9f65-a6b319a11fec.png)](https://user-images.githubusercontent.com/6111778/44764444-45350180-ab82-11e8-9f65-a6b319a11fec.png)

打包成功以后会输出一个`assets.json`在根目录。`assets`指的就是这个json文件，后面我们会讲如果把它们关联起来。

## 静态模板

我们上面已经配置好了模板引擎和静态资源，我们先要去扩展他们，先让页面好看点。

打开[cnode](https://cnodejs.org/)，然后右键查看源代码。把里面内容复制，拷贝到`index.html`里去。

访问`http://localhost:3000/`就可以瞬间看到和`cnode`首页一样的内容了。

[![1](https://user-images.githubusercontent.com/6111778/44771917-006b9380-ab9f-11e8-9122-ed902df536a7.png)](https://user-images.githubusercontent.com/6111778/44771917-006b9380-ab9f-11e8-9122-ed902df536a7.png)

有模板以后，我们需要改造他们:

1. 使用HTML5推荐的`DOCTYPE`申明

```html
<!DOCTYPE html>
<html lang="zh-CN">
```

1. 拆分`body`标签之外到`layout.html`

浏览`cnode`所有页面`head`内容，除了`title`标签内容其他一样

基础`layout.html`模板

```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <title>我是layout模板</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
</head>

<body>
    <%- body -%>
</body>

</html>
```

把`index.html`里的`head`标签内容都移动到`layout.html`的`head`，同名的直接替换。

替换之后的`layout.html`模板

```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <title>CNode：Node.js专业中文社区</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name='description' content='CNode：Node.js专业中文社区'>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="keywords" content="nodejs, node, express, connect, socket.io" />
    <!-- see http://smerity.com/articles/2013/where_did_all_the_http_referrers_go.html -->
    <meta name="referrer" content="always">
    <meta name="author" content="EDP@TaoBao" />
    <meta property="wb:webmaster" content="617be6bd946c6b96" />
    <meta content="_csrf" name="csrf-param">
    <meta content="vlUgGvkx-SgmuzendL9gAP3DHXVS3834IpC4" name="csrf-token">
    <link title="RSS" type="application/rss+xml" rel="alternate" href="/rss" />
    <link rel="icon" href="//o4j806krb.qnssl.com/public/images/cnode_icon_32.png" type="image/x-icon" />
    <!-- style -->
    <link rel="stylesheet" href="//o4j806krb.qnssl.com/public/stylesheets/index.min.23a5b1ca.min.css" media="all" />
    <%- block('styles').toString() %>
</head>

<body>
    <%- body -%>
    <!-- scripts -->
    <script src="//o4j806krb.qnssl.com/public/index.min.f7c13f64.min.js"></script>
    <%- block('scripts').toString() %>
</body>

</html>
```

> style放头部，script放底部，并且利用模板引擎做了2个插槽，一个`styles`和`scripts`

1. 拆分`body`标签之内到`layout.html`

浏览`cnode`所有页面内容，发现头部黑色部分和底部白色部分都是一样的。那么我们需要把它们提取出来。

`cnode`模板

```html
...
<body>
    <div class='navbar'></div>
    <div id='main'></div>
    <div id='backtotop'></div>
    <div id='footer'></div>
    <div id='sidebar-mask'></div>
</body>
```

- `backtotop`和`sidebar-mask`是2个和js相关的功能标签，直接保留它们。
- class`navbar`对应到`header`标签
- id`main`对应到`main`标签
- id`footer`对应到`footer`标签
- 并且把除了`main`标签之外内容都放到对应的标签里面
- 模板里面关于网站访问统计的代码，我们就不需要了，直接去掉了。

改版后的`layout.html`模板

```html
...
<body>
    <header id="navbar">...</header>
    <main id="main">
        <%- body -%>
    </main>
    <footer id="footer">...</footer>
    <div id="backtotop">...</div>
    <div id="sidebar-mask">...</div>
    ...
</body>
```

把剩下`index.html`里面的`styles`和`scripts`使用

```html
<% block('styles').append(``) %>
<% block('scripts').append(``) %>
```

最好是写成`script`和`style`文件。

1. 拆分`main`标签之内到`sidebar.html`

浏览`cnode`所有主体内容，发现右边侧边栏除了`api`页面没有，注册登录找回密码，是另外一种模板内容，其他页面都是一样。

当前`index.html`模板

```html
...
<% layout('layout') -%>
<div id='sidebar'>...</div>
<div id='content'>...</div>
...
```

替换后的`index.html`模板

```html
...
<% layout('layout') -%>
<%- partial('./sidebar.html') %>
<article id="content">...</article>
...
```

这样我们首页模板已经完成了。

## 系统配置和应用配置

系统配置是系统级别的配置，如数据配置，端口，host，签名，加密keys等

应用配置是应用级别的配置，如网站标题，关键字，描述等

系统配置使用`.env`文件，大部分语言都有这个文件，我们需要用`dotenv`读取它们里面的内容。

`dotenv`支持的`.env`语法：

```bash
# 测试单行注释
KEY=
KEY=''
KEY=value
KEY='value'
KEY={"foo": "bar"}
KEY='{"foo": "bar"}'
KEY=["foo", "bar"]
KEY='["foo", "bar"]'
KEY=true
KEY=0
KEY='0'
KEY=null
KEY='null'
```

> `.env` 语法非常简单，`key` 只能是字符串（ps：最好大写带下划线分割单词），`value` 可以是空、字符串、数字、布尔值、字典对象、数组，`dotenv`最后获取也是字符串，需要你做相应处理。

**注意**：`.env` 文件主要的作用是存储环境变量，也就是会随着环境变化的东西，比如数据库的用户名、密码、静态文件的存储路径之类的，因为这些信息应该是和环境绑定的，不应该随代码的更新而变化，所以一般不会把 `.env` 文件放到版本控制中；

我们需要在`.gitignore`文件中排除它们：

```bash
# dotenv environment variables file
*.env
.env
```

> `.env`配置文件，关于隐私配置，可以看`README.md`说明。`.env`文件模板

### ConfigModule（配置模块）

当我们使用`process global`对象时，很难保持测试的干净，因为测试类可能直接使用它。另一种方法是创建一个抽象层，即一个`ConfigModule`，它公开了一个装载配置变量的`ConfigService`。

关于配置模块，官网有详细的[栗子](https://docs.nestjs.com/techniques/configuration)，这里也是基本类似。这里说一些关键点：

1. 需要用到依赖：

```bash
npm i --save dotenv  // 用来解析`.env`配置文件

npm install --save joi  // 用来验证`.env`配置文件
npm install --save-dev @types/joi
```

1. 需要创建`.env`配置文件

```bash
 development.env  开发配置
 production.env  生产配置
 test.env  测试配置
 .env.tmp  .env配置文件模板
```

1. 怎么设置`NODE_ENV`

`windows`和`mac`不一样

windows设置

```json
"scripts": {
    "start:dev": "set NODE_ENV=development&& nodemon",
    "start:prod": "set NODE_ENV=production&& node dist/main.js",
    "test": "set NODE_ENV=test&& jest",
}
```

mac设置

```json
"scripts": {
    "start:dev": "export NODE_ENV=development&& nodemon",
    "start:prod": "export NODE_ENV=production&& node dist/main.js",
    "test": "export NODE_ENV=test&& jest",
}
```

你会发现这个很麻烦，有没有什么方便地方了，可以通过`cross-env`来解决问题，它就是解决跨平台设置NODE_ENV的问题，默认情况下，windows不支持NODE_ENV=development的设置方式，加上cross-env就可以跨平台。

安装`cross-env`依赖

```bash
npm i --save-dev cross-env
```

`cross-env`设置

```json
"scripts": {
    "start:dev": "cross-env NODE_ENV=development nodemon",
    "start:prod": "cross-env NODE_ENV=production node dist/main.js",
    "test": "cross-env NODE_ENV=test jest",
}
```

1. 创建`config`模块:

```bash
$ nest generate module config
OR
$ nest g mo config
```

- 创建全局模块，全局模块不需要在注入到该模块，就能使用该模块导出的服务。
- 创建动态模块，动态模块可以创建可定制的模块，动态做依赖注入关系。

```ts
import { Module, DynamicModule, Global } from '@nestjs/common';
import { ConfigService } from './config.service';
import { ConfigurationToken } from './config.constants';
import { EnvConfig } from './config.interface';

@Global()
@Module({})
export class ConfigModule {
    static forRoot<T = EnvConfig>(filePath?: string, validator?: (envConfig: T) => T): DynamicModule {
        return {
            module: ConfigModule,
            providers: [
                {
                    provide: ConfigService,
                    useValue: new ConfigService(filePath || `${process.env.NODE_ENV || 'development'}.env`, validator),
                },
                {
                    provide: ConfigToken,
                    useFactory: () => new ConfigService(filePath || `${process.env.NODE_ENV || 'development'}.env`, validator),
                },
            ],
            exports: [
                ConfigService,
                ConfigToken,
            ],
        };
    }
}
```

`<T = EnvConfig>`是一种什么写法，`T`是一个泛型，`EnvConfig`是一个默认值，如果使用者不传递就是默认类型，作用类似于函数默认值。

默认用2种注册服务的写法，一种是类，一种是工厂。前面基础篇已经提及了，后面讲怎么使用它们。

1. 创建`config`服务:

```bash
$ nest generate service config/config
OR
$ nest g s config/config
```

首先,让我们写`ConfigService`类。

```ts
import * as fs from 'fs';
import { parse } from 'dotenv';
import { EnvConfig } from './config.interface';

export class ConfigService<T = EnvConfig> {
    // 系统配置
    private readonly envConfig: T;

    constructor(filePath: string, validator?: (envConfig: T) => T) {
        // 解析配置文件
        const configFile: T = parse(fs.readFileSync(filePath));
        // 验证配置参数
        if (typeof validator === 'function') {
            const envConfig: T = validator(configFile);
            if (typeof envConfig !== 'object') {
                throw Error('validator return value is not object');
            }
            this.envConfig = envConfig;
        } else {
            this.envConfig = configFile;
        }
    }

    /**
     * 获取配置
     * @param key
     * @param defaultVal
     */
    get(key: string, defaultVal?: any): string {
        return process.env[key] || this.envConfig[key] || defaultVal;
    }

    /** 获取系统配置 */
    getKeys(keys: string[]): any {
        return keys.reduce((obj, key: string) => {
            obj[key] = this.get(key);
            return obj;
        }, {});
    }

    /**
     * 获取数字
     * @param key
     */
    getNumber(key: string): number {
        return Number(this.get(key));
    }

    /**
     * 获取布尔值
     * @param key
     */
    getBoolean(key: string): boolean {
        return Boolean(this.get(key));
    }

    /**
     * 获取字典对象和数组
     * @param key
     */
    getJson(key: string): { [prop: string]: any } | null {
        try {
            return JSON.parse(this.get(key));
        } catch (error) {
            return null;
        }
    }

    /**
     * 检查一个key是否存在
     * @param key
     */
    has(key: string): boolean {
        return this.get(key) !== undefined;
    }

    /** 开发模式 */
    get isDevelopment(): boolean {
        return this.get('NODE_ENV') === 'development';
    }
    /** 生产模式 */
    get isProduction(): boolean {
        return this.get('NODE_ENV') === 'production';
    }
    /** 测试模式 */
    get isTest(): boolean {
        return this.get('NODE_ENV') === 'test';
    }
}
```

解析数据都存在`envConfig`里，封装一些获取并转义`value`的方法。

传递2个参数，一个是`.env`文件路径，一个是验证器，配合`Joi`使用，`nest`官网文档把配置服务和验证字段放在一起，我觉得这样不是很科学。
我在`.env`加一个配置就需要去修改`ConfigService`类，它本来就是不需要修改的，我就把验证部分提取出来，这样就不用关心验证问题了。`ConfigService`只关心取值问题。

上面模块里面还有一个`ConfigToken`服务，它是做什么的了，它叫做令牌。

1. 我们创建一个常量文件：

```bash
$ touch src/config/config.constants.ts
OR
编辑器新建文件config.constants.ts
```

里面写入常量`configToken`并导出

```bash
export const ConfigToken = 'ConfigToken';
```

`ConfigModule`的`configToken`也是它。

1. 我们创建一个装饰器文件：

```bash
$ touch src/config/config.decorators.ts
OR
编辑器新建文件config.decorators.ts
import { Inject } from '@nestjs/common';

import { ConfigToken } from './config.constants';

export const InjectConfig = () => Inject(ConfigToken);
```

使用`Inject`依赖注入器注入令牌对应的服务

`InjectConfig`是一个装饰器。装饰器在`nest`、`angular`有大量实践案例，各种装饰器，让你眼花缭乱。

简单科普一下装饰器：

写法：（总共四种：类，属性，方法，方法参数）

```ts
declare type ClassDecorator = <TFunction extends Function>(target: TFunction) => TFunction | void;

declare type PropertyDecorator = (target: Object, propertyKey: string | symbol) => void;

declare type MethodDecorator = <T>(target: Object, propertyKey: string | symbol, descriptor: TypedPropertyDescriptor<T>) => TypedPropertyDescriptor<T> | void;

declare type ParameterDecorator = (target: Object, propertyKey: string | symbol, parameterIndex: number) => void;
```

执行顺序：

- 类装饰器总是最后执行。
- 有多个方法参数装饰器时：从最后一个参数依次向前执行。
- 方法参数装饰器中参数装饰器先执行，方法参数装饰器执行完以后，方法装饰器执。
- 方法和属性装饰器，谁在前面谁先执行。（ps：方法参数属于方法一部分，参数会一直紧紧挨着方法执行。）

1. 如何使用`config`

2种方式：

```ts
// 装饰器依赖注入
constructor(
    @InjectConfig() private readonly config: ConfigService<EnvConfig>,
) {
    this.name = this.config.get('name');
}
// 普通依赖注入
constructor(
    private readonly config: ConfigService<EnvConfig>,
) {
    this.name = this.config.get('name');
}
// 通过app实例取
const config: ConfigService<EnvConfig> = app.get(ConfigService);

...
  if (config.isDevelopment) {
    app.use(loaderConnect.less(rootDir));
  }
...
await app.listen(config.getNumber('PORT'));
```

普通依赖注入就够玩了，这里用装饰器依赖注入有些画蛇添足，只是说明装饰器和注入器注入令牌用法。
通过app实例取，一般用于系统启动初始化配置，后面还要其他的获取方式，用到在介绍。

### Config（应用配置）

应用配置对比系统配置就没有这么麻烦了，大多数数据都可以写死就行了。

```bash
$ touch src/core/constants/config.constants.ts
OR
编辑器新建文件config.constants.ts
```

参考`cnode-egg`的`config/config.default.js`

```ts
export const Config = {
    // 网站名字、标题
    name: 'CNode技术社区',
    // 网站关键词
    keywords: 'nodejs, node, express, connect, socket.io',
    // 网站描述
    description: 'CNode：Node.js专业中文社区',
    // logo
    logo: '/public/images/cnodejs_light.svg',
    // icon
    icon: '/public/images/cnode_icon_32.png',
    // 版块
    tabs: [['all', '全部'], ['good', '精华'], ['share', '分享'], ['ask', '问答'], ['job', '招聘'], ['test', '测试']],
    // RSS配置
    rss: {
        title: this.description,
        link: '/',
        language: 'zh-cn',
        description: this.description,
        // 最多获取的RSS Item数量
        max_rss_items: 50,
    },
    // 帖子配置
    topic: {
        // 列表分页20
        list_count: 20,
        // 每天每用户限额计数10
        perDayPerUserLimitCount: 10,
    },
    // 用户配置
    user: {
        // 每个 IP 每天可创建用户数
        create_user_per_ip: 1000,
    },
    // 默认搜索方式
    search: 'baidu', // 'google', 'baidu', 'local'
};
```

哪里需要直接导入就行了，这个比较简单。

系统配置和应用配置告一段落了，那么接下来需要配置数

### mongoose连接

关于`mongoDB`安装，创建数据库，连接认证等操作，这里就展开了，这里有篇[文章](https://github.com/jiayisheji/jianshu/blob/master/blog/连接MongoDB.md)

在`.env`文件里面，我们已经配置`mongoDB`相关数据。

1. 创建核心模块

```bash
$ nest generate module core
OR
$ nest g mo core
```

核心模块，只会注入到`AppModule`，不会注入到`feature`和`shared`模块里面，专门做初始化配置工作，不需要导出任何模块。

它里面包括：守卫，管道，过滤器、拦截器、中间件、全局模块、常量、装饰器

其中全局中间件和全局模块需要模块里面注入和配置。

1. 配置`ConfigModule`

前面我们已经定义好了`ConfigModule`，现在把它添加到`CoreModule`中

```ts
import { Module } from '@nestjs/common';
import { ConfigModule, EnvConfig } from '../config';
import { ConfigValidate } from './config.validate';

@Module({
    imports: [
        ConfigModule.forRoot<EnvConfig>(null, ConfigValidate.validateInput),
    ],
})
export class CoreModule {
}
```

`ConfigValidate.validateInput` 是一个验证 `.env` 方法，`nest`和官网文档一样.

1. 配置`mongooseModule`

`nest`为我们提供了`@nestjs/mongoose`。

安装依赖：

```bash
$ npm install --save @nestjs/mongoose mongoose
$ npm install --save-dev @types/mongoose
```

配置模块：[文档](https://docs.nestjs.com/techniques/mongodb)

```ts
...
import { MongooseModule } from '@nestjs/mongoose';

@Module({
    imports: [
        ...
        MongooseModule.forRoot(url, config)
    ],
})
export class CoreModule {
}
```

`MongooseModule`提供了2个静态方法：

- forRoot(url, config): 对应的`Mongoose.connect()`方法
- forRootAsync({
  imports,
  useFactory,
  inject
  }): `useFactory`返回对应的`Mongoose.connect()`方法参数，`imports`依赖模块，`inject`依赖服务
- forFeature([{ name, schema }]): 对应的`mongoose.model()`方法
- constructor(@InjectModel('Cat') private readonly catModel: Model) {}：`@InjectModel`获取`mongoose.model`，参数和`forFeature`的`name`一样。

根模块使用: (forRoot和forRootAsync，只能注入一次，所以要在根模块导入)

这里我们需要借助配置模块里面获取配置，需要用到`forRootAsync`

```ts
...
import { MongooseModule } from '@nestjs/mongoose';

@Module({
    imports: [
        ...
        MongooseModule.forRootAsync({
            imports: [ConfigModule],
            useFactory: async (configService: ConfigService) => ({
                uri: configService.get('MONGODB_URI'),
                useNewUrlParser: true,
            }),
            inject: [ConfigService],
        })
    ],
})
export class CoreModule {
}
```

如果要写`MongooseOptions`怎么办

直接在uri后面写，有个必须的配置要写：

```bash
DeprecationWarning: current URL string parser is deprecated, and will be removed in a future version. To use the new parser, pass option { useNewUrlParser: true } to MongoClient.connect.
```

其他配置根据自己需求来添加

如果启动失败会显示：

```bash
MongoError: Authentication failed.
```

请检查uri是否正确，如果启动验证，账号是否验证通过，数据库名是否正确等等。

数据库连接成功，我们进行下一步，定义用户表。

### 用户数据库模块

建立数据模型为后面控制器提供服务

#### 生成文件

1. 创建`shared`模块

```bash
$ nest generate module shared
OR
$ nest g mo shared
```

1. 创建`mongodb`模块

```bash
$ nest generate module shared/mongodb
OR
$ nest g mo shared/mongodb
```

1. 创建`user`模块

```bash
$ nest generate module shared/mongodb/user
OR
$ nest g mo shared/mongodb/user
```

1. 创建`user`服务

```bash
$ nest generate service shared/mongodb/user
OR
$ nest g s shared/mongodb/user
```

1. 创建`user`的`interface`、`schema`、`index`。

这三个文件无法用命令创建需要自己手动创建。

```bash
$ touch src/shared/mongodb/user/user.interface.ts
$ touch src/shared/mongodb/user/user.schema.ts
$ touch src/shared/mongodb/user/index.ts
OR
编辑器新建文件`user.interface.ts`
编辑器新建文件`user.schema.ts`
编辑器新建文件`index.ts`
```

- `interface`是`ts`接口定义ts
- `schema`是定义`mongodb`的`schema`

最后完整的`user`文件夹是：

```bash
index.ts
user.module.ts
user.service.ts
user.schema.ts
user.interface.ts
```

> 基本所有的`mongodb`模块都是这样的结构，后面不在介绍`生成文件`这项。

#### 定义服务

默认生产的模块文件

```ts
import { Injectable } from '@nestjs/common';

@Injectable()
export class UserService {
    constructor() { }
}
```

在正式写`UserService`之前，我们先思考一个问题，因为操作数据库服务基本都类似，常用几个方法如：

- findAll 获取指定条件全部数据
- paginator 带分页结构数据
- findOne 获取一个数据
- findById 获取指定id数据
- count 获取指定条件个数
- create 创建数据
- delete 删除数据
- update 更新数据

一个基本表应该有增删改查这样8个快捷操作方法，如果每个表都写一个这样的，就比较多余了。`Typescript`给我们提供一个抽象类，我们可以把这些公共方法写在里面，然后用其他服务来继承。那我们开始写`base.service.ts`:

base.service.ts

```ts
/**
 * 抽象CRUD操作基础服务
 * @export
 * @abstract
 * @class BaseService
 * @template T
 */
export abstract class BaseService<T extends Document> {
    constructor(private readonly _model: Model<T>) {}

    /**
     * 获取指定条件全部数据
     * @param {*} conditions
     * @param {(any | null)} [projection]
     * @param {({
     *         sort?: any;
     *         limit?: number;
     *         skip?: number;
     *         populates?: ModelPopulateOptions[] | ModelPopulateOptions;
     *         [key: string]: any;
     *     })} [options]
     * @returns {Promise<T[]>}
     * @memberof BaseService
     */
    findAll(conditions: any, projection?: any | null, options?: {
        sort?: any;
        limit?: number;
        skip?: number;
        populates?: ModelPopulateOptions[] | ModelPopulateOptions;
        [key: string]: any;
    }): Promise<T[]> {
        const { option, populates } = options;
        const docsQuery = this._model.find(conditions, projection, option);
        return this.populates<T[]>(docsQuery, populates);
    }

    /**
     * 获取带分页数据
     * @param {*} conditions
     * @param {(any | null)} [projection]
     * @param {({
     *         sort?: any;
     *         limit?: number;
     *         offset?: number;
     *         page?: number;
     *         populates?: ModelPopulateOptions[] | ModelPopulateOptions;
     *         [key: string]: any;
     *     })} [options]
     * @returns {Promise<Paginator<T>>}
     * @memberof BaseService
     */
    async paginator(conditions: any, projection?: any | null, options?: {
        sort?: any;
        limit?: number;
        offset?: number;
        page?: number;
        populates?: ModelPopulateOptions[] | ModelPopulateOptions;
        [key: string]: any;
    }): Promise<Paginator<T>> {
        const result: Paginator<T> = {
            data: [],
            total: 0,
            limit: options.limit ? options.limit : 10,
            offset: 0,
            page: 1,
            pages: 0,
        };
        const { offset, page, option } = options;
        if (offset !== undefined) {
            result.offset = options.offset;
            options.skip = offset;
        } else if (page !== undefined) {
            result.page = page;
            options.skip = (page - 1) * result.limit;
            result.pages = Math.ceil(result.total / result.limit) || 1;
        } else {
            options.skip = 0;
        }
        result.data = await this.findAll(conditions, projection, option);
        result.total = await this.count(conditions);
        return Promise.resolve(result);
    }

    /**
     * 获取单条数据
     * @param {*} conditions
     * @param {*} [projection]
     * @param {({
     *         lean?: boolean;
     *         populates?: ModelPopulateOptions[] | ModelPopulateOptions;
     *         [key: string]: any;
     *     })} [options]
     * @returns {(Promise<T | null>)}
     * @memberof BaseService
     */
    findOne(conditions: any, projection?: any, options?: {
        lean?: boolean;
        populates?: ModelPopulateOptions[] | ModelPopulateOptions;
        [key: string]: any;
    }): Promise<T | null> {
        const { option, populates } = options;
        const docsQuery = this._model.findOne(conditions, projection, option);
        return this.populates<T>(docsQuery, populates);
    }

    /**
     * 根据id获取单条数据
     * @param {(any | string | number)} id
     * @param {*} [projection]
     * @param {({
     *         lean?: boolean;
     *         populates?: ModelPopulateOptions[] | ModelPopulateOptions;
     *         [key: string]: any;
     *     })} [options]
     * @returns {(Promise<T | null>)}
     * @memberof BaseService
     */
    findById(id: any | string | number, projection?: any, options?: {
        lean?: boolean;
        populates?: ModelPopulateOptions[] | ModelPopulateOptions;
        [key: string]: any;
    }): Promise<T | null> {
        const { option, populates } = options;
        const docsQuery = this._model.findById(this.toObjectId(id), projection, option);
        return this.populates<T>(docsQuery, populates);
    }

    /**
     * 获取指定查询条件的数量
     * @param {*} conditions
     * @returns {Promise<number>}
     * @memberof UserService
     */
    count(conditions: any): Promise<number> {
        return this._model.countDocuments(conditions).exec();
    }

    /**
     * 创建一条数据
     * @param {T} docs
     * @returns {Promise<T>}
     * @memberof BaseService
     */
    async create(docs: Partial<T>): Promise<T> {
        return this._model.create(docs);
    }

    /**
     * 删除指定id数据
     * @param {string} id
     * @returns {Promise<T>}
     * @memberof BaseService
     */
    async delete(id: string, options: {
        /** if multiple docs are found by the conditions, sets the sort order to choose which doc to update */
        sort?: any;
        /** sets the document fields to return */
        select?: any;
    }): Promise<T | null> {
        return this._model.findByIdAndRemove(this.toObjectId(id), options).exec();
    }

    /**
     * 更新指定id数据
     * @param {string} id
     * @param {Partial<T>} [item={}]
     * @returns {Promise<T>}
     * @memberof BaseService
     */
    async update(id: string, update: Partial<T>, options: ModelFindByIdAndUpdateOptions = { new: true }): Promise<T | null> {
        return this._model.findByIdAndUpdate(this.toObjectId(id), update, options).exec();
    }

    /**
     * 删除所有匹配条件的文档集合
     * @param {*} [conditions={}]
     * @returns {Promise<WriteOpResult['result']>}
     * @memberof BaseService
     */
    async clearCollection(conditions = {}): Promise<WriteOpResult['result']> {
        return this._model.deleteMany(conditions).exec();
    }

    /**
     * 转换ObjectId
     * @private
     * @param {string} id
     * @returns {Types.ObjectId}
     * @memberof BaseService
     */
    private toObjectId(id: string): Types.ObjectId {
        return Types.ObjectId(id);
    }

    /**
     * 填充其他模型
     * @private
     * @param {*} docsQuery
     * @param {*} populates
     * @returns {(Promise<T | T[] | null>)}
     * @memberof BaseService
     */
    private populates<R>(docsQuery, populates): Promise<R | null> {
        if (populates) {
            [].concat(populates).forEach((item) => {
                docsQuery.populate(item);
            });
        }
        return docsQuery.exec();
    }
}
```

这里说几个上面没有提到的属性和方法：

- _model：当前模型的实例，我们使用它去扩展其他方法，如果上面方法不满足我们需求，我们可以随时自定义
- clearCollection：删除所有匹配条件的文档集合
- toObjectId：字符串 id 转换ObjectId

那么我们接下来的`UserService`就简单多了

user.service.ts

```ts
import { Injectable } from '@nestjs/common';
import { BaseService } from '../base.service';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './user.interface';

@Injectable()
export class UserService extends BaseService<User> {
    constructor(
        @InjectModel('User') private readonly userModel: Model<User>,
    ) {
        super(userModel);
    }
}
```

`BaseService`是一个泛型，泛型是什么，简单理解就是你传什么它就是什么。`T`需要把我们`User`类型传进去,返回都是`User`类型，使用`@InjectModel('User')`注入模型实例，最后赋值给`_model`。

我们现在数据库`UserService`就已经完成了，接下来就需要定义`schema`和`interface`。

#### 定义schema

有了上面服务的经验，现在是不是你会说`schema`有没有公用的，当然可以呀。

我们定一个`base.schema.ts`，思考一下需要抽出来，好像唯一可以抽出来就是：

- create_at：创建时间
- update_at: 更新时间

这2个我们可以用抽出来，可以使用`schema`配置参数里面的`timestamps`属性，可以开启它，它默认`createdAt`和`updatedAt`。我们修改它们字段名，使用它们好处，创建自动赋值，修改时候自动更新。
**注意**：它们的存的时间和本地时间相差8小时，这个后面说怎么处理。

那么我们最终的配置就是：

```ts
export const schemaOptions: SchemaOptions = {
    toJSON: {
        virtuals: true,
        getters: true,
    },
    timestamps: {
        createdAt: 'create_at',
        updatedAt: 'update_at',
    },
};
```

`toJSON`是做什么的，我们需要开启显示`virtuals`虚拟数据，`getters`获取数据。

关于schema定义

在创建表之前我们需要跟大家说一下mongoDB的数据类型，具体数据类型如下：

- 字符串 - 这是用于存储数据的最常用的数据类型。`MongoDB`中的字符串必须为`UTF-8`。
- 整型 - 此类型用于存储数值。 整数可以是32位或64位，具体取决于服务器。
- 布尔类型 - 此类型用于存储布尔值(true / false)值。
- 双精度浮点数 - 此类型用于存储浮点值。
- 最小/最大键 - 此类型用于将值与最小和最大`BSON`元素进行比较。
- 数组 - 此类型用于将数组或列表或多个值存储到一个键中。
- 时间戳 - `ctimestamp`当文档被修改或添加时，可以方便地进行录制。
- 对象 - 此数据类型用于嵌入式文档。
- 对象 - 此数据类型用于嵌入式文档。
- Null - 此类型用于存储Null值。
- 符号 - 该数据类型与字符串相同; 但是，通常保留用于使用特定符号类型的语言。
- 日期 - 此数据类型用于以UNIX时间格式存储当前日期或时间。您可以通过创建日期对象并将日，月，年的日期进行指定自己需要的日期时间。
- 对象ID - 此数据类型用于存储文档的ID。
- 二进制数据 - 此数据类型用于存储二进制数据。
- 代码 - 此数据类型用于将JavaScript代码存储到文档中。
- 正则表达式 - 此数据类型用于存储正则表达式。

`mongoose`使用`Schema`所定义的数据模型，再使用`mongoose.model(modelName, schema)`将定义好的`Schema`转换为`Model`。
在`Mongoose`的设计理念中，`Schema`用来也只用来定义数据结构，具体对数据的增删改查操作都由`Model`来执行

```ts
import { Schema } from 'mongoose';
export const UserSchema = new Schema({
    // 定义你的Schema
});
UserSchema.index()  // 索引
UserSchema.virtual() // 虚拟值
UserSchema.pre() // 中间件
UserSchema.methods.xxx = function(){} // 实例方法
UserSchema.statics.xxx = function(){} // 静态方法
UserSchema.query.xxx = function(){} // 查询助手
UserSchema.query.xxx = function(){} // 查询助手
```

> **注意**：这里面都要使用普通函数`function(){}`，不能使用`()=>{}`，原因你懂的。

user.schema.ts

```ts
// 引入mongoose包
import { Schema } from 'mongoose';
// 一个工具包，使用MD5方法加密
import * as utility from 'utility';
// 引入user接口
import { User } from './user.interface';

// 定义schema并导出
export const UserSchema = new Schema({
    name: { type: String },
    loginname: { type: String },
    pass: { type: String },
    email: { type: String },
    url: { type: String },
    profile_image_url: { type: String },
    location: { type: String },
    signature: { type: String },
    profile: { type: String },
    weibo: { type: String },
    avatar: { type: String },
    githubId: { type: String },
    githubUsername: { type: String },
    githubAccessToken: { type: String },
    is_block: { type: Boolean, default: false },
    ...
}, schemaOptions);

// 设置索引
UserSchema.index({ loginname: 1 }, { unique: true });
UserSchema.index({ email: 1 }, { unique: true });
UserSchema.index({ score: -1 });
UserSchema.index({ githubId: 1 });
UserSchema.index({ accessToken: 1 });

// 设置虚拟属性
UserSchema.virtual('avatar_url').get(function() {
    let url =
        this.avatar ||
        `https://gravatar.com/avatar/${utility.md5(this.email.toLowerCase())}?size=48`;

    // www.gravatar.com 被墙
    url = url.replace('www.gravatar.com', 'gravatar.com');

    // 让协议自适应 protocol，使用 `//` 开头
    if (url.indexOf('http:') === 0) {
        url = url.slice(5);
    }

    // 如果是 github 的头像，则限制大小
    if (url.indexOf('githubusercontent') !== -1) {
        url += '&s=120';
    }
    return url;
});
...
```

> **注意**：这里面使用`utility`工具包，需要安装一下，`npm install utility --save`。

#### 定义interface

因为有些公共的字段，我们在定义`interface`时候也需要抽离出来。使用`base.interface.ts`

base.interface.ts

```ts
import { Document, Types } from 'mongoose';

export interface BaseInterface extends Document {
    _id: Types.ObjectId;  // mongodb id
    id: Types.ObjectId; // mongodb id
    create_at: Date; // 创建时间
    update_at: Date; // 更新时间
}
```

`interface` 文件内容和 `schema` 的基本一样，只需要字段名和类型就好了。

user.interface.ts

```ts
import { BaseInterface } from '../base.interface';

export interface User extends BaseInterface {
    name: string;  // 显示名字
    loginname: string;  // 登录名
    pass: string; // 密码
    age: number;  // 年龄
    email: string;  // 邮箱
    active: boolean;  // 是否激活
    collect_topic_count: number;  // 收集话题数
    topic_count: number;  // 发布话题数
    score: number;   // 积分
    is_star: boolean;  //
    is_block: boolean; // 是否黑名单
    ...
}
```

> **注意**：如果是`schema`里面不是定义必填或者有默认值的字段，需要这样写`is_admin?: boolean;`，`?`表示该字段可选的。最好在`interface`里面写上每个字段加上注释，方便查看。

#### 定义模块

默认生产的模块文件

```ts
import { Module } from '@nestjs/common';

@Module({
    imports: [],
    providers: [],
    exports: [],
})
export class UserModule {}
```

上面`schema`和`service`，都定义好了，接下来我们需要在模块里面注册。

user.module.ts

```ts
import { Module } from '@nestjs/common';

// 引入 nestjs 提供的 mongoose 模块
import { MongooseModule } from '@nestjs/mongoose';

// 引入自己写的 schema 和 service 在模块里面注册
import { UserSchema } from './user.schema';
import { UserService } from './user.service';

@Module({
    imports: [
        MongooseModule.forFeature([{ name: 'User', schema: UserSchema }]),
    ],
    providers: [UserService],
    exports: [UserService],
})
export class UserModule {}
```

`forFeature([{ name: 'User', schema: UserSchema }])`就是`MongooseModule`为什么提供的`mongoose.model(modelName, schema)`操作

> **注意**：`providers`是注册服务，如果想要给其他模块使用，需要在`exports`导出。

#### 定义索引文件

index.ts

```ts
export * from './user.module';
export * from './user.interface';
export * from './user.service';
```

> **注意**：不是所有的文件都需要导出的，一些关键的文件，其他模块需要使用的，如果`interface`、`service`都是需要导出的。

其他文件访问

xxx.service.ts

```ts
import { UserService , User } from './user';
```

是不是很方便。

### shared 模块和 mongodb 模块

#### mongodb模块

`mongodb`模块是管理所有`mongodb`文件夹里模块导入导出

mongodb.module.ts

```ts
import { Module } from '@nestjs/common';
import { UserModule } from './user';

@Module({
    imports: [UserModule],
    exports: [UserModule],
})
export class MongodbModule { }
```

> 建立索引文件`index.ts`导出`mongodb`文件夹下所有文件夹

#### shared模块

`shared`模块是管理所有`shared`文件夹里模块导入导出

shared.module.ts

```ts
import { Module } from '@nestjs/common';
import { MongodbModule } from './mongodb';

@Module({
    imports: [MongodbModule],
    exports: [MongodbModule],
})
export class SharedModule { }
```

> 建立索引文件`index.ts`导出`shared`文件夹下所有文件夹

到这里我们`user`数据表模块就基本完成了，接下来就需要使用它们。我们也可以运行`npm run start:dev`，不会出现任何错误，如果有错，请检查你的文件是否正确。如果找不到问题，可以联系我。

**注意**：后面我们搭建数据库就不再如此详细说明，只是一笔带过，大家可以看源码。

## 注册和使用`node-mailer`发送邮件

如果有用户模块功能，登陆注册应该说是必备的入门功能。

先说一下我们登陆注册逻辑：

1. 我们主要使用`passport、passport-github、passport-local`这三个模块，做身份认证。
2. 支持本地注册登陆和`github`第三方认证登陆（后面会介绍github认证登陆怎么玩）
3. 使用`session`和`cookie`，30天内免登陆
4. 退出后清除`session`和`cookie`
5. 支持电子邮箱找回密码

这里注册、登录、登出、找回密码都放在这个模块里面

### 生成文件

1. 创建`feature`模块

```bash
$ nest generate module feature
OR
$ nest g mo feature
```

1. 创建`auth`模块

```bash
$ nest generate module feature/auth
OR
$ nest g mo feature/auth
```

1. 创建`auth`服务

```bash
$ nest generate service feature/auth
OR
$ nest g s feature/auth
```

1. 创建`auth`控制器

```bash
$ nest generate controller feature/auth
OR
$ nest g co feature/auth
```

1. 创建`auth`的`dto`

dto是字段参数验证的验证类，需要配合各种功能，等下会讲解。

最后完整的`auth`文件夹是：

```bash
index.ts
auth.module.ts
auth.service.ts
auth.controller.ts
dto
```

> 基本所有的`feature`模块都是这样的结构，后面不在介绍`生成文件`这项。

### 科普知识：async/await

`ES7`发布`async/await`，也算是异步的解决又一种方案，

看一个简单的栗子：

```ts
const sleep =  (time) => {
    return new Promise( (resolve)=> {
        setTimeout( () => {
            resolve();
        }, time);
    })
};

const start = async () => {
    // 在这里使用起来就像同步代码那样直观
    console.log('start');
    await sleep(3000);
    console.log('end');
};

const startFor = async function () {
    for (var i = 1; i <= 10; i++) {
        console.log(`当前是第${i}次等待..`);
        await sleep(1000);
    }
};

start();

// startFor();
```

> 控制台先输出`start`，稍等`3`秒后，输出了`end`。

看栗子也能知道`async/await`基本使用规则和条件

1. `async` 表示这是一个`async`函数，`await`只能用在这个函数里面
2. `await` 表示在这里等待`promise`返回结果了，再继续执行。
3. `await` 等待的虽然是`promise`对象，但不必写`.then(..)`，直接可以得到返回值。
4. 捕捉错误可以直接用标准的`try catch`语法捕捉错误
5. 循环多个`await` 可以写在for循环里，不必担心以往需要`闭包`才能解决的问题 (注意不能使用`forEach`,只可以用`for/for-of`)

> **注意**：`await`必须在`async`函数的上下文中

在开始之前，前面数据操作有基础服务抽象类，这里控制器和服务也可以抽象出来。是可以抽象出来，但是本项目不决定这么来做，但会做一些抽象的辅助工具。

### auth模块

auth.module.ts

```ts
import { Module } from '@nestjs/common';
// 引入共享模块 访问user数据库
import { SharedModule } from 'shared';
// 引入控制和服务进行在模块注册
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';

@Module({
    imports: [
        SharedModule,
    ],
    controllers: [AuthController],
    providers: [AuthService],
})
export class AuthModule { }
```

> **注意**： `feature` 模块尽量不要导出服务，避免循环依赖。

### feature模块

feature.module.ts

```ts
import { Module } from '@nestjs/common';
// 引入Auth模块导入导出
import { AuthModule } from './auth/auth.module';

@Module({
    imports: [
        AuthModule,
    ],
    exports: [
        AuthModule,
    ],
})
export class FeatureModule { }
```

> **注意**： `feature` 模块功能就是导入导出所以的业务模块。

### app模块

如果是按我顺序用命令行创建的文件，`feature` 模块会自动添加到 `APP` 模块里面，
如果不是，需要手动把 `feature` 模块引入到 `APP` 模块里面。

app.module.ts

```ts
import { Module } from '@nestjs/common';
// 引入核心模块 只能在AppModule导入，nest 没有 angular 模块检查机制，只能自觉遵守吧。
import { CoreModule } from './core/core.module';
// 引入特性模块
import { FeatureModule } from 'feature';

@Module({
  imports: [
    CoreModule,
    FeatureModule，
  ],
})
export class AppModule { }
```

> **注意**：`APP` 模块不需要引入 `shared` 模块，`shared` 模式给业务模块引用的，`APP` 模块只需要引入 `CoreModule`, `feature` 模块就可以了。

### auth控制器

默认控制器文件

```ts
import { Controller } from '@nestjs/common';

@Controller()
export class AuthController {

}
```

#### 注册

要想登录，就要先注册，那我们先从注册开始。

auth.controller.ts

```ts
import {
    ...
    Get,
    Render
 } from '@nestjs/common';

@Controller()
export class AuthController {
    @Get('/register')
    @Render('auth/register')
    async registerView() {
        return { pageTitle: '注册' };
    }
}
```

前面介绍控制器时候已经介绍了`Get`，那么`Render`是什么，渲染模板，对应是`Express`的`res.render('xxxx');`方法。

**提示**：

1. 关于控制器方法命名方式，因为本项目是服务的渲染的，所有会有模板页面和页面请求。模板页面统一加上`View`后缀
2. 模板页面请求都是`get`，返回数据会带一个必须字段`pageTitle`，当前页面的`title`标签使用。
3. 页面请求方法命名根据实际情况来。

现在就可以运行开发启动命令看看效果，百分之两百的会报错，为什么？因为找不到模板`auth/register.ejs`文件。

那我们就去`views`下去创建一个`auth/register.ejs`，随便写的什么，在运行就可以了，浏览器访问：`http://localhost:3000/register`。

[![2](https://user-images.githubusercontent.com/6111778/50327748-4d4aef80-052b-11e9-8f33-7012966a5f0b.png)](https://user-images.githubusercontent.com/6111778/50327748-4d4aef80-052b-11e9-8f33-7012966a5f0b.png)

我们需要完善里面的内容了，因为`cnode`
屏蔽注册功能，全部走`github`第三方认证登录，所以看不到`https://cnodejs.org/signin`这个页面，那么我们可以在[源码](https://github.com/cnodejs/egg-cnode/blob/master/app/view/sign/signup.html)找到这个页面结构，直接拷贝`div#content`里的内容过来。

一刷新就页面报错了：

```json
{
    "statusCode": 500,
    "message": "Internal server error"
}
```

查看命令行提示：j

```bash
[Nest] 22132   - 2018-9-4 16:21:11   [ExceptionsHandler] E:\github\nest-cnode\views\auth\register.html:61
    59|                         <% } %>
    60|                     </div>
 >> 61|                 </div>
    62|                 <input type='hidden' name='_csrf' value='<%= csrf %>' />
    63|
    64|                 <div class='form-actions'>

csrf is not defined
```

提示我们`csrf`这个变量找不到。`csrf`是什么，
跨站请求伪造(CSRF或XSRF)是一种恶意利用的网站,未经授权的命令是传播从一个web应用程序的用户信任。
减轻这种攻击可以使用`csurf`包。这里有篇文章[浅谈cnode社区如何防止csrf攻击](https://cnodejs.org/topic/5533dd6e9138f09b629674fd)

安装所需的包:

```bash
$ npm i --save csurf
```

在入口文件启动函数里面使用它。

```ts
import * as csurf from 'csurf';
async function bootstrap() {
  const app = await NestFactory.create(AppModule, application);
  ...
  // 防止跨站请求伪造
  app.use(csurf({ cookie: true }));
  ...
}  
```

直接这么写肯定有问题，刷新页面控制台报错`Error: misconfigured csrf`

下面来说个我经常解决问题方法：

1. 首先如果我们用的`github`的开源依赖包，我们把这个错误复制到它的`issues`的搜索框里，如果有类似的问题，就进去看看，能不能找到解决方案，如果没有一个问题，你就可以提`issues`。

把你的问题的和环境依赖、最好有示例代码，越详细越好，运气好马上有人给你解决问题。

1. 搜索引擎解决问题比如：谷歌、必应、百度。如果有条件首选谷歌，没条件优先必应，其次百度。也是把问题直接复制到输入框，回车就好有一些类似的答案。
2. 就是去一些相关社区提问，和`1`一样，把问题描述清楚。

使用必应搜索，发现结果第一个就是问题，和我们一模一样的。

[![3](https://user-images.githubusercontent.com/6111778/50327760-563bc100-052b-11e9-888d-96abd6977499.png)](https://user-images.githubusercontent.com/6111778/50327760-563bc100-052b-11e9-888d-96abd6977499.png)

点击链接进去的，有人回复一个收到好评最高，说`app.use(csurf())`要在`app.use(cookieParser())`和`app.use(session({...})`之后执行。

其实我们的这个问题，在[csurf](https://github.com/expressjs/csurf)说明文档里面已经有写了，使用之前必须依赖`cookieParser`和`session`中间件。

`session`中间件可以选择[express-session](https://www.npmjs.com/package/express-session)和[cookie-session](https://www.npmjs.com/package/cookie-session)

我们需要安装2个中间件：

```bash
$ npm i --save cookie-parser express-session connect-redis
```

在入口文件启动函数里面使用它。

```ts
import * as cookieParser from 'cookie-parser';
import * as expressSession from 'express-session';
import * as connectRedis from 'connect-redis';
import * as csurf from 'csurf';
async function bootstrap() {
  const app = await NestFactory.create(AppModule, application);
  ...
  const RedisStore = connectRedis(expressSession);
  const secret = config.get('SESSION_SECRET');
  // 注册session中间件
  app.use(expressSession({
    name: 'jiayi',
    secret,  // 用来对sessionid 相关的 cookie 进行签名
    store: new RedisStore(getRedisConfig(config)),  // 本地存储session（文本文件，也可以选择其他store，比如redis的）
    saveUninitialized: false,  // 是否自动保存未初始化的会话，建议false
    resave: false,  // 是否每次都重新保存会话，建议false
  }));
  // 注册cookies中间件
  app.use(cookieParser(secret));
  // 防止跨站请求伪造
  app.use(csurf({ cookie: true }));
  ...
}  
```

里面有注释，这里就不解释了。

现在刷新还是一样报错`csrf is not defined`。

上面已经ok，现在是没有这个变量，我们去`registerView`方法返回值里面加上

```ts
async registerView() {
    return { pageTitle: '注册', csrf: '' };
}
```

key是`csrf`，value随便写，返回最后都会被替换的。

[![4](https://user-images.githubusercontent.com/6111778/50327790-71a6cc00-052b-11e9-84c7-0585c605653a.png)](https://user-images.githubusercontent.com/6111778/50327790-71a6cc00-052b-11e9-84c7-0585c605653a.png)

如果每次都要写一个那就比较麻烦了，需要写一个中间件来解决问题。

在入口文件启动函数里面使用它。

```ts
async function bootstrap() {
  const app = await NestFactory.create(AppModule, application);
  ...
  // 设置变量 csrf 保存csrfToken值
  app.use((req: any, res, next) => {
    res.locals.csrf = req.csrfToken ? req.csrfToken() : '';
    next();
  });
  ...
}  
```

在刷新又报了另外一个错误：`ForbiddenError: invalid csrf token`。验证`token`失败。

文档里面也有，读取令牌从以下位置,按顺序:

- `req.body._csrf` - typically generated by the `body-parser` module.
- `req.query._csrf` - a built-in from Express.js to read from the URL query string.
- `req.headers['csrf-token']` - the CSRF-Token HTTP request header.
- `req.headers['xsrf-token']` - the XSRF-Token HTTP request header.
- `req.headers['x-csrf-token']` - the X-CSRF-Token HTTP request header.
- `req.headers['x-xsrf-token']` - the X-XSRF-Token HTTP request header.

前端向后端提交数据，常用有2种方式，`form`和`ajax`。`ajax`无刷新，这个比较常用，基本是主流操作了。`form`是服务端渲染使用比较多，不需要js处理直接提交，我们项目大部分都是`form`直接提交。

一般服务端渲染常用就2种请求，`get`打开一个页面，`post`直接`form`提交。

`post`提交都是把数据放在`body`体里面，`Express`，解析`body`需要借助中间件`body-parser`。

`nest`已经自带`body-parser`配置。但是我发现好像有bug，原因不明，给作者提[issues](https://github.com/nestjs/nest/issues/1052)

作者回复速度很快，需要调用`app.init()`初始化才行。

还有一个重要的东西`layout.html`模板需要加上`csrf`这个变量。

```html
<meta content="<%= csrf %>" name="csrf-token">
```

接下来要写表单验证了：

我们在`dto`文件夹里面创建一个`register.dto.ts`和`index.ts`文件

```bash
$ touch src/feature/auth/dto/register.dto.ts
$ touch src/feature/auth/dto/index.ts
OR
编辑器新建文件register.dto.ts
编辑器新建文件index.ts
```

`register.dto.ts`是一个导出的类，typescript类型，可以是`class`，可以`interface`，推荐`class`，因为它不光可以定义类型，还可以初始化数据。

```ts
export class RegisterDto {
    readonly loginname: string;
    readonly email: string;
    readonly pass: string;
    readonly re_pass: string;
    readonly _csrf: string;
}
```

什么叫`dto`, 全称数据传输对象（DTO)(Data Transfer Object)，简单来说`DTO`是面向界面`UI`，是通过`UI`的需求来定义的。通过`DTO`我们实现了控制器与数据验证转化解耦。

`dto`中定义属性就是我们要提交的数据，控制器里面这样获取他们。

```ts
@Post('/register')
@Render('auth/register')
async register(@Body() register: RegisterDto) {
    return await this.authService.register(register);
}
```

这样是不是很普通，也没有太大用处。如果真的是这样的，我就不会写出来了。如果我提交数据之前需要验证字段合法性怎么办。`nest`也为我们想到了，使用官方提供的`ValidationPipe`，并安装2个必须的依赖：

```bash
npm i --save class-validator class-transformer
```

因为数据验证是非常通用的，我们需要在入口文件里全局去注册管道。

```ts
async function bootstrap() {
  const app = await NestFactory.create(AppModule, application);
  ...
  // 注册并配置全局验证管道
  app.useGlobalPipes(new ValidationPipe({
    transform: true,
    whitelist: true,
    forbidNonWhitelisted: true,
    skipMissingProperties: false,
    forbidUnknownValues: true,
  }));
  ...
}  
```

> 配置信息官网都有介绍，说一个重点，`transform`是转换数据，配合`class-transformer`使用。

开始写验证规则，对于这些装饰器使用方法，可以看文档也可以看`.d.ts`文件。

```ts
...
@IsNotEmpty({
        message: '用户名不能为空',
    })
    @Matches(/^[a-zA-Z0-9\-_]{5, 20}$/i, {
        message: '用户名不合法',
    })
    @Transform(value => value.toLowerCase(), { toClassOnly: true })
    readonly loginname: string;
    @IsNotEmpty({
        message: '邮箱不能为空',
    })
    @IsEmail({}, {
        message: '邮箱不合法',
    })
    @Transform(value => value.toLowerCase(), { toClassOnly: true })
    readonly email: string;
    @IsNotEmpty({
        message: '密码不能为空',
    })
    @IsByteLength(6, 18, {
        message: '密码长度不是6-18位',
    })
    readonly pass: string;
    @IsNotEmpty({
        message: '确认密码不能为空',
    })
    readonly re_pass: string;
    @IsOptional()
    readonly _csrf?: string;
...
```

- `IsNotEmpty`不能为空
- `Matches`使用正则表达式
- `Transform`转化数据，这里把英文转成小写。

发现一个问题，默认的提供的`NotEquals、Equals`只能验证一个写死的值，那么我验证确认密码怎么办，这是动态的。我想到一个简单粗暴的方式：

```ts
    @Transform((value, obj) => {
        if (obj.pass === value) {
            return value;
        }
        return 'PASSWORD_INCONSISTENCY';
    }, { toClassOnly: true })
    @NotEquals('PASSWORD_INCONSISTENCY', {
        message: '两次密码输入不一致。',
    })
```

先用转化装饰器，去判断，`obj`拿到就当前实例类，然后去取它对应属性和当前的值对比，如果是相等就直接返回，如果不是就返回一个标识，再用`NotEquals`去判断。

这样写不是很友好，我们需要自定义一个装饰器来完成这个功能。

在core新建`decorators`文件夹下建`validator.decorators.ts`文件

```ts
import { registerDecorator, ValidationOptions, ValidationArguments, Validator } from 'class-validator';
import { get } from 'lodash';

const validator = new Validator();

export function IsEqualsThan(property: string[] | string, validationOptions?: ValidationOptions) {
    return (object: object, propertyName: string) => {
        registerDecorator({
            name: 'IsEqualsThan',
            target: object.constructor,
            propertyName,
            constraints: [property],
            options: validationOptions,
            validator: {
                validate(value: any, args: ValidationArguments): boolean{
                    // 拿到要比较的属性名或者路径 参考`lodash#get`方法
                    const [comparativePropertyName] = args.constraints;
                    // 拿到要比较的属性值
                    const comparativeValue = get(args.object, comparativePropertyName);
                    // 返回false 验证失败
                    return validator.equals(value, comparativeValue);
                },
            },
        });
    };
}
```

官方文字里面有栗子：直接拷贝过来就行了，改改就好。我们需要改的就是`name`和`validate`函数里面的内容，

`validate`函数返回true验证成功，false验证失败，返回错误消息。

```ts
...
@IsNotEmpty({
    message: '确认密码不能为空',
})
@IsEqualsThan('pass', {
    message: '两次密码输入不一致。',
})
readonly re_pass: string;
...
```

> **注意**：`IsEqualsThan`第一个参数参考[lodash#get(https://lodash.com/docs/4.17.10#get)方法

验证规则搞定了，现在又有2个新问题了，

1. 默认返回全部错误格式是数组json，我们需要格式化自定义错误。
2. 我们需要把错误信息显示到当前页面，并且有些字段还需要显示在里面，有些字段不需要（比如密码），需要`Render`方法，可以实现数据显示，但是拿不到当前错误控制器的模板地址。这个是比较致命的问题，其他问题都好解决。

解决这个问题，我纠结了很久，想到了2个方法来解决问题。

### 自定义装饰器+配合`ValidationPipe`+`HttpExceptionFilter`实现

借助`class-validator`配置参数的`context`字段。

我们可以在上面写2个字段，一个是`render`，一个是`locals`。

在实现`render`功能之前，我们需要借助`typescript`的一个功能`enum`枚举。

`Nest`里面`HttpStatus`状态码就是`enum`。

我们把所有的视图模板都存在`enum`里面，枚举好处就是映射，类似于`key-value`对象。

```ts
// js 模拟 enum 写法
const Enum = {
    a: 'a',
    b: 'b'
}

// 取值
Enum[Enum.a]
// 'a'

// 字符串赋值
enum Enum {
    a = 'a',
    b = 'b'
}

// 取值
Enum.a
// 'a'

// 索引赋值
enum Enum {
    a,
    b
}

// 取值
Enum.a
// 0
```

> `typescript`转成`javascript`，枚举取值`Enum[Enum.a]`就是这样的。

创建视图模板路径枚举

```ts
$ touch src/core/enums/views-path.ts
OR
编辑器新建文件views-path.ts
```

在里面写上：

```ts
export enum ViewsPath {
    Register = 'auth/register',
}
```

auth.controller.ts换上枚举：

```ts
...
@Post('/register')
@Render(ViewsPath.Register)
async register(@Body() register: RegisterDto, @Res() res) {
    return await this.authService.register(register);
}
...
```

解决问题之前，我们先看，`ValidationPipe`源码，验证失败之后干了些什么：

```ts
...
const errors = await classValidator.validate(entity, this.validatorOptions);
if (errors.length > 0) {
    throw new BadRequestException(
    this.isDetailedOutputDisabled ? undefined : errors,
    );
}
...
```

返回是一个`ValidationError[]`，那`ValidationError`里面有什么：

```ts
class ValidationError {
    target?: Object; // 目标对象，就是我们定义验证规则那个对象。这里是`RegisterDto`
    property: string; // 当前字段
    value?: any;  // 当前的值
    constraints: {   // 验证规则错误提示，我们定义的装饰 @IsNotEmpty,显示的key是 isNotEmpty，value是定义配置里的`message`，定义多少显示多少。如果想一次只显示一个错误怎么办，后面讲怎么处理
        [type: string]: string;
    };
    children: ValidationError[]; // 嵌套
    contexts?: {  // 装饰器里面配置定义的`context`内容，key是 isNotEmpty ，value是 context内容
        [type: string]: any;
    };
    toString(shouldDecorate?: boolean, hasParent?: boolean, parentPath?: string): string; // 这玩意就不解释了。
}
```

最开始我想到是使用`context`来配置3个字段：

```ts
// context定义内容
interface context {
    render: string;  // 视图模板路径
    locals: boolean; // 字段是否显示
    priority: number;  // 验证规则显示优先级
}

// Render需要参数
interface Render {
    view: string;  // 视图模板路径
    locals: {   // 模板显示的变量
        error: string;   // 必须有的错误消息
        [key: string]: any;
    };
}
```

折腾一遍，功能实现了，就是太麻烦了。每个规则验证装饰器里面都要写`context`一坨。

能不能简便一点了。如果我在这个类里面只定义一次是不是好点。

就想到了在`RegisterDto`里写个私有属性，把相关的字段存进去，改进了`context`配置：

```ts
export interface ValidatorFilterContext {
    render: string;
    locals: { [key: string]: boolean };
    priority: { [key: string]: string[] };
}
```

就变成这样的：

```ts
...

__validator_filter__: {
    render: ViewsPath.Register,
    locals: {
        loginname: true,
        pass: false,
        re_pass: false,
        email: true,
    },
    priority: {
        loginname: ['IsNotEmpty', 'Matches'],
        pass: ['IsNotEmpty', 'IsByteLength'],
        re_pass: ['IsNotEmpty', 'IsEqualsThan'],
        email: ['IsNotEmpty', 'IsEmail'],
    },
}
...
```

这样就比每个规则验证装饰器写`context`配置好了很多，但是这样又有一个问题，会在`target`里面多一个`__validattsor_filter__`，有点多余了。

需要改进一下，我就想到类装饰器。

```ts
export const VALIDATOR_FILTER = '__validator_filter__';

export function ValidatorFilter(context: ValidatorFilterContext): ClassDecorator {
    return (target: any) => Reflect.defineMetadata(VALIDATOR_FILTER, context, target);
}
```

类装饰器前面已经说过了，它是装饰器里面最后执行的，用来装饰类。这里有个比较特殊的[Reflect](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Reflect)。

`Reflect`翻译叫反射，应该说叫映射靠谱点。为什么了，它基本就是类似此功能。

`defineMetadata`定义元数据，有3个参数：第一个是标识key，第二个是存储的数据（获取就是它），第三个就是一个对象。

翻译过来就是在 a 对象里面定一个标识 b 的数据为c。有定义就有获取

`getMetadata`获取元数据，有2个参数：第一个是标识key，第三个就是一个对象。

翻译过来就是在 a 对象里去查一个b 标识，如果有就返回原数据，如果没有就是Undefined。或者是b标识里面去查找a对象。理解差不多。目的是2个都匹配就返回数据。

这玩意简单理解`Reflect`是一个全局对象，`defineMetadata`定一个特定标识的数据，`getMetadata`根据特定标识获取数据。这里`Reflect`用的比较简单就不深入了，`Reflect`是`es6`新特性一部分。

在`Nest`的装饰器大量使用`Reflect`。在`nodejs`使用，需要借助`reflect-metadata`，引入方式`import 'reflect-metadata';`。

处理完了，dot问题，那么我们接下来要处理异常捕获过滤器问题了。

前面也说，`Nest`执行顺序：`客户端请求 ---> 中间件 ---> 守卫 ---> 拦截器之前 ---> 管道 ---> 控制器处理并响应 ---> 拦截器之后 ---> 过滤器`。

因为`ValidationPipe`源码里，只要验证错误就直接抛异常`new BadRequestException()`，然后就直接跳过控制器处理并响应，走拦截器之后和过滤器了。

那么我们需要在过滤器来处理这些问题，这是为什么要这么麻烦原因。

`Nest`已经提供一个自定义`HttpExceptionFilter`的栗子，我们需要改良一下这个栗子。

```ts
@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
    catch(exception: HttpException, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response: Response  = ctx.getResponse();
        const request: Request = ctx.getRequest();
        const status = exception.getStatus();
        // 如果错误码 400
        if (status === HttpStatus.BAD_REQUEST) {
            const render = validationErrorMessage(exception.message.message);
            return response.render(render.view, render.locals);
        }
    }
}
```

`render`接受3个参数，平常只用前个，第一个是模板路径或者模板，第二个提供给模板显示的数据。

这里核心地方在`validationErrorMessage`里：

```ts
function validationErrorMessage(messages: ValidationError[]): Render {
    const message: ValidationError = messages[0];
    const metadata: ValidatorFilterContext = Reflect.getMetadata(VALIDATOR_FILTER, message.target.constructor);
    if (!metadata) {
        throw Error('context is not undefined, use @ValidatorFilter(context)');
    }
    // 处理错误消息显示
    const priorities = metadata.priority[message.property] || [];
    let error = '';
    const notFound = priorities.some((key) => {
        key = key.replace(/\b(\w)(\w*)/g, ($0, $1, $2) => {
            return $1.toLowerCase() + $2;
        });
        if (!!message.constraints[key]) {
            error = message.constraints[key];
            return true;
        }
    });
    // 没有找到对应错误消息，取第一个
    if (!notFound) {
        error = message.constraints[Object.keys(message.constraints)[0]];
    }
    // 处理错误以后显示数据
    const locals = Object.keys(metadata.locals).reduce((obj, key) => {
        if (metadata.locals[key]) {
            obj[key] = message.target[key];
        }
        return obj;
    }, {});

    return {
        view: metadata.render,
        locals: {
            error,
            ...locals,
        },
    };
}
```

- 我们拿到的`messages`是一个数组，我们每次只显示一个错误消息，总是取第一个即可
- `metadata`是我们根据标识获取的元数据，如果找不到，就抛出异常。**注意**：`message.target`是一个`{}`，我们需要获取它的`constructor`才行。
- `priorities`获取当前错误字段显示错误提取的优先级列表
- `priority`里面没有配置获取配置`[]`, 就直接返回验证规则第一个。**提示**：这也是`{}`坑，默认按字母顺序排列属性的位置。
- `locals`直接去判断配置的`locals`，哪些`key`可以显示哪些`key`不能显示。
- 最后数据拼装在一起返回，供`render`使用。

### 自定义装饰器+自定义`ViewValidationPipe`实现

装饰器部分就不用说了，和上面一样，虽然不需要但是后面有用。

`ViewValidationPipe`实现：

```ts
import { Injectable, Optional, ArgumentMetadata, PipeTransform } from '@nestjs/common';

import * as classTransformer from 'class-transformer';
import * as classValidator from 'class-validator';
import { ValidatorOptions } from '@nestjs/common/interfaces/external/validator-options.interface';

import { isNil } from 'lodash';
import { ValidationError } from 'class-validator';
import { VALIDATOR_FILTER } from '../constants/validator-filter.constants';
import { ValidatorFilterContext } from '../decorators';

export interface ValidationPipeOptions extends ValidatorOptions {
    transform?: boolean;
    disableErrorMessages?: boolean;
}

@Injectable()
export class ViewValidationPipe implements PipeTransform<any> {
    protected isTransformEnabled: boolean;
    protected isDetailedOutputDisabled: boolean;
    protected validatorOptions: ValidatorOptions;

    constructor(@Optional() options?: ValidationPipeOptions) {
        options = Object.assign({
            transform: true,
            whitelist: true,
            forbidNonWhitelisted: true,
            skipMissingProperties: false,
            forbidUnknownValues: true,
        }, options || {});
        const { transform, disableErrorMessages, ...validatorOptions } = options;
        this.isTransformEnabled = !!transform;
        this.validatorOptions = validatorOptions;
        this.isDetailedOutputDisabled = disableErrorMessages;
    }

    public async transform(value, metadata: ArgumentMetadata) {
        const { metatype } = metadata;
        if (!metatype || !this.toValidate(metadata)) {
            return value;
        }
        const entity = classTransformer.plainToClass(
            metatype,
            this.toEmptyIfNil(value),
        );
        const errors = await classValidator.validate(entity, this.validatorOptions);
        // 重点实现 start
        if (errors.length > 0) {
            return validationErrorMessage(errors).locals;
        }
        // 重点实现 end
        return this.isTransformEnabled
            ? entity
            : Object.keys(this.validatorOptions).length > 0
                ? classTransformer.classToPlain(entity)
                : value;
    }

    private toValidate(metadata: ArgumentMetadata): boolean {
        const { metatype, type } = metadata;
        if (type === 'custom') {
            return false;
        }
        const types = [String, Boolean, Number, Array, Object];
        return !types.some(t => metatype === t) && !isNil(metatype);
    }

    toEmptyIfNil<T = any, R = any>(value: T): R | {} {
        return isNil(value) ? {} : value;
    }
}
```

我们这里把`validationErrorMessage`函数直接拿过来了。

控制器就需要这么写：

```ts
@Post('/register')
@Render(ViewsPath.Register)
async register(@Body(new ViewValidationPipe({
    transform: true,
    whitelist: true,
    forbidNonWhitelisted: true,
    skipMissingProperties: false,
    forbidUnknownValues: true,
})) register: RegisterDto) {
    if ((register as any).view) {
        return register.locals;
    }
    return await this.authService.register(register);
}
```

- 拿到是`pipe`转换后的结果
- 如果有`view`表示出错了，就直接返回`locals`，如果没有就接着处理服务逻辑。

**注意**：`(register as any).view`这个`view`是不靠谱的，需要返回一个特殊标识，不然页面出现一个`view`字段，就挂了。

这里我们使用第一种，接着实现服务逻辑。

```ts
...
async register(register: RegisterDto) {
    const { loginname, email } = register;
    // 检查用户是否存在，查询登录名和邮箱
    const exist = await this.userService.count({
        $or: [
            { loginname },
            { email },
        ],
    });
    // 返回1存在，0不存在
    if (exist) {
        return {
            error: '用户名或邮箱已被使用。',
            loginname,
            email,
        };
    }
    // hash加密密码，不能明文存储到数据库
    const passhash = hashSync(register.pass, 10);
    // 错误捕获 async/await 科普已经说明
    try {
        // 保存用户到数据库
        await this.userService.create({ loginname, email, pass: passhash });
        // 预留发送激活邮箱实现

        // 返回注册成功信息
        return {
            success: `欢迎加入 ${Config.name}！我们已给您的注册邮箱发送了一封邮件，请点击里面的链接来激活您的帐号。`,
        };
    } catch (error) {
        throw new InternalServerErrorException(error);
    }
}
```

里面注释也说明的我们要操作的步骤，注册逻辑还是比较简单：

- 验证参数是否合法
- 查询用户是否注册
- 加密密码
- 保存到数据库
- 发送激活邮箱
- 返回注册成功信息

做登录之前完成邮箱激活的功能。

### 邮箱模块

前面基础已经介绍过`nest`模块，这里邮箱模块是一个通用的功能模块，我们需要抽离出来写成可配置的动态模块。`nest`目前没有提供发邮箱的功能模块，我们只能自己动手写了，`nodejs`发送邮件最出名使用[node-mailer](https://nodemailer.com/about/)。我们这里也把`node-mailer`封装一下。

对于一个没有写过动态模块的我，是一脸懵逼，还好作者写很多包装的功能模块：

- graphql
- typeorm
- terminus
- passport
- elasticsearch
- mongoose
- jwt
- cqrs

既然不会写我们可以copy一个来仿写，实现我们要功能就ok了，卷起袖子就是干。

通过观察上面几个模块他们文件结构都是这样的：

```ts
index.ts  // 导出快捷文件
mailer-options.interface.ts  // 定义配置接口
mailer.constants.ts  // 定义常量
mailer.providers.ts  // 定义供应商
mailer.module.ts     // 定义导出模块
mailer.decorators.ts  // 定义装饰器
```

我们也来新建一个这样的结构，`core/mailer`建文件就不说了。

这一个模块，就需要先从模块开始：

- 动态可配置模块，而且还是全局模块，只需要导入一次即可。
- 同步配置可以是直接填写，异步配置可以是依赖其他模块

这是我们要实现的2个重要功能，作者写的模块基本是这个套路，有些东西我们不会写，可以先模仿。

```ts
import { DynamicModule, Module, Provider, Global } from '@nestjs/common';
import { MailerModuleAsyncOptions, MailerOptionsFactory } from './mailer-options.interface';
import { MailerService } from './mailer.service';
import { MAILER_MODULE_OPTIONS } from './mailer.constants';
import { createMailerClient } from './mailer.provider';

@Module({})
export class MailerModule {
    /**
     * 同步引导邮箱模块
     * @param options 邮箱模块的选项
     */
    static forRoot<T>(options: T): DynamicModule {
        return {
            module: MailerModule,
            providers: [
                { provide: MAILER_MODULE_OPTIONS, useValue: options },
                createMailerClient<T>(),
                MailerService,
            ],
            exports: [MailerService],
        };
    }

    /**
     * 异步引导邮箱模块
     * @param options 邮箱模块的选项
     */
    static forRootAsync<T>(options: MailerModuleAsyncOptions<T>): DynamicModule {
        return {
            module: MailerModule,
            imports: options.imports || [],
            providers: [
                ...this.createAsyncProviders(options),
                createMailerClient<T>(),
                MailerService,
            ],
            exports: [MailerService],
        };
    }
}
```

- `forRoot`配置同步模块
- `forRootAsync`配置异步模块

我们先说和`node-mailer`相关的，`node-mailer`主要分2块：

- 创建`node-mailer`实例，`node-mailer`新版解决很多问题，自动去识别不同邮件配置，这对我们来说是一个非常好的消息，不用去做各种适配配置了，只需要按官网的相关配置即可。
- 使用`node-mailer`实例，`set`设置配置和`use`注册插件，`sendMail`发送邮件

创建在`createMailerClient`方法里面完成

```ts
import { MAILER_MODULE_OPTIONS, MAILER_TOKEN } from './mailer.constants';
import { createTransport } from 'nodemailer';

export const createMailerClient = <T>() => ({
    provide: MAILER_TOKEN,
    useFactory: (options: T) => {
        return createTransport(options);
    },
    inject: [MAILER_MODULE_OPTIONS],
});
```

这个方法是一个工厂方法，在介绍这个方法之前，先要回顾一下，`nest`依赖注入自定义服务：

- Use value

```ts
const connectionProvider = {
  provide: 'Connection',
  useValue: connection,
};
```

值服务：这个一般作为配置，定义全局常量使用，单纯`key-value`形式

- Use class

```ts
const configServiceProvider = {
  provide: ConfigService,
  useClass: process.env.NODE_ENV === 'development'
    ? DevelopmentConfigService
    : ProductionConfigService,
}
```

类服务：这个比较常用，默认就是类服务，如果`provide`和`useClass`一样，直接注册在`providers`数组里即可。我们只关心`provide`注入是谁，不关心`useClass`依赖谁。

- Use factory

```ts
const connectionFactory = {
  provide: 'Connection',
  useFactory: (optionsProvider: OptionsProvider) => {
    const options = optionsProvider.get();
    return new DatabaseConnection(options);
  },
  inject: [OptionsProvider],
};
```

工厂服务：这个比较高级，一般需要依赖其他服务，来创建当前服务的时候，操作使用。定制服务经常用到。

我们在回过头来说上面这个`createMailerClient`方法

本来我们可以直接写出一个`Use factory`例子一样的，考虑它需要`forRoot`和`forRootAsync`都需要使用，我们写成一个函数，使用时候直接调用即可，也可以写成一个对象形式。

`provide`引入我们定义的常量，至于这个常量是什么，我们不需要关心，如果它变化这个注入者也发生变化，这里不需要改任何代码。也算是配置和程序分离，一种比较好编程方式。

`inject`依赖其他服务，这里依赖是一个`useValue`服务，我们把邮箱配置传递给`MAILER_MODULE_OPTIONS`，然后把它放到`inject`，这样我们在`useFactory`方法里面就可以取到依赖列表。

**注意**：`inject`是一个数组，`useFactory`参数和`inject`一一对应，简单理解，`useFactory`是形参，`inject`数组是实参。

在`useFactory`里面，我们可以根据参数做相关的操作，这里我们直接获取这个服务即可，然后使用`nodemailer`提供的邮件创建方法`createTransport`即可。

依赖注入和服务重点，我不关心依赖者怎么处理，我只关心注入者给我提供什么。

我们在来说上面这个`MAILER_MODULE_OPTIONS`值服务

`MAILER_MODULE_OPTIONS`在`forRoot`里是一个值服务`{ provide: MAILER_MODULE_OPTIONS, useValue: options }`，保存传递的参数。
`MAILER_MODULE_OPTIONS`在`forRootAsync`里是一个特殊处理`...this.createAsyncProviders(options)`，后面会讲解这个函数。

**注意**：因为`createMailerClient`依赖它，所以一定要在`createMailerClient`方法完成注册。

说完通用的创建服务，来说`forRootAsync`里的`createAsyncProviders`方法：

`createAsyncProviders`主要完成的工作是把邮箱配置和邮箱动态模块配置剥离开来，然后根据给定要求分别去处理。

`createAsyncProviders`方法

```ts
    /**
     * 根据给定的模块选项返回异步提供程序
     * @param options 邮箱模块的选项
     */
    private static createAsyncProviders<T>(
        options: MailerModuleAsyncOptions<T>,
    ): Provider[] {
        if (options.useFactory) {
            return [this.createAsyncOptionsProvider<T>(options)];
        }
        return [
            this.createAsyncOptionsProvider(options),
            {
                provide: options.useClass,
                useClass: options.useClass,
            },
        ];
    }

    /**
     * 根据给定的模块选项返回异步邮箱选项提供程序
     * @param options 邮箱模块的选项
     */
    private static createAsyncOptionsProvider<T>(
        options: MailerModuleAsyncOptions<T>,
    ): Provider {
        if (options.useFactory) {
            return {
                provide: MAILER_MODULE_OPTIONS,
                useFactory: options.useFactory,
                inject: options.inject || [],
            };
        }
        return {
            provide: MAILER_MODULE_OPTIONS,
            useFactory: async (optionsFactory: MailerOptionsFactory<T>) => await optionsFactory.createMailerOptions(),
            inject: [options.useClass],
        };
    }
```

解释这个函数之前，先看配置参数有接口：

```ts
export interface MailerModuleAsyncOptions<T> extends Pick<ModuleMetadata, 'imports'> {
    /**
     * 模块的名称
     */
    name?: string;
    /**
     * 应该用于提供MailerOptions的类
     */
    useClass?: Type<T>;
    /**
     * 工厂应该用来提供MailerOptions
     */
    useFactory?: (...args: any[]) => Promise<T> | T;
    /**
     * 应该注入的提供者
     */
    inject?: any[];
}
```

这里面支持2种写法，一种是自定义类，然后使用`useClass`, 一种是自定义工厂，然后使用`useFactory`。

使用在`MailerService`服务里面完成并且把它导出给其他模块使用

```ts
import { Inject, Injectable, Logger } from '@nestjs/common';
import { MAILER_TOKEN } from './mailer.constants';
import * as Mail from 'nodemailer/lib/mailer';
import { Options as MailMessageOptions } from 'nodemailer/lib/mailer';

import { from, Observable } from 'rxjs';
import { tap, retryWhen, scan, delay } from 'rxjs/operators';

const logger = new Logger('MailerModule');

@Injectable()
export class MailerService {
    constructor(
        @Inject(MAILER_TOKEN) private readonly mailer: Mail,
    ) { }
    // 注册插件
    use(name: string, pluginFunc: (...args) => any): ThisType<MailerService> {
        this.mailer.use(name, pluginFunc);
        return this;
    }

    // 设置配置
    set(key: string, handler: (...args) => any): ThisType<MailerService> {
        this.mailer.set(key, handler);
        return this;
    }

    // 发送邮件配置
    async send(mailMessage: MailMessageOptions): Promise<any> {
        return await from(this.mailer.sendMail(mailMessage))
            .pipe(handleRetry(), tap(() => {
                logger.log('send mail success');
                this.mailer.close();
            }))
            .toPromise();
    }
}

export function handleRetry(
    retryAttempts = 5,
    retryDelay = 3000,
): <T>(source: Observable<T>) => Observable<T> {
    return <T>(source: Observable<T>) => source.pipe(
        retryWhen(e =>
            e.pipe(
                scan((errorCount, error) => {
                    logger.error(`Unable to connect to the database. Retrying (${errorCount + 1})...`);
                    if (errorCount + 1 >= retryAttempts) {
                        logger.error('send mail finally error', JSON.stringify(error));
                        throw error;
                    }
                    return errorCount + 1;
                }, 0),
                delay(retryDelay),
            ),
        ),
    );
}
```

`@Inject`是一个注入器，接受一个`provide`标识、令牌，这里我们拿到了`node-mailer`实例

`send`方法使用`rxjs`写法，`this.mailer.sendMail(mailMessage)`返回是一个`Promise`，`Promise`有一些缺陷，`rxjs`可以去弥补一下这些缺陷。

比如这里使用是rxjs作用就是，`handleRetry()`去判断发送有没有错误，如果有错误，就去重试，默认重试5次，如果还错误就直接抛出异常。`tap()`类似一个`console`，不会去改变数据流。
有2个参数，第一个是无错误的处理函数，第二个是有错误的处理函数。如果发送成功我们需要关闭连接。`toPromise`就更简单了，看名字也知道，把`rxjs`转成`Promise`。

介绍完这个这个模块，那么接下来要说一下怎么使用它们：

模块注册：我们需要在核心模块里面`imports`，因为邮件需要一些配置信息，比如邮件地址，端口号，发送邮件的用户和授权码，如果不知道邮箱配置可[参考nodemailer官网](https://nodemailer.com/about/)。

```ts
MailerModule.forRootAsync<SMTPTransportOptions>({
    imports: [ConfigModule],
    useFactory: async (configService: ConfigService) => {
        const mailer = configService.getKeys(['MAIL_HOST', 'MAIL_PORT', 'MAIL_USER', 'MAIL_PASS']);
        return {
            host: mailer.MAIL_HOST,     // 邮箱smtp地址
            port: mailer.MAIL_PORT * 1, // 端口号
            secure: true,
            secureConnection: true,
            auth: {
                user: mailer.MAIL_USER,  // 邮箱账号
                pass: mailer.MAIL_PASS,  // 授权码
            },
            ignoreTLS: true,
        };
    },
    inject: [ConfigService],
}),
```

先使用注入依赖`ConfigService`，拿到配置服务，根据配置服务获取对应的配置。进行邮箱配置即可。

在页面怎么使用它们，因为本项目比较简单，只有2个地方需要使用邮箱，注册成功和找回密码时候，单独写一个`mail.services`服务去处理它们，并且模板里面内容除了用户名，token等特定的数据是动态的，其他都是写死的。

mail.services

```ts
/**
 * 激活邮件
 * @param to 激活人邮箱
 * @param token token
 * @param username 名字
 */
sendActiveMail(to: string, token: string, username: string){
    const name = this.name;
    const subject = `${name}社区帐号激活`;
    const html = `<p>您好：${username}</p>
        <p>我们收到您在${name}社区的注册信息，请点击下面的链接来激活帐户：</p>
        <a href="${this.host}/active_account?key=${token}&name=${username}">激活链接</a>
        <p>若您没有在${name}社区填写过注册信息，说明有人滥用了您的电子邮箱，请删除此邮件，我们对给您造成的打扰感到抱歉。</p>
        <p>${name}社区 谨上。</p>`;
    this.mailer.send({
        from: this.from,
        to,
        subject,
        html,
    });
}
```

这里是实现激活邮件方法，前面写的`mailer`模块，服务里面提供的`send`方法，接受四个最基本的参数。

- `this.name`是配置里面获取的`name`
- `this.from`是配置里面获取的数据，拼接而成，具体看源码
- `this.host`是配置里面获取的数据，拼接而成，具体看源码
- `from`邮件发起者，`to`邮件接收者，`subject`显示在邮件列表的标题，`html`邮件内容。

我们在注册成功时候直接去调用它就好了。

**注意**：我在本地测试，使用163邮箱作为发送者，用qq注册，就会被拦截，出现在垃圾邮箱里面。

### 验证注册邮箱

我们实现了发现邮箱的功能，接下来就来尝试验证走注册的功能及验证邮箱验证完成注册。

因为我只要一个发送邮箱的账号，和一个测试邮箱的的账号，我需要去数据库把我之前注册的账号删除了，从新完成注册。

填写信息，点击注册，就会发送一封邮件，是这个样子的：

[![I1A1)WG%(TW 532FZ)(AME9](https://user-images.githubusercontent.com/6111778/56122270-a04a2600-5fa4-11e9-9df1-82a32a593217.png)](https://user-images.githubusercontent.com/6111778/56122270-a04a2600-5fa4-11e9-9df1-82a32a593217.png)

点击`激活链接`链接跳回来激活账号：

[![2BAJ14WL_L}K{Z GZE{Q7`2](https://user-images.githubusercontent.com/6111778/56122344-ce2f6a80-5fa4-11e9-84f9-93747d625a86.png)](https://user-images.githubusercontent.com/6111778/56122344-ce2f6a80-5fa4-11e9-84f9-93747d625a86.png)

接下来我们就来实现`active_account`路由的逻辑

创建一个`account.dto`

```ts
@ValidatorFilter({
    render: ViewsPath.Notify,
    locals: {
        name: true,
        key: true,
    },
    priority: {
        name: ['IsNotEmpty'],
        key: ['IsNotEmpty'],
    },
})
export class AccountDto {
    @IsNotEmpty({
        message: 'name不能为空',
    })
    @Transform(value => value.toLowerCase(), { toClassOnly: true })
    readonly name: string;
    @IsNotEmpty({
        message: 'key不能为空',
    })
    readonly key: string;
}
```

这个很简单理解：需要2个参数，一个name，一个key，name是用户名，key是注册时候我们创建的标识，邮箱，密码，自定义盐混合一起加密。

通用消息模板：

```ts
<% layout('layout') -%>

<article id="content">
    <div class='panel'>
        <div class='header'>
            <ul class='breadcrumb'>
                <li><a href='/'>主页</a><span class='divider'>/</span></li>
                <li class='active'>通知</li>
            </ul>
        </div>
        <div class='inner'>
            <% if (typeof error !== 'undefined' && error) { %>
                <div class="alert alert-error">
                    <strong><%= error %></strong>
                </div>
            <% } %>
                <% if (typeof success !== 'undefined' && success) { %>
                    <div class="alert alert-success">
                        <strong><%= success %></strong>
                    </div>
                <% } %>
                <a href="<%- typeof referer !== 'undefined' ? referer : '/' %>"><span class="span-common">返回</span></a>
        </div>
    </div>
</article>
```

这模板直接拿`cnode`的页面。

接下来就是控制器：

```ts
@Controller()
export class AuthController {
    constructor(
        private readonly authService: AuthService,
    ) {}
    ....
    /** 激活账号 */
    @Get('/active_account')
    @Render(ViewsPath.Notify)
    async activeAccount(@Query() account: AccountDto) {
        return await this.authService.activeAccount(account);
    }
}
```

我们需要获取`url`的`?`后面的参数，需要用到`@Query()`装饰器，配合参数验证，最后拿到数据参数，丢给对应的服务去处理业务逻辑。

[@Injectable](https://github.com/Injectable)()
export class AuthService {
private readonly logger = new Logger(AuthService.name, true);
constructor(
private readonly userService: UserService,
private readonly config: ConfigService,
private readonly mailService: MailService,
) { }
...

```ts
/** 激活账户 */
async activeAccount({ name, key }: AccountDto) {
    const user = await this.userService.findOne({
        loginname: name,
    });
    // 检查用户是否存在
    if (!user) {
        return { error: '用户不存在' };
    }
    // 对比key是否正确
    if (!user || utility.md5(user.email + user.pass + this.config.get('SESSION_SECRET')) !== key) {
        return { error: '信息有误，帐号无法被激活。' };
    }
    // 检查用户是否激活过
    if (user.active) {
        return { error: '帐号已经是激活状态。', referer: '/login' };
    }

    // 如果没有激活，就激活操作
    user.active = true;
    await user.save();
    return { success: '帐号已被激活，请登录', referer: '/login' };
}
```

}

注释已经写的很清晰的，就不在叙述的问题。接下来讲我们这篇文章的最后一个问题登录，在讲到登录之前需要简单科普一下怎么才算登录，它的凭证是什么？

## 登录

### 登录凭证

目前来说比较常用有2种一种是`session+cookie`，一种是`JSON Web Tokens`。

#### session+cookie

session+cookie是比较常见前后端一起那种。它是流程大概是这样的：

1. 前端发起 http 请求时有携带 cookie
2. 后端拿到此 cookie 对比服务器 session，有登陆则放过此请求，无登录，redirect 到登录页面
3. 前端登录，后端比对用户名密码，成功则生成唯一标识符，放在 session，并且存入浏览器 cookie
4. 用户可以拿到自己的 cookie，就可以发起任何的客户端 http 请求

注意：以上操作都是合法操作，如果个人过失暴露 cookie 给其他人，属于用户个人的行为，比如你在网吧里登录 QQ，服务端没有办法不允许这样操作。而客户端的人应有安全意识，在公共场所及时清空 cookie，或者停止使用一切 [不随 session 关闭而 cookie 失效] 的应用。

#### JSON Web Tokens

JSON Web Tokens是比较常见前后分离那种。它是流程大概是这样的：

1. 登录时候,客户端通过用户名与密码请求登录
2. 服务端收到请求区验证用户名与密码
3. 验证通过,服务端会签发一个Token,再把这个Token发给客户端.
4. 客户端收到Token,存储到本地,如Cookie,SessionStorage,LocalStorage.
5. 客户端每次像服务器请求API接口时候,都要带上Token.
6. 服务端收到请求,验证Token,如果通过就返回数据,否则提示报错信息.

注意：前端是无设防的，不可以信任； 全部的校验都由后端完成

我们这里是前后端一体的，当然选择`session+cookie`。这里有篇文章介绍还行，[传送门](http://wiki.jikexueyuan.com/project/node-lessons/cookie-session.html)。

我们这里登录需要实现2个，一个是本地登录，一个是第三方github登录。

### 本地登录

`nestjs`已经帮我们封装好了`@nestjs/passport`，我们前面已经说了需要下载相关包。本地登录使用`passport-local`完成。

新写个模板，需要去定义一个枚举ViewsPath 登录地址

```ts
@Controller()
export class AuthController {
    constructor(
        private readonly authService: AuthService,
    ) {}
    ....
        /** 登录模板 */
    @Get('/login')
    @Render(ViewsPath.Login)
    async loginView(@Req() req: TRequest) {
        const error: string = req.flash('loginError')[0];
        return { pageTitle: '登录', error};
    }
}
```

和正常注册模板控制器一样，这里多了一项`req.flash('loginError')[0]`，其实它是`connect-flash`中间件。其实我们自己写一个也完全没有问题，本身就没有几行代码，既然有轮子就用呗，它是做什么，就是帮我们去`session`记录消息，然后去获取，绑定在`Request`上。你需要安装它`npm install connect-flash -S`。

模板直接拷贝`cnode`的登录模板，改了一下请求地址。

```ts
     /** 本地登录提交 */
    @Post('/login')
    @UseGuards(AuthGuard('local'))
    async passportLocal(@Req() req: TRequest, @Res() res: TResponse) {
        this.logger.log(JSON.stringify(req.user));
        this.verifyLogin(req, res, req.user);
    }
    /** 验证登录 */
    private verifyLogin(@Req() req, @Res() res, user: User) {
        // id 存入 Cookie, 用于验证过期.
        const auth_token = user._id + '$$$$'; // 以后可能会存储更多信息，用 $$$$ 来分隔
        // 配置 Cookie
        const opts = {
            path: '/',
            maxAge: 1000 * 60 * 60 * 24 * 30,
            signed: true,
            httpOnly: true,
        };
        res.cookie(this.config.get('AUTH_COOKIE_NAME'), auth_token, opts); // cookie 有效期30天
        // 调用 passport 的 login方法 传递 user信息
        req.login(user, () => {
            // 重定向首页
            res.redirect('/');
        });
    }
```

这里使用守卫，`AuthGuard`首页是`@nestjs/passport`。verifyLogin是登录以后操作。为什么封装一个方法，等下github登录成功也是一样的操作。`login`方法是`passport`的方法，`user`就是我们拿到的用户信息。

**注意**：这里的`passport-local`是网上的栗子实现有差别，网上栗子都可以配置，重定向的功能，

这是[passport](http://www.passportjs.org/docs/authenticate/)文档里面的栗子。

```ts
app.post('/login', 
  passport.authenticate('local', 
   { 
       successRedirect: '/',
      failureRedirect: '/login',
   }),t
  function(req, res) {
    res.redirect('/');
  });
```

这个坑我也捣鼓很久，无论成功还是失败重定向都需要手动去处理它。成功就是上面我那个`login`。

我们需要新增一个`passport`文件夹，里面放passport相关的业务。

新建一个`local.strategy.ts`，处理`passport-local`

```ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../auth.service';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy, 'local') {
    constructor(private readonly authService: AuthService) {
        super({
            usernameField: 'name',
            passwordField: 'pass',
            passReqToCallback: false,
        });
    }

    // tslint:disable-next-line:ban-types
    async validate(username: string, password: string, done: Function) {
        await this.authService.local(username, password)
            .then(user => done(null, user))
            .catch(err => done(err, false));
    }
}
```

这里就比较简单，就这么几行代码，自定义一个本地策略，去继承`@nestjs/passport`一个父类，super需要传递是`new LocalStrategy('配置对象')`，`validate`是一个抽象方法，我们必须要去实现的，因为`@nestjs/passport`也不知道我们是怎么样查询用户是否存在，这个验证方法暴露给我们的去实现。`done`就相当于是`callback`，标准nodejs回调函数参数，第一个是表示错误，第二个是用户信息。

放到`AuthModule`里面去做服务申明。

```ts
@Module({
  imports: [SharedModule],
  providers: [
    AuthService,
    AuthSerializer,
    LocalStrategy,
  ],
  controllers: [AuthController],
})
export class AuthModule {}
```

AuthSerializer也是和`passport`相关的，它里面需要实现2个方法`serializeUser`,`deserializeUser`。

- serializeUser：将用户信息序列化后存进 session 里面，一般需要精简，只保存个别字段
- deserializeUser：反序列化后把用户信息从 session 中取出来，反查数据库拿到完整信息

```ts
import { PassportSerializer } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthSerializer extends PassportSerializer {
    /**
     * 序列化用户
     * @param user
     * @param done
     */
    serializeUser(user: any, done: (error: null, user: any) => any) {
        done(null, user);
    }

    /**
     * 反序列化用户
     * @param payload
     * @param done
     */
    async deserializeUser(payload: any, done: (error: null, payload: any) => any) {
        done(null, payload);
    }
    constructor() {
        super();
    }
}
```

我们这里先简单粗暴把所有信息全部存到`session`，先实现功能，其他后面再优化。

接下来去服务实现`local`方法：

```ts
// Validation methods
const validator = new Validator();

@Injectable()
export class AuthService {
    ...
    async local(username: string, password: string) {
        // 处理用户名和密码前后空格，用户名全部小写 保证和注册一致
        username = username.trim().toLowerCase();
        password = password.trim();
        // 验证用户名
        // 可以用户名登录 /^[a-zA-Z0-9\-_]\w{4,20}$/
        // 可以邮箱登录 标准邮箱格式
        // 做一个验证用户名适配器
        const verifyUsername = (name: string) => {
            // 如果输入账号里面有@，表示是邮箱
            if (name.indexOf('@') > 0) {
                return validator.isEmail(name);
            }
            return validator.matches(name, /^[a-zA-Z0-9\-_]\w{4,20}$/);
        };
        if (!verifyUsername(username)) {
            throw new UnauthorizedException('用户名格式不正确。');
        }
        // 验证密码 密码长度是6-18位
        if (!validator.isByteLength(password, 6, 18)) {
            throw new UnauthorizedException('密码长度不是6-18位。');
        }
        // 做一个获取用户适配器
        const getUser = (name: string) => {
            // 如果输入账号里面有@，表示是邮箱
            if (name.indexOf('@') > 0) {
                return this.userService.getUserByMail(name);
            }
            return this.userService.getUserByLoginName(name);
        };
        const user = await getUser(username);
        // 检查用户是否存在
        if (!user) {
            throw new UnauthorizedException('用户不存在。');
        }
        const equal = compareSync(password, user.pass);
        // 密码不匹配
        if (!equal) {
            throw new UnauthorizedException('用户密码不匹配。');
        }
        // 用户未激活
        if (!user.active) {
            // 发送激活邮件
            const token = utility.md5(user.email + user.pass + this.config.get('SESSION_SECRET'));
            this.mailService.sendActiveMail(user.email, token, user.loginname);
            throw new UnauthorizedException('此帐号还没有被激活，激活链接已发送到 ' + user.email + ' 邮箱，请查收。');
        }
        // 验证通过
        return user;
    }
}
```

上面都有注释，这里说明一下为什么需要在这里去验证字段信息，这也是使用`@nestjs/passport`坑。

验证使用`class-validator`提供的验证器类`Validator`，其他验证方法和我们注册保持一致。注释都已经一一说明。

错误都使用`throw new UnauthorizedException('错误信息');`这样的方式去抛出，这也是在`AuthGuard`源码里面，有个处理请求方法：

```ts
handleRequest(err, user, info): TUser {
      if (err || !user) {
        throw err || new UnauthorizedException();
      }
      return user;
    }
```

只要有错误，就回去走错误，这个错误就被`ExceptionFilter`捕获，我们有自定义的`HttpExceptionFilter`，等下就来讲它。
只有没有错误，成功才会返回user，这时候去走，`serializeUser`, `deserializeUser`, `passportLocal`最后重定向到首页。

**注意**：抛出异常一定要用`throw`，不用使用`return`。用`return`就直接走`serializeUser`，然后报错了。

错误处理，因为这个身份认证只要出错返回都是401，那么我们需要去捕获处理一下，

```ts
...
            case HttpStatus.UNAUTHORIZED: // 如果错误码 401
                request.flash('loginError', exception.message.message || '信息不全。');
                response.redirect('/login');
                break;
 ...
```

默认`handleRequest`返回是一个空的，`exception.message.message`是`undefined`，这是`passport`返回，只要用户名或者密码没有填，都会返回这个错误信息，对应我们来捕获错误也是一脸懵逼，我看`cndoe`是直接返回`信息不全。`，这里就一样简单粗暴处理了。

> 说多了都是眼泪，这个地方卡了我很久。这篇文章卡壳，它需要付50%责任，因为网上没有关于`@nestjs/passport`的`passport-local`的栗子。大多数都是`jwt`栗子，比较折腾，试过各种方法方式。

### github登录

这个玩意就本地登录简单多了。先说下流程：

我们网站叫`nest-cnode`

1. nest-cnode 网站让用户跳转到 GitHub。
2. GitHub 要求用户登录，然后询问"nest-cnode 网站要求获得 xx 权限，你是否同意？"
3. 用户同意，GitHub 就会重定向回 nest-cnode 网站，同时发回一个授权码。
4. nest-cnode 网站使用授权码，向 GitHub 请求令牌。
5. GitHub 返回令牌.
6. nest-cnode 网站使用令牌，向 GitHub 请求用户数据。

接下来我们就去实现一下：

先github申请一个认证，应用登记。

一个应用要求 OAuth 授权，必须先到对方网站登记，让对方知道是谁在请求。

所以，我们要先去 GitHub 登记一下。这是免费的。

访问这个[网址](https://github.com/settings/applications/new)，填写登记表。

[![%V}9$D4LD_4YLFKXRTVJ7QP](https://user-images.githubusercontent.com/6111778/56720050-78ad4780-6774-11e9-8503-e494f8bc79b9.png)](https://user-images.githubusercontent.com/6111778/56720050-78ad4780-6774-11e9-8503-e494f8bc79b9.png)

应用的名称随便填，主页 URL 填写`http://localhost:3000`，跳转网址填写 `http://localhost:3000/github/callback`。

提交表单以后，GitHub 应该会返回客户端 ID（client ID）和客户端密钥（client secret），这就是应用的身份识别码。

我们创建一个`github.strategy.ts`

```ts
@Injectable()
export class GithubStrategy extends PassportStrategy(Strategy) {
    constructor(private readonly config: ConfigService) {
        super({
            clientID: config.get('GITHUB_CLIENT_ID'),
            clientSecret: config.get('GITHUB_CLIENT_SECRET'),
            callbackURL: `${config.get('HOST')}:${config.get('PORT')}/github/callback`,
        });
    }

    // tslint:disable-next-line:ban-types
    async validate(accessToken, refreshToken, profile: GitHubProfile, done: Function) {
        profile.accessToken = accessToken;
        done(null, profile);
    }
}
```

需要配置`clientID`, `clientSecret`, `callbackURL`, 这3个东西，我们上面图里面都有。把它申明到模块里面去。

github2个必备的路由：

```ts
    /** github登录提交 */
    @Get('/github')
    @UseGuards(AuthGuard('github'))
    async github() {
        return null;
    }

    @Get('/github/callback')
    async githubCallback(@Req() req: TRequest, @Res() res: TResponse) {
        this.logger.log(JSON.stringify(req.user));
        const existUser = await this.authService.github(req.user);
        this.verifyLogin(req, res, existUser);
    }
```

我们需要github登录时候就去请求`/github`路由，使用守卫，告诉守卫使用`github`策略。这个方法随便写，返回都会重定向到[github.com](https://github.com/)，填完登录信息，就会自动跳转到`githubCallback`方法里面，`req.user`返回就是github给我们提供的所有信息。我们需要去和我们用户系统做关联。

服务github方法：

```ts
async github(profile: GitHubProfile) {
        if (!profile) {
            throw new UnauthorizedException('您 GitHub 账号的 认证失败');
        }
        // 获取用户的邮箱
        const email = profile.emails && profile.emails[0] && profile.emails[0].value;
        // 根据 githubId 查找用户
        let existUser = await this.userService.getUserByGithubId(profile.id);

        // 用户不存在则创建
        if (!existUser) {
            existUser = new this.userService.getMode();
            existUser.githubId = profile.id;
            existUser.active = true;
            existUser.accessToken = profile.accessToken;
        }

        // 用户存在，更新字段
        existUser.loginname = profile.username;
        existUser.email = email || existUser.email;
        existUser.avatar = profile._json.avatar_url;
        existUser.githubUsername = profile.username;
        existUser.githubAccessToken = profile.accessToken;

        // 保存用户到数据库
        try {
            await existUser.save();
            // 返回用户
            return existUser;
        } catch (error) {
            // 获取MongoError错误信息
            const errmsg = error.errmsg || '';
            // 处理邮箱和用户名重复问题
            if (errmsg.indexOf('duplicate key error') > -1) {
                if (errmsg.indexOf('email') > -1) {
                    throw new UnauthorizedException('您 GitHub 账号的 Email 与之前在 CNodejs 注册的 Email 重复了');
                }

                if (errmsg.indexOf('loginname') > -1) {
                    throw new UnauthorizedException('您 GitHub 账号的用户名与之前在 CNodejs 注册的用户名重复了');
                }
            }
            throw new InternalServerErrorException(error);
        }
    }
```

**注意**：`profile`返回信息可能是个`undefined`，因为认证可能会失败，需要去处理一下，不然后面代码全挂了。O(∩_∩)O哈哈~。

登录功能基本完成了，需要判断用户登录。

我们需要写一个中间件，`current_user.middleware.ts`

```ts
import { Injectable, NestMiddleware, MiddlewareFunction } from '@nestjs/common';

@Injectable()
export class CurrentUserMiddleware implements NestMiddleware {
    constructor() { }
    resolve(...args: any[]): MiddlewareFunction {
        return (req, res, next) => {
            res.locals.current_user = null;
            const { user } = req;
            if (!user) {
                return next();
            }
            res.locals.current_user = user;
            next();
        };
    }
}
```

因为`passport`登录成功以后，会自动给`req`添加一个属性`user`，我们只需要去判断它就可以了。

**注意**：`nestjs`中间件和`express`中间件有区别：

express定义的中间件，如果全局可以直接通过`express.use(中间件)`去申明使用。

nestjs定义的中间件不能这么玩，需要在模块里面去申明使用。

```ts
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(CurrentUserMiddleware)
      .forRoutes({ path: '*', method: RequestMethod.ALL });
  }
}
```

我们把全局的中间件都丢到`AppModule`，里面去申明使用。

修改一下`AppController`首页：

```ts
@Get()
  @Render('index')
  root() {
    return {};
  }
```

登录前：

[![KZWPT O)_GKL`$6 RAISBOX](https://user-images.githubusercontent.com/6111778/56723079-dc3a7380-677a-11e9-8429-d562ae754c3c.png)](https://user-images.githubusercontent.com/6111778/56723079-dc3a7380-677a-11e9-8429-d562ae754c3c.png)

登录后：

[![0SJTB2VL`C)C7P6F34KT6V5](https://user-images.githubusercontent.com/6111778/56723112-eb212600-677a-11e9-82da-c7a0b24700ec.png)](https://user-images.githubusercontent.com/6111778/56723112-eb212600-677a-11e9-82da-c7a0b24700ec.png)

在弄个退出就完美了：它就更简单了:

```ts
@Controller()
export class AuthController {
    /** 登出 */
    @All('/logout')
    async logout(@Req() req: TRequest, @Res() res: TResponse) {
        // 销毁 session
        req.session.destroy();
        // 清除 cookie
        res.clearCookie(this.config.get('AUTH_COOKIE_NAME'), { path: '/' });
        // 调用 passport 的 logout方法
        req.logout();
        // 重定向到首页
        res.redirect('/');
    }
}
```

就是一波清空操作，调用`passport`的`logout`方法。

代码已更新，[传送门](https://github.com/jiayisheji/nest-cnode)。

欲知后事如何，请听下回分解。

> 中篇就到此为止了，最后感谢大家暴力吹更，让我坚持不懈的把它写完。后面就比较容易了。[Typeorm](https://github.com/typeorm/typeorm)比较火，等我把全部业面写完了，会更新`typeorm`版操作`MongoDB`。回馈大家不离不弃的关注，再次感谢大家阅读。

[本文来自 https://github.com/jiayisheji/blog/issues/19](https://github.com/jiayisheji/blog/issues/18)

