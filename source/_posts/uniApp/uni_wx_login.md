---
title: uniApp公众号登录和支付公用封装方法
date: 2021-1-05 21:33:01
index_img: https://fang-kang.gitee.io/blog-img/6.jpg
tags:
 - uniApp
 - utils
categories:
 - uniApp
---

最近在开发公众号的时候碰上了这个问题，记录一下,以后有用到再来看

<!-- more -->

## uniApp公众号登录公用封装方法

```js
// 微信工具类 
var wxUtil = {
	// 获取jscode
	getJscode: function(url,success) {
		// 一些配置参数 
		var option = {
			appid: 'wxf3d0029f0ef462b1',	// 替换成你的appid   
			scope: 'snsapi_userinfo',	// 非静默授权，可以获取用户信息  
			// scope: 'snsapi_base',	// 静默授权，仅可获取openid  
			success: success,		// 成功的回调  
			url:url
		}
		this.start_get(option);
	},
	// 开始获取jscode码 
	start_get: function(option) {
		// 如果url中有值，直接从url中取值 
		let jscode = this.p('code');
		if(jscode) {
			return option.success(jscode, option);
		}
		// 如果非微信环境，则不允许此操作 
		if(this.is_weixn_qq() != '微信') {
			alert('当前环境非微信内置浏览器');
			return;
		}
		// 向微信官方请求获取 
		let appid = option.appid;		// appid   
		let uri = encodeURIComponent(option.url); 	// 这里务必编码  
		let scope = option.scope;	// 
		// let scope = 'snsapi_userinfo'; // 
		// let scope = 'snsapi_base'; // 
		let url = "https://open.weixin.qq.com/connect/oauth2/authorize" +  
			"?appid=" + appid + 
			"&redirect_uri=" + uri + 
			"&response_type=code" + 
			"&scope=" + scope + 
			"&state=123" + 
			"#wechat_redirect";
		window.location.href = url;
	},
	// 获取接口上指定参数值  
	p: function(name, defaultValue){
		var query = window.location.search.substring(1);
		var vars = query.split("&");
		for (var i=0;i<vars.length;i++) {
			var pair = vars[i].split("=");
			if(pair[0] == name){return pair[1];}
		}
		return(defaultValue == undefined ? null : defaultValue);
	},
	// 判断当前环境 
	is_weixn_qq: function(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/MicroMessenger/i)=="micromessenger") {
			return "微信";
		} else if (ua.match(/QQ/i) == "qq") {
			return "QQ";
		}
		return false;
	} 
	
}
module.exports = wxUtil;
```

调用

- 注意:需要在公众号后台配置授权回调地址

```js
<script>
	const wxPayUtil = require('./common/uni-wx-util.js')
	export default {
		globalData: {
			baseUrl: 'http://xy.myym.top/xy-server'
		},
		onLaunch: function() {
			console.log('App Launch')
			this.$u.post('/SysUser/getByCurr', {}).then(res => {
			 }).catch(res => {
				wxPayUtil.getJscode('http://xy.myym.top/shop/#/', (code, option) => {
				console.log(code, option)
					this.$u.post('/SysUserAcc/doWeChat',{
						code
					}).then(res=>{
						uni.setStorageSync('satoken',res.data.tokenInfo.tokenValue)
					}).catch(res=>{
						console.log(res)
				})
			 	})
			 })
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>
```

## uniApp公众号支付公用封装方法

```js
// 微信支付相关 
let wxPayUtil = {
	// 开始调起支付
	// 订单信息、成功回调、失败回调
	jsapi_pay: function (info, successFn, failFn) {
		// alert(JSON.stringify(info))  
		WeixinJSBridge.invoke(
			'getBrandWCPayRequest', {
				"appId": info.appId, //公众号名称，由商户传入     
				"timeStamp": info.timeStamp, //时间戳，自1970年以来的秒数     
				"nonceStr": info.nonceStr, //随机串     
				"package": info['package'],
				"signType": info.signType, //微信签名方式：     
				"paySign": info.paySign //微信签名 
			},
			function(res) {
				if (res.err_msg == "get_brand_wcpay_request:ok") {
					// 使用以上方式判断前端返回,微信团队郑重提示：
					// res.err_msg将在用户支付成功后返回ok，但并不保证它绝对可靠。
					if(successFn) {
						successFn();
					}
				} else {
					if(failFn) {
						failFn();
					}
				}

			}
		);
	}
}
module.exports = wxPayUtil;
```

调用

```js
const wxPayUtil = require('../../common/uni-wx-pay-util.js')

//确认支付
pay() {
	this.payShow = !this.payShow
	this.$u.post('/SmOrderPay/getPayInfoByWxAppPay',{
		pay_id:this.pay_id
	}).then(res=>{
		console.log(res)
		wxPayUtil.jsapi_pay(res.data,()=>{
			this.$all.toast('','支付成功')
			//获取订单列表
			this.getOrder()
		},()=>{
			this.$u.toast('支付失败')
		},)
	}).catch(res=>{
		console.log(res)
	})
},
```

**注意:以上方法需要在公众号使用才会有效果**