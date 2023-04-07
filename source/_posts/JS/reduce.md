---
title: JS中 reduce() 的用法
date: 2020-12-12 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/vdysjx.webp
tags:
  - js
categories:
  - js
---

过去有很长一段时间，我一直很难理解 **reduce()** 这个方法的具体用法，平时也很少用到它。事实上，如果你能真正了解它的话，其实在很多地方我们都可以用得上，那么今天我们就来简单聊聊 JS 中 reduce() 的用法。

## 一、语法

> arr.reduce(function(prev,cur,index,arr){
> ...
> }, init);

其中，
**arr** 表示原数组；
**prev** 表示上一次调用回调时的返回值，或者初始值 init;
**cur** 表示当前正在处理的数组元素；
**index** 表示当前正在处理的数组元素的索引，若提供 init 值，则索引为 0，否则索引为 1；
**init** 表示初始值。

看上去是不是感觉很复杂？没关系，只是看起来而已，其实常用的参数只有两个：**prev** 和 **cur**。接下来我们跟着实例来看看具体用法吧~

## 二、实例

先提供一个原始数组：

```js
var arr = [3, 9, 4, 3, 6, 0, 9]
```

实现以下需求的方式有很多，其中就包含使用 reduce()的求解方式，也算是实现起来比较简洁的一种吧。

### 1. 求数组项之和

```js
var sum = arr.reduce(function (prev, cur) {
  return prev + cur
}, 0)
```

由于传入了初始值 0，所以开始时 prev 的值为 0，cur 的值为数组第一项 3，相加之后返回值为 3 作为下一轮回调的 prev 值，然后再继续与下一个数组项相加，以此类推，直至完成所有数组项的和并返回。

### 2. 求数组项最大值

```js
var max = arr.reduce(function (prev, cur) {
  return Math.max(prev, cur)
})
```

由于未传入初始值，所以开始时 prev 的值为数组第一项 3，cur 的值为数组第二项 9，取两值最大值后继续进入下一轮回调。

### 3. 数组去重

```js
var newArr = arr.reduce(function (prev, cur) {
  prev.indexOf(cur) === -1 && prev.push(cur)
  return prev
}, [])
```

实现的基本原理如下：

> ① 初始化一个空数组
> ② 将需要去重处理的数组中的第 1 项在**初始化数组**中查找，如果找不到（空数组中肯定找不到），就将该项添加到**初始化数组**中
> ③ 将需要去重处理的数组中的第 2 项在**初始化数组**中查找，如果找不到，就将该项继续添加到**初始化数组**中
> ④ ……
> ⑤ 将需要去重处理的数组中的第 n 项在**初始化数组**中查找，如果找不到，就将该项继续添加到**初始化数组**中
> ⑥ 将这个**初始化数组**返回

## 三、其他相关方法

### 1. reduceRight()

该方法用法与 reduce()其实是相同的，只是遍历的顺序相反，它是从数组的最后一项开始，向前遍历到第一项。

### 2. forEach()、map()、every()、some()和 filter()

详情请戳 →[简述 forEach()、map()、every()、some()和 filter()的用法](http://fang-kang.gitee.io/views/JS/array.html)

## 重点总结

reduce() 是数组的**归并方法**，与 forEach()、map()、filter()等**迭代方法**一样都会对数组每一项进行遍历，但是 reduce() 可同时将前面数组项遍历产生的结果与当前遍历项进行运算，这一点是其他迭代方法无法企及的

### 先看 w3c 语法

```js
array.reduce(function(total, currentValue, currentIndex, arr), initialValue);
/*
  total: 必需。初始值, 或者计算结束后的返回值。
  currentValue： 必需。当前元素。
  currentIndex： 可选。当前元素的索引；
  arr： 可选。当前元素所属的数组对象。
  initialValue: 可选。传递给函数的初始值，相当于total的初始值。
*/
```

### 常见用法

#### 数组求和

```js
const arr = [12, 34, 23];
const sum = arr.reduce((total, num) => total + num);
<!-- 设定初始值求和 -->
const arr = [12, 34, 23];
const sum = arr.reduce((total, num) => total + num, 10);  // 以10为初始值求和
<!-- 对象数组求和 -->
var result = [
  { subject: 'math', score: 88 },
  { subject: 'chinese', score: 95 },
  { subject: 'english', score: 80 }
];
const sum = result.reduce((accumulator, cur) => accumulator + cur.score, 0);
const sum = result.reduce((accumulator, cur) => accumulator + cur.score, -10);  // 总分扣除10分
```

#### 数组最大值

```js
const a = [23, 123, 342, 12]
const max = a.reduce(function (pre, cur, inde, arr) {
  return pre > cur ? pre : cur
}) // 342
```

### 进阶用法

#### 数组对象中的用法

```html
<!-- 比如生成“老大、老二和老三” -->
```

```js
const objArr = [{ name: '老大' }, { name: '老二' }, { name: '老三' }]
const res = objArr.reduce((pre, cur, index, arr) => {
  if (index === 0) {
    return cur.name
  } else if (index === arr.length - 1) {
    return pre + '和' + cur.name
  } else {
    return pre + '、' + cur.name
  }
}, '')
```

#### 求字符串中字母出现的次数

```js
const str = 'sfhjasfjgfasjuwqrqadqeiqsajsdaiwqdaklldflas-cmxzmnha'
const res = str.split('').reduce((accumulator, cur) => {
  accumulator[cur] ? accumulator[cur]++ : (accumulator[cur] = 1)
  return accumulator
}, {})
```

#### 数组转数组

```js
<!-- 按照一定的规则转成数组 -->
var arr1 = [2, 3, 4, 5, 6]; // 每个值的平方
var newarr = arr1.reduce((accumulator, cur) => {accumulator.push(cur * cur); return accumulator;}, []);
```

#### 数组转对象

```js
<!-- 按照id 取出stream -->
var streams = [{name: '技术', id: 1}, {name: '设计', id: 2}];
var obj = streams.reduce((accumulator, cur) => {accumulator[cur.id] = cur; return accumulator;}, {});
```

### 高级用法

#### 多维的叠加执行操作

```html
<!-- 各科成绩占比重不一样， 求结果 -->
```

```js
var result = [
  { subject: 'math', score: 88 },
  { subject: 'chinese', score: 95 },
  { subject: 'english', score: 80 },
]
var dis = {
  math: 0.5,
  chinese: 0.3,
  english: 0.2,
}
var res = result.reduce((accumulator, cur) => dis[cur.subject] * cur.score + accumulator, 0)
```

```html
<!-- 加大难度， 商品对应不同国家汇率不同，求总价格 -->
```

```js
var prices = [{ price: 23 }, { price: 45 }, { price: 56 }]
var rates = {
  us: '6.5',
  eu: '7.5',
}
var initialState = { usTotal: 0, euTotal: 0 }
var res = prices.reduce(
  (accumulator, cur1) =>
    Object.keys(rates).reduce((prev2, cur2) => {
      console.log(accumulator, cur1, prev2, cur2)
      accumulator[`${cur2}Total`] += cur1.price * rates[cur2]
      return accumulator
    }, {}),
  initialState
)

var manageReducers = function () {
  return function (state, item) {
    return Object.keys(rates).reduce((nextState, key) => {
      state[`${key}Total`] += item.price * rates[key]
      return state
    }, {})
  }
}
var res1 = prices.reduce(manageReducers(), initialState)
```

#### 扁平一个二维数组

```js
var arr = [
  [1, 2, 8],
  [3, 4, 9],
  [5, 6, 10],
]
var res = arr.reduce((x, y) => x.concat(y), [])
```

#### 对象数组去重

```js
const hash = {}
chatlists = chatlists.reduce((obj, next: Object) => {
  const hashId = `${next.topic}_${next.stream_id}`
  if (!hash[hashId]) {
    hash[`${next.topic}_${next.stream_id}`] = true
    obj.push(next)
  }
  return obj
}, [])
```

#### compose 函数

> redux compose 源码实现

```js
function compose(...funs) {
  if (funs.length === 0) {
    return arg => arg
  }
  if (funs.length === 1) {
    return funs[0]
  }
  return funs.reduce(
    (a, b) =>
      (...arg) =>
        a(b(...arg))
  )
}
```
