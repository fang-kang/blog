---
title: Vue.JS请求工具Axios的封装
date: 2020-11-13 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/6.png
tags:
 - vue
 - axios
categories:
  - vue
---

## 1.前期准备

创建一个`js`文件，命名自定。我这里定义为`request.js`

```javascript
import axios from 'axios'  //导入原生的axios 
import qs from 'qs';       //导入qs,做字符串的序列化，为了后面不同的场景使用。
import {
  MessageBox,
  Message
} from 'element-ui'            //引入element-ui的两个组件，分别是消息框和消息提示         
import store from '@/store'    //引入状态管理仓库
import router from '@/router'  //引入路由

import {
  getToken
} from '@/utils/auth'          //根据业务需求，这个方法是用来获取Token

```

## 2.创建实例

```javascript
// 创建一个axios实例
const service = axios.create({
  baseURL: 'XXXXXX',         // url = base url + request url
  withCredentials: true,    // 当跨域请求时发送cookie
  timeout: 15000           // 请求时间
})
```

## 3.请求拦截器

在发送请求之前做些什么

```javascript
service.interceptors.request.use(
  config => {
    if (store.getters.token) {
    // 让每个请求携带令牌——['Has-Token']作为自定义密钥。
    // 请根据实际情况修改。
    config.headers['Has-Token'] = getToken()
    }
    //在这里根据自己相关的需求做不同请求头的切换，我司是需要使用这两种请求头。
    if (config.json) {
      config.headers['Content-Type'] = 'application/json'
    } else {
      config.headers['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'
      config.data = qs.stringify(config.data);   //利用qs做json序列化
    }
    return config
  },
  error => {
    // 处理请求错误
    console.log(error) // 调试
    return Promise.reject(error)
  }
)
```

## 4.响应拦截器

在收到相应后做些什么

```javascript
service.interceptors.response.use(
  response => {
    const res = response.data    //这是响应返回后的结果
    //在这里可以根据返回的状态码对存在响应错误的请求做拦截，提前做处理。

    //以下为我司的处理规则
    // 如果自定义代码不是200，则判断为错误。
    if (res.code == 200 || res.code == 300) {
      // 重新登陆
      MessageBox.confirm('您的登录状态存在问题，您可以取消以停留在此页面，或再次登录', '系统提示', {
        confirmButtonText: '重新登录',
        type: 'warning'
      }).then(() => {
        store.dispatch('user/resetToken').then(() => {
          location.reload();
        })
      })
      return
    } else {
      if (res.code == 700) {
        Message.warning('您没有获取请求的权限！')
        router.replace({
          path: '/401'
        })
        return
      } else {
        return res
      }
    }
    //end
  },
  error => {
    console.log('err' + error)
    Message({
      message: error.message,
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

```

## 5.抛出实例

```javascript
export default service
```

## 6.如何调用

```javascript
import request from '@/utils/request'

export function getCity(data) {
  return request({
    url: '/getCity/findParentId',
    method: 'post',
    data
  })
}
```

## 7.完整代码

```javascript
import axios from 'axios'
import qs from 'qs';
import {
  MessageBox,
  Message
} from 'element-ui'
import store from '@/store'
import router from '@/router'
import {
  getToken
} from '@/utils/auth'

// 创建一个axios实例
const service = axios.create({
  baseURL: 'XXXXX', 
  withCredentials: true, 
  timeout: 15000 
})

service.interceptors.request.use(
  config => {
    if (store.getters.token) {
    // 让每个请求携带令牌——['Has-Token']作为自定义密钥。
    // 请根据实际情况修改。
    config.headers['Has-Token'] = getToken()
    }
    //在这里根据自己相关的需求做不同请求头的切换，我司是需要使用这两种请求头。
    if (config.json) {
      config.headers['Content-Type'] = 'application/json'
    } else {
      config.headers['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'
      config.data = qs.stringify(config.data);   //利用qs做json序列化
    }
    return config
  },
  error => {
    // 处理请求错误
    console.log(error) // 调试
    return Promise.reject(error)
  }
)
service.interceptors.response.use(
  response => {
    const res = response.data    //这是响应返回后的结果
    //在这里可以根据返回的状态码对存在响应错误的请求做拦截，提前做处理。

    //以下为我司的处理规则
    // 如果自定义代码不是200，则判断为错误。
    if (res.code == 200 || res.code == 300) {
      // 重新登陆
      MessageBox.confirm('您的登录状态存在问题，您可以取消以停留在此页面，或再次登录', '系统提示', {
        confirmButtonText: '重新登录',
        type: 'warning'
      }).then(() => {
        store.dispatch('user/resetToken').then(() => {
          location.reload();
        })
      })
      return
    } else {
      if (res.code == 700) {
        Message.warning('您没有获取请求的权限！')
        router.replace({
          path: '/401'
        })
        return
      } else {
        return res
      }
    }
    //end
  },
  error => {
    console.log('err' + error)
    Message({
      message: error.message,
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service
```

