---
title: uniApp小程序 腾讯地图/百度地图 地理编码与逆编码
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/hero.jpg
tags:
  - 地图
  - uniApp
  - utils
categories:
  - uniApp
---

## uniApp 小程序 腾讯地图/百度地图 地理编码与逆编码

### 腾讯地图

1. 申请开发者密钥（`key`）：申请密钥

2. 开通`webserviceAPI`服务：控制台 -> `key`管理 -> 设置（使用该功能的`key`）-> 勾选`webserviceAPI` -> 保存

3. (小程序`SDK`需要用到`webserviceAPI`的部分服务，所以使用该功能的`KEY`需要具备相应的权限)

4. 下载微信小程序`JavaScriptSDK`，微信小程序[JavaScriptSDK v1.2](http://3gimg.qq.com/lightmap/xcx/jssdk/qqmap-wx-jssdk1.2.zip)

5. 安全域名设置，在“设置” -> “开发设置”中设置`request`合法域名，添加`https://apis.map.qq.com`

- 腾讯地图获取地理位置

```javascript
 //// 引入SDK核心类
 const QQMapWX = require('@/libs/qqmap-wx-jssdk.min.js');
 var qqmapsdk
 var self;

 onLoad(){
  self = this
  self.mapCtx = uni.createMapContext('map')
  // 实例化API核心类
  qqmapsdk = new QQMapWX({
   key: 'your key'
  });

  //获取地址
  qqmapsdk.reverseGeocoder({
   location: {
    latitude: uni.getStorageSync('latitude') ,
    longitude: uni.getStorageSync('longitude'),
   },
   success: (res, data) => {
    console.log(res, data)
    this.location = data.reverseGeocoderResult.address_component.province + data.reverseGeocoderResult.address_component.city +
    data.reverseGeocoderResult.address_component.district
   }
  })


  //获取经纬度
  qqmapsdk.geocoder({
   address:'北京市海淀区彩和坊路海淀西大街74号'
    success: (res, data) => {
    console.log(res, data)
   }
  })
 }

```

### 百度地图

1. 注册百度账号，成为百度地图开发者

2. 进入百度开放平台官网，点击右上角“API 控制台”，注册成为百度地图开发者。如果未登录百度账号，会引导登录百度账号。如果账号未注册，请根据提示填写正确的邮箱及手机号完成开发者注册流程

3. 创建应用 再次点击进入控制台，创建一个新应用。

4. 获取密钥（AK）

> 在创建应用页面，录入应用名称、选择应用类型为"微信小程序"、勾选启用服务、填写`AppID`(小程序 ID)。点击提交后，即可在查看应用页面看到申请成功的密钥（`AK`）。

5. 引入 JS 模块

- 在项目根目录下新建一个路径，下载百度地图微信小程序[JavaScript API](https://mapopen-website-wiki.cdn.bcebos.com/wechat-api/wxapp-jsapi-master.zip)，
- 解压后的文件中有 `bmap-wx.js` 文件(压缩版 `bmap-wx.min.js` )，将其拷贝到新建的路径下，安装完成。
- 新建路径 "`libs`" ,将 `bmap-wx.js` 文件拷贝至 "`libs`" 路径下。

6. 安全域名设置，在“设置” -> “开发设置”中设置`request`合法域名，添加`api.map.baidu.com`

- 百度地图获取地理位置

```javascript
 // 引入SDK核心类
 const bmap = require('@/libs/bmap-wx.min.js');
 var BMap;
 var self;

 onLoad(){
  self = this
  self.mapCtx = uni.createMapContext('map')
  // 实例化API核心类
  BMap = new bmap.BMapWX({
    ak: 'your key'
   });

  //获取地址
   BMap.regeocoding({
    location: uni.getStorageSync('longitude') + ',' + uni.getStorageSync('latitude'),
    success: (res) => {
     console.log(res)
    },
    fail: () => {
     uni.showToast({
      title: '请检查位置服务是否开启',
     })
    },
   });


  //获取经纬度
  BMap.geocoding({
   address:'北京市海淀区彩和坊路海淀西大街74号'
    success: (res, data) => {
    console.log(res, data)
   }
  })
 }

```
