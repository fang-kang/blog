---
title: filter（过滤器）
date: 2020-10-21 15:33:01
index_img: https://fang-kang.gitee.io/blog-img/default.png
tags:
 - vue
categories:
  - vue
---

## 过滤器

>Vue.js 允许你自定义过滤器，可被用于一些常见的文本格式化。过滤器可以用在两个地方：**双花括号插值**和 **`v-bind` 表达式** (后者从 2.1.0+ 开始支持)。过滤器应该被添加在 JavaScript 表达式的尾部，由“管道”符号指示：

注：过滤器也可以定义多个过滤器，如：`{{ msg | 过滤器1 | 过滤器2}}` 可以多次调用过滤器:步骤是按顺序进行，先把`msg` 交给第一个过滤器 执行，得到结果，然后交给下一个过滤器执行，返回的最终结果渲染到页面相应的位置

### 过滤器定义语法

```js
Vue.filter(‘过滤器的名称’,fucntion(){})
过滤器中的 function ，第一个参数已经规定死了，永远都是 过滤器 管道符前面 传过来的数据
例如：
Vue.filter(‘过滤器名称’,function(data){
return data + “123”;
})
```

### 过滤器调用时候的格式

```html
<!-- 花括号中 -->
{{ message |  dataFormat}}

<!-- 在v-bind 中 -->
<div v-bind:id="dataId | formatId"></div>
```

### 全局过滤器

```js
全局过滤器 Vue.filter(‘过滤器名称’,function(){})
function 中第一个参数，必须是过滤器管道符前边的数据，这是 Vue 规定死的，后边也可以跟多参数
接下来通过一个例子来了解一下过滤器
```

```html
<div id="app">
<p>{{ctime | dataFilter}}</p>
</div>

<script>
//在这给 形参 par1="" 赋空值，也就是在调用过滤器的时候，除了实参赋 "yyyy-mm-dd"以外，其他的都是详细日期输出
Vue.filter('dataFilter',function(dataStr,par1=""){
    // 根据给定的时间字符串，得到特定的时间
  var dt = new Date(dataStr);
    var y = dt.getFullYear();
    
    // 得到的是0月，所以+1
    var m = (dt.getMonth() + 1).toString().padStart(2,'0');
 
 //.toString.padStart(最大字符串长度值，"要替补的符号或值")
    var d = dt.getDate().toString().padStart(2,'0');
    
    //如果给的实参字符串是yyyy-mm-dd ，输出年月日，否则输出全日期
    if(par1.toLowerCase() === "yyyy-mm-dd"){
     //模板字符串
     return `${y}-${m}-${d}`;
    }else{
      var hh = dt.getHours().toString().padStart(2,'0');
         var mm = dt.getMinutes().toString().padStart(2,'0');
         var ss = dt.getSeconds().toString().padStart(2,'0');
   return `${y}-${m}-${d} ${hh}:${mm}:${ss}`;
    }
})


var vm = new Vue({
 el:'#app',
 data:{
 ctime:new Date();
 },
 methods:{},
})
</script>
```

### 局部过滤器

```js
定义私有过滤器：过滤器有两个条件【过滤器名称 和 处理函数】
filters:{
}
```

{% note success %}
注：过滤器调用的时候，采用的就是就近原则，如果私有过滤器和全局过滤器名称一致了，这时候 优先调用私有过滤器
{% endnote %}

```html
<div id="app">

//<!-- 如果不给实参，形参pattern 永远是undefined代码报错，这里是给空值；第二种方法是给形参:pattern='' -->

<p>{{ctime | dataFilter("")}}</p>
</div>

<script>
 var vm = new Vue({
  el:'#app',
  data:{
   ctime:new Date();
  },
  methods:{},
  filters:{
   dataFilter:function(dtime,par){
     var dt = new Date(dtime);
                 var y = dt.getFullYear().toString().padStart(2, '0');
                 var m = (dt.getMonth() + 1).toString().padStart(2, '0');
                 var d = dt.getDate().toString().padStart(2, '0');
                  if (par.toLowerCase() === "yyyy-mm--dd") {
                       return `${y}-${m}-${d}`;
                       
                    } else {
                        var hh = dt.getHours().toString().padStart(2, '0');
                        var mm = dt.getMinutes().toString().padStart(2, '0');
                        var ss = dt.getSeconds().toString().padStart(2, '0');
                        
                        return `${y}-${m}-${d} ${hh}:${mm}:${ss} ***`;
                    }
   }
  }
 })
</script>
```
