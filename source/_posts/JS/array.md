---
title: JS中数组的常用方法
date: 2020-11-04 15:33:01
tags:
  - js
  - 数组
categories:
  - js
index_img: https://fang-kang.gitee.io/blog-img/2.jpg
---

# JS 中数组的常用方法

## 常规方法

### 一、push()

{% note success %}

`push()`方法可向数组的末尾添加一个或多个元素，并返回新的数组长度。**会改变原数组**。

{% endnote %}

```javascript
let a = ['a', 'b', 'c']
let b = a.push('d')
console.log(a) //['a','b','c','d']
console.log(b) //d
push方法可以一次添加多个元素 //push('e','f',...)
```

<!-- more -->

### 二、pop()

{% note success %}

`pop()`方法用于删除并返回数组的最后一个元素。**会改变原数组**。

{% endnote %}

```javascript
let a = ['a', 'b', 'c']
let b = a.pop()
console.log(a) //['a','b']
console.log(b) //c
```

### 三、unshift()

{% note success %}

`unshift()`方法可向数组的开头添加一个或更多元素，并返回新的数组长度。**改变原数组**。

{% endnote %}

```javascript
var arr = [2, 3, 4, 5]
console.log(arr.unshift(3, 1)) //6
console.log(arr) //[3, 1, 2, 3, 4, 5]
```

### 四、shift()

{% note success %}

`shift()`方法用于删除并返回数组的第一个元素。**会改变原数组**。

{% endnote %}

```javascript
var arr = [2, 3, 4]
console.log(arr.shift()) //2
console.log(arr) //[3,4]
```

### 五、concat()

{% note success %}

`concat()`方法用于连接两个或多个数组。**该方法不会改变现有的数组**，仅会返回一个连接在一起的数组。

{% endnote %}

```javascript
var arr1 = [1, 2, 3]
var arr2 = [4, 5]
var arr3 = arr1.concat(arr2)
console.log(arr1) //[1, 2, 3]
console.log(arr3) //[1, 2, 3, 4, 5]
```

**ES6 中也可以这么写**

```javascript
let arr1 = [1, 2, 3]
let arr2 = [4, 5]
let arr3 = [...arr1, ...arr2]
console.log(arr1) //[1, 2, 3]
console.log(arr3) //[1, 2, 3, 4, 5]
```

### 六、join()

{% note success %}

`join()`方法用于把数组中的所有元素放入一个字符串。元素通过指定的分隔符进行分隔，默认使用","号分割，**不改变原数组**。

{% endnote %}

**数组转字符串**

```javascript
var arr = [2, 3, 4]
console.log(arr.join()) //2,3,4
console.log(arr.join('-')) //2-3-4
console.log(arr) //[2, 3, 4]
```

### 七、slice()

{% note success %}

截取从`start` 到 `end` 下标区间中数组的元素。返回一个新的数组，**该方法不会修改原数组。**

{% endnote %}

```javascript
var arr = [2, 3, 4, 5]
console.log(arr.slice(1, 3)) //[3,4]
console.log(arr) //[2,3,4,5]
```

### 八、splice()

{% note success %}

`splice()`方法可删除从 `index`(数组下标) 处开始的零个或多个元素，并且用参数列表中声明的一个或多个值来替换那些被删除的元素。如果从数组中删除了元素，则返回的是含有被删除的元素的数组。**此方法会直接对数组进行修改**。

{% endnote %}

**删除数组**

```javascript
var a = [5, 6, 7, 8]
console.log(a.splice(1, 0, 9)) //[]    --> 表示从下标为1开始，删除0位
console.log(a) // [5, 9, 6, 7, 8]
var b = [5, 6, 7, 8]
console.log(b.splice(1, 2, 3)) //[6, 7] --> 表示从下标为1开始，到下标为2结束，并将删除的内容替换为 3
console.log(b) //[5, 3, 8]
```

### 九、sort 排序

{% note success %}

按照 `Unicode code` 位置排序，默认升序

{% endnote %}

```javascript
var fruit = ['cherries', 'apples', 'bananas']
fruit.sort() // ['apples', 'bananas', 'cherries']

var scores = [1, 10, 21, 2]
scores.sort() // [1, 10, 2, 21]
```

当不带参数调用 `sort()`时，数组元素是以`ACSII`码顺序进行排序（如有必要将临时转化为字符串进行比较）。

可以传入一个 `function` ，用来自定义排序方式

```javascript
var nums = [12, 645, 6, 85, 81, 0, 9, 365, 4, 752]
var arr = nums.sort(function (a, b) {
  return a - b
})
console.log(arr) //[0, 4, 6, 9, 12, 81, 85, 365, 645, 752]
```

### 十、reverse()

{% note success %}

`reverse`() 方法用于颠倒数组中元素的顺序。返回的是颠倒后的数组，**会改变原数组**。

{% endnote %}

```javascript
var arr = [2, 3, 4]
console.log(arr.reverse()) //[4, 3, 2]
console.log(arr) //[4, 3, 2]
```

### 十一、indexOf() 和 lastIndexOf()

{% note success %}

都接受两个参数：查找的值 、查找起始位置 。 不存在，返回 `-1` ；存在，返回当前数组下标。`indexOf` 是从前往后查找， `lastIndexOf` 是从后往前查找。

{% endnote %}

**indexOf()**

```javascript
var a = [2, 9, 9]
a.indexOf(2) // 0
a.indexOf(7) // -1

if (a.indexOf(7) === -1) {
  console.log(a) // [2, 9, 9]
}
```

**lastIndexOf()**

```javascript
var numbers = [2, 5, 9, 2]
numbers.lastIndexOf(2) // 3
numbers.lastIndexOf(7) // -1
numbers.lastIndexOf(2, 3) // 3
numbers.lastIndexOf(2, 2) // 0
numbers.lastIndexOf(2, -2) // 0
numbers.lastIndexOf(2, -1) // 3
```

### 十二、every()

{% note success %}

对数组的每一项都运行指定的函数，如果**每一项**都返回 `ture`,则返回 `true`。

{% endnote %}

```javascript
function isAdult(element, index, array) {
  return element > 18
}
;[22, 25, 28, 34, 46].every(isAdult) // true
```

### 十三、some()

{% note success %}

对数组的每一项都运行指定的函数，如果**任意一项**都返回 `ture`,则返回 `true`。

{% endnote %}

```javascript
function compare(element, index, array) {
  return element > 10
}
;[2, 5, 8, 1, 4].some(compare) // false
;[12, 5, 8, 1, 4].some(compare) // true
```

### 十四、filter()

{% note success %}

对数组的每一项都运行给定的函数，返回结果为 `ture` 的项组成的数组。

{% endnote %}

```javascript
let ages = [15, 25, 34, 56, 77, 8, 17]

let adultAge = ages.filter(age => age > 18)

// Filtered array adult age is [25, 34, 56, 77]
```

### 十五、map()

{% note success %}

对数组的每一项都运行指定的函数，返回每次函数调用的结果组成一个新数组。

{% endnote %}

```javascript

let numbers = [1, 5, 10, 15];

let doubles = numbers.map(x => x * 2)
})

// doubles is now [2, 10, 20, 30]
// numbers is still [1, 5, 10, 15]

```

### 十六、forEach()

{% note success %}

循环遍历数组。

{% endnote %}

```javascript
const items = ['item1', 'item2', 'item3']
const copy = []
items.forEach((item, index) => {
  copy.push(item)
})
console.log(copy) // ['item1', 'item2', 'item3']
```

## ES6 新增方法

### 一、find()

{% note success %}

传入一个回调函数，找到数组中符合当前搜索规则的第一个元素，返回它，并且终止搜索。

{% endnote %}

```javascript
const arr = [1, '2', 3, 3, '2']

console.log(arr.find(n => typeof n === 'number')) // 1
```

### 二、findIndex()

{% note success %}

传入一个回调函数，找到数组中符合当前搜索规则的第一个元素，返回它的下标，并终止搜索。

{% endnote %}

```javascript
const arr = [1, '2', 3, 3, '2']

console.log(arr.findIndex(n => typeof n === 'number')) // 0
```

### 三、fill()

{% note success %}

用新元素替换掉数组内的元素，可以指定替换下标范围。`fill(value, start, end)`

{% endnote %}

```javascript
var arr = [1, 2, 3, 4, 5]

arr.fill(6, 1, 3) // [1, 6, 6, 4, 5] --> 依次替换从下标1到3之间的内容为6
```

### 四、copyWithin()

{% note success %}

选择数组的某个下标，从该位置开始复制数组元素，默认从`0`开始复制。也可以指定要复制的元素范围。

{% endnote %}

```javascript
arr.copyWithin(target, start, end)

var arr = [1, 2, 3, 4, 5]

console.log(arr.copyWithin(3))

// [1,2,3,1,2] --> 从下标为3的元素开始，复制数组，所以4, 5被替换成1, 2

var arr1 = [1, 2, 3, 4, 5]

console.log(arr1.copyWithin(3, 1))

// [1,2,3,2,3] --> 从下标为3的元素开始，复制数组，指定复制的第一个元素下标为1，所以4, 5被替换成2, 3

var arr2 = [1, 2, 3, 4, 5]

console.log(arr2.copyWithin(3, 1, 2))

// [1,2,3,2,5] --> 从下标为3的元素开始，复制数组，指定复制的第一个元素下标为1，结束位置为2，所以4被替换成2
```

### 五、from()

{% note success %}

将类似数组的对象`（array-like object）`和可遍历（`iterable`）的对象转为真正的数组

{% endnote %}

```javascript
const bar = ['a', 'b', 'c']

Array.from(bar) // ["a", "b", "c"]

Array.from('foo') // ["f", "o", "o"]
```

### 六、of()

{% note success %}

用于将一组值，转换为数组。这个方法的主要目的，是弥补数组构造函数 `Array()` 的不足。因为参数个数的不同，会导致 `Array()` 的行为有差异。

{% endnote %}

```javascript
Array() // []
Array(3) // [, , ,]
Array(3, 11, 8) // [3, 11, 8]
Array.of(7) // [7]
Array.of(1, 2, 3) // [1, 2, 3]

Array(7) // [ , , , , , , ]
Array(1, 2, 3) // [1, 2, 3]
```

### 七、entries()

{% note success %}

返回迭代器：返回键值对

{% endnote %}

```javascript
//数组
var arr = ['a', 'b', 'c']
for (let v of arr.entries()) {
  console.log(v)
}
// [0, 'a'] [1, 'b'] [2, 'c']

//Set
var arr = new Set(['a', 'b', 'c'])
for (let v of arr.entries()) {
  console.log(v)
}
// ['a', 'a'] ['b', 'b'] ['c', 'c']

//Map
var arr = new Map()
arr.set('a', 'a')
arr.set('b', 'b')
for (let v of arr.entries()) {
  console.log(v)
}
// ['a', 'a'] ['b', 'b']
```

### 八、values()

{% note success %}

返回迭代器：返回键值对的`value`

{% endnote %}

```javascript
//数组
var arr = ['a', 'b', 'c']
for (let v of arr.values()) {
  console.log(v)
}
//'a' 'b' 'c'

//Set
var arr = new Set(['a', 'b', 'c'])
for (let v of arr.values()) {
  console.log(v)
}
// 'a' 'b' 'c'

//Map
var arr = new Map()
arr.set('a', 'a')
arr.set('b', 'b')
for (let v of arr.values()) {
  console.log(v)
}
// 'a' 'b'
```

### 九、keys()

{% note success %}

返回迭代器：返回键值对的`key`

{% endnote %}

```javascript
//数组
const arr = ['a', 'b', 'c']
for (let v of arr.keys()) {
  console.log(v)
}
// 0 1 2

//Set
const arr = new Set(['a', 'b', 'c'])
for (let v of arr.keys()) {
  console.log(v)
}
// 'a' 'b' 'c'

//Map
const arr = new Map()
arr.set('a', 'a')
arr.set('b', 'b')
for (let v of arr.keys()) {
  console.log(v)
}
// 'a' 'b'
```

### 十、includes()

{% note success %}

判断数组中是否存在该元素，参数：查找的值、起始位置，可以替换 `ES5` 时代的 `indexOf` 判断方式。`indexOf` 判断元素是否为 `NaN`，会判断错误。

{% endnote %}

```javascript
var a = [1, 2, 3, NaN]
a.includes(2) // true
a.includes(4) // false
a.includes(NaN) // true
```
