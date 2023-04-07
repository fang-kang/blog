---
title: uniapp中前端如何和原生混合开发开发app
date: 2020-11-05 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/n7a9bv.webp
tags:
  - uniApp
categories:
  - uniApp
---

## uniapp 中前端如何和原生混合开发开发 app

{% note success %}

项目中遇到了一些类似于直播需要与原生进行混合开发的时候，前端应该怎么做？

{% endnote %}

<!-- more -->

1. 先引入`js`文件 `unfile.js`

[下载`unifile.js`的链接](http://www.cx521.cn/unfile.js)

或者可以复制以下`js`代码

```javascript
var bridge = {
  default: this,
  call: function (b, a, c) {
    var e = ''
    'function' == typeof a && ((c = a), (a = {}))
    a = {
      data: void 0 === a ? null : a,
    }
    if ('function' == typeof c) {
      var g = 'dscb' + window.dscb++
      window[g] = c
      a._dscbstub = g
    }
    a = JSON.stringify(a)
    if (window._dsbridge) e = _dsbridge.call(b, a)
    else if (window._dswk || -1 != navigator.userAgent.indexOf('_dsbridge')) e = prompt('_dsbridge=' + b, a)
    return JSON.parse(e || '{}').data
  },
  register: function (b, a, c) {
    c = c ? window._dsaf : window._dsf
    window._dsInit ||
      ((window._dsInit = !0),
      setTimeout(function () {
        bridge.call('_dsb.dsinit')
      }, 0))
    'object' == typeof a ? (c._obs[b] = a) : (c[b] = a)
  },
  registerAsyn: function (b, a) {
    this.register(b, a, !0)
  },
  hasNativeMethod: function (b, a) {
    return this.call('_dsb.hasNativeMethod', {
      name: b,
      type: a || 'all',
    })
  },
  disableJavascriptDialogBlock: function (b) {
    this.call('_dsb.disableJavascriptDialogBlock', {
      disable: !1 !== b,
    })
  },
}
!(function () {
  if (!window._dsf) {
    var b = {
        _dsf: {
          _obs: {},
        },
        _dsaf: {
          _obs: {},
        },
        dscb: 0,
        dsBridge: bridge,
        close: function () {
          bridge.call('_dsb.closePage')
        },
        _handleMessageFromNative: function (a) {
          var e = JSON.parse(a.data),
            b = {
              id: a.callbackId,
              complete: !0,
            },
            c = this._dsf[a.method],
            d = this._dsaf[a.method],
            h = function (a, c) {
              b.data = a.apply(c, e)
              bridge.call('_dsb.returnValue', b)
            },
            k = function (a, c) {
              e.push(function (a, c) {
                b.data = a
                b.complete = !1 !== c
                bridge.call('_dsb.returnValue', b)
              })
              a.apply(c, e)
            }
          if (c) h(c, this._dsf)
          else if (d) k(d, this._dsaf)
          else if (((c = a.method.split('.')), !(2 > c.length))) {
            a = c.pop()
            var c = c.join('.'),
              d = this._dsf._obs,
              d = d[c] || {},
              f = d[a]
            f && 'function' == typeof f
              ? h(f, d)
              : ((d = this._dsaf._obs), (d = d[c] || {}), (f = d[a]) && 'function' == typeof f && k(f, d))
          }
        },
      },
      a
    for (a in b) window[a] = b[a]
    bridge.register('_hasJavascriptMethod', function (a, b) {
      b = a.split('.')
      if (2 > b.length) return !(!_dsf[b] && !_dsaf[b])
      a = b.pop()
      b = b.join('.')
      return (b = _dsf._obs[b] || _dsaf._obs[b]) && !!b[a]
    })
  }
})()
module.exports = bridge
```

2. 放在 common/unfile.js'

3. 调用方法，在要使用原生技术的页面进行引入

```javascript
import bridge from '@/common/unfile.js'
```

4. 使用

```javascript

//调用的方法名字和回调的方法名字需要与原生相同
bridge.call('调用的方法名字',"传给原生的参数")

bridge.register('回调的方法名字',(result)=> {
 //原生给返回的数据
}）

```

{% note danger %}

注意

1. 原来是前端打包为`apk`或者`ipa`，现在打包为`h5`手机版让后端上传服务器给`ios`或者安卓链接，让安卓和`ios`进行打包

在 `manifest.json` 中 `h5配置`中设置 **路由模式** 和 **运行的基础路径** 例如: `hash` `/h5/`

2. 如果使用原生会有一些很多方法不能使用例如：前端写的微信登录，拉起相机，扫描二维码等都需要原生来做

3. 所以说尽量前端能做，不要与原生混合开发

{% endnote %}
