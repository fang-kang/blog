---
title: 数组的5个ES5方法
date: 2020-10-21 15:33:01
tags:
 - 数组
 - Js
categories:
  - Js
index_img: https://fang-kang.gitee.io/blog-img/2.jpg
---
# 数组的5个ES5方法

## 1. forEach

- `forEach()` 方法就是遍历数组。功能等同于`for`循环.
- **返回值** : 没有返回值

**需求：遍历数组["张飞","关羽","赵云","马超"]**

```javascript
var arr = ["张飞","关羽","赵云","马超"];
//第一个参数：item，数组的每一项元素
//第二个参数：index，数组的下标
//第三个参数：array，正在遍历的数组
arr.forEach(function(item, index, array){
  console.log(item, index, array);
});
```

<!-- more -->

## 2. map

- **映射 (一一对应)**  
  - 原来有几个,返回的就有几个

- **作用** : 遍历,遍历数组里的每一个元素并且返回对应的元素(返回的是处理后的元素) (map 映射 一一对应)
- **返回值** : 返回的是一个处理后的新数组 (新数组和旧数组的个数绝对是一样的)

**需求：遍历数组，求每一项的值都并存在于一个数组中**

```javascript
var arr1 = ['zs', 'ls', 'ww']

第一个参数 : 数组里的元素
第二个参数 : 元素的索引
arr1 =  arr1.map(function ( item , index) {
  // console.log(item,index);
    return  item + 666
})

var arr1 = [10, 20, 30]
    // 需求2：给数组的每一项 加1

    // arr1 = arr1.map(function(item) {
    //   return item + 1
    // })
    // console.log(arr1)

    // 需求3：要得到一个新数组，新数组的每一项是原数组项的平方
    arr1 = arr1.map(function(item) {
      return item * item
    })
    // console.log(arr1)

    var list = [
      { id: 1, name: '张三' },
      { id: 2, name: '李四' },
      { id: 3, name: '王五' },
      { id: 4, name: '赵六' },
    ]

    // 需求4：把数组中的name 返回成一个新数组

    list = list.map(function(item, index, array) {
      return item.name
    })
    console.log(list)
```

## 3. filter

- **过滤**

- **作用** :  `filter`用于过滤出来满足条件的元素 /  删除不满足条件的元素
- **返回值** :  一个新数组，如果在回调函数中返回true，那么就留下来，如果返回false，就扔掉

- **三个需求 :**

```javascript
var arr = [
      { id: 1, name: '吃饭', done: true },
      { id: 2, name: '睡觉', done: true },
      { id: 3, name: '打豆豆', done: false },
    ]

    // 需求1： 把已经做完的事情过滤出来， done 是 true
    // arr = arr.filter(function(item) {
    //   return item.done === true
    // })
    // console.log(arr)
    
    // 需求2： 把done为 false 的项 过滤出来
    // arr = arr.filter(function(item) {
    //   // 一个布尔值和 true 做匹配， 返回当前布尔值。
    //   // 一个布尔值和 false 做匹配，返回当前布尔值的取反。
    //   // return item.done === false
    //   return !item.done
    // })
    // console.log(arr)

    // 需求3： 过滤出id 小于3的数组项
    arr = arr.filter(function(item) {
      return item.id < 3
    })
    console.log(arr)
```

- **filter的特殊用法-删除数组项**

```javascript
  var list = [
        { id: 1, name: '吃饭', done: true },
        { id: 2, name: '睡觉', done: true },
        { id: 3, name: '打豆豆', done: false },
      ]
      //删除 数组中id 为2 的元素。
      // 使用filter删除数组项，删除谁，条件就是 不等于谁。
      list = list.filter(function(item) {
        return item.id !== 2
      })
      console.log(list)
```

## 4. some

- **一些**

- **作用** : 遍历数组, 只要有一个以上(1+)符合条件的都会返回true ,否则返回false返回值: 布尔 true/false
- **返回值** : 一个布尔值

```js
var list = [
      { id: 1, name: '吃饭', done: true },
      { id: 2, name: '睡觉', done: true },
      { id: 3, name: '打豆豆', done: false },
    ]
    // 需求1：判断数组中是否有 done 为 true的 
    // var b = list.some(function(item) {
    //   // return item.done === true
    //   return item.done
    // })
    // // console.log(b)
    
    // 需求2：判断是否有done 为 false的
    // var b = list.some(function(item) {
    //   // return item.done === false
    //   return !item.done
    // })
    // console.log(b)

    // 需求3：判断数组中是否有 id 为7的

    var b = list.some(function(item) {
      return item.id === 7
    })
    console.log(b)
```

## 5. every

- **每一个**

- **作用** :作用 :  遍历数组, 每一个(全部)都要满足条件 =>  true,  否则 ==> false
- **返回值** : 布尔 true/false

```javascript
var list = [
      { id: 1, name: '吃饭', done: true },
      { id: 2, name: '睡觉', done: true },
      { id: 3, name: '打豆豆', done: false },
    ]

    // 需求1：判断数组所有项的done ，是否都为true
    // var b = list.every(function(item) {
    //   // return item.done === true
    //   return item.done
    // })
    // console.log(b)

    // 需求2：判断数组中所有项 id 是不是 都 大于0
    var b = list.every(function(item) {
      return item.id > 0
    })
    console.log(b)
```

## 总结

```js
/**
 * 方法1 : forEach  --------简单的遍历  ====for   ★★
 * 遍历
 * 作用 : 遍历数组里面的每一个元素 , 功能等同于 for
 * 格式 :
 *  arr.forEach(function(item,index){
 *     .....
 *  })
 *
 *
 * -------------返回一个新数组
 * 方法2 : map   ★★★
 * 映射 (一一对应)
 * 作用 : 遍历数组的每个元素,返回对应的元素(处理之后的元素)
 * 返回值 : 返回一个新的数组  (新数组的个数 和 旧数组 的个数 一定一样的)
 *
 * 方法3 : filter  ★★★
 * 过滤 (筛选)
 * 作用 : 过滤出来满足条件的元素, 不满足的删除
 * 返回值 : 返回一个新的数组 (个数就不一定)
 *
 *
 *
 * ------------返回一个布尔值
 * 方法4 : some    ★★
 * 一些 (判断)
 * 作用 : 判断数组里的元素是否 有一个以上满足条件的
 *      如果有1+ 满足条件的 => true
 *      否则  ==> false
 * 返回值 : 布尔值
 *
 * 方法5 : every    ★★
 * 每一个 (判断)
 * 作用 : 判断数组里的元素是否都满足条件
 *      如果都 满足 => true
 *      否则 : false
 * 返回值 : 布尔值
 */
```
