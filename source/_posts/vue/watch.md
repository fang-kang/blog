---
title: Vue 里的 computed 和 watch 的区别
date: 2020-10-10 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/2.png
tags:
  - vue
categories:
  - vue
---

## computed

> computed 是计算属性，它会根据你所依赖的数据动态显示新的计算结果

计算属性将被加入到 Vue 实例中。所有 getter 和 setter 的 this 上下文**自动地绑定为 Vue 实例**

通过计算出来的属性**不需要调用**直接可以在 DOM 里使用

### 基础例子

```js
var vm = new Vue({
  el: '#app',
  data: {
    message: 'hello',
  },
  template: `
  <div>
  <p>我是原始值: "{{ message }}"</p>
  <p>我是计算属性的值: "{{ computedMessage}}"</p> // computed 在 DOM 里直接使用不需要调用
  </div>
  `,
  computed: {
    // 计算属性的 getter
    computedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join('')
    },
  },
})
```

结果：

我是原始值: "Hello"
我是计算属性的值: "olleH"

如果不使用计算属性，那么 message.split('').reverse().join('') 就会直接写到 template 里，那么在模版中放入太多声明式的逻辑会让模板本身过重，尤其当在页面中使用大量复杂的逻辑表达式处理数据时，**会对页面的可维护性造成很大的影响**

**而且计算属性如果依赖不变的话，它就会变成缓存，computed 的值就不会重新计算**

所以，如果数据要通过复杂逻辑来得出结果，那么就推荐使用计算属性

## watch

> 一个对象，键是 data 对应的数据，值是对应的回调函数。值也可以是方法名，或者包含选项的对象，当 data 的数据发生变化时，就会发生一个回调，他有两个参数，一个 val （修改后的 data 数据），一个 oldVal（原来的 data 数据）
> Vue 实例将会在实例化时调用`$watch()`，遍历 watch 对象的每一个属性

### 基础例子

```js
new Vue({
  data: {
    n: 0,
    obj: {
      a: 'a',
    },
  },
  template: `
    <div>
      <button @click="n += 1">n+1</button>
      <button @click="obj.a += 'hi'">obj.a + 'hi'</button>
      <button @click="obj = {a:'a'}">obj = 新对象</button>
    </div>
  `,
  watch: {
    n() {
      console.log('n 变了')
    },
    obj: {
      handler: function (val, oldVal) {
        console.log('obj 变了')
      },
      deep: true, // 该属性设定在任何被侦听的对象的 property 改变时都要执行 handler 的回调，不论其被嵌套多深
    },
    'obj.a': {
      handler: function (val, oldVal) {
        console.log('obj.a 变了')
      },
      immediate: true, // 该属性设定该回调将会在侦听开始之后被立即调用
    },
  },
}).$mount('#app')
```

注意：**不应该使用箭头函数来定义 watcher 函数**，因为箭头函数没有 this，它的 this 会继承它的父级函数，但是它的父级函数是 window，导致箭头函数的 this 指向 window，而不是 Vue 实例

- **deep 控制是否要看这个对象里面的属性变化**
- **immediate 控制是否在第一次渲染是执行这个函数**

**vm.$watch()** 的用法和 watch 回调类似

- vm.$watch('data 属性名', fn, {deep: .., immediate: ..})

```js
vm.$watch(
  'n',
  function (val, newVal) {
    console.log('n 变了')
  },
  { deep: true, immediate: true }
)
```

## 总结

- 如果一个数据需要经过复杂计算就用 computed
- 如果一个数据需要被监听并且对数据做一些操作就用 watch
