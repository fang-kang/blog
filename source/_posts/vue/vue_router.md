---
title: Vue解决同一页面跳转页面不更新
date: 2021-01-31 9:50
index_img: https://fang-kang.gitee.io/blog-img/2.png
tags:
 - vue
 - vurRouter
categories:
  - vue
---


## Vue解决同一页面跳转页面不更新

>问题分析：路由之间的切换，其实就是组件之间的切换，不是真正的页面切换。这也会导致一个问题，就是引用相同组件的时候，会导致该组件无法更新。

两个页面参数不同使用同一组件，默认情况下当这两个页面切换时并不会触发`created`或者`mounted`钩子。

### 方法一：通过watch $route的变化来做处理

```javascript
  watch: {
    $route(to, from) {
      console.log(to);
    },
  },
```

### 方法二：在 router-view上加上一个唯一的key，来保证路由切换时都会重新渲染触发钩子

```html
<router-view :key="key"></router-view>
```

```js
computed: {
    key() {
        return this.$route.name !== undefined? this.$route.name + +new Date(): this.$route + +new Date()
    }
 }
```

### 可能遇到的问题

跳转当前路由可能遇到如下错误

```javascript
message: "Navigating to current location (XXX) is not allowed"
```

此时在`src/router/index.js`里导入`router`的后面追加如下方法即可

```javascript
import VueRouter from 'vue-router'
...

// fix Navigating to current location
const originalPush = VueRouter.prototype.push
VueRouter.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}
```
