---
title: Vue项目 webpack优化 compression-webpack-plugin 开启gzip
date: 2020-12-09 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/2.jpg
tags:
 - webpack       
categories: 
 - webpack
---

> 打包的时候开启gzip可以很大程度减少包的大小，非常适合于上线部署。更小的体积对于用户体验来说就意味着更快的加载速度以及更好的用户体验。

## Vue-cli3.0项目 安装依赖：`compression-webpack-plugin`

```bash
　　npm install compression-webpack-plugin@6.0.5 -D
```

{% note warning %}
安装最新版7.0.0的时候报错 回退下版本就好了
{% endnote %}

```js
"use strict";
const path = require("path");
const CompressionWebpackPlugin = require("compression-webpack-plugin");
const productionGzipExtensions = ["js", "css"];

function resolve(dir) {
 return path.join(__dirname, dir)
}
module.exports = {
 lintOnSave: false,
 publicPath: './',
 // 配置webpack打包
 productionSourceMap: false,
 configureWebpack: (config) => {
  // 取消console打印    
  config.optimization.minimizer[0].options.terserOptions.compress.drop_console = true
  if (process.env.NODE_ENV === 'production') {
   return {
    plugins: [
     new CompressionWebpackPlugin({
      filename: "[path].gz[query]",
      algorithm: "gzip",
      test: new RegExp("\\.(" + productionGzipExtensions.join("|") + ")$"), //匹配文件名
      threshold: 10240, //对10K以上的数据进行压缩
      minRatio: 0.8,
      deleteOriginalAssets: true //是否删除源文件
     })
    ]

   }
  }
 },
 chainWebpack: config => {
  config.plugins.delete('preload') 
  config.plugins.delete('prefetch')
 },
 // 第三方插件配置
 pluginOptions: {
  // ...
  pwa: {
   iconPaths: {
    favicon32: './favicon.ico',
    favicon16: './favicon.ico',
    appleTouchIcon: './favicon.ico',
    maskIcon: './favicon.ico',
    msTileImage: './favicon.ico'
   }
  },
 }
}

```

## 服务器启用`gzip`

**在 `nginx/conf/nginx.conf` 中配置**

```bash
# 开启和关闭gzip模式
gzip on;
# gizp压缩起点，文件大于1k才进行压缩
gzip_min_length 1k;
# 设置压缩所需要的缓冲区大小，以4k为单位，如果文件为7k则申请2*4k的缓冲区 
gzip_buffers 4 16k;
# 设置gzip压缩针对的HTTP协议版本
gzip_http_version 1.1;
# gzip 压缩级别，1-9，数字越大压缩的越好，也越占用CPU时间
gzip_comp_level 2;
# 需要压缩的文件mime类型
gzip_types text/plain application/javascript application/x-javascript text/javascript text/css application/xml;
# 是否在http header中添加Vary: Accept-Encoding，建议开启
gzip_vary on;
# nginx做前端代理时启用该选项，表示无论后端服务器的headers头返回什么信息，都无条件启用压缩
gzip_proxied expired no-cache no-store private auth;
# 不启用压缩的条件，IE6对Gzip不友好，所以不压缩
gzip_disable "MSIE [1-6]\.";
```

gzip

`gzip`属于在线压缩，在资源通过`http`发送报文给客户端的过程中，进行压缩，可以减少客户端带宽占用，减少文件传输大小。

一般写在`server`或者`location`均可；

```bash
server {
 listen 6002;
 server_name **.234.133.**;

 gzip on;
 gzip_proxied any;
 gzip_types
  text/css
  text/javascript
  text/xml
  text/plain
  image/x-icon
  application/javascript
  application/x-javascript
  application/json;
}
```
