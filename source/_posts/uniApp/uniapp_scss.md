---
title: uniApp全局公共样式
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/1cm6iu.webp
tags:
 - uniApp
 - scss
 - utils
categories:
 - uniApp
---

## 内置的一些类名，方便全局使用

<!-- more -->

```scss

/* 
  全局公共样式  
  by fk 2020年11月5日11:27
 */

body {
	/* background-color: #f6f6f6; */
	color: #333333;
	font-family: Helvetica Neue, Helvetica, sans-serif;
}

.yuan{
	border-radius: 50%;
}

view,
scroll-view,
swiper,
button,
input,
textarea,
label,
navigator,
image {
	box-sizing: border-box;
}

.btnhover {
	opacity: .7;
}

.c-white {
	color: #FFFFFF;
}

.bg-white{
	background-color: #fff;
}

.c-black {
	color: #333333;
}

.ty_content-tab {
	height: calc(100vh - var(--status-bar-height));
	width: 100%;
	/* background-color: #f6f6f6; */
}

.ty_content {
	min-height: 100vh;
	width: 100%;
	background-color: #fff;
}

.ty_contenthui {
	min-height: 100vh;
	width: 100%;
	background-color: #f6f6f6;
}

.ty-hengxiang {
	display: flex;
	flex-direction: row;
}

.ty_hengxiangjuzhong {
	display: flex;
	flex-direction: row;
	-webkit-justify-content: center;
	justify-content: center;
}

.ty_hengxiangliangduan {
	display: flex;
	flex-direction: row;
	-webkit-justify-content: space-between;
	justify-content: space-between;
}

.ty_hengxiangjuyou {
	display: flex;
	flex-direction: row;
	-webkit-justify-content: flex-end;
	justify-content: flex-end;
}

.ty-zidongzhanman {
	-webkit-flex: 1;
	flex: 1;
}

.ty-hengxianghuanhang {
	display: flex;
	flex-wrap: wrap;
}

.ty_zidongzhanman {
	-webkit-flex: 1;
	flex: 1;
}

.ty_chuizhijuzhong {
	align-items: center;
}

.ty_shang {
	width: 750rpx;
	height: 40rpx;
}

.ty_daohanglan {
	width: 750rpx;
	height: 128rpx;
	background-color: #FFFFFF;
}

.ty_anniuzi {
	width: 750rpx;
	height: 88rpx;

	align-items: center;
	-webkit-justify-content: space-between;
	justify-content: space-between;
}

.ty_biaoti {
	margin-right: 64rpx;
	-webkit-flex: 1;
	flex: 1;
	text-align: center;
	font-size: 36rpx;
	letter-spacing: 0rpx;
	color: #464646;
}

.ty_yuan {
	border-radius: 150rpx;
}

.ty_mc {
	background: rgba(0, 0, 0, 0.4);
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	z-index: 10241;

}

.ty_mc10 {
	background: rgba(0, 0, 0, 1);
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	z-index: 102411;

}

.ty_back {
	width: 45rpx;
	height: 45rpx;
}

.ty_guding {
	position: fixed;
	width: 100%;
	top: 0;
	z-index: 1024;
	box-shadow: 0 1upx 6upx rgba(0, 0, 0, 0.1);
}

.ty_beijinghuise {
	width: 100%;
	background-color: #F1F1F1;
}

.ty_congxiapailie {
	display: flex;
	flex-direction: column-reverse;
}

.ty_mengceng {
	background: rgba(21, 19, 19, 0.6);
	box-sizing: border-box;
	position: fixed;
	z-index: 1111;
	width: 750rpx;
}

.t-s {
	text-shadow: #999 2rpx 2rpx 5rpx;
}

/* 特殊处理 */
.ty_shanchuxian {
	text-decoration: line-through;
	/* 加删除线 */
}

/*========== flex布局相关 ==========*/
.dp-f {
	display: flex;
	display: -webkit-flex;
	/*在webkit内核的浏览器上使用要加前缀*/
}

/*快捷水平垂直居中*/
.dp-fc {
	display: flex;
	display: -webkit-flex;
	align-items: center;
	justify-content: center;
}

/*行内块元素*/
.dp-ib {
	display: inline-block!important;
}

/* 主轴方向 */
.fd-rr {
	flex-direction: row-reverse!important;
	/* 主轴方向从右到左,默认从左到右 */
}

.fd-c {
	flex-direction: column!important;
	/* 主轴方向从上到下,默认从左到右 */
}

.fd-cr {
	flex-direction: column-reverse!important;
	/* 主轴方向从下到上,默认从左到右 */
}

/* flex-wrap属性 */
.fw-w {
	flex-wrap: wrap!important;
	/* 换行，第一行在上方。 */
}

.fw-wr {
	flex-wrap: wrap-reverse!important;
	/* 换行，第一行在下方。 */
}

/* justify-content属性 */
.jc-fs {
	justify-content: flex-start!important;
	/* 在主轴左对齐-默认 */
}

.jc-fe {
	justify-content: flex-end!important;
	/* 在主轴右对齐 */
}

.jc-c {
	justify-content: center!important;
	/* 在主轴居中对齐 */
}

.jc-sb {
	justify-content: space-between!important;
	/* 两端对齐（两边不留空） */
}

.jc-sa {
	justify-content: space-around!important;
	/* 等距对齐*/
}


/* align-items属性 */
.ai-fs {
	align-items: flex-start!important;
}

.ai-fe {
	align-items: flex-end!important;
	/* 底对齐 */
}

.ai-c {
	align-items: center!important;
	/* 水平居中 */
}

.ai-bl {
	align-items: baseline!important;
	/* 水平居中 */
}

/* align-content属性(多列对齐) */

.ac-fs {
	align-content: flex-start!important;
	/* 与交叉轴的起点对齐 */
}

.ac-fe {
	align-content: flex-end!important;
	/* 与交叉轴的终点对齐 */
}

.ac-c {
	align-content: center!important;
	/* 与交叉轴的中点对齐。 */
}

.ac-sb {
	align-content: space-between!important;
	/* 与交叉轴两端对齐，轴线之间的间隔平均分布。 */
}

.ac-sa {
	align-content: space-around!important;
	/* 每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。 */
}

/* align-self属性(默认auto),该属性用于子元素特殊处理 */
.as-fs {
	align-self: flex-start!important;
	/* 自身在交叉左对齐 */
}

.as-fe {
	align-self: flex-end!important;
	/* 自身在交叉右对齐 */
}

.as-c {
	align-self: center!important;
	/* 自身在交叉居中对齐 */
}

.as-bl {
	align-self: baseline!important;
	/* 自身根据文字对齐 */
}





/* 定位相关 */
.pt-f {
	position: fixed;
}

.pt-r {
	position: relative;
}

.pt-a {
	position: absolute;
}

.top-0 {
	top: 0;
}

.lef-0 {
	left: 0;
}

.rig-0 {
	right: 0;
}

.bot-0 {
	bottom: 0;
}

.all-0 {
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
}


/* 百分比 */
.w100 {
	width: 100%;
}

.h100 {
	height: 100%;
}

/* 对齐方式 */
.te-l {
	text-align: left;
}

.te-r {
	text-align: right;
}

.te-c {
	text-align: center;
}

/* 粗体 */
.fw-b {
	font-weight: bold;
}

.fw-l {
	font-weight: lighter;
}

.fw-n {
	font-weight: normal;
}

// 定义flex等分
@for $i from 0 through 12 {
	.f-#{$i} {
		flex: $i;
	}
}

// 定义字体(rpx)单位，10~100rpx  fs-10 ~ fs-100
@for $i from 10 through 100 {
	.fs-#{$i} {
		font-size: $i + rpx;
	}
}

// 定义内外边距，历遍1-100
@for $i from 0 through 100 {
	// 得出：m-all-30
	.m-all-#{$i} {
		margin: $i + rpx;
	}
	
	// 得出：p-all-30
	.p-all-#{$i} {
		padding: $i + rpx;
	}
	
	@each $short,$long in l left, t top, r right, b bottom {
		// 缩写版，结果如： ml-30
		// 定义外边距
		.m#{$short}-#{$i} {
			margin-#{$long}: $i + rpx;
		}
		
		// 定义内边距
		.p#{$short}-#{$i} {
			padding-#{$long}: $i + rpx;
		}
	}
}

//全局宽高
@for $i from 0 through 750 {
	 // w-0 ~ w-750
	.w-#{$i} {
		width: $i + rpx;
	}
	 // h-0 ~ h-750
	.h-#{$i} {
		height: $i + rpx;
	}
}

//全局圆角 行高 br-0 ~ br-50  lh0 ~ lh-50
@for $i from 0 through 50 {
	 // w-0 ~ w-750
	.br-#{$i} {
		border-radius: $i + rpx;
	}
	 // h-0 ~ h-750
	.lh-#{$i} {
		line-height: $i + rpx;
	}
}


/* start--文本行数限制--start */
.line-1 {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  word-break: break-all;
}

.line-2 {
    -webkit-line-clamp: 2;
}

.line-3 {
    -webkit-line-clamp: 3;
}

.line-4 {
    -webkit-line-clamp: 4;
}

.line-5 {
    -webkit-line-clamp: 5;
}

.line-2, .line-3, .line-4, .line-5 {
    overflow: hidden;
	word-break: break-all;
    text-overflow: ellipsis; 
    display: -webkit-box; // 弹性伸缩盒
    -webkit-box-orient: vertical; // 设置伸缩盒子元素排列方式
}

```



