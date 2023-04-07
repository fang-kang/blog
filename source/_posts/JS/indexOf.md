---
title: JS判断字符串中是否存在某个字符
index_img: https://fang-kang.gitee.io/blog-img/5.jpg
date: 2020-11-04 15:33:01
tags:
  - js
  - utils
categories:
  - js
---

# JS 判断字符串中是否存在某个字符

## 可以用 String 中的 indexOf()

<!-- more -->

```javascript
let str = 'abcd'

if (str.indexOf('a') == -1) {
  //等于-1表示这个字符串中没有a这个字符
  console.log('不含这个字符')
} else {
  console.log('含有这个字符')
}
```
