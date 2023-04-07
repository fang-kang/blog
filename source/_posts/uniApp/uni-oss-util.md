---
title: uniApp上传图片阿里云工具类
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/1.jpg
tags:
 - uniApp
 - utils
categories:
 - uniApp
---

## uniApp上传图片阿里云工具类

<!-- more -->

``` javascript

import Vue from 'vue';
module.exports = {
	// 开始上传，图片版 
	uploadImage: function(success) {
		this.select_img(1, success);
	},
	// 选择文件 （参数：上传类型、上传成功的回调）
	select_img:  function(way, success) {
		uni.chooseImage({
			count: 1,	// 只能选择一个 
			success: function(res) {	// 选择成功的回调 
				// console.log(res);
				if (res.tempFilePaths.length > 0) {
					let filePath = res.tempFilePaths[0];	// 文件地址 
					let ext = '';	// 文件后缀 
					// #ifdef H5
						ext = this.get_suffix(res.tempFiles[0].name);	// h5端这样获取 
					// #endif
					// #ifndef H5
						ext = this.get_suffix(res.tempFiles[0].path);	// 非h5端这样获取 
					// #endif
					this.get_sign(way, filePath, ext, success);
				} else {
					console.log('选择文件失败');
				}
			}.bind(this)
		})
	},
	// 获取临时授权签名  （参数：上传类型、文件地址、文件后缀、上传成功的回调）
	get_sign: function(way, filePath, ext, success) {
		// 1、请求地址 
		var url = getApp().globalData.baseUrl + '/sp-home/alioss/getSign';	// 修改地方一：请求地址
		// 2、从服务器获取oss临时授权签名信息 
		uni.request({
			url: url,
			header: this.get_header(),
			data: {way: way, ext: ext},
			success: function(res) {
				if(res.data.code == 200) {
					var sign_obj = res.data.data;
					this.upload_to_oss(sign_obj, filePath, success);
				} else {
					console.log('错误：' +  res.data.msg);
				}
			}.bind(this)
		});
	},
	// 根据签名将文件上传到阿里云 （参数：签名信息、文件地址、上传成功的回调）
	upload_to_oss: function(sign_obj, filePath, success) {
		// 1、声明FormData对象
		var formData = {
			"OSSAccessKeyId": sign_obj.OSSAccessKeyId, //Bucket 拥有者的Access Key Id。
			"policy": sign_obj.policy, //policy规定了请求的表单域的合法性
			"Signature": sign_obj.Signature, //根据Access Key Secret和policy计算的签名信息，OSS验证该签名信息从而验证该Post请求的合法性
			"key": sign_obj.key, //文件名字，可设置路径
			"success_action_status": sign_obj.success_action_status, // 让服务端返回200,不然，默认会返回204
			'x-oss-object-acl': sign_obj['x-oss-object-acl']
		};
		uni.showLoading({
			title:'上传中',
			mask:false
		})
		// 2、开始上传  
		uni.uploadFile({
			url: sign_obj.host,
			name: 'file',
			filePath: filePath,
			formData: formData,
			success: function(res) {
				console.log('上传成功');
				uni.hideLoading()
				success(sign_obj.file_url);
			}
		})
		
	},
	// 根据文件名，返回后缀名
	get_suffix: function (filename) {
		var pos = filename.lastIndexOf('.');
		let suffix = '';
		if (pos != -1) {
			suffix = filename.substring(pos + 1);
		}
		return suffix;
	},
	// 获取header信息 
	get_header: function() {
		// 修改地方一：获取token的方式 
		var tokenName = 'satoken'    // 从本地缓存读取tokenName值
		var tokenValue = uni.getStorageSync('satoken');    // 从本地缓存读取tokenValue值
		var header = {
		    "content-type": "application/x-www-form-urlencoded"     // 防止后台拿不到参数
		};
		if (tokenName != undefined && tokenName != '') {
		    header[tokenName] = tokenValue;
		}
		// header["satoken"] = "0cb3e831-bb77-4b5d-a02f-637fdf5bbdf3"; 	// 弄一个假的，方便测试 ，正式环境删掉 
		return header;
	},
} 

```

