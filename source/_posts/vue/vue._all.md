---
title: Vue全家桶
date: 2020-12-10
sticky: 1
index_img: https://fang-kang.gitee.io/blog-img/1.png
tags:
  - vue
categories:
  - vue
---

## Vue 核心

### 一、Vue 的基本认识

渐进式 JavaScript 框架，用来动态构建用户界面

**特点**

1. 遵循 MVVM 模式
   1. 编码简洁，体积小，运行效率高，适合 移动/pc 端开发
   2. 它本身只关注 UI，可以轻松引入 vue 插件或其它第三方库开发项目

**与其他前端 JS 框架的关联**

1. 借鉴 angular 的模板 和 数据绑定技术
2. 借鉴 react 的组件化 和 虚拟 DOM 技术

**Vue 扩展插件**

1. vue-cli：vue 脚手架
2. vue-resource(axios)：ajax 请求
3. vue-router：路由
4. vuex：状态管理（它是 vue 的插件但是没有用 vue-xxx 的命名规则）
5. vue-lazyload：图片懒加载
6. vue-scroller：页面滑动相关
7. mint-ui：基于 vue 的 UI 组件库（移动端）
8. element-ui：基于 vue 的 UI 组件库（PC 端）

### 二、Vue 的基本使用

#### 编码

1. 引入 Vue.js

2. 创建 Vue 对象

   el：指定根 element (选择器)

   data：初始化数据(页面可以访问)

3. 双向数据绑定：v-model

4. 显示数据：{{xxx}}

5. 理解 vue 的 mvvm 实现

```vue
<!--template模板-->
<div id="test">
  <input type="text" v-model="msg"><br><!--指令-->
  <input type="text" v-model="msg"><!--指令-->
  <p>hello {{msg}}</p><!--大括号表达式-->
</div>

<script type="text/javascript" src="../js/vue.js"></script>
<script type="text/javascript">
const vm = new Vue({
  // 配置对象 options
  // 配置选项(option)
  el: "#test", // element: 指定用vue来管理页面中的哪个标签区域
  data: {
    msg: "atguigu",
  },
});
</script>
```

#### 理解 Vue 的 MVVM

![img](https://img-blog.csdnimg.cn/20200731102428901.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

MVVM --> model-view-viewModel

model：模型，数据对象（data）

view：视图，模板页面

viewModel：视图模型（vue 的实例）

MVVM 本质上是 MVC （Model-View- Controller）的改进版。即模型-视图-视图模型。

`模型`指的是后端传递的数据，`视图`指的是所看到的页面。

`视图模型`是 mvvm 模式的核心，它是连接 view 和 model 的桥梁。它有两个方向：

1. 将`模型`转化成`视图`，即**将后端传递的数据转化成所看到的页面**。实现的方式是：数据绑定。
2. 将`视图`转化成`模型`，即**将所看到的页面转化成后端的数据**。实现的方式是：DOM 事件监听。

这两个方向都实现的，我们称之为数据的**双向绑定**。

### 三、模板语法

**模板的理解**

1. 动态的 html 页面
2. 包含了一些 JS 语法代码：
   1. 双大括号表达式
   2. 指令（以 v- 开头的自定义标签属性）

**双大括号表达式**

1. 语法：{{exp}}
2. 功能：向页面输出数据
3. 可以调用对象的方法

**指令一：强制数据绑定**

功能：指定变化的属性值

完整写法：v-bind:xxx='yyy' //yyy 会作为表达式解析执行

简洁写法：:xxx='yyy'

**指令二：绑定事件监听**

功能：绑定指定事件名的回调函数

完整写法：v-on:keyup='xxx'，v-on:keyup='xxx(参数)'，v-on:keyup.enter='xxx'

简洁写法：@keyup='xxx'，@keyup.enter='xxx'

### 四、计算属性和监视

**计算属性**

1. 在 computed 属性对象中定义计算属性的方法
2. 在页面中使用 {{方法名}} 来显示计算的结果

**监视属性**

1. 通过 vm 对象的 `$watch()` 或 `watch 配置` 来监视指定的属性
2. 当属性变化时，回调函数自动调用，在函数内部进行计算

**计算属性高级**

1. 通过 getter/setter 实现对属性数据的计算读取 和 变化监视
2. 计算属性存在缓存，多次读取只执行一次 getter 计算

### 五、class 与 style 绑定

1. 在应用界面中, 某个(些)元素的样式是变化的
2. class/style 绑定就是专门用来实现动态样式效果的技术

**class 绑定**：`:class='xxx'`

1. 表达式是字符串: 'classA'
2. 表达式是对象: {classA:isA, classB: isB}
3. 表达式是数组: ['classA', 'classB']
   **style 绑定**：`:style="{ color: activeColor, fontSize: fontSize + 'px' }"`
   其中 activeColor/fontSize 是 data 属性

### 六、条件渲染条件渲染指令

1. v-if + v-else
2. v-show

如果需要频繁切换 v-show 较好。当条件不成立时, v-if 的所有子节点不会解析。

### 七、列表渲染

列表显示指令：

- 数组：v-for/index
- 对象：v-for/key

**列表的更新显示：**

1.删除 item：变更方法，顾名思义，会变更调用了这些方法的原始数组。

```js
// 两种更新方式
this.persons[index] = newP;
// 这样只更新persons中的某一个数据，vue根本就不知道，视图不会更新
this.persons.splice(index, 1, newP);
// splice方法被 Vue 将进行了包裹，所以也将会触发视图更新。
```

这些被包裹过的方法包括：

- `push()`
- `pop()`
- `shift()`
- `unshift()`
- `splice()`
- `sort()`
- `reverse()`

  2.替换 item：相比之下，也有非变更方法，例如 `filter()`、`concat()` 和 `slice()`。它们不会变更原始数组，而**总是返回一个新数组**。当使用非变更方法时，可以用新数组替换旧数组。

```js
let fpersons = persons.filter((p) => p.name.includes(searchName));
```

**列表的高级处理：**
列表过滤

列表排序

```js
fpersons.sort(function (p1, p2) {
  if (orderType === 1) {
    // 降序
    return p2.age - p1.age;
  } else {
    // 升序
    return p1.age - p2.age;
  }
});
```

### 八、事件处理

#### 绑定监听

1. v-on:xxx="fun"
2. @xxx="fun"
3. @xxx="fun(参数)"
4. 默认事件形参: event， 隐含属性对象:

`$event` 就是当前触发事件的元素，即使不传 `$event`，在回调函数中也可以使用 event 这个参数。

#### 事件修饰符

事件修饰符用来控制事件的冒泡和默认行为。

1. .prevent : 阻止事件的默认行为 event.preventDefault()
2. .stop : 停止事件冒泡 event.stopPropagation()

```html
<!-- 阻止事件冒泡 -->
<div id="big" @click="test">
  <div id="small" @click.stop="test2"></div>
</div>

<!-- 提交事件不再重载页面 -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 点击事件将只会触发一次 -->
<a v-on:click.once="doThis"></a>
```

#### 按键修饰符

1. .keycode : 操作的是某个 keycode 值的键
2. .keyName : 操作的某个按键名的键(少部分)

```html
<!-- 任何按键按下都会触发回调函数 -->
<textarea @keyup="testKeyup"></textarea>

<!-- 下面的两种写法效果是一致的 -->
<!-- 使用按键码，回车键的keyCode是13 -->
<textarea @keyup.13="testKeyup"></textarea>
<!-- 使用按键修饰符，因为回车键比较常用，所以vue为他设置了名称，可以直接使用enter来代替 -->
<textarea @keyup.enter="testKeyup"></textarea>
```

### 九、表单输入绑定

使用 v-model 对表单数据自动收集

1. text/textarea
2. checkbox
3. radio
4. select

### 十、vue 实例生命周期

**生命周期流程图**

![img](https://img-blog.csdnimg.cn/2020073110243019.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

**vue 生命周期分析**

1. 初始化显示
   - beforeCreate()
   - created()
   - beforeMount()
   - mounted()
2. 更新显示：this.xxx = value
   - beforeUpdate()
   - updated()
3. 销毁 vue 实例：vm.$destroy()
   - beforeDestory()
   - destoryed()

**常用的生命周期方法**

1. created()/mounted()：发送 ajax 请求，启动定时器等异步任务
2. beforeDestroy()：做收尾工作，如：清除定时器

### 十一、过渡&动画

**vue 动画的理解**

1. 操作 css 的 transition 或 animation

2. vue 会给目标元素添加/移除特定的 class

3. 过渡的相关类名

   xxx-enter-active：指定显示的 transition

   xxx-leave-active：指定隐藏的 transition

   xxx-enter/xxx-leave-to：指定隐藏时的样式

![img](https://img-blog.csdnimg.cn/20200731102427934.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

**基本过渡动画的编码**

1. 在目标元素外包裹`<transition name="xxx">`

2. 定义 class 样式

   指定过渡样式：transition

   指定隐藏时的样式：opacity/其它

### 十二、过滤器

**理解过滤器**

1. 功能: 对要显示的数据进行特定格式化后再显示

2. 注意: 并没有改变原本的数据, 可是产生新的对应的数据

**定义和使用过滤器**

定义过滤器：

```js
Vue.filter(filterName, function(value[,arg1,arg2,...]){
    // 进行一定的数据处理
    return newValue
})
```

使用过滤器 ：

```html
<div>{{myData | filterName}}</div>

<div>{{myData | filterName(arg)}}</div>
```

其中，myData 会作为 value 传入 filter 中。

### 十三、内置指令与自定义指令

#### 常用内置指令

1. v-text : 更新元素的 textContent

2. v-html : 更新元素的 innerHTML

3. v-if : 如果为 true, 当前标签才会输出到页面

4. v-else: 如果为 false, 当前标签才会输出到页面

5. v-show : 通过控制 display 样式来控制显示/隐藏

6. v-for : 遍历数组/对象

7. v-on : 绑定事件监听, 一般简写为@

8. v-bind : 强制绑定解析表达式, 可以省略 v-bind

9. v-model : 双向数据绑定

10. ref : 指定唯一标识, vue 对象通过$els 属性访问这个元素对象

11. v-cloak : 防止闪现, 与 css 配合: [v-cloak] { display: none }

#### 自定义指令

el：指令所在的标签对象

binding：包含指令相关数据的容器对象

1. 注册全局指令 ：

```js
Vue.directive("my-directive", function (el, binding) {
  el.innerHTML = binding.value.toupperCase();
});
```

2. 注册局部指令 ：

```js
directives: {
    'my-directive'(el, binding) {
        el.innerHTML = binding.value.toupperCase()
    }
}
```

3. 使用指令 ：v-my-directive='xxx'

（binding.value 就是 xxx 的值）

### 十四、自定义插件

**说明**

1. Vue 插件是一个包含 install 方法的对象

2. 通过 install 方法给 Vue 或 Vue 实例添加方法，定义全局指令等

### 其他 API

#### vm.$nextTick([callback])

**用法**：将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新。它跟全局方法 `Vue.nextTick` 一样，不同的是回调的 `this` 自动绑定到调用它的实例上。

**用途**：需要在视图更新之后，基于新的视图进行操作。

```js
//改变数据
vm.message = "changed";

//想要立即使用更新后的DOM。这样不行，因为设置message后DOM还没有更新
console.log(vm.$el.textContent); // 并不会得到'changed'

//这样可以，nextTick里面的代码会在DOM更新后执行
Vue.nextTick(function () {
  console.log(vm.$el.textContent); //可以得到'changed'
});
```

## vue 组件化编码

### 组件间通信

**组件间通信基本原则**

1. 不要在子组件中直接修改父组件的状态数据
2. 数据在哪，更新数据的行为(函数)就应该定义在哪

#### vue 组件间通信方式

1. props
2. vue 的自定义事件
3. 消息订阅与发布(如: pubsub.js 库)
4. slot
5. vuex

##### props

使用组件标签时：

```vue
<my-component name="tom" :age="3" :set-name="setName"></my-component>
```

定义 MyComponent 时：

1.在组件内声明所有的 props：

```js
// 方式一：只指定名称
props: ['name', 'age', 'setName']
// 方式二：指定名称和类型
props: {
    name: String,
    age: Number,
    setNmae: Function
}
// 方式三：指定名称/类型/必要性/默认值
props: {
    name: {type: String, required: true, default:xxx},
}
```

注意

1. 此方式用于父组件向子组件传递数据
2. 所有标签属性都会成为组件对象的属性，模板页面可以直接引用
3. 问题:
   a. 如果需要向非子后代传递数据必须多层逐层传递
   b. 兄弟组件间也不能直接 props 通信，必须借助父组件才可以

##### vue 自定义事件

绑定事件监听（绑定在父组件中）

```vue
// 方式一: 通过v-on 绑定 @delete_todo="deleteTodo" // 方式二: 通过$on()
<TodoHeader ref="header" />
mounted () { this.$refs.header.$on('delete_todo', this.deleteTodo) }
```

触发事件（写在子组件中）

```js
// 触发事件(只能在父组件中接收)
this.$emit("delete_todo", data);
```

注意

1. 此方式只用于子组件向父组件发送消息(数据)
2. 问题：隔代组件或兄弟组件间通信此种方式不合适

##### 消息订阅与发布(PubSubJS 库)

订阅消息

```js
PubSub.subscribe('msg', function(msg, data){
  ...
})
```

发布消息

```js
PubSub.publish("msg", data);
```

注意

1. 优点：此方式可实现任意关系组件间通信(数据)

##### 事件的 2 个重要操作(总结)

1. 绑定事件监听(订阅消息)
   目标：标签元素`<button>`
   事件名(类型)：click/focus
   回调函数：function(event){}
2. 触发事件(发布消息)
   DOM 事件：用户在浏览器上对应的界面上做对应的操作
   自定义：编码手动触发

##### slot

此方式用于父组件向子组件传递`标签数据`

子组件: Child.vue

```vue
<template>
  <div>
    <slot name="xxx">不确定的标签结构1</slot>
    <div>组件确定的标签结构</div>
    <slot name="yyy">不确定的标签结构2</slot>
  </div>
</template>
```

父组件: Parent.vue

```vue
<child>
    <div slot="xxx">xxx 对应的标签结构</div>
    <div slot="yyy">yyyy 对应的标签结构</div>
</child>
```

### axios

**为脚手架添加 axios 模块**

1.本地安装 axios 模块:

`npm i -save axios`

2.在脚手架项目源代码的 src/main.js 中，new Vue() 前引入 axios 模块

`import axios from "axios"` // node_modules 中安装的模块，引入时都不用加路径

3.设置 axios 对象的基础路径属性：

`axios.defaults.baseURL="http://服务器端域名"`

4.将 axios 对象放入 Vue 的原型对象中

`Vue.prototype.axios = axios;`

5.结果：因为所有组件对象都是 Vue 类型的子对象，所以在所有组件内，任何位置都可用 `this.$axios.get()` 和 `this.$axios.post()` 访问 Vue.prototype 中的 axios 对象里的函数。

```js
// 发送 ajax 请求
this.$axios
  .get("/index")
  .then((response) => {
    console.log(response.data); // 得到返回结果数据
  })
  .catch((error) => {
    console.log(error.message);
  });
let data = {
  pagenum: 1,
};
this.$axios
  .post("/users/signin", data)
  .then((res) => {
    console.log(res.data);
  })
  .catch((err) => {
    console.log(err.message);
  });
```

### render 配置

在 main.js 文件中

```js
// 原始写法
new Vue({
  el: "#app",
  components: {
    // 将App.vue映射成标签
    APP,
  },
  template: "<App/>", // 将App标签转化成模板
});
// 更简洁的写法
new Vue({
  el: "#app",
  render: (h) => h(App),
});
```

render 是一个渲染函数，h => h(App) 是一个箭头函数，其参数 h 是一个函数，这个函数执行接收一个参数 App 组件。

h(App) 执行后返回的结果就是 render 的值。

也就是：

```js
new Vue({
  el: "#app",
  render: function (createElement) {
    // h就是createElement，用来创建元素标签
    return createElement(App); // <App/>
  },
});
// 其中App标签被插入到el中
```

## vue-router

官方提供的用来实现 SPA 的 vue 插件。

### 相关 API 说明

1.注册路由器（在 main.js）

```js
import Vue from "vue";
import router from "./router";
// 创建vue 配置路由器
new Vue({
  el: "#app",
  router,
  render: (h) => h(app),
});
```

2.路由器配置：（在 router 目录下 index.js）

```js
import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);
```

3.路由配置：

```js
const routes = [
  {
    path: "/home",
    component: home,
    // 嵌套路由
    children: [
      {
        path: "news",
        component: News,
      },
      {
        path: "message",
        component: Message,
      },
    ],
  },
  {
    // 一般路由
    path: "about",
    component: About,
  },
  {
    // 自动跳转路由
    path: "/",
    redirect: "/about",
  },
];
```

3.VueRouter()：用于创建路由器的构建函数

```js
const router = new VueRouter({
  mode: "history", // 模式
  base: process.env.BASE_URL,
  routes,
});

export default router;
```

4.使用路由组件标签

- `<router-link>`：用来生成路由链接

  `<router-link to="/home/news">News</router-link>`

- `<router-view>`：用来显示当前路由组件界面

  `<router-view></router-view>`

### 向路由组件传递数据

#### 方式 1: 路由路径携带参数(param/query)

1. 配置路由

```js
children: [
  {
    path: "mdetail/:id",
    component: MessageDetail,
  },
];
```

2. 路由路径

```vue
<router-link :to="'/home/message/mdetail/' + m.id">{{m.title}}</router-link>
```

3. 路由组件中读取请求参数
   `this.$route.params.id`

#### 方式 2: `<router-view>`属性携带数据

```vue
<router-view :msg="msg"></router-view>
```

### 缓存路由组件对象

1. 默认情况下，被切换的路由组件对象会死亡释放，再次回来时是重新创建的（原来的数据就没有了）
2. 如果可以缓存路由组件对象，可以提高用户体验

```vue
<keep-alive>
    <router-view></router-view>
</keep-alive>
```

### 两种模式的区别

前后端分离 ===> 利用 Ajax，可以在**不刷新浏览器**的情况下异步数据请求交互。

**单页应用（**只有一个 html 文件，整个网站的所有内容都在这一个 html 里，通过 js 来处理**）**不仅仅是在**页面交互**是无刷新的，连**页面跳转**都是无刷新的。为了实现单页应用 ==> 前后端分离 + 前端路由。（更新视图但不重新请求页面）

前端路由实现起来其实也很简单，就是**匹配不同的 url 路径**，进行解析，加载不同的组件，然后动态的渲染出区域 html 内容。

vue-router 默认 hash 模式，还有一种是 history 模式。

#### hash 模式

只能改变 # 后面的 url 片段即 hash 值。hash 值的变化，并**不会导致浏览器向服务器发出请求**，浏览器不发出请求，也就不会刷新页面。每次 hash 值的变化，会**触发** `hashchange` 这个事件，通过这个事件我们就可以知道 hash 值发生了哪些变化。然后我们便可以**监听 `hashchange` 来实现更新页面部分内容的操作**：

hash 模式的工作原理是 hashchange 事件，可以在 window 监听 hash 的变化。

```vue
<div id="test" style="height: 500px;width: 500px;margin: 0 auto"></div>

<script>
window.onhashchange = function (event) {
  console.log(event); // HashChangeEvent {..., newURL: "...test.html#red", oldURL: "...test.html", ...}
  console.log(location); // location {..., hash: "#red", ...}
  let hash = location.hash.slice(1); // red
  document.body.style.color = hash;
  document.getElementById("test").style.backgroundColor = hash;
};
</script>
```

在 url 后面随便添加一个 #xx 会触发 onhashchange 事件。打印 event，里边有两个属 性 newURL 和 oldURL。可以通过模拟改变 hash 的值，动态改变页面数据。

##### 相关 API

HashHistory 的方法

1. `this.$router.push(path)`：相当于点击路由链接(可以返回到当前路由界面)

![img](https://img-blog.csdnimg.cn/20200731102427668.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

2. `this.$router.replace(path)`：用新路由替换当前路由(不可以返回到当前路由界面)

![img](https://img-blog.csdnimg.cn/20200731102427671.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

3)`this.$router.back()`：请求(返回)上一个记录路由 4) `this.$router.go(-1)`：请求(返回)上一个记录路由 5) `this.$router.go(1)`：请求下一个记录路由

因为 hash 发生变化的 url 都会被浏览器记录（历史访问栈）下来，从而你会发现浏览器的**前进后退**都可以用了。尽管浏览器没有请求服务器，但是页面状态和 url 已经关联起来了，这就是所谓的前端路由，单页应用的标配。

#### history 模式

前面的 hashchange，只能改变 # 后面的 url 片段，而 history api 则给了前端完全的自由。

通过 history api，我们丢掉了丑陋的 #，但是它也有个毛病：

不怕前进，不怕后退，就怕**f5 刷新**，刷新是实实在在地去请求服务器的。在 hash 模式下，前端路由修改的是 # 中的信息，而浏览器请求时是跟它无关的，所以没有问题。

但是在 history 下，你可以自由的修改 path，当刷新时，如果服务器中没有相应的响应或者资源，会刷出 404 来。

##### 相关 API

多了两个 API，`pushState()` 和 `replaceState()。`通过这两个 API：

1）可以改变 url 地址且不会发送请求

2）不仅可以读取历史记录栈，还可以对**浏览器历史记录栈进行修改。**

```js
window.history.pushState(stateObject, title, URL);
window.history.replaceState(stateObject, title, URL);
history.go(-2); //后退两次
history.go(2); //前进两次
history.back(); //后退
hsitory.forward(); //前进
```

#### 区别

- 前面的 hashchange，你只能改变 # 后面的 url 片段。而 pushState 设置的新 URL 可以是与当前 URL 同源的任意 URL。
- history 模式则会将 URL 修改得就和正常请求后端的 URL 一样，如后端没有配置对应 /user/id 的路由处理，则会返回 404 错误

### `$router`与`$route`的区别

1. `$route`是一个跳转的路由对象，每一个路由都会有一个 route 对象，是一个局部的对象。可以获取对应的 name、path、query、params 等（`<router-link>`传的参数由 `this.$route.query`或者 `this.$route.params` 接收）
2. `$router`为通过 Vue.use(VueRouter) 和 VueRouter 构造函数得到的一个 router 的实例对象，这个对象是一个全局的对象。想要导航到不同 URL，则使用`$router.push`方法；返回上一个 history 也是使用`$router.go`方法

### 总结: 编写使用路由的 3 步

1. 定义路由组件
2. 注册路由
3. 使用路由
   `<router-link>`
   `<router-view>`

## vuex

**vuex 是什么**：对 vue 应用中多个组件的共享状态进行集中式的管理（读/写）

**状态自管理应用**：

1. state：驱动应用的数据源
2. view：以声明方式将 state 映射到视图
3. actions：响应在 view 上的用户输入导致的状态变化（包含 n 个更新状态的方法）

**多组件共享状态的问题**：

1. 多个视图依赖于同一状态
2. 来自不同视图的行为需要变更同一状态

以前的解决办法：

- 将数据以及操作数据的行为都定义在父组件
- 将数据以及操作数据的行为传递给需要的各个子组件（有可能需要多级传递）

vuex 就是用来解决这个问题的。

### vuex 核心概念和 API

#### state

vuex 管理的状态对象。它应该是唯一的：

```js
const state = {
  xxx: initValue,
};
```

#### getters

包含多个计算属性（get）的对象

由谁读取：组件中 `$store.getters.xxx`

```js
const getters = {
  nnn(state) {
    return ...
  }
  mmm(state, getters) {
    return getters.nnn...
    //注意：引入getters时，必须放在第二位，因为第一位默认是state
  }
}
```

#### actions

包含多个**事件回调函数**的对象。通过执行 `commit()` 来触发 mutation 的调用，**间接更新** state。

由谁触发：组件中 `$store.dispatch('action 名称', data1)` // 'zzz'

可以包含异步代码（定时器，ajax）

```js
const actions = {
  zzz({ commit, state }, data1) {
    commit("yyy", { data1 }); // 传递数据必须用大括号包裹住
  },
};
```

#### mutations

包含多个**直接更新** state 的方法（回调函数）的对象。

由谁触发：action 中的 `commit('mutation 名称')` 来触发。

只能包含同步的代码，不能写异步代码。

```js
const mutations = {
  yyy(state, { data1 }) {
    // 传递数据必须用大括号包裹住
    // 更新 state 的某个属性
  },
};
```

#### modules

包含多个 module。一个 module 是一个 store 的配置对象，与一个组件（包含有共享数据）对应

#### 核心模块 store 对象

index.js 固定写法：

```js
import Vue from "vue";
import Vuex from "vuex";
import state from "./state";
import mutations from "./mutations";
import actions from "./actions";
import getters from "./getters";

Vue.use(Vuex);

export default new Vuex.store({
  state,
  mutations,
  actions,
  getters,
});
```

##### 组件中

```js
{{xxx}} {{mmm}} @click="zzz(data)"

import {mapState. mapGetters, mapActions} from 'vuex'
export default{
  computed: {
    ...mapState(['xxx']), //相当于 this.$store.state.xxx
    ...mapGetters(['mmm']), //相当于 this.$store.getters['mmm']
  },
  methods: {
    ...mapActions(['zzz']) //相当于 this.$store.dispatch('zzz')
  }
}
```

##### 映射 store

在 main.js 中

```js
import store from "./store";

new Vue({
  store,
});
```

##### store 对象

1.所有用 vuex 管理的组件中都多了一个属性 $store，它就是一个 store 对象

2.属性：

state：注册的 state 对象

getters：注册的 getters 对象

3.方法：

dispatch(actionName, data)：分发调用 action

### Vuex 结构分析

![img](https://img-blog.csdnimg.cn/20200731102430351.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

## vue 源码分析

分析 vue 作为一个 MVVM 框架的基本实现原理

### 数据代理

数据代理：通过一个对象代理对另一个对象(在前一个对象内部)中属性的操作(读/写)

vue 数据代理：data 对象的所有属性的操作(读/写)由 vm 对象来代理操作

好处：通过 vm 对象就可以方便的操作 data 中的数据

基本实现流程：

1. 通过 Object.defineProperty() 给 vm 添加与 data 对象的属性对应的属性描述符
2. 所有添加的属性都包含 getter/setter
3. getter/setter 内部去操作 data 中对应的属性数据

### 模板解析

#### 模板解析的基本流程

1. 将 el 的所有**子节点取出**，添加到一个新建的文档 fragment 对象中

2. 对 fragment 中的**所有层次**子节点递归进行编译解析处理

- 对大括号表达式文本节点进行解析
- 对元素节点的指令属性进行解析
  - 事件指令解析
  - 一般指令解析

3. 将解析后的 fragment 添加到 el 中显示

#### 大括号表达式解析

1. 根据**正则**对象得到**匹配**出的表达式字符串：子匹配/RegExp.$1 name
2. 从 data 中**取出**表达式对应的**属性值**
3. 将属性值**设置**为文本节点的 **textContent**

#### 事件指令解析

1. 从指令名中**取出事件名**
2. 根据指令的值（表达式）从 methods 中得到**对应的事件处理函数对象**
3. 给当前元素节点**绑定**指定事件名和回调函数的 dom **事件监听**
4. 指令解析完后，**移除**此指令属性

#### 一般指令解析

1. 得到**指令名和指令值**（表达式） text/html/class msg/myClass

2. 从 **data 中**根据表达式得到**对应的值**

3. 根据指令名**确定需要操作元素节点的什么属性**

- v-text---textContent 属性
- v-html---innerHTML 属性
- v-class--className 属性

4. 将得到的表达式的值**设置到对应的属性上**

5. **移除**元素的指令属性

### 数据绑定

**数据绑定**

一旦更新了 data 中的某个属性数据，所有界面上直接使用或间接使用了此属性的节点都会更新。

**数据劫持**

1. 数据劫持是 vue 中用来实现数据绑定的一种技术
2. 基本思想：通过 defineProperty() 来监视 data 中所有属性(任意层次)数据的变化, 一旦变化就去更新界面

#### 四个重要对象

实现数据的绑定，首先要对数据进行劫持监听，所以我们需要设置一个监听器 Observer，用来监听所有属性。

如果属性发生变化了，就需要告诉订阅者 Watcher 看是否需要更新。因为订阅者是有很多个，所以我们需要有一个消息订阅器 Dep 来专门收集这些订阅者，然后在监听器 Observer 和订阅 Watcher 之间进行统一管理。

接着，我们还需要有一个指令解析器 Compile，对每个节点元素进行扫描和解析，将相关指令对应初始化成一个订阅者 Watcher，并替换模板数据或者绑定相应的函数。此时当订阅者 Watcher 接收到相应属性的变化，就会执行对应的更新函数，从而更新视图。

##### Observer（监听器）

1.用来对 data 所有属性数据进行劫持的构造函数

2.给 data 中所有属性重新定义属性描述(get/set)

3.为 data 中的每个属性创建对应的 dep 对象

##### Dep(Depend)

1.data 中的每个属性(所有层次)都对应一个 dep 对象

2.创建的时机:

- 在初始化 define data 中各个属性时创建对应的 dep 对象
- 在 data 中的某个属性值被设置为新的对象时

  3.对象的结构

```js
function Dep() {
  // 标识属性
  this.id = uid++; // 每个dep都有一个唯一的id
  // 相关的所有watcher的数组
  this.subs = []; //包含n个对应watcher的数组(subscribes的简写)
}

{
  (this.id = uid++), (this.subs = []);
}
```

4.subs 属性说明

- 当 `watcher`被创建时，内部将当前 `watcher`对象添加到对应的 `dep`对象的`subs`中
- 当此 `data`属性的值发生改变时，`subs`中所有的 `watcher`都会收到更新的通知，从而最终更新对应的界面

##### Compiler（指令解析器）

1. 用来解析模板页面的对象的构造函数（一个实例）
2. 利用 `compile`对象解析模板页面
3. 每解析一个表达式（非事件指令，如`{{}}`或`v-text`，`v-html`）都会创建一个对应的 `watcher`对象，并建立 `watcher`与 `dep`的关系
4. `complie` 与 `watcher`关系：一对多的关系

##### Watcher（订阅者）

1.模板中每个非事件指令或表达式都对应一个 watcher 对象

2.监视当前表达式数据的变化

3.创建的时机：在初始化编译模板时（compiler 中）

4.对象的组成

```js
function Watcher(vm, exp, cb) {
  this.vm = vm; // vm 对象
  this.exp = exp; // 对应指令的表达式
  this.cb = cb; // 当表达式所对应的数据发生改变的回调函数
  this.value = this.get(); // 表达式当前的值
  this.depIds = {};
  // 表达式中各级属性所对应的dep对象的集合对象
  // 属性名为dep的id, 属性值为dep
}
```

##### 总结：dep 与 watcher 的关系 --> 多对多

1. data 中的一个属性对应一个 dep，一个 dep 中可能包含多个 watcher（模板中有几个表达式使用到了同一个属性）
2. 模板中一个非事件表达式对应一个 watcher，一个 watcher 中可能包含多个 dep（表达式是多层：a.b.c）
3. 数据绑定使用到 2 个核心技术
   - defineProperty()
   - 消息订阅与发布

#### MVVM 原理图分析

![img](https://img-blog.csdnimg.cn/20200731102429847.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

MVVM 中会创建 Observer（用来劫持/监听所有属性）和 Compile（解析指令/大括号表达式），

**Observer**：要劫持就需要对应的 set()方法，所以在 observer 中为每一个属性创建了一个 dep 对象（与 data 中的属性一一对应）

**Compile**：（做了两件事）

1.目的是初始化视图（显示界面），调用 updater（有很多更新节点的方法）

2.为表达式创建对应的 Watcher ，同时指定了更新节点的函数

**Watcher 和 Dep 建立关系**：

1.watcher 放到 dep 中（添加订阅者）

dep 中有一个 subs，是用来保存 n 个 watcher 的数组容器

2.dep 放到 watcher 中

watcher 中的 depIds 是用来保存 n 个 dep 的对象容器。为了判断 dep 与 watcher 的关系是否已经建立（防止重复的建立关系）

**以上都是初始化阶段会经历的过程**

**更新阶段：**

vm.name = 'Tom' 导致 data 中的数据变化，会触发监视 data 属性的 observer 中的 set() 方法，然会它又会通知 dep，dep 会去通知它保存的所有相关的 watcher，watcher 收到信息后，其回调函数会去调用 updater 更新界面

如下图所示：（黑线是初始化阶段，红线是更新阶段）

![img](https://img-blog.csdnimg.cn/20200731102430723.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQwNTA4ODMy,size_16,color_FFFFFF,t_70)

### 双向数据绑定

1. 双向数据绑定是建立在单向数据绑定(model==>View)的基础之上的
2. 双向数据绑定的实现流程:
   a. 在解析 v-model 指令时，给当前元素添加 input 监听
   b. 当 input 的 value 发生改变时，将最新的值赋值给当前表达式所对应的 data 属性
