---
title: 按需引入ElementUI 和 AntD
date: 2020-11-21 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/9.jpg
tags:
  - vue
categories:
  - vue
---

## vue 按需引入 Element UI 的方法

> 在我们的实际项目开发中，多数是采用按需引入的模式来进行开发的，那么具体应该如何操作呢，可能会有许多新人傻傻分不清楚，具体将在下文讲到。

1. 按需引入

借助 `babel-plugin-component`，我们可以只引入需要的组件，以达到减小项目体积的目的：

```bash
npm install babel-plugin-component -D
```

<!-- more -->

2. 更改.babelrc 文件

配置 babel，修改 babel.config.js/.babelrc 文件

```js
module.exports = {
  presets: ['@vue/cli-plugin-babel/preset'],
  plugins: [
    [
      'component',
      {
        libraryName: 'element-ui',
        styleLibraryName: 'theme-chalk',
      },
    ],
  ],
}
```

3. 第三步

1. 在 `src` 文件夹中新建我们的 `element` 文件夹，并在里面新建一个 `index.js` 文件
1. 在`index`文件中去书写我们需要引入的部分组件
1. 在 `main.js` 中使用该文件，就大功告成了

```js
// element/index.js
import { Button, Select, Switch, MessageBox, Message } from 'element-ui'
const element = {
  install: function (Vue) {
    Vue.use(Button)
    Vue.use(Switch)
    Vue.use(Select)
    Vue.prototype.$msgbox = MessageBox
    Vue.prototype.$alert = MessageBox.alert
    Vue.prototype.$confirm = MessageBox.confirm
    Vue.prototype.$message = Message
  },
}
export default element
```

```js
// main.js
import element from './element/index'
Vue.use(element)
```

## vue 按需引入 Antd-vue 的方法

1. 从 `yarn` 或 `npm` 安装并引入 `ant-design-vue`

```bash
//npm
 npm install ant-design-vue --save
//yarn
 yarn add ant-design-vue
```

2. 开始配置按需引入配置

`babel-plugin-import`是一个用于按需加载组件代码和样式的 `babel` 插件，如果需要样式自动加载那么要先装这个插件

```bash
npm install babel-plugin-import --dev
```

安装完后需要配置`babel.plugin.config`文件
这里要注意 `style：true`会报错 ，把`true`换成`css`

```js
module.exports = {
  presets: ['@vue/cli-plugin-babel/preset'],
  plugins: [['import', { libraryName: 'ant-design-vue', libraryDirectory: 'es', style: 'css' }]],
}
```

3. 新建一个文件，把需要的组件引入进来

```js
//main.js
import { Button } from 'ant-design-vue'
Vue.use(Button)
```
