---
title: deepMerge 对象深度合并
index_img: https://fang-kang.gitee.io/blog-img/4.jpg
date: 2020-11-05 15:33:01
tags:
  - js
  - utils
categories:
  - js
---

## deepMerge 对象深度合并

{% note success %}

注意

由于`JS`对象包括的范围非常广，加上`ES6`又有众多的新特性，很难、也没必要做到囊括所有的类型和情况，这里说的"对象"，指的是普通的对象，不包括修改对象原型链， 或者为"`Function`"，"`Promise`"等的情况，请留意。

{% endnote %}

在 ES6 中，我们可以很方便的使用`Object.assign`进行对象合并，但这只是浅层的合并，如果对象的属性为数组或者对象的时候，会导致属性内部的值丢失。

**注意**： 此处合并不同于`Object.assign`，因为`Object.assign(a, b)`会修改`a`的值为最终的结果(这往往不是我们所期望的)，但是`deepMerge(a, b)`并不会修改`a`的值。

`deepMerge(target = {}, source = {})`

- `target` <Object> 目标对象

- `source` <Object> 源对象

`Object.assign`浅合并示例：

```javascript
let a = {
  info: {
    name: 'mary',
  },
}

let b = {
  info: {
    age: '22',
  },
}

// 使用Object.assign进行合并，注意此时a被修改了
let c = Object.assign(a, b)

// 我们期望的结果为：
c = {
  info: {
    name: 'mary',
    age: '22',
  },
}

// 事实上，我们得到的结果却为：
c = {
  info: {
    age: '22',
  },
}
```

深度合并示例：

```javascript
let a = {
  info: {
    name: 'mary',
  },
}

let b = {
  info: {
    age: '22',
  },
}

let c = deepMerge(a, b)

// c为我们期望的结果
c = {
  info: {
    age: '22',
    name: 'mary',
  },
}
```

```javascript
// JS对象深度合并
function deepMerge(target = {}, source = {}) {
  target = deepClone(target)
  if (typeof target !== 'object' || typeof source !== 'object') return false
  for (var prop in source) {
    if (!source.hasOwnProperty(prop)) continue
    if (prop in target) {
      if (typeof target[prop] !== 'object') {
        target[prop] = source[prop]
      } else {
        if (typeof source[prop] !== 'object') {
          target[prop] = source[prop]
        } else {
          if (target[prop].concat && source[prop].concat) {
            target[prop] = target[prop].concat(source[prop])
          } else {
            target[prop] = deepMerge(target[prop], source[prop])
          }
        }
      }
    } else {
      target[prop] = source[prop]
    }
  }
  return target
}
```
