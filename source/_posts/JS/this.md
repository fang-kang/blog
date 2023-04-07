---
title: 嗨，你真的懂this吗？
date: 2020-12-18 15:33:01
tags:
 - Js
categories:
 - Js
index_img: https://fang-kang.gitee.io/blog-img/sdqryn.webp
---

`this`关键字是`JavaScript`中最复杂的机制之一，是一个特别的关键字，被自动定义在所有函数的作用域中，但是相信很多`JavaScript`开发者并不是非常清楚它究竟指向的是什么。听说你很懂`this`,是真的吗？

再看一道题，控制台打印出来的值是什么？【浏览器运行环境】

```javascript
var number = 5;
var obj = {
    number: 3,
    fn1: (function () {
        var number;
        this.number *= 2;
        number = number * 2;
        number = 3;
        return function () {
            var num = this.number;
            this.number *= 2;
            console.log(num);
            number *= 3;
            console.log(number);
        }
    })()
}
var fn1 = obj.fn1;
fn1.call(null);
obj.fn1();
console.log(window.number);
```

如果你思考出来的结果，与在浏览中执行结果相同，并且每一步的依据都非常清楚，那么，你可以选择继续往下阅读，或者关闭本网页，愉快得去玩耍。如果你有一部分是靠蒙的，或者对自己的答案并不那么确定，那么请继续往下阅读。

毕竟花一两个小时的时间，把`this`彻底搞明白，是一件很值得事情，不是吗？

本文将细致得讲解`this`的绑定规则，并在最后剖析前文两道题。

## 为什么要学习this?

首先，我们为什么要学习`this`？

1. `this`使用频率很高，如果我们不懂`this`，那么在看别人的代码或者是源码的时候，就会很吃力。
2. 工作中，滥用`this`，却没明白`this`指向的是什么，而导致出现问题，但是自己却不知道哪里出问题了。【在公司，我至少帮10个以上的开发人员处理过这个问题】
3. 合理的使用`this`，可以让我们写出简洁且复用性高的代码。
4. 面试的高频问题，回答不好，抱歉，出门右拐，不送。

不管出于什么目的，我们都需要把`this`这个知识点整的明明白白的。

OK，Let's go!

## this是什么？

言归正传，`this`是什么？首先记住`this`不是指向自身！`this `就是一个指针，指向调用函数的对象。这句话我们都知道，但是很多时候，我们未必能够准确判断出`this`究竟指向的是什么？这就好像我们听过很多道理 却依然过不好这一生。今天咱们不探讨如何过好一生的问题，但是呢，希望阅读完下面的内容之后，你能够一眼就看出`this`指向的是什么。

为了能够一眼看出`this`指向的是什么，我们首先需要知道`this`的绑定规则有哪些？

1. 默认绑定
2. 隐式绑定
3. 硬绑定
4. new绑定

上面的名词，你也许听过，也许没听过，但是今天之后，请牢牢记住。我们将依次来进行解析。

### 默认绑定

默认绑定，在不能应用其它绑定规则时使用的默认规则，通常是独立函数调用。

```javascript
function sayHi(){
    console.log('Hello,', this.name);
}
var name = 'YvetteLau';
sayHi();
```

在调用`Hi()`时，应用了默认绑定，`this`指向全局对象（非严格模式下），严格模式下，`this`指向`undefined`，`undefined`上没有`this`对象，会抛出错误。

上面的代码，如果在浏览器环境中运行，那么结果就是 `Hello,YvetteLau`

但是如果在`node`环境中运行，结果就是 `Hello,undefined`.这是因为`node`中`name`并不是挂在全局对象上的。

本文中，如不特殊说明，默认为浏览器环境执行结果。

### 隐式绑定

函数的调用是在某个对象上触发的，即调用位置上存在上下文对象。典型的形式为` XXX.fun()`.我们来看一段代码：

```javascript
function sayHi(){
    console.log('Hello,', this.name);
}
var person = {
    name: 'YvetteLau',
    sayHi: sayHi
}
var name = 'Wiliam';
person.sayHi();
```

打印的结果是 `Hello,YvetteLau.`

`sayHi`函数声明在外部，严格来说并不属于`person`，但是在调用`sayHi`时,调用位置会使用`person`的上下文来引用函数，隐式绑定会把函数调用中的`this`(即此例`sayHi`函数中的`this`)绑定到这个上下文对象（即此例中的`person`）

需要注意的是：对象属性链中只有最后一层会影响到调用位置。

```javascript
function sayHi(){
    console.log('Hello,', this.name);
}
var person2 = {
    name: 'Christina',
    sayHi: sayHi
}
var person1 = {
    name: 'YvetteLau',
    friend: person2
}
person1.friend.sayHi();
```

结果是：`Hello, Christina.`

因为只有最后一层会确定`this`指向的是什么，不管有多少层，在判断`this`的时候，我们只关注最后一层，即此处的`friend`。

隐式绑定有一个大陷阱，绑定很容易丢失(或者说容易给我们造成误导，我们以为`this`指向的是什么，但是实际上并非如此).

```javascript
function sayHi(){
    console.log('Hello,', this.name);
}
var person = {
    name: 'YvetteLau',
    sayHi: sayHi
}
var name = 'Wiliam';
var Hi = person.sayHi;
Hi();
```

结果是: `Hello,Wiliam.`

这是为什么呢，`Hi`直接指向了`sayHi`的引用，在调用的时候，跟`person`没有半毛钱的关系，针对此类问题，我建议大家只需牢牢继续这个格式:`XXX.fn()`;`fn()`前如果什么都没有，那么肯定不是隐式绑定，但是也不一定就是默认绑定，这里有点小疑问，我们后来会说到。

除了上面这种丢失之外，隐式绑定的丢失是发生在回调函数中(事件回调也是其中一种)，我们来看下面一个例子:

```javascript
function sayHi(){
    console.log('Hello,', this.name);
}
var person1 = {
    name: 'YvetteLau',
    sayHi: function(){
        setTimeout(function(){
            console.log('Hello,',this.name);
        })
    }
}
var person2 = {
    name: 'Christina',
    sayHi: sayHi
}
var name='Wiliam';
person1.sayHi();
setTimeout(person2.sayHi,100);
setTimeout(function(){
    person2.sayHi();
},200);
```

结果为:

```js
Hello, Wiliam
Hello, Wiliam
Hello, Christina
```

- 第一条输出很容易理解，`setTimeout`的回调函数中，`this`使用的是默认绑定，非严格模式下，执行的是全局对象

- 第二条输出是不是有点迷惑了？说好`XXX.fun()`的时候，fun中的`this`指向的是XXX呢，为什么这次却不是这样了！Why?

  其实这里我们可以这样理解:` setTimeout(fn,delay){ fn(); }`,相当于是将`person2.sayHi`赋值给了一个变量，最后执行了变量，这个时候，`sayHi`中的`this`显然和`person2`就没有关系了。

- 第三条虽然也是在`setTimeout`的回调中，但是我们可以看出，这是执行的是`person2.sayHi()`使用的是隐式绑定，因此这是`this`指向的是`person2`，跟当前的作用域没有任何关系。

读到这里，也许你已经有点疲倦了，但是答应我，别放弃，好吗？再坚持一下，就可以掌握这个知识点了。

### 显式绑定

显式绑定比较好理解，就是通过`call`,`apply`,`bind`的方式，显式的指定`this`所指向的对象。(注意:《你不知道的Javascript》中将bind单独作为了硬绑定讲解了)

`call`,`apply`和`bind`的第一个参数，就是对应函数的`this`所指向的对象。`call`和`apply`的作用一样，只是传参方式不同。`call`和`apply`都会执行对应的函数，而`bind`方法不会。

```js
function sayHi(){
    console.log('Hello,', this.name);
}
var person = {
    name: 'YvetteLau',
    sayHi: sayHi
}
var name = 'Wiliam';
var Hi = person.sayHi;
Hi.call(person); //Hi.apply(person)
```

输出的结果为: `Hello, YvetteLau`. 因为使用硬绑定明确将`this`绑定在了`person`上。

那么，使用了硬绑定，是不是意味着不会出现隐式绑定所遇到的绑定丢失呢？显然不是这样的，不信，继续往下看。

```js
function sayHi(){
    console.log('Hello,', this.name);
}
var person = {
    name: 'YvetteLau',
    sayHi: sayHi
}
var name = 'Wiliam';
var Hi = function(fn) {
    fn();
}
Hi.call(person, person.sayHi); 
```

输出的结果是 `Hello, Wiliam`. 原因很简单，`Hi.call(person, person.sayHi)`的确是将`this`绑定到Hi中的`this`了。但是在执行fn的时候，相当于直接调用了`sayHi`方法(记住: person.sayHi已经被赋值给fn了，隐式绑定也丢了)，没有指定`this`的值，对应的是默认绑定。

现在，我们希望绑定不会丢失，要怎么做？很简单，调用fn的时候，也给它硬绑定。

```js
function sayHi(){
    console.log('Hello,', this.name);
}
var person = {
    name: 'YvetteLau',
    sayHi: sayHi
}
var name = 'Wiliam';
var Hi = function(fn) {
    fn.call(this);
}
Hi.call(person, person.sayHi);
```

此时，输出的结果为:` Hello, YvetteLau`，因为`person`被绑定到Hi函数中的`this`上，fn又将这个对象绑定给了`sayHi`的函数。这时，`sayHi`中的`this`指向的就是`person`对象。

至此，革命已经快胜利了，我们来看最后一种绑定规则: `new `绑定。

### new 绑定

`javaScript`和`Ｃ＋＋`不一样，并没有类，在`javaScript`中，构造函数只是使用`new`操作符时被调用的函数，这些函数和普通的函数并没有什么不同，它不属于某个类，也不可能实例化出一个类。任何一个函数都可以使用`new`来调用，因此其实并不存在构造函数，而只有对于函数的“构造调用”。

> 使用new来调用函数，会自动执行下面的操作：

1. 创建一个新对象
2. 将构造函数的作用域赋值给新对象，即this指向这个新对象
3. 执行构造函数中的代码
4. 返回新对象

因此，我们使用`new`来调用函数的时候，就会新对象绑定到这个函数的`this`上。

```js
function sayHi(name){
    this.name = name;
	
}
var Hi = new sayHi('Yevtte');
console.log('Hello,', Hi.name);
```

输出结果为 `Hello, Yevtte`, 原因是因为在var Hi = new sayHi('Yevtte');这一步，会将sayHi中的this绑定到Hi对象上。

### 绑定优先级

我们知道了`this`有四种绑定规则，但是如果同时应用了多种规则，怎么办？

显然，我们需要了解哪一种绑定方式的优先级更高，这四种绑定的优先级为:

new绑定 > 显式绑定 > 隐式绑定 > 默认绑定

这个规则时如何得到的，大家如果有兴趣，可以自己写个`demo`去测试，或者记住上面的结论即可。

### 绑定例外

凡事都有例外，`this`的规则也是这样。

如果我们将`null`或者是`undefined`作为`this`的绑定对象传入`call`、`apply`或者是`bind`,这些值在调用时会被忽略，实际应用的是默认绑定规则。

```js
var foo = {
    name: 'Selina'
}
var name = 'Chirs';
function bar() {
    console.log(this.name);
}
bar.call(null); //Chirs 
```

输出的结果是 `Chirs`，因为这时实际应用的是默认绑定规则。

### 箭头函数

箭头函数是`ES6`中新增的，它和普通函数有一些区别，箭头函数没有自己的`this`，它的this继承于外层代码库中的`this`。箭头函数在使用时，需要注意以下几点:

（1）函数体内的`this`对象，继承的是外层代码块的`this`。

（2）不可以当作构造函数，也就是说，不可以使用`new`命令，否则会抛出一个错误。

（3）不可以使用`arguments`对象，该对象在函数体内不存在。如果要用，可以用 `rest `参数代替。

（4）不可以使用`yield`命令，因此箭头函数不能用作 `Generator `函数。

（5）箭头函数没有自己的`this`，所以不能用call()、apply()、bind()这些方法去改变`this`的指向.

OK，我们来看看箭头函数的`this`是什么？

```js
var obj = {
    hi: function(){
        console.log(this);
        return ()=>{
            console.log(this);
        }
    },
    sayHi: function(){
        return function() {
            console.log(this);
            return ()=>{
                console.log(this);
            }
        }
    },
    say: ()=>{
        console.log(this);
    }
}
let hi = obj.hi();  //输出obj对象
hi();               //输出obj对象
let sayHi = obj.sayHi();
let fun1 = sayHi(); //输出window
fun1();             //输出window
obj.say();          //输出window
```

那么这是为什么呢？如果大家说箭头函数中的`this`是定义时所在的对象，这样的结果显示不是大家预期的，按照这个定义，`say`中的`this`应该是obj才对。

我们来分析一下上面的执行结果：

1. `obj.hi(); `对应了`this`的隐式绑定规则，`this`绑定在`obj`上，所以输出`obj`，很好理解。
2. `hi(); `这一步执行的就是箭头函数，箭头函数继承上一个代码库的`this`，刚刚我们得出上一层的`this`是`obj`，显然这里的`this`就是`obj`.
3. 执行`sayHi();`这一步也很好理解，我们前面说过这种隐式绑定丢失的情况，这个时候`this`执行的是默认绑定，`this`指向的是全局对象`window`.
4. `fun1();` 这一步执行的是箭头函数，如果按照之前的理解，`this`指向的是箭头函数定义时所在的对象，那么这儿显然是说不通。OK，按照箭头函数的`this`是继承于外层代码库的`this`就很好理解了。外层代码库我们刚刚分析了，`this`指向的是`window`，因此这儿的输出结果是`window`.
5. `obj.say();` 执行的是箭头函数，当前的代码块`obj`中是不存在`this`的，只能往上找，就找到了全局的`this`，指向的是`window`.

### 你说箭头函数的this是静态的？

依旧是前面的代码。我们来看看箭头函数中的`this`真的是静态的吗？

**我要说：非也**

```js
var obj = {
    hi: function(){
        console.log(this);
        return ()=>{
            console.log(this);
        }
    },
    sayHi: function(){
        return function() {
            console.log(this);
            return ()=>{
                console.log(this);
            }
        }
    },
    say: ()=>{
        console.log(this);
    }
}
let sayHi = obj.sayHi();
let fun1 = sayHi(); //输出window
fun1();             //输出window

let fun2 = sayHi.bind(obj)();//输出obj
fun2();                      //输出obj
```

可以看出，`fun1`和`fun2`对应的是同样的箭头函数，但是`this`的输出结果是不一样的。

所以，请大家牢牢记住一点: 箭头函数没有自己的`this`，箭头函数中的`this`继承于外层代码库中的`this`.

## 总结

关于`this`的规则，至此，就告一段落了，但是想要一眼就能看出`this`所绑定的对象，还需要不断的训练。

我们来回顾一下，最初的问题。

> #### 1. 如何准确判断this指向的是什么？

1. 函数是否在`new`中调用(`new`绑定)，如果是，那么`this`绑定的是新创建的对象。
2. 函数是否通过`call`,`apply`调用，或者使用了`bind`(即硬绑定)，如果是，那么`this`绑定的就是指定的对象。
3. 函数是否在某个上下文对象中调用(隐式绑定)，如果是的话，`this`绑定的是那个上下文对象。一般是`obj.foo()`
4. 如果以上都不是，那么使用默认绑定。如果在严格模式下，则绑定到`undefined`，否则绑定到全局对象。
5. 如果把Null或者`undefined`作为`this`的绑定对象传入`call`、`apply`或者`bind`，这些值在调用时会被忽略，实际应用的是默认绑定规则。
6. 如果是箭头函数，箭头函数的`this`继承的是外层代码块的`this`。

> #### 2. 执行过程解析

```js
var number = 5;
var obj = {
    number: 3,
    fn: (function () {
        var number;
        this.number *= 2;
        number = number * 2;
        number = 3;
        return function () {
            var num = this.number;
            this.number *= 2;
            console.log(num);
            number *= 3;
            console.log(number);
        }
    })()
}
var myFun = obj.fn;
myFun.call(null);
obj.fn();
console.log(window.number);
```

我们来分析一下，这段代码的执行过程。

1. 在定义obj的时候，fn对应的闭包就执行了，返回其中的函数，执行闭包中代码时，显然应用不了new绑定(没有出现new 关键字)，硬绑定也没有(没有出现call,apply,bind关键字),隐式绑定有没有？很显然没有，如果没有XX.fn()，那么可以肯定没有应用隐式绑定，所以这里应用的就是默认绑定了，非严格模式下this绑定到了window上(浏览器执行环境)。【这里很容易被迷惑的就是以为this指向的是obj，一定要注意，除非是箭头函数，否则this跟词法作用域是两回事，一定要牢记在心】

```js
window.number * = 2; //window.number的值是10(var number定义的全局变量是挂在window上的)

number = number * 2; //number的值是NaN;注意我们这边定义了一个number，但是没有赋值，number的值是undefined;Number(undefined)->NaN

number = 3;  //number的值为3
```

1. myFun.call(null);我们前面说了，call的第一个参数传null，调用的是默认绑定;

```js
fn: function(){
    var num = this.number;
    this.number *= 2;
    console.log(num);
    number *= 3;
    console.log(number);
}
```

执行时:

```js
var num = this.number; //num=10; 此时this指向的是window
this.number * = 2;  //window.number = 20
console.log(num);  //输出结果为10
number *= 3;  //number=9; 这个number对应的闭包中的number;闭包中的number的是3
console.log(number);  //输出的结果是9
```

1. obj.fn();应用了隐式绑定，fn中的`this`对应的是`obj`.

```js
var num = this.number;//num = 3;此时this指向的是obj
this.number *= 2; //obj.number = 6;
console.log(num); //输出结果为3;
number *= 3; //number=27;这个number对应的闭包中的number;闭包中的number的此时是9
console.log(number);//输出的结果是27
```

1. 最后一步console.log(window.number);输出的结果是20

因此组中结果为:

```js
10
9
3
27
20
```

严格模式下结果，大家根据今天所学，自己分析，巩固一下知识点。

最后，恭喜坚持读完的小伙伴们，你们成功get到了`this`这个知识点，但是想要完全掌握，还是要多回顾和练习。如果你有不错的`this`练习题，欢迎在评论区留言哦，大家一起进步！

本文转载于 [嗨，你真的懂this吗？](https://juejin.cn/post/6844903805587619854)