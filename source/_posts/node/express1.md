---
title: node express基本使用
date: 2020-12-23 16:20
index_img: https://fang-kang.gitee.io/blog-img/1.png
tags:
 - node
 - express
categories:
  - node
---


# node express基本使用

这里 用的`express 5` 请注意

## 1.创建一个新的[路由器](http://expressjs.com/en/5x/api.html#router)对象。

```js
const router = express.Router([options])
mergeParams  // 保留来自父路由器的req.params值。如果父对象和子对象具有冲突的参数名，则以子对象的值为准。
caseSensitive //     启用区分大小写。 默认情况下禁用，将“ / Foo”和“ / foo”视为相同。
strict // 启用严格路由。 默认情况下禁用，路由器将“ / foo”和“ / foo /”视为相同。

路由规则是app.use(path,router)定义的，router代表一个由express.Router()创建的对象，在路由对象中可定义多个路由规则。可是如果我们的路由只有一条规则时，可直接接一个回调作为简写，也可直接使用app.get或app.post方法。即
当一个路径有多个匹配规则时，使用app.use（）

// 很麻烦这样写
app.get("/home",callback)
app.get("/home/one",callback)
app.get("/home/second",callback)

// 可以创建一个router.js 专门用来一个路由匹配多个子路由
var router = express.Router()
router.get("/",(req,res)=>{
    res.send("/")
})
router.get("/one",(req,res)=>{
    res.send("one")
})
router.get("/second",(req,res)=>{
    res.send("second")
})
module.exports = router;

// 在app.js中导入router.js
var express = require('express')
var router = require("./router")
var app = express()
app.use('/home',router) //router路由对象中的路由都会匹配到"/home"路由后面
```

## 2.app.use用法

```js
app.use(path,callback)中的callback既可以是router对象又可以是函数
app.get(path,callback)中的callback只能是函数

// 中间件也可以使用多级 callback   anth()中要调用next（） 否则不会往下走 
// callback中定义的const let 在下一个callback中是无法访问的 要挂载到 req 或者 res 中
app.use('/admin/api/rest/:resourse', anth(), (req, res, next) => {
  const MODEL_NAME = require('inflection').classify(req.params.resourse)
  // const model = require(`../../models/${MODEL_NAME}`);
  // 为什么不使用 const   router 会访问不到model 所以挂载到req上
  req.model = require(`../../models/${MODEL_NAME}`);
  next()
}, router)
```

## 3.加载静态资源

```js
const path = require('path')
app.use('/uploads', express.static(path.join(__dirname, 'uploads')))

// 为了提供对静态资源文件（图片，css，js文件）的服务，请使用Express内置的中间函数express.static
uploads文件中静态资源通过 http://localhost:3000/uploads/6abe1df86915ae97a3ee28537a5f8cfa 来访问 

// 为了给静态资源文件创建一个虚拟的文件前缀（文件系统中不存在），可以使用express.static函数指定一个虚拟的静态目录
app.use('/static', express.static('public'))
// 使用‘/static’作为前缀来加载public文件夹下的文件了
```

## 4.不同模块的接口分模块开发

```js
module.exports = (app) => {
const express = require('express')
const router = express.Router({
mergeParams: true // 保留来自父路由器的req.params值。如果父对象和子对象具有冲突的参数名，则以子对象的值为准。
}) // 创建express 的子路由, 分模块存储接口
router.get('/', async(req, res) => {
const items = await req.model.find().limit(10) // find 相当于select 进行查询操作
res.send(items)
})
app.use('/admin/api/rest/:resourse', router)
} // 在这个文件里你可以拿到app

// 在 index.js 中引入
require('./routes/admin')(app)
```



## 5.使用CRUD 公共接口

```js
/**
 * 共享接口 CRUD
 * 假如 有两个模板 功能都是增删改查 接口都是相似的操作 就可以使用共享接口
 * app.use('/admin/api/rest/:resourse', router)
 * 需要自己加一个 rest 防止接口冲突
 * 后面是动态的参数  也就是自己的模型名 数据库表名 == 接口名
 * req.params.resourse  可以拿到动态参数 也就是表名  resourse 是自己定义的 也可以是别的
 * 然后 在接口里面 引入参数对应的模型名  
 
 */
 module.exports = (app) => {
    const express = require('express')
    const anth = require('../../utils/auth')
    const router = express.Router({
            mergeParams: true // 保留来自父路由器的req.params值。如果父对象和子对象具有冲突的参数名，则以子对象的值为准。
        }) // 创建express 的子路由, 分模块存储接口
    router.post('/', async(req, res) => {
        const model = await req.model.create(req.body) // 往mongoodb添加数据
        res.send(model)
    })
    router.get('/', async(req, res) => {
        // populate 方法 返回关联对象id 转换成 对象 
        const queryOption = {}
        if (req.model.modelName == 'Category') {
            queryOption.populate = 'parent'
        }
        if (req.model.modelName == 'Article') {
            queryOption.populate = 'categories'
        }
        const items = await req.model.find().setOptions(queryOption).limit(10) // find 相当于select  进行查询操作 populate 查找绑定对象
        res.send(items)
    })
    router.get('/:id', async(req, res) => {
        const model = await req.model.findById(req.params.id) // find 相当于select  进行查询操作
        res.send(model)
    })
    router.put('/:id', async(req, res) => {
        const model = await req.model.findByIdAndUpdate(req.params.id, req.body) // find 相当于select  进行查询操作
        res.send({ msg: '修改成功' })
    })
    router.delete('/:id', async(req, res) => {
        await req.model.findByIdAndDelete(req.params.id) // find 相当于select  进行查询操作
        res.send({ msg: '删除成功' })
    })

    //  使用 rest 防止接口冲突 加上私有前缀
    //  /admin/api/rest/:resourse 中 /:resourse 绑定动态名称  resourse 是自己定义的 也可以是别的
    //  前台传得 http://localhost:3000/admin/api/rest/items
    //  req.params.resourse  可以拿到动态参数 也就是表名 也就是前台接口中items
    app.use('/admin/api/rest/:resourse', (req, res, next) => {
    
        // *inflection插件   inflection.classify( 'message_bus_properties' );//=== 'MessageBusProperty'  会把单词 复数 转换成 单数 因为mongoose中表名是单数  而接口中都是复数  转一下子
        const MODEL_NAME = require('inflection').classify(req.params.resourse)
        
        // const model = require(`../../models/${MODEL_NAME}`);
        // 为什么不使用 const   router 会访问不到 model 所以挂载到req上
        req.model = require(`../../models/${MODEL_NAME}`);
        next()
    }, router)
}
```

## 6.图片文件上传 中间件multer

```js
const multer = require('multer')
// dest 目标地址  文件存放在哪里
const upload = multer({ dest: __dirname + '/../../uploads' })
// upload.single() 接受名称为的单个文件fieldname。单个文件将存储在中req.file。
app.post('/admin/api/upload', upload.single('file'), async(req, res) => {
  const file = req.file
  // 如果想让前台查看上传图片要拼接文件路径返给前台 file.filename就是存储的文件名 uploads是存储的文件夹
  file.url = `http://localhost:3000/uploads/${file.filename}`
  res.send(file)
})
```

## 7. 对存储用户密码进行加密解密操作 bcryptjs

```js
const bcryptjs = require('bcryptjs')
// val 要加密的数据 也就是密码   10 就要加密的等级 最好是10-12之间 12以后加密跟解密性能慢 但是安全度高
var pwd = bcryptjs'.hashSync(val, 10)
// 然后存到数据库表中

// 登陆的时候 先根据前台传的 name 去数据库中那条数据   name 一般是唯一的 然后在取出密码
// 密码校验的操作  password 是用户传来的密码  user.password 是数据库存储的加密的密码
var flag = bcryptjs.compareSync(password, user.password) // 返回 true 和 false
// true 返回正确 false 返回错误
```