---
title: vue.config.js
date: 2020-11-21 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/73twhs.webp
sticky: 1
tags:
 - vue.config
categories:
  - vue
---

## vue.config.js常用配置

{% note success %}

使用`vue-cli`3.0搭建项目比之前更简洁，没有了`build`和`config`文件夹。
`vue-cli3`的一些服务配置都迁移到`CLI Service`里面了，对于一些基础配置和一些扩展配置需要在根目录新建一个`vue.config.js`文件进行配置

{% endnote %}
<!-- more -->
```js 
module.exports = {
  // 选项...
}
```


### publicPath 

`baseUrl`从 Vue CLI 3.3 起已弃用使用`publicPath`来替代。

在开发环境下，如果想把开发服务器架设在根路径，可以使用一个条件式的值

``` js
module.exports = {
  publicPath: process.env.NODE_ENV === 'production' ? '/production-sub-path/' : '/'
}
```

{% note success %}

`Type: string`
`Default`: '/'
 部署应用包时的基本 `URL`， 用法和 `webpack` 本身的 `output.publicPath`一致。
这个值也可以被设置为空字符串 ('') 或是相对路径 ('./')，这样所有的资源都会被链接为相对路径，这样打出来的包可以被部署在任意路径。

{% endnote %}

### outputDir

{% note success %}

`Type: string`
Default: '`dist`'
输出文件目录，当运行 `vue-cli-service build` 时生成的生产环境构建文件的目录。注意目标目录在构建之前会被清除 (构建时传入 --no-clean 可关闭该行为)。

{% endnote %}

``` js
module.exports = {
 outputDir: 'dist',
}
```

### assetsDir

{% note success %}

`Type: string`
Default: ''
放置生成的静态资源 (`js`、`css`、`img`、`fonts`) 的目录。

{% endnote %}

```js
module.exports = {
 assetsDir: 'assets',
}
```
>注：从生成的资源覆写 filename 或 chunkFilename 时，assetsDir 会被忽略。

### indexPath

{% note success %}

Type: `string`
Default: '`index.html`'
指定生成的 `index.html` 的输出路径 (相对于 `outputDir`)。也可以是一个绝对路径。

{% endnote %}

``` js
module.exports = {
 indexPath: 'index.html',
}
```

### filenameHashing

{% note success %}

Type: `boolean`
Default: `true`
默认情况下，生成的静态资源在它们的文件名中包含了 `hash` 以便更好的控制缓存。然而，这也要求 `index` 的 `HTML` 是被 `Vue CLI `自动生成的。如果你无法使用 `Vue CLI` 生成的 `index HTML`，你可以通过将这个选项设为 false 来关闭文件名哈希。

{% endnote %}

``` js
module.exports = {
 filenameHashing: true,
}
```

### pages

{% note success %}

Type: `Object`
Default: `undefined`
在 `multi-page`（多页）模式下构建应用。每个“`page`”应该有一个对应的 `JavaScript` 入口文件。

{% endnote %}

其值应该是一个对象，对象的 key 是入口的名字，value 是：

{% note success %}

一个指定了 `entry`, `template`, `filename`, `title` 和 `chunks` 的对象 (除了 `entry` 之外都是可选的)；
或一个指定其 `entry` 的字符串。

{% endnote %}

``` js
module.exports = {
	//用于多页配置 默认是undefined
 pages:{	 
	 index:{
		 //page的入口文件
		 entry：'src/index/main.js',
		 //模板文件
		 template:'index.html',
		 //在dist/index.html输出的文件
		 filename:'index.html',
		 //当使用页面title选项时，
		 //template中的title标签需要<title><%= htmlWebpackPlugin.options.title %></title>
		 title:'标题',
		 //在这个页面中包含的块，默认情况下会包含
		 //提取出来的同意chunk和vendor chunk
		 chunk:['chunk-vendors','chunk-common','index']
	 },
	 //当使用只有入口的字符串格式时
	 //模板文件默认是`public/subpage.html`,
	 //如果不存在，就回退到`public/index.html`,
	 //输入文件默认是`subpage.html`.
	 subpage:'src/subpage/main.js'
 }
}
```
> 注：当在 多页应用 模式下构建时，`webpack` 配置会包含不一样的插件 (这时会存在多个 html-webpack-plugin 和 `preload-webpack-plugin `的实例)。如果你试图修改这些插件的选项，请确认运行 `vue inspect`。

### lintOnSave

{% note success %} 

Type: `boolean | 'error'`
Default: `true`
是否在保存的时候使用 `eslint-loader` 进行检查。 有效的值：`ture` | `false` | `"error"`  当设置为 `"error"` 时，检查出的错误会触发编译失败。

{% endnote %}

``` js
module.exports = {
 lintOnSave: true,
}
```

### runtimeCompiler

{% note success %}

Type: `boolean`
Default: `false`
是否使用包含运行时编译器的 `Vue` 构建版本。设置为 `true` 后你就可以在 `Vue` 组件中使用 `template` 选项了，但是这会让你的应用额外增加 `10kb` 左右。

{% endnote %}

``` js
module.exports = {
 runtimeCompiler: false,
}
```

### transpileDependenciesCDN

{% note success %}

Type: `Array<string | RegExp>`
Default: []
默认情况下 `babel-loader` 会忽略所有 `node_modules` 中的文件。如果你想要通过 `Babel` 显式转译一个依赖，可以在这个选项中列出来。

{% endnote %}

### productionSourceMap

{% note success %}

Type: `boolean`
Default: `true`
如果你不需要生产环境的 `source map`，可以将其设置为 `false` 以加速生产环境构建。

{% endnote %}

### crossorigin

{% note success %}

Type: `string`
Default: `undefined`
设置生成的 `HTML` 中 `<link rel="stylesheet">` 和 `<script>` 标签的 `crossorigin` 属性。

{% endnote %}

### integrity

{% note success %}

Type: `boolean`
Default: `false`
在生成的 `HTML` 中的 `<link rel="stylesheet"> `和 `<script>` 标签上启用 `Subresource` `Integrity` (SRI)。如果你构建后的文件是部署在 `CDN` 上的，启用该选项可以提供额外的安全性。

{% endnote %}

## Webpack相关配置

### configureWebpack

{% note success %}

Type: `Object | Function`
如果这个值是一个对象，则会通过` webpack-merge` 合并到最终的配置中。
如果这个值是一个函数，则会接收被解析的配置作为参数。该函数及可以修改配置并不返回任何东西，也可以返回一个被克隆或合并过的配置版本。

{% endnote %}

### chainWebpack

{% note success %}

Type: `Function`
是一个函数，会接收一个基于 `webpack-chain` 的 `ChainableConfig` 实例。允许对内部的 `webpack` 配置进行更细粒度的修改。

{% endnote %}

## Css相关配置

### css.modules

{% note success %}

Type: `boolean`
Default: `false`
默认情况下，只有 `*.module.[ext] `结尾的文件才会被视作 `CSS` `Modules` 模块。设置为 `true` 后你就可以去掉文件名中的 `.module` 并将所有的 `*.(css|scss|sass|less|styl(us)?)` 文件视为 `CSS` `Modules` 模块。

{% endnote %}

### css.extract

{% note success %}

Type: `boolean | Object`
Default: 生产环境下是 `true`，开发环境下是 `false`
是否将组件中的 `CSS` 提取至一个独立的 `CSS` 文件中 (而不是动态注入到 `JavaScript` 中的 `inline` 代码)。

{% endnote %}

### css.sourceMap

{% note success %}

Type: `boolean`
Default: `false`
是否为 `CSS` 开启 `source map`。设置为 `true` 之后可能会影响构建的性能。

{% endnote %}

### css.loaderOptions

{% note success %}

Type: `Object`
Default: {}
向 `CSS` 相关的 `loader` 传递选项。

{% endnote %}

支持的 `loader` 有：

- css-loader

- postcss-loader

- sass-loader

- less-loader

- stylus-loader

### devServer

{% note success %}

Type: `Object`
所有 `webpack-dev-server` 的选项都支持。注意：
有些值像 `host`、`port` 和 `https` 可能会被命令行参数覆写。
有些值像 `publicPath` 和 `historyApiFallback` 不应该被修改，因为它们需要和开发服务器的 `publicPath` 同步以保障正常的工作。

{% endnote %}

### devServer.proxy

{% note success %}

Type: `string | Object`
如果你的前端应用和后端 `API` 服务器没有运行在同一个主机上，你需要在开发环境下将 `API` 请求代理到 API 服务器。这个问题可以通过 `vue.config.js` 中的 `devServer.proxy` 选项来配置。

{% endnote %}


```js

module.exports = {
  runtimeCompiler: true,
  devServer: {
      proxy: {
          // 匹配请求路径中的字符， 
          // 如果符合就用这个代理对象代理本次请求，路径为target的网址， 
          // changeOrigin为是否跨域，
          // 如果不想始终传递这个前缀，可以重写路径 
          // pathRewrite为是否将指定字符串转换一个再发过去。
          '/api': {
            target: 'http://localhost:9001',
              ws: true,
              changeOrigin: true,
              pathRewrite: {
                  '^/api': ''
              }
          }
      }
  }
}
```

### parallel

{% note success %}

Type: `boolean`
Default: require('os').cpus().length > 1
是否为 `Babel` 或 `TypeScript` 使用 `thread-loader`。该选项在系统的 `CPU` 有多于一个内核时自动启用，仅作用于生产构建。

{% endnote %}

### pwa

{% note success %}

Type: `Object`
向 `PWA` 插件传递选项。

{% endnote %}

### pluginOptions

{% note success %}

Type: `Object`
这是一个不进行任何 `schema` 验证的对象，因此它可以用来传递任何第三方插件选项

{% endnote %}

```js
module.exports = {
    // 部署应用时的基本 URL
    publicPath: process.env.NODE_ENV === 'production' ? '192.168.60.110:8080' : '192.168.60.110:8080',

    // build时构建文件的目录 构建时传入 --no-clean 可关闭该行为
    outputDir: 'dist',

    // build时放置生成的静态资源 (js、css、img、fonts) 的 (相对于 outputDir 的) 目录
    assetsDir: '',

    // 指定生成的 index.html 的输出路径 (相对于 outputDir)。也可以是一个绝对路径。
    indexPath: 'index.html',

    // 默认在生成的静态资源文件名中包含hash以控制缓存
    filenameHashing: true,

    // 构建多页面应用，页面的配置
    pages: {
        index: {
            // page 的入口
            entry: 'src/index/main.js',
            // 模板来源
            template: 'public/index.html',
            // 在 dist/index.html 的输出
            filename: 'index.html',
            // 当使用 title 选项时，
            // template 中的 title 标签需要是 <title><%= htmlWebpackPlugin.options.title %></title>
            title: 'Index Page',
            // 在这个页面中包含的块，默认情况下会包含
            // 提取出来的通用 chunk 和 vendor chunk。
            chunks: ['chunk-vendors', 'chunk-common', 'index']
        },
        // 当使用只有入口的字符串格式时，
        // 模板会被推导为 `public/subpage.html`
        // 并且如果找不到的话，就回退到 `public/index.html`。
        // 输出文件名会被推导为 `subpage.html`。
        subpage: 'src/subpage/main.js'
    },

    // 是否在开发环境下通过 eslint-loader 在每次保存时 lint 代码 (在生产构建时禁用 eslint-loader)
    lintOnSave: process.env.NODE_ENV !== 'production',

    // 是否使用包含运行时编译器的 Vue 构建版本
    runtimeCompiler: false,

    // Babel 显式转译列表
    transpileDependencies: [],

    // 如果你不需要生产环境的 source map，可以将其设置为 false 以加速生产环境构建
    productionSourceMap: true,

    // 设置生成的 HTML 中 <link rel="stylesheet"> 和 <script> 标签的 crossorigin 属性（注：仅影响构建时注入的标签）
    crossorigin: '',

    // 在生成的 HTML 中的 <link rel="stylesheet"> 和 <script> 标签上启用 Subresource Integrity (SRI)
    integrity: false,

    // 如果这个值是一个对象，则会通过 webpack-merge 合并到最终的配置中
    // 如果你需要基于环境有条件地配置行为，或者想要直接修改配置，那就换成一个函数 (该函数会在环境变量被设置之后懒执行)。该方法的第一个参数会收到已经解析好的配置。在函数内，你可以直接修改配置，或者返回一个将会被合并的对象
    configureWebpack: {},

    // 对内部的 webpack 配置（比如修改、增加Loader选项）(链式操作)
    chainWebpack: () =>{

    },

    // css的处理
    css: {
        // 当为true时，css文件名可省略 module 默认为 false
        modules: true,
        // 是否将组件中的 CSS 提取至一个独立的 CSS 文件中,当作为一个库构建时，你也可以将其设置为 false 免得用户自己导入 CSS
        // 默认生产环境下是 true，开发环境下是 false
        extract: false,
        // 是否为 CSS 开启 source map。设置为 true 之后可能会影响构建的性能
        sourceMap: false,
        //向 CSS 相关的 loader 传递选项(支持 css-loader postcss-loader sass-loader less-loader stylus-loader)
        loaderOptions: {
            css: {},
            less: {}
        }
    },

    // 所有 webpack-dev-server 的选项都支持
    devServer: {},

    // 是否为 Babel 或 TypeScript 使用 thread-loader
    parallel: require('os').cpus().length > 1,

    // 向 PWA 插件传递选项
    pwa: {},

    // 可以用来传递任何第三方插件选项
    pluginOptions: {}
}
```

## 常用配置

```js
const path = require("path");
 
function resolve(dir) {
  return path.join(__dirname, dir);
}
 
// If your port is set to 80,
// use administrator privileges to execute the command line.
// For example, Mac: sudo npm run
const port = 9527; // dev port
 
// All configuration item explanations can be find in https://cli.vuejs.org/config/
module.exports = {
  /**
   * You will need to set publicPath if you plan to deploy your site under a sub path,
   * for example GitHub Pages. If you plan to deploy your site to https://foo.github.io/bar/,
   * then publicPath should be set to "/bar/".
   * In most cases please use '/' !!!
   * Detail: https://cli.vuejs.org/config/#publicpath
   */
  publicPath: "/",
  outputDir: "dist",
  assetsDir: "static",
  lintOnSave: process.env.NODE_ENV === "development",
  productionSourceMap: false,
  devServer: {
    port,
    open: true,
    overlay: {
      warnings: false,
      errors: true
    },
    // 配置代理 （以接口 https://www.easy-mock.com/mock/5ce2a7854c85c12abefbae0b/api 说明）
    proxy: {
      "/api": {
        // 以 “/api” 开头的 代理到 下边的 target 属性 的值 中
        target: process.env.VUE_APP_URL,
        changeOrigin: true, // 是否改变域名
        ws: true,
        pathRewrite: {
          // 路径重写
          "/api": "5ce2a7854c85c12abefbae0b/api" // 这个意思就是以api开头的，定向到哪里, 如果你的后边还有路径的话， 会自动拼接上
        }
      }
    }
    // 下边这个， 如果你是本地自己mock 的话用after这个属性，线上环境一定要干掉
    // after: require("./mock/mock-server.js")
  },
  configureWebpack: {
    // provide the app's title in webpack's name field, so that
    // it can be accessed in index.html to inject the correct title.
    resolve: {
      // 配置别名
      alias: {
        "@": resolve("src")
      }
    }
  },
  // webpack配置覆盖
  chainWebpack(config) {
    config.plugins.delete("preload"); // TODO: need test
    config.plugins.delete("prefetch"); // TODO: need test
 
    // set svg-sprite-loader
    config.module
      .rule("svg")
      .exclude.add(resolve("src/icons"))
      .end();
    config.module
      .rule("icons")
      .test(/\.svg$/)
      .include.add(resolve("src/icons"))
      .end()
      .use("svg-sprite-loader")
      .loader("svg-sprite-loader")
      .options({
        symbolId: "icon-[name]"
      })
      .end();
 
    // set preserveWhitespace
    config.module
      .rule("vue")
      .use("vue-loader")
      .loader("vue-loader")
      .tap(options => {
        options.compilerOptions.preserveWhitespace = true;
        return options;
      })
      .end();
 
    config
      // https://webpack.js.org/configuration/devtool/#development
      .when(process.env.NODE_ENV === "development", config =>
        config.devtool("cheap-source-map")
      );
 
    config.when(process.env.NODE_ENV !== "development", config => {
      config
        .plugin("ScriptExtHtmlWebpackPlugin")
        .after("html")
        .use("script-ext-html-webpack-plugin", [
          {
            // `runtime` must same as runtimeChunk name. default is `runtime`
            inline: /runtime\..*\.js$/
          }
        ])
        .end();
      config.optimization.splitChunks({
        chunks: "all",
        cacheGroups: {
          libs: {
            name: "chunk-libs",
            test: /[\\/]node_modules[\\/]/,
            priority: 10,
            chunks: "initial" // only package third parties that are initially dependent
          },
          elementUI: {
            name: "chunk-elementUI", // split elementUI into a single package
            priority: 20, // the weight needs to be larger than libs and app or it will be packaged into libs or app
            test: /[\\/]node_modules[\\/]_?element-ui(.*)/ // in order to adapt to cnpm
          },
          commons: {
            name: "chunk-commons",
            test: resolve("src/components"), // can customize your rules
            minChunks: 3, //  minimum common number
            priority: 5,
            reuseExistingChunk: true
          }
        }
      });
      config.optimization.runtimeChunk("single");
    });
  }
};
```