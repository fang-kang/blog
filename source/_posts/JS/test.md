---
title: test 规则校验
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/sdqryn.webp
tags:
 - Js
 - utils
categories:
 - Js
 - utils
---

# test 规则校验

{% note success %}

里面有一些常用的规则校验 如是否手机号，邮箱号，URL等

{% endnote %}

**首先引入**

``` javascript

//main.js

import test from './common/test.js';
Vue.prototype.$test = test;

```

<!-- more -->


## 是否验证码

`code(value, len = 6)`

校验是否验证码(要求为数字)，返回`true`或者`false`

- `value` <String> 验证码字符串
- `len` <Number> 验证码长度，默认为6

``` javascript

console.log(this.$test.code('4567', 4));

```

## 是否数组

`array(array)`

校验是否数组，返回`true`或者`false`。

- `array` <Array> 数组

``` javascript

console.log(this.$test.array([1, 2, 3]));

```

## 是否Json字符串

`jsonString(json)`

校验是否`Json`，返回`true`或者`false`。

- `json` <Json> Json字符串

注意：请留意`json`字符串的要求：

1. 整体为一个字符串
2. 字符串对象内的属性需要用`""`双引号包含

``` javascript

console.log(this.$test.jsonString('{"a": 1}'));

```

## 是否对象

`object(object)`

校验是否对象，返回`true`或者`false`。

- `object` <Object> 对象

注意：请留意`json`字符串的要求：

1. 整体为一个字符串
2. 字符串对象内的属性需要用`""`双引号包含

``` javascript

console.log(this.$test.object({a: 1}));

```

## 是否邮箱号

`email(email)`

校验是否邮箱号，返回`true`或者`false`。

- `email` <String> 字符串

``` javascript

console.log(this.$test.email('123465798@gmail.com'));

```

## 是否手机号

`mobile(mobile)`

校验是否手机号，返回`true`或者`false`。

- `mobile` <String> 字符串

``` javascript

console.log(this.$test.mobile('13845678900'));

```

## 是否URL

`url(url)`

校验是否URL链接，返回`true`或者`false`。

- `url` <String> 字符串

``` javascript

console.log(this.$test.url('http://www.baidu.com'))

```

## 是否为空

这里指的“空”，包含如下几种情况：

- 值为`undefined`(一种类型)，非字符串"`undefined`"
- 字符串长度为`0`，也即空字符串
- 值为`false`(布尔类型)，非字符串"`false`"
- 值为数值`0`(非字符串"`0`")，或者`NaN`
- 值为`null`，空对象`{}`，或者长度为`0`的数组

 `isEmpty(value)`

校验值是否为空，返回`true`或者`false`。
此方法等同于`empty`名称，但是为了更语义化，推荐用`isEmpty`名称。

- `value` <any> 字符串

``` javascript

console.log(this.$test.isEmpty(false));

```


## 是否普通日期

验证一个字符串是否日期，返回`true`或者`false`，如下行为正确

- `2020-02-10`、`2020-02-10 08:32:10`、`2020/02/10 3:10`、`2020/02/10 03:10`、`2020/02-10 3:10`

如下为错误：

- `2020年02月10日、2020-02-10 25:32`

总的来说，年月日之间可以用"/"或者"-"分隔(不能用中文分隔)，时分秒之间用":"分隔，数值不能超出范围，如月份不能为13，则检验成功，否则失败。

`date(date)`

- `date` <String> 日期字符串

``` javascript

console.log(this.$test.date('2020-02-10 08:32:10'));

```

## 是否十进制数值

整数，小数，负数，带千分位数(2,359.08)等可以检验通过，返回`true`或者`false`。

`number(number)`

- `number` <String> 数字

``` javascript

console.log(this.$test.number('2020'));

```

## 是否整数

所有字符都在`0-9`之间，才校验通过，结果返回`true`或者`false`。

`digits(number)`

- `number` <String> 数字

``` javascript

console.log(this.$test.digits('2020'));

```

## 是否身份证号

身份证号，包括尾数为"X"的类型，可以校验通过，结果返回`true`或者`false`。

`idCard(idCard)`

- `idCard` <String> 身份证号

``` javascript

console.log(this.$test.idCard('110101199003070134'));

```

## 是否车牌号

可以校验旧车牌号和新能源类型车牌号，结果返回`true`或者`false`。

`carNo(carNo)`

- `carNo` <String> 车牌号

``` javascript

console.log(this.$test.carNo('京A88888'));

```

## 是否金额

最多两位小数，可以带千分位，结果返回`true`或者`false`。

`amount(amount)`

- `amount` <String> 金额字符串

``` javascript

console.log(this.$test.amount('3,233.08'));

```

## 是否字母或者数字

只能是字母或者数字，结果返回`true`或者`false`。

`enOrNum(str)`

- `str` <String> 字母或者数字字符串

``` javascript

console.log(this.$test.enOrNum('sas'));

```

## 是否包含某个值

字符串中是否包含某一个子字符串，区分大小写，结果返回`true`或者`false`。

`contains(str, subStr)`

- `str` <String> 字母或者数字字符串
- `subStr` <String> 子字符串

``` javascript

console.log(this.$test.contains('sas', 'sa'));

```

## 数值是否在某个范围内

如30在"29-35"这个范围内，不在"25-28"这个范围内，结果返回`true`或者`false`

`range(number, range)`

- `number` <Number> 数值
- `range` <Array> 如"[25-35]"

``` javascript

console.log(this.$test.range(35, [30, 34]));

```

## 字符串长度是否在某个范围内

如"`abc`"长度为3，范围在"2-5"这个区间，结果返回`true`或者`false`

`rangeLength(str, range)`

- `str` <String> 数值
- `range` <Array> 如"[25-35]"

``` javascript

console.log(this.$test.rangeLength('abc', [3, 10]));

```


``` javascript


/**
 * 验证电子邮箱格式
 */
function email(value) {
	return /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/.test(value);
}

/**
 * 验证手机格式
 */
function mobile(value) {
	return /^1[23456789]\d{9}$/.test(value)
}

/**
 * 验证URL格式
 */
function url(value) {
	return /^((https|http|ftp|rtsp|mms):\/\/)(([0-9a-zA-Z_!~*'().&=+$%-]+: )?[0-9a-zA-Z_!~*'().&=+$%-]+@)?(([0-9]{1,3}.){3}[0-9]{1,3}|([0-9a-zA-Z_!~*'()-]+.)*([0-9a-zA-Z][0-9a-zA-Z-]{0,61})?[0-9a-zA-Z].[a-zA-Z]{2,6})(:[0-9]{1,4})?((\/?)|(\/[0-9a-zA-Z_!~*'().;?:@&=+$,%#-]+)+\/?)$/
		.test(value)
}

/**
 * 验证日期格式
 */
function date(value) {
	return !/Invalid|NaN/.test(new Date(value).toString())
}

/**
 * 验证ISO类型的日期格式
 */
function dateISO(value) {
	return /^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])$/.test(value)
}

/**
 * 验证十进制数字
 */
function number(value) {
	return /^(?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/.test(value)
}

/**
 * 验证整数
 */
function digits(value) {
	return /^\d+$/.test(value)
}

/**
 * 验证身份证号码
 */
function idCard(value) {
	return /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(
		value)
}

/**
 * 是否车牌号
 */
function carNo(value) {
	// 新能源车牌
	const xreg = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF]$)|([DF][A-HJ-NP-Z0-9][0-9]{4}$))/;
	// 旧车牌
	const creg = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳]{1}$/;
	if (value.length === 7) {
		return creg.test(value);
	} else if (value.length === 8) {
		return xreg.test(value);
	} else {
		return false;
	}
}

/**
 * 金额,只允许2位小数
 */
function amount(value) {
	//金额，只允许保留两位小数
	return /^[1-9]\d*(,\d{3})*(\.\d{1,2})?$|^0\.\d{1,2}$/.test(value);
}

/**
 * 中文
 */
function chinese(value) {
	let reg = /^[\u4e00-\u9fa5]+$/gi;
	return reg.test(value);
}

/**
 * 只能输入字母
 */
function letter(value) {
	return /^[a-zA-Z]*$/.test(value);
}

/**
 * 只能是字母或者数字
 */
function enOrNum(value) {
	//英文或者数字
	let reg = /^[0-9a-zA-Z]*$/g;
	return reg.test(value);
}

/**
 * 验证是否包含某个值
 */
function contains(value, param) {
	return value.indexOf(param) >= 0
}

/**
 * 验证一个值范围[min, max]
 */
function range(value, param) {
	return value >= param[0] && value <= param[1]
}

/**
 * 验证一个长度范围[min, max]
 */
function rangeLength(value, param) {
	return value.length >= param[0] && value.length <= param[1]
}

/**
 * 是否固定电话
 */
function landline(value) {
	let reg = /^\d{3,4}-\d{7,8}(-\d{3,4})?$/;
	return reg.test(value);
}

/**
 * 判断是否为空
 */
function empty(value) {
	switch (typeof value) {
		case 'undefined':
			return true;
		case 'string':
			if (value.replace(/(^[ \t\n\r]*)|([ \t\n\r]*$)/g, '').length == 0) return true;
			break;
		case 'boolean':
			if (!value) return true;
			break;
		case 'number':
			if (0 === value || isNaN(value)) return true;
			break;
		case 'object':
			if (null === value || value.length === 0) return true;
			for (var i in value) {
				return false;
			}
			return true;
	}
	return false;
}

/**
 * 是否json字符串
 */
function jsonString(value) {
	if (typeof value == 'string') {
		try {
			var obj = JSON.parse(value);
			if (typeof obj == 'object' && obj) {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			return false;
		}
	}
	return false;
}


/**
 * 是否数组
 */
function array(value) {
	if (typeof Array.isArray === "function") {
		return Array.isArray(value);
	} else {
		return Object.prototype.toString.call(value) === "[object Array]";
	}
}

/**
 * 是否对象
 */
function object(value) {
	return Object.prototype.toString.call(value) === '[object Object]';
}

/**
 * 是否短信验证码
 */
function code(value, len = 6) {
	return new RegExp(`^\\d{${len}}$`).test(value);
}


export default {
	email,
	mobile,
	url,
	date,
	dateISO,
	number,
	digits,
	idCard,
	carNo,
	amount,
	chinese,
	letter,
	enOrNum,
	contains,
	range,
	rangeLength,
	empty,
	isEmpty: empty,
	jsonString,
	landline,
	object,
	array,
	code
}


```

