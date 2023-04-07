---
title: ES6——箭头函数与普通函数的区别
date: 2021-01-09 17:38
index_img: https://fang-kang.gitee.io/blog-img/2.jpg
tags:
  - Js
categories:
  - Js
---

ES6 标准新增了一种新的函数：`Arrow Function`（箭头函数）。

为什么叫`Arrow Function`？因为它的定义用的就是一个箭头：

语法:

```js
//1、没有形参的时候
let fun = () => console.log('我是箭头函数')
fun()
//2、只有一个形参的时候()可以省略
let fun2 = a => console.log(a)
fun2('aaa')

//3、俩个及俩个以上的形参的时候
let fun3 = (x, y) => console.log(x, y) //函数体只包含一个表达式则省略return 默认返回
fun3(24, 44)

//4、俩个形参以及函数体多条语句表达式
let fun4 = (x, y) => {
  console.log(x, y)
  return x + y //必须加return才有返回值
} //5、如果要返回对象时需要用小括号包起来，因为大括号被占用解释为代码块了，正确写法let fun5 = ()=>({ foo: x })   //如果x => { foo: x }  //则语法出错
```

那么箭头函数有哪些特点？

- 更简洁的语法
- 没有 this
- 不能使用 new 构造函数
- 不绑定 arguments，用 rest 参数...解决
- 使用 call()和 apply()调用
- 捕获其所在上下文的 this 值，作为自己的 this 值
- 箭头函数没有原型属性
- 不能简单返回对象字面量
- 箭头函数不能当做 Generator 函数,不能使用 yield 关键字
- 箭头函数不能换行

## 相比普通函数更简洁的语法

箭头函数

```js
var a = () => {
  return 1
}
```

相当于普通函数

```js
function a() {
  return 1
}
```

## 没有 this

在箭头函数出现之前，每个新定义的函数都有其自己的 `this` 值

```js
var myObject = {
  value: 1,
  getValue: function () {
    console.log(this.value)
  },
  double: function () {
    return function () {
      //this指向double函数内不存在的value
      console.log((this.value = this.value * 2))
    }
  },
}
/*希望value乘以2*/
myObject.double()() //NaN
myObject.getValue() //1
```

使用箭头函数

```js
var myObject = {
  value: 1,
  getValue: function () {
    console.log(this.value)
  },
  double: function () {
    return () => {
      console.log((this.value = this.value * 2))
    }
  },
}
/*希望value乘以2*/
myObject.double()() //2
myObject.getValue() //2
```

## 不能使用 new

箭头函数作为匿名函数,是不能作为构造函数的,不能使用`new`

```js
var B = () => {
  value: 1
}

var b = new B() //TypeError: B is not a constructor
```

## 不绑定 arguments，用 rest 参数...解决

```js
/*常规函数使用arguments*/
function test1(a) {
  console.log(arguments) //1
}
/*箭头函数不能使用arguments*/
var test2 = a => {
  console.log(arguments)
} //ReferenceError: arguments is not defined
/*箭头函数使用reset参数...解决*/
let test3 = (...a) => {
  console.log(a[1])
} //22

test1(1)
test2(2)
test3(33, 22, 44)
```

## 使用 call()和 apply()调用

由于 this 已经在词法层面完成了绑定，通过 call() 或 apply() 方法调用一个函数时，只是传入了参数而已，对 this 并没有什么影响：

```js
var obj = {
  value: 1,
  add: function (a) {
    var f = v => v + this.value //a==v,3+1
    return f(a)
  },
  addThruCall: function (a) {
    var f = v => v + this.value //此this指向obj.value
    var b = { value: 2 }
    return f.call(b, a) //f函数并非指向b,只是传入了a参数而已
  },
}

console.log(obj.add(3)) //4
console.log(obj.addThruCall(4)) //5
```

## 捕获其所在上下文的 this 值，作为自己的 this 值

```js
var obj = {
  a: 10,
  b: function () {
    console.log(this.a) //10
  },
  c: function () {
    return () => {
      console.log(this.a) //10
    }
  },
}
obj.b()
obj.c()()
```

## 箭头函数没有原型属性

```js
var a = () => {
  return 1
}

function b() {
  return 2
}

console.log(a.prototype) //undefined
console.log(b.prototype) //object{...}
```

## 不能简单返回对象字面量

如果要返回对象时需要用小括号包起来，因为大括号被占用解释为代码块了，正确写法

```js
let fun5 = () => ({ foo: x }) //如果x => { foo: x }  //则语法出错
```

## 箭头函数不能当做 Generator 函数,不能使用 yield 关键字

## 箭头函数不能换行

```js
let a = ()
          =>1; //SyntaxError: Unexpected token =>
```
