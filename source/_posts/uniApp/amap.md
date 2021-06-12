---
title: 高德地图地理编码与逆编码
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/banner.png
tags:
 - 地图
 - uniApp
 - utils
categories:
 - uniApp
---

## 高德地图地理编码与逆编码

- 获取地理位置

<!-- more -->

``` javascript

uni.request({
	url: "https://restapi.amap.com/v3/geocode/regeo",
	method: "GET",
	data: {
		key: 'your key',
		location: '116.481488,39.990464',
	},
	header: {
		"Content-Type": "application/x-www-form-urlencoded",
	},
	success: res => {
			console.log(res)
		}
	});

```

<!-- more -->

- 获取经纬度

``` javascript

uni.request({
	url: "https://restapi.amap.com/v3/geocode/geo",
	method: "GET",
	data: {
		key: 'your key',
		address: '北京市朝阳区阜通东大街6号',
		city: '北京'
	},
	header: {
		"Content-Type": "application/x-www-form-urlencoded",
	},
	success: res => {
			console.log(res)
		}
	});

```


