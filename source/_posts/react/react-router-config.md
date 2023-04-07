---
title: react-router-config的使用
date: 2020-12-21 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/1.jpg
tags:
  - react
categories:
  - react
---

> 随着项目的增大，路由会越来越多，这就需要我们进行集中管理，我们可以自己写脚本，也可以使用`react-router-config`这个第三方库，这个库简化了配置`React-Router`，并且对路由实现集中管理，还能实现嵌套路由，下面我们看一下如何使用`react-router-config`。

`react-router-config`的使用包含如下三个步骤：

1. 按照规则配置静态路由文件，示例代码如下：

在`routes/index.jsx`中

```jsx
//eslint-disable-next-line
import React from 'react'

import Layout from '@/layouts'

import ServerError from '@/pages/500'
import NotFound from '@/pages/404'

const routes = [
  {
    component: Layout,
    routes: [
      {
        path: '/',
        component: React.lazy(() => import('@/pages/blog')),
        exact: true,
        key: 'home',
      },
      {
        path: '/about',
        component: React.lazy(() => import('@/pages/about')),
        key: 'about',
      },
      {
        path: '/blog/:id',
        component: React.lazy(() => import('@/pages/blog/show')),
        key: 'blog-show',
      },
      {
        path: '/tag',
        component: React.lazy(() => import('@/pages/tag')),
        key: 'tag',
      },
      {
        path: '/category',
        component: React.lazy(() => import('@/pages/category')),
        key: 'category',
      },
      {
        path: '/archive',
        component: React.lazy(() => import('@/pages/archive')),
        key: 'archive',
      },
      {
        path: '/error',
        component: ServerError,
        key: 'server-error',
      },
      {
        path: '*',
        component: NotFound,
        key: 'not-found',
      },
    ],
  },
]

export default routes
```

仔细阅读代码，我们发现配置文件本质就是一个数组，数组的每一项都有如下属性：`path`、`component`、`routes`、`render`，（注意：`render`和`component`只能使用一个）

这是最简单的配置。

如果你的路由存在嵌套路由，比方说`/admin`下面有`/admin/control`，那么就必须在有嵌套的路由下追加`routes`属性，`routes`也是一个数组，数组的每一项也是一个对象，对象具有`path`属性和`component`属性。有时根据需求需要跳转，可以配置`render`属性，`render`为一个函数，函数内返回一个重定向组件。

2. 从`react-router-config`中导入`renderRoutes`方法，将上面配置的数据传入此方法。

3. 将第二步的计算结果放到`Router`组件内部，代码如下：

```jsx
import { renderRoutes } from 'react-router-config'

import routes from './routes/'

function App() {
  return renderRoutes(routes)
}

export default App
```

4. 这里需要注意，如果使用了嵌套路由，就需要这一步，如果没有嵌套路由，则忽略这一步。那就是在使用了嵌套路由的组件中设置占位符，本质是按照`react-router`的规则配置路由，我们在`Layout`组件中使用了嵌套路由`Layout`的代码如下：

```jsx
import React, { Suspense } from 'react'
import { Spin } from 'antd'
import { renderRoutes } from 'react-router-config'

import Header from '@/components/header'
import Footer from '@/components/footer'

const Loading = () => {
  return (
    <div style={{ width: '100%', textAlign: 'center' }}>
      <Spin />
    </div>
  )
}

const BlogLayout = props => {
  return (
    <>
      <Header />
      <div className="blogs-body">
        <Suspense fallback={<Loading />}>{renderRoutes(props.route.routes)}</Suspense>
      </div>
      <Footer />
    </>
  )
}

export default BlogLayout
```

以上便是`react-router-config`的使用步骤，希望对你有所帮助。
