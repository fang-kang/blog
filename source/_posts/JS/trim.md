---
title: trim 去除空格
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/73twhs.webp
tags:
 - Js
 - utils
categories:
 - Js
---

## trim 去除空格

{% note success %}

`trim(str, pos)`

该方法可以去除空格，分别可以去除所有空格，两端空格，左边空格，右边空格，默认为去除两端空格

{% endnote %}

 - `str` <String> 字符串

 - `pos` <String> 去除那些位置的空格，可选为：`both`-默认值，去除两端空格，`left`-去除左边空格，`right`-去除右边空格，`all`-去除包括中间和两端的所有空格

<!-- more -->

``` javascript

import trim from 'trim.js'

console.log(trim('abc    b ', 'all')); // 去除所有空格
console.log(trim(' abc '));	// 去除两端空格

```

``` javascript

function trim(str, pos = 'both') {
	if (pos == 'both') {
		return str.replace(/^\s+|\s+$/g, "");
	} else if (pos == "left") {
		return str.replace(/^\s*/, '');
	} else if (pos == 'right') {
		return str.replace(/(\s*$)/g, "");
	} else if (pos == 'all') {
		return str.replace(/\s+/g, "");
	} else {
		return str;
	}
}

export default trim

```

