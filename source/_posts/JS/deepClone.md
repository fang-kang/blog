---
title: deepClone 对象深度克隆
date: 2020-11-05 15:33:01
tags:
 - Js
categories:
 - Js
index_img: https://fang-kang.gitee.io/blog-img/3.jpg
---

# deepClone 对象深度克隆

{% note success %}

注意

由于`JS`对象包括的范围非常广，加上`ES6`又有众多的新特性，很难、也没必要做到囊括所有的类型和情况，这里说的"对象"，指的是普通的对象，不包括修改对象原型链， 或者为"`Function`"，"`Promise`"等的情况，请留意。

{% endnote %}

<!-- more -->

## 场景

我们平时可能会遇到需要通过`console.log`打印一个对象，至执行打印的时刻，此对象为空，后面的逻辑
中对此对象进行了修改赋值，但是我们在控制台直接看到的打印结果 却是修改后的值，这让人匪夷所思，虽然我们可以通过
`console.log(JSON.parse(JSON.stringify(object)))`的形式处理，但是需要写这长长的一串，难免让人心生抵触。

当我们将一个对象(变量A)赋值给另一个变量(变量B)时，修改变量B，因为对象引用的特性，导致A也同时被修改，所以有时候我们需要将A克隆给B，这样修改B的时候，就不会 导致A也被修改。

`deepClone(object = {})`

- `object` <Object> 需要被克隆的对象

``` javascript

let a = {
	name: '小明'
};

// 直接赋值，为对象引用，即修改b等于修改a，因为a和b为同一个值

let b = a;

b.name = '小明';
console.log(b); // 结果为 {name: '小明'}
console.log(a); // 结果为 {name: '小明'}


// 深度克隆
let b = deepClone(a);

b.name = '小红';
console.log(b); // 结果为 {name: '小红'}
console.log(a); // 结果为 {name: '小明'}

```

``` javascript

// 判断arr是否为一个数组，返回一个bool值
function isArray (arr) {
    return Object.prototype.toString.call(arr) === '[object Array]';
}

// 深度克隆
function deepClone (obj) {
	// 对常见的“非”值，直接返回原来值
	if([null, undefined, NaN, false].includes(obj)) return obj;
    if(typeof obj !== "object" && typeof obj !== 'function') {
		//原始类型直接返回
        return obj;
    }
    var o = isArray(obj) ? [] : {};
    for(let i in obj) {
        if(obj.hasOwnProperty(i)){
            o[i] = typeof obj[i] === "object" ? deepClone(obj[i]) : obj[i];
        }
    }
    return o;
}

```

