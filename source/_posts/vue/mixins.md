---
title: mixins的基本使用
date: 2020-12-26 22:50:01
subSidebar: false
index_img: https://fang-kang.gitee.io/blog-img/1cm6iu.webp
tags:
  - vue
categories:
  - vue
---

## 一、来自官网的描述

`混入 (mixins)： 是一种分发 Vue 组件中可复用功能的非常灵活的方式。混入对象可以包含任意组件选项。当组件使用混入对象时，所有混入对象的选项将被混入该组件本身的选项`。

## 二、如何创建 Mixins？

在`src`目录下创建一个`mixins`文件夹，文件夹下新建一个`index.js`文件。前面我们说了`mixins`是一个`js`对象，所以应该以对象的形式来定义`index`，在对象中我们可以和`vue`组件一样来定义我们的`data`、`components`、`methods`、`created`、`computed`等属性，并通过`export`导出该对象

`mixins/index.js`

```js
export default {
  data() {
    return {
      test: '测试',
    }
  },
  created() {
    this.test()
  },
  methods: {
    test() {
      console.log(this.test)
    },
  },
}
```

`main.js`

- 全局引用

  ```js
  import mixins from 'mixins/index.js'
  Vue.mixmn(mixins)
  ```

- 局部引用

  ```js
  import mixins from 'mixins/index.js'
  export default {
    mixins: [mixins], //混入 mixins
    data() {
      return {}
    },
  }
  ```

## 三、项目中如何使用混入

在 vue 组件内，如果想将一些公共功能，如组件、方法、钩子函数等复用，混入是一个很好的选择。下面简单介绍一下混入的方式及特点。
你可以将一个对象作为混入的选项，在组件中复用。因为 vue 实例也是对象，所以你可以将`vue`实例作为混入选项传递进去。
我们可以创建一个目录`mixins`，在创建一个`comment.js`文件如图：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200922202240508.png#pic_center)

1. 定义混入对象
   `common.js`就是我们要混入其它组件的内容：

```javascript
export default {
  data() {
    return {
      msg: 'erwerwe',
      form: {
        a: 'aaa',
      },
    }
  },
  filters: {
    //过滤器
    numToString(value) {
      return value.toString()
    },
  },
  created() {
    //钩子函数
    console.log('这是混入的组件')
  },
  computed: {
    //计算属性
    ids() {
      return !this.loading
    },
  },
  methods: {
    exm() {
      console.log('这是混入的exm方法')
    },
    clickFn() {
      console.log(this.msg)
    },

    // 其它属性方法......
  },
}
```

1. 定义使用混入的组件
   `test.vue`组件用`mixins`把`common.js`内容混入当前组件

```js
<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <h1>{{ form.a }}</h1>
    <button @click="buttonClick">current</button>
  </div>
</template>

<script>
//导入js文件
import fun from './mixins/common.js'

export default {
  name: "HelloWorld",
  mixins:[fun],  //混入 fnu对象
  created(){
    console.log('这是当前组件')
  },
  data() {
    return {
      msg: "组件的msg"
    }
  },
  methods:{
    buttonClick(){
      console.log(this.form.a)
      console.log(this.msg)
      this.clickFn();
      this.exm();
    },
    exm(){
      console.log('这是组件的exm方法')
    }
  }
}
</script>
```

3.存在的问题：

混入的对象中的`msg`属性，和组件的`msg`属性冲突，以`组件的值优先。`组件中没有的属性，混入对象中的生效。

同名钩子函数将会合并成一个数组，`都会调用`，`混入函数先调用`

值为对象的选项，如`methods`，`components`，`directives`等，将会合并为一个新对象，如果键名冲突，`组件的值优先`

## 四、与 vuex 的区别

- `vuex`：用来做状态管理的，里面定义的变量在每个组件中均可以使用和修改，在任一组件中修改此变量的值之后，其他组件中此变量的值也会随之修改。

- `Mixins`：可以定义共用的变量，在每个组件中使用，引入组件中之后，各个变量是相互独立的，值的修改在组件中不会相互影响。

## 五、与公共组件的区别

> 组件：在父组件中引入组件，相当于在父组件中给出一片独立的空间供子组件使用，然后根据`props`来传值，但本质上两者是相对独立的。
>
> `Mixins`：则是在引入组件之后与组件中的对象和方法进行合并，相当于扩展了父组件的对象与方法，可以理解为形成了一个新的组件

## 六、与 vux 一起使用

有时候需要全局使用`store`里面的公用属性，每个页面单独引入比较麻烦，这个时候可以使用`mixins`来全局混入

`store/index.js`

```js
import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    name: '123',
  },
  mutations: {
    SET_Name(state, data) {
      state.name = data
    },
  },
  actions: {},
  modules: {},
})
```

`mixins/index.js`

```js
import { mapState } from 'vuex'
export default {
  data() {
    return {}
  },
  computed: {
    ...mapState(['name']),
  },
}
```

然后全局混入

```js
//main.js
import mixins from 'mixins/index.js'
Vue.mixmn(mixins)
```

此时所有页面都能使用`name`拿到`123`这个值
