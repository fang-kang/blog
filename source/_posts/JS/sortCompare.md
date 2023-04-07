---
title: js中数组对象排序
date: 2021-05-08 11:13:01
tags:
 - Js
 - 数组
 - utils
categories:
 - Js
index_img: https://fang-kang.gitee.io/blog-img/2.jpg
---

```js
/**
 * 排序
 * arr: 所需排序的数组
 * prop：排序的依据字段
 * order：默认true -> 正序（小 -> 大） / false -> 倒序（大 -> 小）
 */
export const sortCompare = (arr, prop, order = true) => {
  return arr.sort(compare(prop, order));
};

function compare (prop, order) {
  return (obj1, obj2) => {
    let val1 = obj1[prop];
    let val2 = obj2[prop];
    if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
      val1 = Number(val1);
      val2 = Number(val2);
    }
    if (order) {
      if (val1 < val2) return -1;
      else if (val1 > val2) return 1;
      else return 0;
    } else {
      if (val1 > val2) return -1;
      else if (val1 < val2) return 1;
      else return 0;
    }
  };
}
```