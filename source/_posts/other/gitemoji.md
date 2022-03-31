---
title: git emoji
date: 2021-04-28 ：19:14
index_img: https://fang-kang.gitee.io/blog-img/2.png
tags:
 - other
categories:
 - 其他
---

# git提交消息的表情符号指南

## Gitmoji

> 是一项倡议，旨在标准化和解释GitHub提交消息上表情符号的使用。

记录一下emoji在git中的使用方法，直接在git提交时添加emoji图标代码就可以了，如下：

```bash
git commit -m ":tada: Initial commit"
```

关于所有的emoji图标代码，可以参考[emojipedia](https://link.juejin.im/?target=https%3A%2F%2Femojipedia.org%2F)，不过GitHub上有一套约定俗成的emoji使用规范，我整理成了以下表格，在使用git提交信息的时候，你不妨尝试使用它们，让你的提交信息更加明晰和生动。

| emoji                                        | emoji 代码                    | commit 说明                  |
| :------------------------------------------- | :---------------------------- | :--------------------------- |
| :art: (调色板)                               | `:art:`                       | 改进代码结构/代码格式        |
| :zap: (闪电) :racehorse: (赛马)              | `:zap:` `:racehorse:`         | 提升性能                     |
| :fire: (火焰)                                | `:fire:`                      | 移除代码或文件               |
| :bug: (bug)                                  | `:bug:`                       | 修复 bug                     |
| :ambulance: (急救车)                         | `:ambulance:`                 | 重要补丁                     |
| :sparkles: (火花)                            | `:sparkles:`                  | 引入新功能                   |
| :memo: (备忘录)                              | `:memo:`                      | 撰写文档                     |
| :rocket: (火箭)                              | `:rocket:`                    | 部署功能                     |
| :lipstick: (口红)                            | `:lipstick:`                  | 更新 UI 和样式文件           |
| :tada: (庆祝)                                | `:tada:`                      | 初次提交                     |
| :white_check_mark: (白色复选框)              | `:white_check_mark:`          | 更新测试                     |
| :lock: (锁)                                  | `:lock:`                      | 修复安全问题                 |
| :apple: (苹果)                               | `:apple:`                     | 修复 macOS 下的问题          |
| :penguin: (企鹅)                             | `:penguin:`                   | 修复 Linux 下的问题          |
| :checkered_flag: (旗帜)                      | `:checked_flag:`              | 修复 Windows 下的问题        |
| :robot:（机器人）                            | `:robot:`                     | 修复 Android 下的问题        |
| :green_apple: (绿苹果)                       | `:green_apple:`               | 修复 iOS 下的问题            |
| :bookmark: (书签)                            | `:bookmark:`                  | 发行/版本标签                |
| :rotating_light: (警车灯)                    | `:rotating_light:`            | 移除 linter 警告             |
| :construction: (施工)                        | `:construction:`              | 工作进行中                   |
| :construction_worker: (工人)                 | `:construction_worker:`       | 添加 CI 构建系统             |
| :green_heart: (绿心)                         | `:green_heart:`               | 修复 CI 构建问题             |
| :arrow_up: (上升箭头)                        | `:arrow_up:`                  | 升级依赖                     |
| :arrow_down: (下降箭头)                      | `:arrow_down:`                | 降级依赖                     |
| :pushpin: (图钉)                             | `:pushpin:`                   | 将依赖项固定到特定版本       |
| :chart_with_upwards_trend: (上升趋势图)      | `:chart_with_upwards_trend:`  | 添加分析或跟踪代码           |
| :recycle: （回收）                           | `:recycle:`                   | 重构代码                     |
| :whale: (鲸鱼)                               | `:whale:`                     | Docker 相关工作              |
| :globe_with_meridians: (带子午线的地球仪)    | `:globe_with_meridians:`      | 国际化与本地化               |
| :heavy_plus_sign: (加号)                     | `:heavy_plus_sign:`           | 增加一个依赖                 |
| :heavy_minus_sign: (减号)                    | `:heavy_minus_sign:`          | 减少一个依赖                 |
| :wrench: (扳手)                              | `:wrench:`                    | 修改配置文件                 |
| :hammer: (锤子)                              | `:hammer:`                    | 重大重构                     |
| :pencil2: (铅笔)                             | `:pencil2:`                   | 修复 typo                    |
| :hankey: (粑粑...)                           | `:hankey:`                    | 写了辣鸡代码需要优化         |
| :rewind: (倒带)                              | `:rewind:`                    | 恢复更改                     |
| :twisted_rightwards_arrows: (交叉向右的箭头) | `:twisted_rightwards_arrows:` | 合并分支                     |
| :package: (包裹)                             | `:package:`                   | 更新编译的文件或包           |
| :alien: (外星人)                             | `:alien:`                     | 由于外部API更改而更新代码    |
| :truck: (货车)                               | `:truck:`                     | 移动或者重命名文件           |
| :page_facing_up: (正面朝上的页面)            | `:page_facing_up:`            | 增加或更新许可证书           |
| :boom: (爆炸)                                | `:boom:`                      | 引入突破性的变化             |
| :bento: (铅笔)                               | `:bento:`                     | 增加或更新资源               |
| :ok_hand: (OK手势)                           | `:ok_hand:`                   | 由于代码审查更改而更新代码   |
| :wheelchair: (轮椅)                          | `:wheelchair:`                | 改善无障碍交互               |
| :bulb: (灯泡)                                | `:bulb:`                      | 给代码添加注释               |
| :beers: (啤酒)                               | `:beers:`                     | 醉醺醺地写代码...            |
| :speech_balloon: (消息气泡)                  | `:speech_balloon:`            | 更新文本文档                 |
| :card_file_box: (卡片文件盒)                 | `:card_file_box:`             | 执行与数据库相关的更改       |
| :loud_sound: (音量大)                        | `:loud_sound:`                | 增加日志                     |
| :mute: (静音)                                | `:mute:`                      | 移除日志                     |
| :busts_in_silhouette: (轮廓中的半身像)       | `:busts_in_silhouette:`       | 增加贡献者                   |
| :children_crossing: (孩童通行)               | `:children_crossing:`         | 优化用户体验、可用性         |
| :building_construction: (建筑建造)           | `:building_construction:`     | 结构变动                     |
| :iphone: (iPhone)                            | `:iphone:`                    | 做响应式设计                 |
| :clown_face: (小丑脸)                        | `:clown_face:`                | 嘲弄事物（直译，这个没明白） |
| :egg: (鸡蛋)                                 | `:egg:`                       | 增加彩蛋                     |
| :see_no_evil: (看不见邪恶)                   | `:see_no_evil:`               | 增加或更改gitignore          |
| :camera_flash: (照相机闪光灯)                | `:camera_flash:`              | 增加或更新截图               |
| :alembic: (蒸馏器)                           | `:alembic:`                   | 尝试新东西                   |
| :mag: (放大镜)                               | `:mag:`                       | SEO优化                      |
| :wheel_of_dharma: (船的方向盘)               | `:wheel_of_dharma:`           | 关于Kubernetes的工作         |
| :label: (标签)                               | `:label:`                     | 增加类型（FLow、Typescript） |
