---
title: 回调函数-Promise
date: 2020-11-24 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/7.jpg
tags:
  - js
categories:
  - js
---

## 一、准备

### 1.1 区别实例对象与函数对象

1. 实例对象：new 函数产生的对象，称为实例对象，简称为对象
2. 函数对象：将函数作为对象使用时，称为函数对象

```js
function Fn() {
  // Fn只能称为函数
}
const fn = new Fn() // Fn只有new过的才可以称为构造函数
//fn称为实例对象
console.log(Fn.prototype) // Fn作为对象使用时，才可以称为函数对象
Fn.bind({}) //Fn作为函数对象使用
$('#test') // $作为函数使用
$.get('/test') // $作为函数对象使用
```

> ()的左边必然是函数，点的左边必然是对象

### 1.2 回调函数

#### 同步回调

定义：立即执行，完全执行完了才结束，不会放入回调队列中

举例：数组遍历相关的回调 / Promise 的 excutor 函数

```js
const arr = [1, 3, 5]
arr.forEach(item => {
  // 遍历回调，同步回调，不会放入队列，一上来就要执行
  console.log(item)
})
console.log('forEach()之后')
// 1
// 3
// 5
// "forEach()之后"
```

#### 异步回调

定义：不会立即执行，会放入回调队列中将来执行

举例：定时器回调 / ajax 回调 / Promise 成功或失败的回调

```js
// 定时器回调
setTimeout(() => {
  // 异步回调，会放入队列中将来执行
  console.log('timeout callback()')
}, 0)
console.log('setTimeout()之后')
// “setTimeout()之后”
// “timeout callback()”
// Promise 成功或失败的回调
new Promise((resolve, reject) => {
  resolve(1)
}).then(
  value => {
    console.log('value', value)
  },
  reason => {
    console.log('reason', reason)
  }
)
console.log('----')
// ----
// value 1
```

**js 引擎是先把初始化的同步代码都执行完成后，才执行回调队列中的代码**

### 1.3 JS 的 error 处理

#### 错误的类型

Error：所有错误的父类型

ReferenceError：引用的变量不存在

```js
console.log(a) // ReferenceError:a is not defined
```

TypeError：数据类型不正确

```js
let b
console.log(b.xxx)
// TypeError:Cannot read property 'xxx' of undefined
let b = {}
b.xxx()
// TypeError:b.xxx is not a function
```

RangeError：数据值不在其所允许的范围内

```js
function fn() {
  fn()
}
fn()
// RangeError:Maximum call stack size exceeded
```

SyntaxError：语法错误

```
const c = """"
// SyntaxError:Unexpected string
```

#### 错误处理

捕获错误：try ... catch

抛出错误：throw error

```js
function something() {
  if (Date.now() % 2 === 1) {
    console.log('当前时间为奇数，可以执行任务')
  } else {
    //如果时间为偶数抛出异常，由调用来处理
    throw new Error('当前时间为偶数，无法执行任务')
  }
}

// 捕获处理异常
try {
  something()
} catch (error) {
  alert(error.message)
}
```

#### 错误对象

massage 属性：错误相关信息

stack 属性：函数调用栈记录信息

```js
try {
  let d
  console.log(d.xxx)
} catch (error) {
  console.log(error.message)
  console.log(error.stack)
}
console.log('出错之后')
// Cannot read property 'xxx' of undefined
// TypeError:Cannot read property 'xxx' of undefined
// 出错之后
```

> 因为错误被捕获处理了，后面的代码才能运行下去，打印出‘出错之后’

## 二、Promise 的理解和使用

### 2.1 Promise 是什么

#### 2.1.1 Promise 的理解

抽象表达：Promise 是 JS 中进行异步编程的新的解决方案

具体表达：

1. 语法上：Promise 是一个构造函数
2. 功能上：Promise 对象用来封装一个异步操作并可以获取其结果

#### 2.1.2 Promise 的状态改变

1. pending 变为 resolved
2. pending 变为 rejected

只有这两种，且一个 promise 对象只能改变一次。无论成功还是失败，都会有一个结果数据。成功的结果数据一般称为 value，而失败的一般称为 reason。

#### 2.1.3 Promise 的基本流程

![img](https://img-blog.csdnimg.cn/20200703144207912.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

#### 2.1.4 Promise 的基本使用

```js
// 创建一个新的p对象promise
const p = new Promise((resolve, reject) => {
  // 执行器函数
  // 执行异步操作任务
  setTimeout(() => {
    const time = Date.now()
    // 如果当前时间是偶数代表成功，否则失败
    if (time % 2 == 0) {
      // 如果成功，调用resolve(value)
      resolve('成功的数据，time=' + time)
    } else {
      // 如果失败，调用reject(reason)
      reject('失败的数据，time=' + time)
    }
  }, 1000)
})

p.then(
  value => {
    // 接收得到成功的value数据 onResolved
    console.log('成功的回调', value)
  },
  reason => {
    // 接收得到失败的reason数据 onRejected
    console.log('失败的回调', reason)
  }
)
```

.then() 和执行器(excutor)同步执行，.then() 中的回调函数异步执行

### 2.2 为什么要用 Promise

#### 1.指定回调函数的方式更加灵活

旧的：必须在启动异步任务前指定

promise：启动异步任务 => 返回 promise 对象 => 给 promise 对象绑定回调函数(甚至可以在异步任务结束后指定)

#### 2.支持链式调用，可以解决回调地狱问题

##### 什么是回调地狱？

回调函数嵌套调用，**外部回调函数**异步执行的结果是其**内部嵌套的回调函数**执行的条件

```js
doSomething(function (result) {
  doSomethingElse(
    result,
    function (newResult) {
      doThirdThing(
        newResult,
        function (finalResult) {
          console.log('Got the final result:' + finalResult)
        },
        failureCallback
      )
    },
    failureCallback
  )
}, failureCallback)
```

##### 回调地狱的缺点？

不便于阅读 / 不便于异常处理

##### 解决方案？

promise 链式调用

##### 终极解决方案？

async/await

##### 使用 promise 的链式调用解决回调地狱

```js
doSomething()
  .then(result => doSomethingElse(result))
  .then(newResult => doThirdThing(newResult))
  .then(finalResult => {
    console.log('Got the final result:' + finalResult)
  })
  .catch(failureCallback)
```

回调地狱的终极解决方案 async/await

```js
async function request() {
  try {
    const result = await doSomething()
    const newResult = await doSomethingElse(result)
    const finalResult = await doThirdThing(newResult)
    console.log('Got the final result:' + finalResult)
  } catch (error) {
    failureCallback(error)
  }
}
```

### 2.3 如何使用 Promise

#### API

1. Promise 构造函数：Promise(excutor) {}

   excutor 函数：同步执行 (resolve, reject) => {}

   resolve 函数：内部定义成功时调用的函数 resove(value)

   reject 函数：内部定义失败时调用的函数 reject(reason)

   说明：excutor 是执行器，会在 Promise 内部立即同步回调，异步操作 `resolve/reject` 就在 excutor 中执行

2. Promise.prototype.then 方法：p.then(onResolved, onRejected)

   1）onResolved 函数：成功的回调函数 (value) => {}

   2）onRejected 函数：失败的回调函数 (reason) => {}

   说明：指定用于得到成功 value 的成功回调和用于得到失败 reason 的失败回调，返回一个新的 promise 对象

3. Promise.prototype.catch 方法：p.catch(onRejected)

   1）onRejected 函数：失败的回调函数 (reason) => {}

   说明：**then() 的语法糖**，相当于 then(undefined, onRejected)

```js
new Promise((resolve, reject) => { // excutor执行器函数
 setTimeout(() => {
   if(...) {
     resolve('成功的数据') // resolve()函数
   } else {
     reject('失败的数据') //reject()函数
    }
 }, 1000)
}).then(
 value => { // onResolved()函数
  console.log(value)
}
).catch(
 reason => { // onRejected()函数
  console.log(reason)
}
)
```

1. Promise.resolve 方法：Promise.resolve(value)

   value：将被 `Promise` 对象解析的参数，也可以是一个成功或失败的 `Promise` 对象

   返回：返回一个带着给定值解析过的 `Promise` 对象，如果参数本身就是一个 `Promise` 对象，则直接返回这个 `Promise` 对象。

2. Promise.reject 方法：Promise.resolve(reason)

   reason：失败的原因

   说明：返回一个失败的 promise 对象

```js
//产生一个成功值为1的promise对象
new Promise((resolve, reject) => {
  resolve(1)
})
//相当于
const p1 = Promise.resolve(1)
const p2 = Promise.resolve(2)
const p3 = Promise.reject(3)

p1.then(value => {
  console.log(value)
}) // 1
p2.then(value => {
  console.log(value)
}) // 2
p3.catch(reason => {
  console.log(reason)
}) // 3
```

`Promise.resolve()/Promise.reject()` 方法就是一个**语法糖**

1. Promise.all 方法：Promise.all(iterable)

   iterable：包含 n 个 promise 的可迭代对象，如 `Array` 或 `String`

   说明：返回一个新的 promise，只有所有的 promise 都成功才成功，只要有一个失败了就直接失败

```js
const pAll = Promise.all([p1, p2, p3])
const pAll2 = Promise.all([p1, p2])
//因为其中p3是失败所以pAll失败
pAll.then(
  value => {
    console.log('all onResolved()', value)
  },
  reason => {
    console.log('all onRejected()', reason)
  }
)
// all onRejected() 3
pAll2.then(
  values => {
    console.log('all onResolved()', values)
  },
  reason => {
    console.log('all onRejected()', reason)
  }
)
// all onResolved() [1, 2]
```

1. Promise.race 方法：Promise.race(iterable)

   iterable：包含 n 个 promise 的可迭代对象，如 `Array` 或 `String`

   说明：返回一个新的 promise，第一个完成的 promise 的结果状态就是最终的结果状态

```js
const pRace = Promise.race([p1, p2, p3])
// 谁先完成就输出谁(不管是成功还是失败)
const p1 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(1)
  }, 1000)
})
const p2 = Promise.resolve(2)
const p3 = Promise.reject(3)

pRace.then(
  value => {
    console.log('race onResolved()', value)
  },
  reason => {
    console.log('race onRejected()', reason)
  }
)
//race onResolved() 2
```

#### Promise 的几个关键问题

##### 1.如何改变 promise 的状态？

(1)resolve(value)：如果当前是 pending 就会变为 resolved

(2)reject(reason)：如果当前是 pending 就会变为 rejected

(3)抛出异常：如果当前是 pending 就会变为 rejected

```js
const p = new Promise((resolve, reject) => {
  //resolve(1) // promise变为resolved成功状态
  //reject(2) // promise变为rejected失败状态
  throw new Error('出错了') // 抛出异常，promise变为rejected失败状态，reason为抛出的error
})
p.then(
  value => {},
  reason => {
    console.log('reason', reason)
  }
)
// reason Error:出错了
```

##### 2.一个 promise 指定多个成功/失败回调函数，都会调用吗？

当 promise 改变为对应状态时都会调用

```js
const p = new Promise((resolve, reject) => {
  //resolve(1)
  reject(2)
})
p.then(
  value => {},
  reason => {
    console.log('reason', reason)
  }
)
p.then(
  value => {},
  reason => {
    console.log('reason2', reason)
  }
)
// reason 2
// reason2 2
```

##### 3.改变 promise 状态和指定回调函数谁先谁后？

1. 都有可能，常规是先指定回调再改变状态，但也可以先改状态再指定回调

2. 如何先改状态再指定回调？

   (1)在执行器中直接调用 resolve()/reject()

   (2)延迟更长时间才调用 then()

3. 什么时候才能得到数据？

   (1)如果先指定的回调，那当状态发生改变时，回调函数就会调用得到数据

   (2)如果先改变的状态，那当指定回调时，回调函数就会调用得到数据

```js
new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(1) // 改变状态
  }, 1000)
}).then(
  // 指定回调函数
  value => {},
  reason => {}
)
```

**此时，先指定回调函数，保存当前指定的回调函数；后改变状态(同时指定数据)，然后异步执行之前保存的回调函数。**

```js
new Promise((resolve, reject) => {
  resolve(1) // 改变状态
}).then(
  // 指定回调函数
  value => {},
  reason => {}
)
```

**这种写法，先改变的状态(同时指定数据)，后指定回调函数(不需要再保存)，直接异步执行回调函数**

##### 4.promise.then() 返回的新 promise 的结果状态由什么决定？

(1)简单表达：由 then() 指定的回调函数执行的结果决定

(2)详细表达：

① 如果抛出异常，新 promise 变为 rejected，reason 为抛出的异常

② 如果返回的是非 promise 的任意值，新 promise 变为 resolved，value 为返回的值

③ 如果返回的是另一个新 promise，此 promise 的结果就会成为新 promise 的结果

```js
new Promise((resolve, reject) => {
  resolve(1)
})
  .then(
    value => {
      console.log('onResolved1()', value)
    },
    reason => {
      console.log('onRejected1()', reason)
    }
  )
  .then(
    value => {
      console.log('onResolved2()', value)
    },
    reason => {
      console.log('onRejected2()', reason)
    }
  )
// onResolved1() 1
// onResolved2() undefined
new Promise((resolve, reject) => {
  resolve(1)
})
  .then(
    value => {
      console.log('onResolved1()', value)
      //return 2                   // onResolved2() 2
      //return Promise.resolve(3)  // onResolved2() 3
      //return Promise.reject(4)   // onRejected2() 4
      //throw 5                    // onRejected2() 5
    },
    reason => {
      console.log('onRejected1()', reason)
    }
  )
  .then(
    value => {
      console.log('onResolved2()', value)
    },
    reason => {
      console.log('onRejected2()', reason)
    }
  )
// onResolved1() 1
// 对应输出如上所示
```

##### 5.promise 如何串联多个操作任务？

(1)promise 的 then() 返回一个新的 promise，可以并成 then() 的链式调用

(2)通过 then 的链式调用串联多个同步/异步任务

```js
new Promise((resolve, reject) => {
  setTimeout(() => {
    console.log('执行任务1(异步)')
    resolve(1)
  }, 1000)
})
  .then(value => {
    console.log('任务1的结果', value)
    console.log('执行任务2(同步)')
    return 2 // 同步任务直接return返回结果
  })
  .then(value => {
    console.log('任务2的结果', value)
    return new Promise((resolve, reject) => {
      // 异步任务需要包裹在Promise对象中
      setTimeout(() => {
        console.log('执行任务3(异步)')
        resolve(3)
      }, 1000)
    })
  })
  .then(value => {
    console.log('任务3的结果', value)
  })
// 执行任务1(异步)
// 任务1的结果 1
// 执行任务2(同步)
// 任务2的结果 2
// 执行任务3(异步)
// 任务3的结果 3
```

##### 6.Promise 异常穿透(传透)？

(1)当使用 promise 的 then 链式调用时，可以在最后指定失败的回调

(2)前面任何操作出了异常，都会传到最后失败的回调中处理

```js
new Promise((resolve, reject) => {
  //resolve(1)
  reject(1)
})
  .then(value => {
    console.log('onResolved1()', value)
    return 2
  })
  .then(value => {
    console.log('onResolved2()', value)
    return 3
  })
  .then(value => {
    console.log('onResolved3()', value)
  })
  .catch(reason => {
    console.log('onRejected1()', reason)
  })
// onRejected1() 1
```

相当于这种写法：

```js
new Promise((resolve, reject) => {
  //resolve(1)
  reject(1)
})
  .then(
    value => {
      console.log('onResolved1()', value)
      return 2
    },
    reason => {
      throw reason
    } // 抛出失败的结果reason
  )
  .then(
    value => {
      console.log('onResolved2()', value)
      return 3
    },
    reason => {
      throw reason
    }
  )
  .then(
    value => {
      console.log('onResolved3()', value)
    },
    reason => {
      throw reason
    }
  )
  .catch(reason => {
    console.log('onRejected1()', reason)
  })
// onRejected1() 1
```

所以失败的结果是一层一层处理下来的，最后传递到 catch 中。

或者，将 `reason => {throw reason}` 替换为 `reason => Promise.reject(reason)` 也是一样的

##### 7.中断 promise 链？

当使用 promise 的 then 链式调用时，在中间中断，不再调用后面的回调函数

办法：在回调函数中返回一个 pending 状态的 promise 对象

```js
new Promise((resolve, reject) => {
  //resolve(1)
  reject(1)
})
  .then(value => {
    console.log('onResolved1()', value)
    return 2
  })
  .then(value => {
    console.log('onResolved2()', value)
    return 3
  })
  .then(value => {
    console.log('onResolved3()', value)
  })
  .catch(reason => {
    console.log('onRejected1()', reason)
  })
  .then(
    value => {
      console.log('onResolved4()', value)
    },
    reason => {
      console.log('onRejected2()', reason)
    }
  )
// onRejected1() 1
// onResolved4() undefined
```

为了在 catch 中就中断执行，可以这样写：

```js
new Promise((resolve, reject) => {
  //resolve(1)
  reject(1)
})
  .then(value => {
    console.log('onResolved1()', value)
    return 2
  })
  .then(value => {
    console.log('onResolved2()', value)
    return 3
  })
  .then(value => {
    console.log('onResolved3()', value)
  })
  .catch(reason => {
    console.log('onRejected1()', reason)
    return new Promise(() => {}) // 返回一个pending的promise
  })
  .then(
    value => {
      console.log('onResolved4()', value)
    },
    reason => {
      console.log('onRejected2()', reason)
    }
  )
// onRejected1() 1
```

在 catch 中返回一个新的 promise，且这个 promise 没有结果。

由于，返回的新的 promise 结果决定了后面 then 中的结果，所以后面的 then 中也没有结果。

这就实现了中断 promise 链的效果。

## 三、自定义(手写)Promise

### 3.1 Promise.js

> Promise.js 是 ES5 function 实现 Promise 的完整版

```js
/*
  自定义Promise函数模块：IIFE
*/
;(function (window) {
  const PENDING = 'pending'
  const RESOLVED = 'resolved'
  const REJECTED = 'rejected'

  /*
  Promise构造函数
  excutor: 执行器函数(同步执行)
*/
  function Promise(excutor) {
    // 将当前Promise对象保存起来
    const self = this
    self.status = PENDING // 给promise对象指定status属性，初始值为pending
    self.data = undefined // 给promise对象指定一个用于存储结果数据的属性
    self.callbacks = [] // 每个元素的结构： {onResolved() {}, onRejected() {}}
    function resolve(value) {
      // 如果当前状态不是pending，直接结束
      if (self.status !== PENDING) {
        return
      }
      // 将状态改为resolved
      self.status = RESOLVED
      // 保存value数据
      self.data = value
      // 如果有待执行的callback函数，立即异步执行回调函数onResolved
      if (self.callbacks.length > 0) {
        setTimeout(() => {
          // 放入队列中执行所有成功的回调
          self.callbacks.forEach(callbacksObj => {
            callbacksObj.onResolved(value)
          })
        })
      }
    }

    function reject(reason) {
      // 如果当前状态不是pending，直接结束
      if (self.status !== PENDING) {
        return
      }
      // 将状态改为rejected
      self.status = REJECTED
      // 保存value数据
      self.data = reason
      // 如果有待执行的callback函数，立即异步执行回调函数onRejected
      if (self.callbacks.length > 0) {
        setTimeout(() => {
          // 放入队列中执行所有失败的回调
          self.callbacks.forEach(callbacksObj => {
            callbacksObj.onRejected(reason)
          })
        })
      }
    }
    //立即同步执行excutor函数
    try {
      excutor(resolve, reject)
    } catch (error) {
      // 如果执行器抛出异常，promise对象变为rejected状态
      reject(error)
    }
  }

  /*
  Promise原型对象的then()
  指定成功和失败的回调函数
  返回一个新的promise对象
  */
  Promise.prototype.then = function (onResolved, onRejected) {
    onResolved = typeof onResolved === 'function' ? onResolved : value => value // 向后传递成功的value
    // 指定默认的失败的回调（实现错误/异常穿透的关键点）
    onRejected =
      typeof onRejected === 'function'
        ? onRejected
        : reason => {
            throw reason
          } // 向后传递失败的reason
    const self = this
    // 返回一个新的promise对象
    return new Promise((resolve, reject) => {
      /*
      调用指定的回调函数处理
      */
      function handle(callback) {
        /*
          1. 如果抛出异常，return的promise就会失败，reason就是error
          2. 如果回调函数执行返回的不是promise，return的promise就会成功，value就是返回的值
          3. 如果回调函数执行返回的是promise，return的promise的结果就是这个promise的结果
          */
        try {
          const result = callback(self.data)
          if (result instanceof Promise) {
            // 第三种情况
            result.then(
              value => resolve(value), // 当result成功时，让return的promise也成功
              reason => reject(reason) // 当result失败时，让return的promise也失败
            )
            // result.then(resolve, reject) // 简洁的写法
          } else {
            //第二种情况
            resolve(result)
          }
        } catch (error) {
          // 第一种情况
          reject(error)
        }
      }
      if (self.status === PENDING) {
        // 如果当前状态还是pending状态，将回调函数保存起来
        self.callbacks.push({
          onResolved(value) {
            handle(onResolved)
          },
          onRejected(reason) {
            handle(onRejected)
          },
        })
      } else if (self.status === RESOLVED) {
        // 如果当前状态已经改变为resolved状态，异步执行onResolved并改变return的promise状态
        setTimeout(() => {
          handle(onResolved)
        })
      } else {
        // 如果当前状态已经改变为rejected状态，异步执行onRejected并改变return的promise状态
        setTimeout(() => {
          handle(onRejected)
        })
      }
    })
  }

  /*
  Promise原型对象的catch()
  指定成功和失败的回调函数
  返回一个新的promise对象
  */
  Promise.prototype.catch = function (onRejected) {
    return this.then(undefined, onRejected)
  }

  /*
  Promise函数对象的resolve方法
  返回一个指定结果的成功的promise
  */
  Promise.resolve = function (value) {
    // 返回一个成功/失败的promise
    return new Promise((resolve, reject) => {
      if (value instanceof Promise) {
        // value是promise，使用value的结果作为new的promise的结果
        value.then(resolve, reject)
      } else {
        // value不是promise => promise变为成功，数据是value
        resolve(value)
      }
    })
  }

  /*
  Promise函数对象的reject方法
  返回一个指定reason的失败的promise
  */
  Promise.reject = function (reason) {
    // 返回一个失败的promise
    return new Promise((resolve, reject) => {
      reject(reason)
    })
  }

  /*
  Promise函数对象的all方法
  返回一个promise，只有当所有promise都成功时才成功，否则只要有一个失败的就失败
  */
  Promise.all = function (promises) {
    // 用来保存成功promise的数量
    let resolvedCount = 0
    // 用来保存所有成功value的数组
    const values = new Array(promises.length)
    // 返回一个新的promise
    return new Promise((resolve, reject) => {
      // 遍历promises获取每个promise的结果
      promises.forEach((p, index) => {
        Promise.resolve(p).then(
          // 将p用Promise.resolve()包裹起来使得p可以是一个值
          value => {
            resolvedCount++ // 成功的数量加1
            // p成功，将成功的value按顺序保存到values
            values[index] = value
            // 如果全部成功了。将return的promise改为成功
            if (resolvedCount === promises.length) {
              resolve(values)
            }
          },
          reason => {
            // 只要有一个失败了，return的promise就失败
            reject(reason)
          }
        )
      })
    })
  }

  /*
  Promise函数对象的all方法
  返回一个promise，其结果由第一个完成的promise决定
  */
  Promise.race = function (promises) {
    // 返回一个promise
    return new Promise((resolve, reject) => {
      // 遍历promises获取每个promise的结果
      promises.forEach((p, index) => {
        // 只有第一次调用的有效果
        Promise.resolve(p).then(
          value => {
            // 一旦有成功，将return的promise变为成功
            resolve(value)
          },
          reason => {
            // 一旦有失败，将return的promise变为失败
            reject(reason)
          }
        )
      })
    })
  }

  /*
  返回一个promise对象，它在指定的时间后才确定结果
  (在Promise.resolve()上加setTimeout)
  */
  Promise.resolveDelay = function (value, time) {
    // 返回一个成功/失败的promise
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        if (value instanceof Promise) {
          // value是promise，使用value的结果作为new的promise的结果
          value.then(resolve, reject)
        } else {
          // value不是promise => promise变为成功，数据是value
          resolve(value)
        }
      }, time)
    })
  }

  /*
  返回一个promise对象，它在指定的时间后才失败
  */
  Promise.rejectDelay = function (reason, time) {
    // 返回一个失败的promise
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        reject(reason)
      }, time)
    })
  }

  window.Promise = Promise // 向外暴露Promise
})(window)
```

### 3.2 Promise_class.js

> Promise_class.js 是 ES6 class 实现 Promise 的完整版

```javascript
/*
  类版本
  自定义Promise函数模块：IIFE
*/
;(function (window) {
  const PENDING = 'pending'
  const RESOLVED = 'resolved'
  const REJECTED = 'rejected'

  class Promise {
    /*
    Promise构造函数
    excutor: 执行器函数(同步执行)
    */
    constructor(excutor) {
      // 将当前Promise对象保存起来
      const self = this
      self.status = PENDING // 给promise对象指定status属性，初始值为pending
      self.data = undefined // 给promise对象指定一个用于存储结果数据的属性
      self.callbacks = [] // 每个元素的结构： {onResolved() {}, onRejected() {}}
      function resolve(value) {
        // 如果当前状态不是pending，直接结束
        if (self.status !== PENDING) {
          return
        }
        // 将状态改为resolved
        self.status = RESOLVED
        // 保存value数据
        self.data = value
        // 如果有待执行的callback函数，立即异步执行回调函数onResolved
        if (self.callbacks.length > 0) {
          setTimeout(() => {
            // 放入队列中执行所有成功的回调
            self.callbacks.forEach(callbacksObj => {
              callbacksObj.onResolved(value)
            })
          })
        }
      }

      function reject(reason) {
        // 如果当前状态不是pending，直接结束
        if (self.status !== PENDING) {
          return
        }
        // 将状态改为rejected
        self.status = REJECTED
        // 保存value数据
        self.data = reason
        // 如果有待执行的callback函数，立即异步执行回调函数onRejected
        if (self.callbacks.length > 0) {
          setTimeout(() => {
            // 放入队列中执行所有失败的回调
            self.callbacks.forEach(callbacksObj => {
              callbacksObj.onRejected(reason)
            })
          })
        }
      }

      //立即同步执行excutor函数
      try {
        excutor(resolve, reject)
      } catch (error) {
        // 如果执行器抛出异常，promise对象变为rejected状态
        reject(error)
      }
    }

    /*
    Promise原型对象的then()
    指定成功和失败的回调函数
    返回一个新的promise对象
    */
    then(onResolved, onRejected) {
      onResolved = typeof onResolved === 'function' ? onResolved : value => value // 向后传递成功的value
      // 指定默认的失败的回调（实现错误/异常穿透的关键点）
      onRejected =
        typeof onRejected === 'function'
          ? onRejected
          : reason => {
              throw reason
            } // 向后传递失败的reason
      const self = this
      // 返回一个新的promise对象
      return new Promise((resolve, reject) => {
        /*
        调用指定的回调函数处理
        */
        function handle(callback) {
          /*
            1. 如果抛出异常，return的promise就会失败，reason就是error
            2. 如果回调函数执行返回的不是promise，return的promise就会成功，value就是返回的值
            3. 如果回调函数执行返回的是promise，return的promise的结果就是这个promise的结果
            */
          try {
            const result = callback(self.data)
            if (result instanceof Promise) {
              // 第三种情况
              result.then(
                value => resolve(value), // 当result成功时，让return的promise也成功
                reason => reject(reason) // 当result失败时，让return的promise也失败
              )
              // result.then(resolve, reject) // 简洁的写法
            } else {
              //第二种情况
              resolve(result)
            }
          } catch (error) {
            // 第一种情况
            reject(error)
          }
        }
        if (self.status === PENDING) {
          // 如果当前状态还是pending状态，将回调函数保存起来
          self.callbacks.push({
            onResolved(value) {
              handle(onResolved)
            },
            onRejected(reason) {
              handle(onRejected)
            },
          })
        } else if (self.status === RESOLVED) {
          // 如果当前状态已经改变为resolved状态，异步执行onResolved并改变return的promise状态
          setTimeout(() => {
            handle(onResolved)
          })
        } else {
          // 如果当前状态已经改变为rejected状态，异步执行onRejected并改变return的promise状态
          setTimeout(() => {
            handle(onRejected)
          })
        }
      })
    }

    /*
    Promise原型对象的catch()
    指定成功和失败的回调函数
    返回一个新的promise对象
    */
    catch(onRejected) {
      return this.then(undefined, onRejected)
    }

    /*
    Promise函数对象的resolve方法
    返回一个指定结果的成功的promise
    */
    static resolve = function (value) {
      // 返回一个成功/失败的promise
      return new Promise((resolve, reject) => {
        if (value instanceof Promise) {
          // value是promise，使用value的结果作为new的promise的结果
          value.then(resolve, reject)
        } else {
          // value不是promise => promise变为成功，数据是value
          resolve(value)
        }
      })
    }

    /*
    Promise函数对象的reject方法
    返回一个指定reason的失败的promise
    */
    static reject = function (reason) {
      // 返回一个失败的promise
      return new Promise((resolve, reject) => {
        reject(reason)
      })
    }

    /*
    Promise函数对象的all方法
    返回一个promise，只有当所有promise都成功时才成功，否则只要有一个失败的就失败
    */
    static all = function (promises) {
      // 用来保存成功promise的数量
      let resolvedCount = 0
      // 用来保存所有成功value的数组
      const values = new Array(promises.length)
      // 返回一个新的promise
      return new Promise((resolve, reject) => {
        // 遍历promises获取每个promise的结果
        promises.forEach((p, index) => {
          Promise.resolve(p).then(
            // 将p用Promise.resolve()包裹起来使得p可以是一个值
            value => {
              resolvedCount++ // 成功的数量加1
              // p成功，将成功的value按顺序保存到values
              values[index] = value
              // 如果全部成功了。将return的promise改为成功
              if (resolvedCount === promises.length) {
                resolve(values)
              }
            },
            reason => {
              // 只要有一个失败了，return的promise就失败
              reject(reason)
            }
          )
        })
      })
    }

    /*
    Promise函数对象的all方法
    返回一个promise，其结果由第一个完成的promise决定
    */
    static race = function (promises) {
      // 返回一个promise
      return new Promise((resolve, reject) => {
        // 遍历promises获取每个promise的结果
        promises.forEach((p, index) => {
          // 只有第一次调用的有效果
          Promise.resolve(p).then(
            value => {
              // 一旦有成功，将return的promise变为成功
              resolve(value)
            },
            reason => {
              // 一旦有失败，将return的promise变为失败
              reject(reason)
            }
          )
        })
      })
    }

    /*
    返回一个promise对象，它在指定的时间后才确定结果
    (在Promise.resolve()上加setTimeout)
    */
    static resolveDelay = function (value, time) {
      // 返回一个成功/失败的promise
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          if (value instanceof Promise) {
            // value是promise，使用value的结果作为new的promise的结果
            value.then(resolve, reject)
          } else {
            // value不是promise => promise变为成功，数据是value
            resolve(value)
          }
        }, time)
      })
    }

    /*
    返回一个promise对象，它在指定的时间后才失败
    */
    static rejectDelay = function (reason, time) {
      // 返回一个失败的promise
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          reject(reason)
        }, time)
      })
    }
  }

  window.Promise = Promise // 向外暴露Promise
})(window)
```

### 3.3 then.js

> then.js 是第二次重写的 then()方法

```javascript
/*
  Promise原型对象的then()
  指定成功和失败的回调函数
  返回一个新的promise对象
  返回promise的结果由onResolved/onRejected执行结果决定
  */
Promise.prototype.then = function (onResolved, onRejected) {
  const self = this
  // 指定回调函数的默认值（必须是函数）
  onResolved = typeof onResolved === 'function' ? onResolved : value => value
  onRejected =
    typeof onRejected === 'function'
      ? onRejected
      : reason => {
          throw reason
        }
  // 返回一个新的promise
  return new Promise((resolve, reject) => {
    /*
     执行指定的回调函数
     根据执行的结果改变这个新返回的promise的状态和数据
    */
    function handle(callback) {
      /*
        上面新返回的promise的结果由onResolved/onRejected执行结果决定
        1.抛出异常，将要返回的promise的结果为失败，reason为异常
        2.如果onResolved()返回的是一个promise，这个返回的promise的结果就是这个将要返回的promise的结果
        3.如果onResolved()返回的不是promise，将要返回的promise为成功，value为返回值
        */
      try {
        const result = callback(self.data)
        if (result instanceof Promise) {
          //2.
          // result.then(
          //   value => resolve(value),
          //   reason => reject(reason)
          // )
          result.then(resolve.reject) //简洁的写法
        } else {
          //3.
          resolve(result)
        }
      } catch (error) {
        //1.
        reject(error)
      }
    }
    if (self.status === RESOLVED) {
      //当前promise的状态是resolved
      // 立即异步执行成功的回调函数
      setTimeout(() => {
        handle(onResolved)
      })
    } else if (self.status === REJECTED) {
      //当前promise的状态是rejected
      // 立即异步执行成功的回调函数
      setTimeout(() => {
        handle(onRejected)
      })
    } else {
      //当前promise的状态是pending
      // 将成功和失败的回调函数保存到callbacks容器中缓存起来
      self.callbacks.push({
        //在resolve()/reject()中等待调用这两个函数
        onResolved(value) {
          //这里使用ES6中的对象字面量特性省略function
          handle(onResolved)
        },
        onRejected(reason) {
          handle(onRejected)
        },
      })
    }
  })
}
```

### 3.4 Promise.html

> 自定义 Promise.html 文件用来测试

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>

  <body>
    <!-- <script src="Promise.js"></script> -->
    <script src="Promise_class.js"></script>

    <!-- <script>
    /*
    测试.then()和.catch()
    Promise.resolve(value)
    value是将被Promise对象解析的参数，可以是一个成功/失败的Promise对象或值
    Promise.reject(reason)
    reason表示被拒绝的原因，不能是Promise对象
    */
    const p = new Promise((resolve, reject) => {
      setTimeout(() => {
        //resolve(1)
        reject(2)
        //console.log('reject()改变状态之后')
      }, 100)
    }).then(
      value => {
        console.log('onResolved1()', value)
      },
      reason => {
        console.log('onRejected1()', reason)
        //return 3
        //throw 4
        return new Promise((resolve, reject) => {reject(5)})
      }
    ).then(
      value => {
        console.log('onResolved2()', value)
      },
      reason => {
        console.log('onRejected2()', reason)
        throw 6
      }
    ).catch(
      reason => {
        console.log('onRejected3()', reason)
        return new Promise(() => {}) // 中断promise链
      }
    ).then(
      value => {
        console.log('onResolved4()', value)
      },
      reason => {
        console.log('onRejected4()', reason)
        throw 6
      }
    )
  </script> -->
    <!-- <script>
    /*
    测试Promise.resolve(value)和Promise.reject(reason)
    语法
    1.Promise.resolve(value)
    value是将被Promise对象解析的参数，可以是一个成功/失败的Promise对象或值
    2.Promise.reject(reason)
    reason表示被拒绝的原因，不能是Promise对象
    */
    const p1 = Promise.resolve(2) // 如果是一般值，p1成功，value就是这个值
    const p2 = Promise.resolve(Promise.resolve(3)) // 如果是成功的promise，p2成功，value就是这个promise的value
    const p3 = Promise.resolve(Promise.reject(4)) // 如果是失败的promise，p3失败，reason就是这个promise的reason
    p1.then(value => {
      console.log('p1', value)
    })
    p2.then(value => {
      console.log('p2', value)
    })
    p3.catch(reason => {
      console.log('p3', reason)
    })
  </script> -->
    <script>
      /*
    测试Promise.all(value)和Promise.race(reason)
    语法
    1.Promise.resolve(value)
    value是将被Promise对象解析的参数，可以是一个成功/失败的Promise对象或值
    2.Promise.reject(reason)
    reason表示被拒绝的原因，不能是Promise对象
    */
      const p1 = Promise.resolve(2) // 如果是一般值，p1成功，value就是这个值
      const p2 = Promise.resolve(Promise.resolve(3)) // 如果是成功的promise，p2成功，value就是这个promise的value
      const p3 = Promise.resolve(Promise.reject(4)) // 如果是失败的promise，p3失败，reason就是这个promise的reason(只返回第一个失败的reason)
      /*const p4 = new Promise((resolve, reject) =>
      setTimeout(() => {
        resolve(5)
      }, 1000)
    )*/
      const p4 = Promise.resolveDelay(5, 1000) // 新的写法
      const p5 = Promise.reject(6)
      const pAll = Promise.all([p4, 7, p1, p2])
      pAll.then(
        value => {
          console.log('all onResolved()', value)
        },
        reason => {
          console.log('all onRejected()', reason)
        }
      )
      /*const pRace = Promise.race([p4, 7, p1, p2])
    pRace.then(
      value => {
        console.log('race onResolved()', value)
      },
      reason => {
        console.log('race onRejected()', reason)
      }
    )*/

      /*
    测试自定义的两个函数
    Promise.resolveDelay()和Promise.rejectDelay()
    */
      const p6 = Promise.resolveDelay(66, 2000)
      const p7 = Promise.rejectDelay(77, 3000)
      p6.then(value => {
        console.log('p6', value)
      })
      p7.catch(reason => {
        console.log('p7', reason)
      })
    </script>
  </body>
</html>
```

## 四、async 与 await

### 4.1 async 函数

1. 函数的返回值为 promise 对象
2. promise 对象的结果由 async 函数执行的返回值决定

```js
async function fn1() {
  //return 1
  // 返回一个Promise对象（PromiseStatus为resolved，PromiseValue为1）
  throw 2
  // 返回一个Promise对象（PromiseStatus为rejected，PromiseValue为2）
}
const result = fn1()
console.log(result)
```

这时，可以将 result.then()：

```js
async function fn1() {
  //return 1
  throw 2
}
const result = fn1()
result.then(
  value => {
    console.log('onResolved()', value)
  },
  reason => {
    console.log('onRejected()', reason)
  }
)
// onRejected() 2
```

也可以在异步函数中返回一个 promise

```js
async function fn1() {
  //return Promise.reject(3)
  return Promise.resolve(3)
}
const result = fn1()
result.then(
  value => {
    console.log('onResolved()', value)
  },
  reason => {
    console.log('onRejected()', reason)
  }
)
// onResolved() 3
```

也就是说，一旦在函数前加 async，它返回的值都将被包裹在 Promise 中，这个 Promise 的结果由函数执行的结果决定。

上面的栗子都是立即成功/失败的 promise，也可以返回延迟成功/失败的 promise：

```js
async function fn1() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(4)
    }, 1000)
  })
}
const result = fn1()
result.then(
  value => {
    // 过1s后才异步执行回调函数 onResolved()
    console.log('onResolved()', value)
  },
  reason => {
    console.log('onRejected()', reason)
  }
)
// onResolved() 4
```

### 4.2 await 表达式

#### MDN

[async](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/async_function)

[await](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/await)

#### 语法

[return_value] = await expression;

**表达式**

一个 `Promise` 对象或者任何要**等待**的`值`。

**返回值**

返回 Promise 对象的处理结果。如果**等待**的不是 Promise 对象，则返回该值本身。

**解释**

**await 表达式会暂停当前 async function 的执行，等待 Promise 处理完成。**

1. await 右侧的表达式一般为 promise 对象，但也可以是其他的值
2. 如果表达式是 promise 对象，await 返回的是 promise 成功的值
3. 如果表达式是其他值，直接将此值作为 await 的返回值

注意：

await 必须写在 async 函数中，但 async 函数中可以没有 await

如果 await 的 promise 失败了，就会抛出异常，需要通过 try...catch 来捕获处理

```js
function fn2() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(5)
    }, 1000)
  })
}

function fn4() {
  return 6
}

async function fn3() {
  //const p = fn2() // 这种写法只能得到一个promise对象
  const value = await fn2() // value 5
  //const value = await fn4() // value 6
  console.log('value', value)
}
fn3()
```

不写 await，只能得到一个 promise 对象。在表达式前面加上 await，1s 后将得到 promise 的结果 5，但是要用 await 必须在函数上声明 async。

await 右侧表达式 fn2() 为 promise，得到的结果就是 promise 成功的 value；await 右侧表达式 fn4() 不是 promise，得到的结果就是这个值本身。

Promise 对象的结果也有可能失败：

```js
function fn2() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      reject(5)
    }, 1000)
  })
}

async function fn3() {
  const value = await fn2()
  console.log('value', value)
}
fn3()
// 报错：Uncaught (in promise) 5
```

await 只能得到成功的结果，要想得到失败的结果就要用 try/catch：

```js
function fn2() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      reject(5)
    }, 1000)
  })
}

async function fn3() {
  try {
    const value = await fn2()
    console.log('value', value)
  } catch (error) {
    console.log('得到失败的结果', error)
  }
}
fn3()
// 得到失败的结果 5
```

下面这个栗子中，fn1 是第 2 种情况，fn2 是第 3 种情况，fn3 也是第 3 种情况

```js
async function fn1() {
  //async声明的异步回调函数将返回一个promise
  return 1
}
function fn2() {
  return 2
}
function fn3() {
  throw 3 // 抛出异常
}
async function fn3() {
  try {
    const value = await fn1() // value 1
    //const value = await fn2() // value 2
    //const value = await fn3() // 得到失败的结果 3
    console.log('value', value)
  } catch (error) {
    console.log('得到失败的结果', error)
  }
}
fn3()
```

## 五、JS 异步之宏队列与微队列

![img](https://img-blog.csdnimg.cn/20200703144207979.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

1. JS 中用来存储待执行回调函数的队列包含 2 个不同特定的队列

2. 宏队列：用来保存待执行的宏任务（回调），比如：定时器回调/DOM 事件回调/ajax 回调

3. 微队列：用来保存待执行的微任务（回调），比如：promise 的回调/MutationObserver 的回调

4. JS 执行时会区别这 2 个队列

   (1) JS 引擎首先必须执行所有的初始化同步任务代码

   (2) 每次准备取出第一个宏任务前，都要将所有的微任务一个一个取出来执行

```js
setTimeout(() => {
  // 会立即被放入宏队列
  console.log('timeout callback1()')
}, 0)
setTimeout(() => {
  // 会立即被放入宏队列
  console.log('timeout callback2()')
}, 0)
Promise.resolve(1).then(value => {
  // 会立即被放入微队列
  console.log('Promise onResolved1()', value)
})
Promise.resolve(1).then(value => {
  // 会立即被放入微队列
  console.log('Promise onResolved2()', value)
})
// Promise onResolved1() 1
// Promise onResolved2() 1
// timeout callback1()
// timeout callback2()
```

先执行所有的同步代码，再执行队列代码。队列代码中，微队列中的回调函数优先执行。

```js
setTimeout(() => { // 会立即被放入宏队列
  console.log('timeout callback1()')
  Promise.resolve(1).then(
  value => { // 会立即被放入微队列
    console.log('Promise onResolved3()', value)
  }
}, 0)
setTimeout(() => { // 会立即被放入宏队列
  console.log('timeout callback2()')
}, 0)
Promise.resolve(1).then(
  value => { // 会立即被放入微队列
    console.log('Promise onResolved1()', value)
  }
)
Promise.resolve(1).then(
  value => { // 会立即被放入微队列
    console.log('Promise onResolved2()', value)
  }
)
// Promise onResolved1() 1
// Promise onResolved2() 1
// timeout callback1()
  // Promise onResolved3() 1
// timeout callback2()
```

执行完 `timeout callback1()` 后 `Promise onResolved3()` 会立即被放入微队列。在执行 `timeout callback2()` 前，`Promise onResolved3()` 已经在微队列中了，所以先执行 `Promise onResolved3()`。

## 六、相关面试题

### 6.1 面试题 1

```js
setTimeout(() => {
  console.log(1)
}, 0)
new Promise(resolve => {
  console.log(2)
  resolve()
})
  .then(() => {
    console.log(3)
  })
  .then(() => {
    console.log(4)
  })
console.log(5)
// 2 5 3 4 1
/*
同步：[2,5]
异步：
宏队列：[1]
微队列：[3,4]
*/
```

**2 是 excutor 执行器，是同步回调函数，所以在同步代码中。.then() 中的函数才是异步回调**

其中，执行完 2 后改变状态为 resolve，第一个 .then() 中的 3 会放入微队列，但还没执行（promise 是 pending 状态），就不会把结果给第二个 then()，这时，4 就会缓存起来但不会被放入微队列。只有在微队列中的 3 执行完后才把 4 放入微队列。

所以顺序是：

1 放入宏队列，2 执行，3 放入微队列，4 缓存起来等待 Promise 的状态改变，5 执行，微队列中的 3 执行，4 放入微队列，微队列中的 4 执行，宏队列中的 1 执行。

### 6.2 面试题 2

```js
const first = () =>
  // 省略return所以不用{}而用()
  new Promise((resolve, reject) => {
    console.log(3)
    let p = new Promise((resolve, reject) => {
      console.log(7)
      setTimeout(() => {
        console.log(5)
        resolve(6) //没用，状态只能改变一次，在resolve(1)时就改变了
      }, 0)
      resolve(1)
    })
    resolve(2)
    p.then(arg => {
      console.log(arg)
    })
  })
first().then(arg => {
  console.log(arg)
})
console.log(4)
// 3 7 4 1 2 5
/*
宏：[5]
微：[1,2]
*/
```

### 6.3 面试题 3

```js
setTimeout(() => {
  console.log('0')
}, 0)
new Promise((resolve, reject) => {
  console.log('1')
  resolve()
})
  .then(() => {
    console.log('2')
    new Promise((resolve, reject) => {
      console.log('3')
      resolve()
    })
      .then(() => {
        console.log('4')
      })
      .then(() => {
        console.log('5')
      })
  })
  .then(() => {
    console.log('6')
  })

new Promise((resolve, reject) => {
  console.log('7')
  resolve()
}).then(() => {
  console.log('8')
})
// 1 7 2 3 8 4 6 5 0
/*
宏：[0]
微：[2, 8, 4, 6, 5]
*/
```

顺序：

0 放入宏队列，同步执行 1，2 放入微队列，6 缓存到内部，同步执行 7，8 放入微队列，取出微队列中的 2 执行，同步执行 3，4 放入微队列，5 缓存到内部，6 放入微队列(因为 6 的前一个 promise 已经执行完了返回成功结果 undefined)，取出微队列中的 8 执行，取出微队列中的 4 执行，5 放入微队列，取出微队列中的 6 执行，取出微队列中的 5 执行，取出宏队列中的 0 执行
