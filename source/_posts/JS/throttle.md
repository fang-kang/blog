---
title: throttle & debounce节流防抖
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/n7a9bv.webp
tags:
  - js
  - utils
categories:
  - js
---

## 什么是节流和防抖？

- 节流

节流的意思是，规定时间内，只触发一次。比如我们设定 500ms，在这个时间内，无论点击按钮多少次，它都只会触发一次。

> 具体场景可以是抢购时候，由于有无数人 快速点击按钮，如果每次点击都发送请求，就会给服务器造成巨大的压力，但是我们进行节流后，就会大大减少请求的次数。

- 防抖

防抖的意思是，在连续的操作中，无论进行了多长时间，只有某一次的操作后在指定的时间内没有再操作，这一次才被判定有效。

> 具体场景可以搜索框输入关键字过程中实时 请求服务器匹配搜索结果，如果不进行处理，那么就是输入框内容一直变化，导致一直发送请求。如果进行防抖处理，结果就是当我们输入内容完成后，一定时间(比如 500ms)没有再 输入内容，这时再触发请求。

<!-- more  -->

### 节流

`throttle(func, wait = 500, immediate = true)`

规定时间内，只触发一次，可以通过设置`immediate`来决定触发的时机在这个时间的开始，还是结束的时候执行。

- `func` <Function> 触发回调执行的函数

- `wait` <Number> 时间间隔，单位 ms

- `immediate` <Number> 在开始还是结束处触发，比如设置 wait 为 1000ms，如果在一秒内进行了 5 次操作，只触发一次，如果 immediate 为`true`，那么就会在第一次操作 触发回调，如果为`false`,就会在第 5 次操作触发回调。

```javascript
let timer, flag
/**
 * 节流原理：在一定时间内，只能触发一次
 *
 * @param {Function} func 要执行的回调函数
 * @param {Number} wait 延时的时间
 * @param {Boolean} immediate 是否立即执行
 * @return null
 */
function throttle(func, wait = 500, immediate = true) {
  if (immediate) {
    if (!flag) {
      flag = true
      // 如果是立即执行，则在wait毫秒内开始时执行
      typeof func === 'function' && func()
      timer = setTimeout(() => {
        flag = false
      }, wait)
    }
  } else {
    if (!flag) {
      flag = true
      // 如果是非立即执行，则在wait毫秒内的结束处执行
      timer = setTimeout(() => {
        flag = false
        typeof func === 'function' && func()
      }, wait)
    }
  }
}
```

### 防抖

`debounce(func, wait = 500, immediate = false)`

在连续的操作中，无论进行了多长时间，只有某一次的操作后在指定的时间内没有再操作，这一次才被判定有效

- `func` <Function> 触发回调执行的函数

- `wait` <Number> 时间间隔，单位 ms

- `immediate` <Number> 在开始还是结束处触发，如非特殊情况，一般默认为`false`即可

```javascript
let timeout = null

/**
 * 防抖原理：一定时间内，只有最后一次操作，再过wait毫秒后才执行函数
 *
 * @param {Function} func 要执行的回调函数
 * @param {Number} wait 延时的时间
 * @param {Boolean} immediate 是否立即执行
 * @return null
 */
function debounce(func, wait = 500, immediate = false) {
  // 清除定时器
  if (timeout !== null) clearTimeout(timeout)
  // 立即执行，此类情况一般用不到
  if (immediate) {
    var callNow = !timeout
    timeout = setTimeout(function () {
      timeout = null
    }, wait)
    if (callNow) typeof func === 'function' && func()
  } else {
    // 设置定时器，当最后一次操作后，timeout不会再被清除，所以在延时wait毫秒后执行func回调方法
    timeout = setTimeout(function () {
      typeof func === 'function' && func()
    }, wait)
  }
}
```
