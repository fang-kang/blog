---
title: uniApp常用js函数
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/6.png
tags:
 - uniApp
 - utils
categories:
 - uniApp
---

## uniApp常用js函数

<!-- more -->

``` javascript

// common/all.js

// 图片路径
function preview1(e) {
	uni.previewImage({
		urls: [e],
	});
}

// 图片数组，图片路径
function preview2(e, q) {
	uni.previewImage({
		urls: e,
		current: q,
		indicator: 'number'
	});
}

function previewLB(e) {
	uni.previewImage({
		urls: [getApp().globalData.baseUrl + e.image],
	});
}

// 加载中
function loading(){
	uni.showLoading({
		title:'努力加载中~',
		mask:true
	})
}

function img(e) {
	return getApp().globalData.baseUrl + e
}

// 隐藏银行卡 19位
// replace(/^(\w{3})\w{4}(.*)$/, '$1****$2'  正则修改手机号
function changeBank(e) {
	console.log(e);
	e = '' + e;
	var ary = e.split('');
	ary.splice(4, 12, ' **** **** **** ');
	var num = ary.join('');
	return num;
}
/**
 * 13位时间戳转标准时间,如果10位则*1000
 * 
 * 在main.js中
	配置全局时间格式
	import formatTime from './plugins/utils/filters'
	Vue.prototype.formatTime=formatTime
	在页面中
	console.log(this.formatTime(this.time*1000,'YYYY-MM-DD hh:mm:ss'));
	
 *  filters.js
 * 对Date的扩展，将 Date 转化为指定格式的String  默认是2019-11-25 14:00:00 需要格式则后续传值
 * 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
 * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
 * (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2019-11-25 08:09:04.423
 * (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2019-11-25 8:9:4.18
 * 使用格式,dom上 {{formatTime(time,'YYYY-MM-DD')}}
 * 在script中 this.formatTime(this.time,"hh:mm:ss")
 * 
 */
import Vue from 'vue'
Date.prototype.Format = function(fmt) {
	var o = {
		"M+": this.getMonth() + 1, //月份
		"D+": this.getDate(), //日
		"h+": this.getHours(), //小时
		"m+": this.getMinutes(), //分
		"s+": this.getSeconds(), //秒
		"q+": Math.floor((this.getMonth() + 3) / 3), //季度
		"S": this.getMilliseconds() //毫秒
	};
	if (/(Y+)/.test(fmt))
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	for (var k in o)
		if (new RegExp("(" + k + ")").test(fmt))
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}
const formatTime = function(times, pattern) {
	var d = new Date(times).Format("YYYY-MM-DD hh:mm:ss");
	if (pattern) {
		d = new Date(times).Format(pattern);
	}
	return d.toLocaleString();
}

function num(e) {
	if (e > 9999) {
		return '9999+';
	} else {
		return e;
	}
}
// this.$all.toast('none', '', 2000, false, 'center');
function toast(icon, text, duration = 1500, mask = false, position = 'bottom') {
	uni.showToast({
		icon: icon,
		title: text,
		duration: duration,
		mask: mask,
		position: position,
	})
}
// 秒转时分秒
function changeTime(value) {
	let result = parseInt(value);
	// 　　let h = Math.floor(result / 3600) < 10 ? '0' + Math.floor(result / 3600) : Math.floor(result / 3600)
	let m = Math.floor((result / 60) % 60) < 10 ? '0' + Math.floor((result / 60) % 60) : Math.floor((result / 60) % 60);
	let s = Math.floor(result % 60) < 10 ? '0' + Math.floor(result % 60) : Math.floor(result % 60);
	// 　　result = `${h}:${m}:${s}`
	result = `${m}:${s}`;
	return result;
}
// 上传单图

//调用
//	this.$all.uploadImage(src => {
//		console.log(src) //图片路径
//	})

function uploadImage(callback) {
	uni.chooseImage({
		success: (res) => {
			const tempFilePaths = res.tempFilePaths;
			uni.showLoading({
				title: '上传中',
				mask: true
			})
			uni.uploadFile({
				url: getApp().globalData.baseUrl + '/api/video.Video/qiniu',  //后台上传图片路径 可改
				filePath: tempFilePaths[0],
				name: 'file',
				success: (res) => {
					console.log(JSON.parse(res.data));
					if (JSON.parse(res.data).code == 1) {
						callback(JSON.parse(res.data).data.url)  //后台上传图片字段 可改
					} else {
						uni.showToast({
							title: JSON.parse(res.data).msg,
							mask: true
						})
					}

				},
				complete: () => {
					uni.hideLoading()
				}
			});
		}
	});
}

// 上传多图 

//调用

// this.$all.uploadImage2(imgList => {
//		console.log(imgList) 
// })

function uploadImage2(success, count = 9) {
	uni.chooseImage({
		count: count,
		success: (res) => {
			uni.showLoading({
				title: '上传中',
				mask: true
			})
			console.log(res)
			if (res.tempFilePaths.length > count) {
				uni.showToast({
					icon: 'none',
					title: `最多上传${count}张图片`,
					duration: 2000
				});
			} else {
				var imgList = []
				for (let k = 0; k < res.tempFilePaths.length; k++) {
					// 上传评价图片
					uni.uploadFile({
						url: getApp().globalData.baseUrl + '/api/video.Video/qiniu', //后台上传图片路径 可改
						filePath: res.tempFilePaths[k],
						name: 'file',
						fileType: 'image',
						success: (res) => {
							uni.hideLoading();
							if (JSON.parse(res.data).code == 1) {
								console.log("上传成功", JSON.parse(res.data));
								let url_href = JSON.parse(res.data).data.url		 //后台上传图片字段 可改			
								imgList.push(url_href);
								success(imgList)    //返回图片数组
							} else {
								uni.showToast({
									title: JSON.parse(res.data).msg,
									mask: true
								})
							}
						},
						complete: () => {
							uni.hideLoading()
						}
					});
				}
			}
		}
	});
}
// 字符串转数组
function changeList(e) {
	if (e == null || e == '') {
		return [];
	} else {
		return e.split(',');
	}
}
// 切割时间
function splitTime(e) {
	if (e) {
		return e.split(' ')[0];
	}
}

/**
 * 判断用户输入的内容是否为纯数字
 **/

function validate(obj) {
	var reg = /^[0-9]*$/;
	return reg.test(obj);

};

export default {
	validate,
	preview1,
	preview2,
	previewLB,
	img,
	formatTime,
	changeBank,
	num,
	toast,
	changeTime,
	changeList,
	splitTime,
	uploadImage,
	uploadImage2,
	loading
}


```

``` js

// main.js

import all from './common/all.js';
Vue.prototype.$all = all;

```

