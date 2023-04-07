---
title: nest.js学习（一）
date: 2021-01-28 22:20
index_img: https://fang-kang.gitee.io/blog-img/nest.png
tags:
 - node
 - nest
categories:
  - node
---


## 什么是 Nest

[![nest_logo](https://user-images.githubusercontent.com/6111778/44448923-46fd4300-a61f-11e8-86ba-f7ba68f708fc.png)](https://user-images.githubusercontent.com/6111778/44448923-46fd4300-a61f-11e8-86ba-f7ba68f708fc.png)

`Nest`是一个强大的`Node web`框架。它可以帮助您轻松地构建高效、可伸缩的应用程序。它使用现代`JavaScript`，用`TypeScript`构建，结合了`OOP`(面向对象编程)和`FP`(函数式编程)的最佳概念。

它不仅仅是另一个框架。你不需要等待一个大的社区，因为`Nest`是用非常棒的、流行的知名库——`Express`和`socket.io`构建的!这意味着，您可以快速开始使用框架，而不必担心第三方插件。

作者[Kamil Myśliwiec](http://kamilmysliwiec.com/)初衷：

> JavaScript is awesome. Node.js gave us a possibility to use this language also on the server side. There are a lot of amazing libraries, helpers and tools on this platform, but non of them do not solve the main problem – the architecture. This is why I decided to create Nest framework.

> **重要**：`Nest` 受到 `Java Spring` 和 `Angular` 的启发。如果你用过 `Java Spring` 或 `Angular` 就会学起来非常容易，我本人一直使用 `Angular`。

## Nest 核心概念

Nest的核心概念是提供一种体系结构，它帮助开发人员实现层的最大分离，并在应用程序中增加抽象。

### 架构概览

`Nest`采用了`ES6`和`ES7`的特性(`decorator`, `async/await`)。如果想使用它们，需要用到`Babel`或`TypeScript`进行转换成 `es5`。

`Nest`默认使用的是[TypeScript](http://www.typescriptlang.org/)，也可以直接使用`JavaScript`，不过那样就没什么意义了。

> 如果你使用过[Angular](https://angular.cn/)，你来看这篇文章会觉得非常熟悉的感觉，因为它们大部分写法类似。如果你没有用过也没有关系，我将带领你一起学习它们。

### 模块 Module

使用`Nest`，您可以很自然地将代码拆分为独立的和可重用的模块。`Nest`模块是一个带有`@Module()`装饰器的类。这个装饰器提供元数据，框架使用元数据来组织应用程序结构。

每个 `Nest` 应用都有一个根模块，通常命名为 `AppModule`。根模块提供了用来启动应用的引导机制。 一个应用通常会包含很多功能模块。

像 `JavaScript` 模块一样，`@Module` 也可以从其它 `@Module` 中导入功能，并允许导出它们自己的功能供其它 `@Module` 使用。 比如，要在你的应用中使用`nest`提供的`mongoose`操作功能，就需要导入`MongooseModule`。

把你的代码组织成一些清晰的功能模块，可以帮助管理复杂应用的开发工作并实现可复用性设计。 另外，这项技术还能让你使用动态加载，`MongooseModule`就是使用这项技术。

`@Module` 装饰器接受一个对象，该对象的属性描述了模块:

| 属性          | 描述                                                 |
| ------------- | ---------------------------------------------------- |
| `providers`   | 由`Nest`注入器实例化的服务，可以在这个模块之间共享。 |
| `controllers` | 存放创建的一组控制器。                               |
| `imports`     | 导入此模块中所需的提供程序的模块列表。               |
| `exports`     | 导出这个模块可以其他模块享用`providers`里的服务。    |

`@Module` 为一个控制器集声明了编译的上下文环境，它专注于某个应用领域、某个工作流或一组紧密相关的能力。 `@Module` 可以将其控制器和一组相关代码（如服务）关联起来，形成功能单元。

怎么组织一个模块结构图

AppModule 根模块

- CoreModule 核心模块（注册中间件，过滤器，管道，守卫，拦截器，装饰器等）
- SharedModule 共享模块（注册服务，mongodb，redis等）
- ConfigModule 配置模块（系统配置）
- FeatureModule 特性模块（业务模块，如用户模块，产品模块等）

在`Nest`中，模块默认是单例的，因此可以在多个模块之间共享任何提供者的同一个实例。共享模块毫不费力。

整体看起来比较干净清爽，这也是我在`Angular`项目中一直使用的模块划分。

如果你有更好建议，欢迎和我一起交流改进。

### 控制器 Controller

控制器负责处理客户端传入的请求参数并向客户端返回响应数据，说的通俗点就是路由`Router`。

为了创建一个基本的控制器，我们使用`@Controller`装饰器。它们将类与基本的元数据相关联，因此`Nest`知道如何将控制器映射到相应的路由。

`@Controller`它是定义基本控制器所必需的。`@Controller('Router Prefix')`是类中注册的每个路由的可选前缀。使用前缀可以避免在所有路由共享一个公共前缀时重复使用自己。

```ts
@Controller('user')
export class UserController {
    @Get()
    findAll() {
        return [];
    }

    @Get('/admin')
    admin() {
        return {};
    }
}
//  findAll访问就是  xxx/user
//  admin访问就是    xxx/user/admin
```

控制器是一个比较核心功能，所有的业务都是围绕它来开展。`Nest`也提供很多相关的装饰器，接下来一一介绍他们，这里只是简单说明，后面实战会介绍他们的使用。

请求对象表示HTTP请求，并具有请求查询字符串、参数、HTTP标头等属性，但在大多数情况下，不需要手动获取它们。我们可以使用专用的`decorator`，例如`@Body()`或`@Query()`，它们是开箱即用的。下面是`decorator`与普通`Express`对象的比较。

先说方法参数装饰器：

| 装饰器名称                 | 描述                                   |
| -------------------------- | -------------------------------------- |
| `@Request()`               | 对应`Express`的`req`，也可以简写`@req` |
| `@Response()`              | 对应`Express`的`res`，也可以简写`@res` |
| `@Next()`                  | 对应`Express`的`next`                  |
| `@Session()`               | 对应`Express`的`req.session`           |
| `@Param(param?: string)`   | 对应`Express`的`req.params`            |
| `@Body(param?: string)`    | 对应`Express`的`req.body`              |
| `@Query(param?: string)`   | 对应`Express`的`req.query`             |
| `@Headers(param?: string)` | 对应`Express`的`req.headers`           |

先说方法装饰器：

| 装饰器名称    | 描述                                                      |
| ------------- | --------------------------------------------------------- |
| `@Post()`     | 对应`Express`的`Post`方法                                 |
| `@Get()`      | 对应`Express`的`Get`方法                                  |
| `@Put()`      | 对应`Express`的`Put`方法                                  |
| `@Delete()`   | 对应`Express`的`Delete`方法                               |
| `@All()`      | 对应`Express`的`All`方法                                  |
| `@Patch()`    | 对应`Express`的`Patch`方法                                |
| `@Options()`  | 对应`Express`的`Options`方法                              |
| `@Head()`     | 对应`Express`的`Head`方法                                 |
| `@Render()`   | 对应`Express`的`res.render`方法                           |
| `@Header()`   | 对应`Express`的`res.header`方法                           |
| `@HttpCode()` | 对应`Express`的`res.status`方法，可以配合`HttpStatus`枚举 |

以上基本都是控制器装饰器，一些常用的HTTP请求参数需要使用对应的方法装饰器和参数来配合使用。

关于返回响应数据，`Nest`也提供2种解决方案：

1. 直接返回一个`JavaScript`对象或数组时，它将被自动解析为`JSON`。当我们返回一个字符串时，`Nest`只发送一个字符串，而不尝试解析它。默认情况下，响应的状态代码总是`200`,
   但`POST`请求除外，它使用`201`。可以使用`@HttpCode(HttpStatus.xxxx)`装饰器可以很容易地改变这种行为。
2. 我们可以使用库特定的响应对象，我们这里可以使用[@res](https://github.com/res)()修饰符在函数签名中注入该对象，
   `res.status(HttpStatus.CREATED).send()`或者`res.status(HttpStatus.OK).json([])`等`Express`的`res`方法。

**注意**：禁止同时使用这两种方法，如果2个都使用，那么会出现这个路由不工作的情况。如果你在使用时候发现路由不响应，请检查有没有出现混用的情况，如果是正常情况下，推荐第一种方式返回。

> 控制器必须注册到该模块元数据的`controllers`里才能正常工作。

关于控制器异常处理，在后面过滤器讲解。

### 服务与依赖注入 Provider Dependency injection

服务是一个广义的概念，它包括应用所需的任何值、函数或特性。狭义的服务是一个明确定义了用途的类。它应该做一些具体的事，并做好。

`Nest` 把控制器和服务区分开，以提高模块性和复用性。

通过把控制器中和逻辑有关的功能与其他类型的处理分离开，你可以让控制器类更加精简、高效。 理想情况下，控制器的工作只管申明装饰器和响应数据，而不用顾及其它。 它应该提供请求和响应桥梁，以便作为视图（由模板渲染）和应用逻辑（通常包含一些模型的概念）的中介者。

控制器不需要定义任何诸如从客户端获取数据、验证用户输入或直接往控制台中写日志等工作。 而要把这些任务委托给各种服务。通过把各种处理任务定义到可注入的服务类中，你可以让它可以被任何控制器使用。 通过在不同的环境中注入同一种服务的不同提供商，你还可以让你的应用更具适应性。

`Nest` 不会强制遵循这些原则。它只会通过依赖注入让你能更容易地将应用逻辑分解为服务，并让这些服务可用于各个控制器中。

控制器是服务的消费者，也就是说，你可以把一个服务注入到控制器中，让控制器类得以访问该服务类。

那么服务就是提供者，基本上，几乎所有事情都可以看作是提供者—服务、存储库、工厂、助手等等。它们都可以通过构造函数注入依赖关系，这意味着它们可以彼此创建各种关系。

在 `Nest` 中，要把一个类定义为服务，就要用 `@Injectable` 装饰器来提供元数据，以便让 `Nest` 可以把它作为依赖注入到控制器中。

同样，也要使用 `@Injectable` 装饰器来表明一个控制器或其它类（比如另一个服务、模块等）拥有一个依赖。 依赖并不必然是服务，它也可能是函数或值等等。

依赖注入（通常简称 DI）被引入到 `Nest` 框架中，并且到处使用它，来为新建的控制器提供所需的服务或其它东西。

注入器是主要的机制。你不用自己创建 `Nest` 注入器。`Nest` 会在启动过程中为你创建全应用级注入器。

该注入器维护一个包含它已创建的依赖实例的容器，并尽可能复用它们。

提供者是创建依赖项的配方。对于服务来说，它通常就是这个服务类本身。你在应用中要用到的任何类都必须使用该应用的注入器注册一个提供商，以便注入器可以使用它来创建新实例。

关于依赖注入，前端框架`Angular`应该是最出名的，可以看[这里](https://angular.cn/guide/dependency-injection-pattern)介绍。

```ts
// 用户服务
import { Injectable } from '@nestjs/common';

interface User {}

@Injectable()
export class UserService {
  private readonly user: User[] = [];

  create(cat: User) {
    this.user.push(User);
  }

  findAll(): User[] {
    return this.user;
  }
}

// 用户控制器
import { Controller, Get, Post, Body } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  async create(@Body() createUserDto: CreateUserDto) {
    this.userService.create(createUserDto);
  }

  @Get()
  async findAll(): Promise<User[]> {
    return this.userService.findAll();
  }
}
```

自定义服务

我们不光可以使用`@Injectable()`来定义服务，还可以使用其他三种方式：`value`、`class`、`factory`。
这个和Angular一样，默认`@Injectable()`来定义服务就是`class`。

使用`value`：

```ts
const customObject = {};
@Module({
    controllers: [ UsersController ],
    components: [
        { provide: UsersService, useValue: customObject }
    ],
})
```

> **注意**：`useValue`可以是任何值，在这个模块中，`Nest`将把`customObject`与`UsersService`相关联，你还可以使用做测试替身(单元测试)。

使用`class`：

```ts
import { UserService } from './user.service';
const customObject = {};
@Module({
    controllers: [ UsersController ],
    components: [
        { provide: UsersService, useClass: UserService }
        OR
        UserService
    ],
})
```

> **注意**：只需要在本模块中使用选定的、更具体的类，`useClass`可以是和`provide`一样，如果不一样就相当于`useClass`替换`provide`。简单理解换方法，不换方法名，常用处理不同环境依赖注入。

使用`factory`：

```ts
@Module({
    controllers: [ UsersController ],
    components: [
        ChatService,
        {
            provide: UsersService,
            useFactory: (chatService) => {
                return Observable.of('customValue');
            },
            inject: [ ChatService ]
        }
    ],
})
```

> **注意**：希望提供一个值，该值必须使用其他组件(或自定义包特性)计算，希望提供异步值(只返回可观察的或承诺的值)，例如数据库连接。`inject`依赖服务，`provide`注册名，`useFactory`处理方式，`useFactory`参数和`inject`注入数组顺序一样。

如果我们`provide`注册名不是一个服务怎么办，是一个字符串`key`，也是很常用的。

```ts
@Module({
    controllers: [ UsersController ],
    components: [
        { provide: 'isProductionMode', useValue: false }
    ],
})
```

要用选择的自定义字符串`key`，您必须告诉Nest，需要用到`@Inject()`装饰器，就像这样:

```ts
import { Component, Inject } from 'nest.js';

@Component()
class SampleComponent {
    constructor(@Inject('isProductionMode') private isProductionMode: boolean) {
        console.log(isProductionMode); // false
    }
}
```

还有一个循环依赖的坑，后面实战会介绍怎么避免和解决这个坑。

> 服务必须注册到该模块元数据的`providers`里才能正常工作。如果需要给其他模块使用，需要添加到`exports`中。

### 中间件 Middleware

中间件是在路由处理程序之前调用的函数。中间件功能可以访问请求和响应对象，以及应用程序请求-响应周期中的下一个中间件功能。下一个中间件函数通常由一个名为`next`的变量表示。在`Express`中的中间件是非常出名的。

默认情况下，`Nest`中间件相当于表示`Express`中间件。和`Express`中间件功能类似，中间件功能可以执行以下任务

- 执行任何代码。
- 对请求和响应对象进行更改。
- 请求-响应周期结束。
- 调用堆栈中的下一个中间件函数。
- 如果当前中间件函数没有结束请求-响应周期，它必须调用`next()`将控制权传递给下一个中间件函数。否则，请求将被挂起。

简单理解`Nest`中间件就是把`Express`中间件进行了包装。那么好处就是只要你想用中间件，可以立马搜索`Express`中间件，拿来即可使用。是不是很方便。

`Nest`中间件要么是一个函数，要么是一个带有`@Injectable()`装饰器的类。类应该实现`NestMiddleware`接口，而函数却没有任何特殊要求。

```ts
// 实现一个带有`@Injectable()`装饰器的类打印中间件
import { Injectable, NestMiddleware, MiddlewareFunction } from '@nestjs/common';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  resolve(...args: any[]): MiddlewareFunction {
    return (req, res, next) => {
      console.log('Request...');
      next();
    };
  }
}
```

怎么使用，有两种方式：

1. 中间件可以全局注册

```ts
async function bootstrap() {
  // 创建Nest.js实例
  const app = await NestFactory.create(AppModule, application, {
    bodyParser: true,
  });
  // 注册中间件
  app.use(LoggerMiddleware());
  // 监听3000端口
  await app.listen(3000);
}
bootstrap();
```

1. 中间件可以模块里局部注册

```ts
export class CnodeModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(LoggerMiddleware)
      .with('ApplicationModule')
      .exclude(
        { path: 'user', method: RequestMethod.GET },
        { path: 'user', method: RequestMethod.POST },
      )
      .forRoutes(UserController);
  }
}

// or

export class CnodeModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(LoggerMiddleware)
      .forRoutes('*');
  }
}

// 1. with是提供数据，resolve里可以获取，exclude指定的路由，forRoutes注册路由，
// 2. forRoutes传递'*'表示作用全部路由
```

> **注意**：他们注册地方不一样，影响的路由也不一样，全局注册影响全部路由，局部注册只是影响当前路由下的路由。

### 过滤器 Exception filter

异常过滤器层负责在整个应用程序中处理所有抛出的异常。当发现未处理的异常时，最终用户将收到适当的用户友好响应。

默认显示响应`JSON`信息

```ts
{
  "statusCode": 500,
  "message": "Internal server error"
}
```

使用底层过滤器

```ts
@Post()
async create(@Body() createCatDto: CreateCatDto) {
  throw new HttpException('Forbidden', HttpStatus.FORBIDDEN);
}
```

HttpException 接受2个参数：

- 消息内容，可以是字符串错误消息或者对象`{status: 状态码，error：错误消息}`
- 状态码

每次写这么多很麻烦，那么过滤器也支持扩展和定制快捷过滤器对象。

```ts
export class ForbiddenException extends HttpException {
  constructor() {
    super('Forbidden', HttpStatus.FORBIDDEN);
  }
}
```

就可以直接使用了：

```ts
@Post()
async create(@Body() createCatDto: CreateCatDto) {
  throw new ForbiddenException('Forbidden');
}
```

是不是，方便很多了。

`Nest`给我们提供很多这样快捷常用的HTTP状态错误：

- BadRequestException 400
- UnauthorizedException 401
- ForbiddenException 403
- NotFoundException 404
- NotAcceptableException 406
- RequestTimeoutException 408
- ConflictException 409
- GoneException 410
- PayloadTooLargeException 413
- UnsupportedMediaTypeException 415
- UnprocessableEntityException 422
- InternalServerErrorException 500
- NotImplementedException 501
- BadGatewayException 502
- ServiceUnavailableException 503
- GatewayTimeoutException 504

异常处理程序基础很好,但有时你可能想要完全控制异常层,例如,添加一些日志记录或使用一个不同的`JSON`模式基于一些选择的因素。前面说了，`Nest`给我们内置返回响应模板，这个不能接受的，我们要自定义怎么办了，`Nest`给我们扩展空间。

```ts
import { ExceptionFilter, Catch, ArgumentsHost } from '@nestjs/common';
import { HttpException } from '@nestjs/common';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();
    const status = exception.getStatus();

    response
      .status(status)
      .json({
        statusCode: status,
        timestamp: new Date().toISOString(),
        path: request.url,
      });
  }
}
```

它返回是一个`Express`的方法`response`，来定制自己的响应异常格式。

怎么使用，有四种方式：

1. 直接`@UseFilters()`装饰器里面使用，作用当前这条路由的响应结果

```ts
@Post()
@UseFilters(HttpExceptionFilter | new HttpExceptionFilter())
async create(@Body() createCatDto: CreateCatDto) {
  throw new ForbiddenException();
}
```

1. 直接`@UseFilters()`装饰器里面使用，作用当前控制器路由所有的响应结果

```ts
@UseFilters(HttpExceptionFilter | new HttpExceptionFilter())
export class CatsController {}
```

1. 在全局注册使用内置实例方法`useGlobalFilters`，作用整个项目。过滤器这种比较通用推荐全局注册。

```ts
async function bootstrap() {
  const app = await NestFactory.create(ApplicationModule);
  app.useGlobalFilters(new HttpExceptionFilter());
  await app.listen(3000);
}
bootstrap();
```

### 管道 Pipe

管道可以把你的请求参数根据特定条件验证类型、对象结构或映射数据。管道是一个纯函数，不应该从数据库中选择或调用任何服务操作。

定义一个简单管道：

```ts
import { PipeTransform, Injectable, ArgumentMetadata } from '@nestjs/common';

@Injectable()
export class ValidationPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    return value;
  }
}
```

管道是用`@Injectable()`装饰器注释的类。应该实现`PipeTransform`接口，具体代码在`transform`实现，这个和`Angular`很像。

`Nest`处理请求数据验证，在数据不正确时可以抛出异常，使用过滤器来捕获。

`Nest`为我们内置了2个通用的管道，一个数据验证`ValidationPipe`，一个数据转换`ParseIntPipe`。

使用`ValidationPipe`需要配合`class-validator class-transformer`，如果你不安装它们 ，你使用`ValidationPipe`会报错的。

> **提示**：`ValidationPipe`不光可以验证请求数据也做数据类型转换，这个可以看官网。

怎么使用，有四种方式

1. 直接`@Body()`装饰器里面使用，只作用当前body这个参数

```ts
// 用户控制器
import { Controller, Get, Post, Body } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}
  @Post()
  async create(@Body(ValidationPipe | new ValidationPipe()) createUserDto: CreateUserDto) {
    this.userService.create(createUserDto);
  }
}
```

1. 在`@UsePipes()`装饰器里面使用，作用当前这条路由所有的请求参数

```ts
// 用户控制器
import { Controller, Get, Post, Body } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}
  @Post()
  @UsePipes(ValidationPipe | new ValidationPipe())
  async create(@Body() createUserDto: CreateUserDto) {
    this.userService.create(createUserDto);
  }
}
```

1. 在`@UsePipes()`装饰器里面使用，作用当前控制器路由所有的请求参数

```ts
// 用户控制器
import { Controller, Get, Post, Body } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
@UsePipes(ValidationPipe | new ValidationPipe())
export class UserController {
  constructor(private readonly userService: UserService) {}
  @Post()
  async create(@Body() createUserDto: CreateUserDto) {
    this.userService.create(createUserDto);
  }
}
```

1. 在全局注册使用内置实例方法`useGlobalPipes`，作用整个项目。这个管道比较通用推荐全局注册。

```ts
async function bootstrap() {
  const app = await NestFactory.create(ApplicationModule);
  app.useGlobalPipes(new ValidationPipe());
  await app.listen(3000);
}
bootstrap();
```

那么`createUserDto`怎么玩了，后面实战教程会讲解，这里不展开。

```ts
@Get(':id')
async findOne(@Param('id', ParseIntPipe | new ParseIntPipe()) id) {
  return await this.catsService.findOne(id);
}
```

`ParseIntPipe`使用也很简单，就是把一个字符串转换成数字。也是比较常用的，特别是你的id是字符串数字的时候，用`get`，`put`，`patch`，`delete`等请求，有id时候特别好用了。
还可以做分页处理，后面实战中用到，具体在讲解。

### 守卫 Guard

守卫可以做权限认证，如果你没有权限可以拒绝你访问这个路由，默认返回`403`错误。

定义一个简单管道：

```ts
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();
    return validateRequest(request);
  }
}
```

守卫是用`@Injectable()`装饰器注释的类。应该实现`CanActivate`接口，具体代码在`canActivate`方法实现，返回一个布尔值，true就表示有权限，false抛出异常403错误。这个写法和`Angular`很像。

怎么使用，有两种方式

1. 直接`@UseGuards()`装饰器里面使用，作用当前控制器路由所有的请求参数

```ts
@Controller('cats')
@UseGuards(RolesGuard | new RolesGuard())
export class CatsController {}
```

1. 在全局注册使用内置实例方法`useGlobalGuards`，作用整个项目。

```ts
const app = await NestFactory.create(ApplicationModule);
app.useGlobalGuards(new RolesGuard());
```

如果你不做权限管理相关的身份验证操作，基本用不上这个功能。不过还是很有用抽象功能。我们这个实战项目也会用到这个功能。

### 拦截器 Interceptor

拦截器是一个比较特殊强大功能，类似于AOP面向切面编程，前端编程中也尝尝使用这样的技术，比如各种http请求库都提供类似功能。有名的框架`Angular`框架HTTP模块。有名的库有老牌的`jquery`和新潮的`axios`等。

定义一个简单拦截器：

```ts
import { Injectable, NestInterceptor, ExecutionContext } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(
    context: ExecutionContext,
    call$: Observable<any>,
  ): Observable<any> {
    console.log('Before...');
    const now = Date.now();
    return call$.pipe(
      tap(() => console.log(`After... ${Date.now() - now}ms`)),
    );
  }
}
```

拦截器是用`@Injectable()`装饰器注释的类。应该实现`NestInterceptor`接口，具体代码在`intercept`方法实现，返回一个`Observable`，这个写法和`Angular`很像。

拦截器可以做什么：

- 在方法执行之前/之后绑定额外的逻辑
- 转换从函数返回的结果
- 转换从函数抛出的异常
- 扩展基本的函数行为
- 完全覆盖一个函数取决于所选择的条件(例如缓存)

怎么使用，有三种方式

1. 直接`@UseInterceptors()`装饰器里面使用，作用当前路由，还可以传参数，需要特殊处理，写成高阶函数，也可以使用依赖注入。

```ts
@Post('upload')
@UseInterceptors(FileFieldsInterceptor | FileFieldsInterceptor([
  { name: 'avatar', maxCount: 1 },
  { name: 'background', maxCount: 1 },
]))
uploadFile(@UploadedFiles() files) {
  console.log(files);
}
```

1. 直接`@UseInterceptors()`装饰器里面使用，作用当前控制器路由，这个不能传参数，可以使用依赖注入

```
@UseInterceptors(LoggingInterceptor | new LoggingInterceptor())
export class CatsController {}
```

1. 在全局注册使用内置实例方法`useGlobalInterceptors`，作用整个项目。

```ts
const app = await NestFactory.create(ApplicationModule);
app.useGlobalInterceptors(new LoggingInterceptor());
```

拦截器可以做很多功能，比如缓存处理，响应数据转换，异常捕获转换，响应超时跑错，打印请求响应日志。我们这个实战项目也会用到这个功能。

### 总结

模块是按业务逻辑划分基本单元，包含控制器和服务。控制器是处理请求和响应数据的部件，服务处理实际业务逻辑的部件。

中间件是路由处理Handler前的数据处理层，只能在模块或者全局注册，可以做日志处理中间件、用户认证中间件等处理，中间件和express的中间件一样，所以可以访问整个request、response的上下文，模块作用域可以依赖注入服务。全局注册只能是一个纯函数或者一个高阶函数。

管道是数据流处理，在中间件后路由处理前做数据处理，可以控制器中的类、方法、方法参数、全局注册使用，只能是一个纯函数。可以做数据验证，数据转换等数据处理。

守卫是决定请求是否可以到达对应的路由处理器，能够知道当前路由的执行上下文，可以控制器中的类、方法、全局注册使用，可以做角色守卫。

拦截器是进入控制器之前和之后处理相关逻辑，能够知道当前路由的执行上下文，可以控制器中的类、方法、全局注册使用，可以做日志、事务处理、异常处理、响应数据格式等。

过滤器是捕获错误信息，返回响应给客户端。可以控制器中的类、方法、全局注册使用，可以做自定义响应异常格式。

中间件、过滤器、管道、守卫、拦截器，这是几个比较容易混淆的东西。他们有个共同点都是和控制器挂钩的中间抽象处理层，但是他们的职责却不一样。

全局管道、守卫、过滤器和拦截器和任何模块松散耦合。他们不能依赖注入任何服务，因为他们不属于任何模块。
可以使用控制器作用域、方法作用域或辅助作用域仅由管道支持，其他除了中间件是模块作用域，都是控制器作用域和方法作用域。

> **重点**：在示例给出了它们的写法，注意全局管道、守卫、过滤器和拦截器，只能new，全局中间件是纯函数，全局管道、守卫、过滤器和拦截器，中间件都不能依赖注入。中间件模块注册也不能用new，可以依赖注入。管道、守卫、过滤器和拦截器局部注册可以使用new和类名，除了管道以为其他都可以依赖注入。拦截器和守卫可以写成高阶方法来传参，达到定制目的。

管道、过滤器、拦截器守卫都有各自的具体职责。拦截器和守卫与模块结合在一起，而管道和过滤器则运行在模块区域之外。管道任务是根据特定条件验证类型、对象结构或映射数据。过滤器任务是捕获各种错误返回给客户端。管道不是从数据库中选择或调用任何服务的适当位置。另一方面来说，拦截器不应该验证对象模式或修饰数据。如果需要重写，则必须由数据库调用服务引起。守卫决定了哪些路由可以访问，它接管你的验证责任。

那你肯定最关心他们执行顺序是什么：

```bash
客户端请求 ---> 中间件 ---> 守卫 ---> 拦截器之前 ---> 管道 ---> 控制器处理并响应 ---> 拦截器之后 ---> 过滤器
```

我们来看2张图，

请求返回响应结果：

[![hdvo ug9_58 g 9o_n n 7o](https://user-images.githubusercontent.com/6111778/44449059-a3f8f900-a61f-11e8-9414-15ae4fe6f312.png)](https://user-images.githubusercontent.com/6111778/44449059-a3f8f900-a61f-11e8-9414-15ae4fe6f312.png)

请求返回响应异常：

[![nmzgsgsc5ynm_ghfsxzl5jh](https://user-images.githubusercontent.com/6111778/44449066-a9eeda00-a61f-11e8-92c4-8aca90649f53.png)](https://user-images.githubusercontent.com/6111778/44449066-a9eeda00-a61f-11e8-92c4-8aca90649f53.png)

## Hello World

学习一门语言一门技术都是从 `Hello World` 开始，我们也是从零到`Hello World`开启学习`Nest`之旅

### 准备必备开发环境和工具

推荐`nvm`来管理`nodejs`版本，根据自己电脑下载对应版本吧。

1. 准备环境: [Nodejs](https://nodejs.org/en/) v8+ (目前版本v10+, 必须8以上，对es2015支持率很高)

2. 准备数据库：[mongodb](https://www.mongodb.com/) v3+ (目前版本v4+)

3. 准备数据库：[redis](https://redis.io/) v3+ (目前版本v3+)

4. 准备编辑器: [vs code](https://code.visualstudio.com/) 最新版即可(本机 windows v1.26)

5. ```bash
   vs code
   ```

   推荐插件：(其他插件自己随意)

   - Debugger for Chrome -- 调试
   - ejs -- ejs文件高亮
   - Beautify -- 代码格式化
   - DotENV -- .env文件高亮
   - Jest -- nest默认测试框架支持
   - TSLint -- ts语法检查
   - TypeScript Hero -- ts提示
   - vscode-icons -- icons

6. 推荐几个好用的工具：

   - Postmen -- API测试神器
   - Robomongo -- mongodb图形化工具
   - Redis Desktop Manager -- Redis图形化工具
   - Cmder -- Windows命令行神器

### Nest相关资源

1. 官网：[https://nestjs.com](https://nestjs.com/)
2. 文档：[https://docs.nestjs.com](https://docs.nestjs.com/)
3. 中文文档：[https://docs.nestjs.cn](https://docs.nestjs.cn/)
4. Github：<https://github.com/nestjs/nest>
5. 版本：目前稳定版v5.1.0
6. CLI：<https://github.com/nestjs/nest-cli>

### nest-cli

`nest-cli` 是一个 `nest` 项目脚手架。为我们提供一个初始化模块，可以让我们快速完成`Hello World`功能。

#### 安装

```bash
npm i -g @nestjs/cli
```

#### 常用命令

##### new(简写：n) 构建新项目

```bash
$ nest new my-awesome-app
OR
$ nest n my-awesome-app
```

##### generate(简写：g) 生成文件

- class (简写: cl) 类
- controller (简写: co) 控制器
- decorator (简写: d) 装饰器
- exception (简写: e) 异常捕获
- filter (简写: f) 过滤器
- gateway (简写: ga) 网关
- guard (简写: gu) 守卫
- interceptor (简写: i) 拦截器
- middleware (简写: mi) 中间件
- module (简写: mo) 模块
- pipe (简写: pi) 管道
- provider (简写: pr) 供应商
- service (简写: s) 服务

创建一个users服务文件

```bash
$ nest generate service users
OR
$ nest g s users
```

> **注意**：

1. `必须`在项目`根目录`下创建，（默认创建在src/）。（不能在当前文件夹里面创建，不然会自动生成xxx/src/xxx。吐槽：这个没有Angular-cli智能）
2. 需要`优先`新建模块，不然创建的非模块以外的服务，控制器等就会自动注入更新到上级的模块里面

##### info(简写：i) 打印版本信息

打印当前系统，使用nest核心模块版本，供你去官方提交[issues](https://github.com/nestjs/nest/issues)

```bash
| \ | |           | |    |_  |/  ___|/  __ \| |   |_   _|
|  \| |  ___  ___ | |_     | |\ `--. | /  \/| |     | |
| . ` | / _ \/ __|| __|    | | `--. \| |    | |     | |
| |\  ||  __/\__ \| |_ /\__/ //\__/ /| \__/\| |_____| |_
\_| \_/ \___||___/ \__|\____/ \____/  \____/\_____/\___/


[System Information]
OS Version     : Windows 10
NodeJS Version : v8.11.1
NPM Version    : 5.6.0
[Nest Information]
microservices version : 5.1.0
websockets version    : 5.1.0
testing version       : 5.1.0
common version        : 5.1.0
core version          : 5.1.0
```

> 最后，整体功能和`Angular-cli`类似，比较简单实用功能。构建项目，生成文件，打印版本信息。

### nest内置功能

目前`Nest.js`支持 `express` 和 `fastify`, 对 `fastify` 不熟，本文选择`express`。

#### 核心模块

- @nestjs/common 提供很多装饰器，log服务等
- @nestjs/core 核心模块处理底层框架兼容
- @nestjs/microservices 微服务支持
- @nestjs/testing 测试套件
- @nestjs/websockets websocket支持

#### 可选模块

- @nestjs/typeorm 还没玩过
- @nestjs/graphql 还没玩过
- @nestjs/cqrs 还没玩过
- @nestjs/passport 身份验证（v5版支持，不向下兼容）
- @nestjs/swagger swagger UI API
- @nestjs/mongoose mongoose模块

> **注意**: 其他中间件模块，只要支持`express`和都可以使用。

### 构建项目

1. 创建项目`nest-cnode`

```bash
nest new nest-cnode
```

[![nest_cli](https://user-images.githubusercontent.com/6111778/44448993-7318c400-a61f-11e8-9201-0d099d6f5d24.png)](https://user-images.githubusercontent.com/6111778/44448993-7318c400-a61f-11e8-9201-0d099d6f5d24.png)

其中提交的你的`description`, 初始化版本`version`, 作者`author`, 以及一个`package manager`选择`node_modules`安装方式 `npm` 或者 `yarn`。

1. 项目启动

```bash
cd nest-cnode

// 启动命令

npm run start  // 预览
npm run start:dev // 开发
npm run prestart:prod  // 编译成js
npm run start:prod  // 生产

// 测试命令

npm run test  // 单元测试
npm run test:cov  // 单元测试+覆盖率生成
npm run test:e2e  // E2E测试
```

1. 项目文件介绍

| 文件              | 说明                                     |
| ----------------- | ---------------------------------------- |
| node_modules      | npm包                                    |
| src               | 源码                                     |
| logs              | 日志                                     |
| test              | E2E测试                                  |
| views             | 模板                                     |
| public            | 静态资源                                 |
| nodemon.json      | nodemon配置（npm run start:dev启动）     |
| package.json      | npm包管理                                |
| README.md         | 说明文件                                 |
| tsconfig.json     | Typescript配置文件（Typescript必备）     |
| tslint.json       | Typescript风格检查文件（Typescript必备） |
| webpack.config.js | 热更新（npm run start:hmr启动）          |
| .env              | 配置文件                                 |

> 开发代码都在`src`里，生成代码在`dist` (打包自动编译)，`typescript`打包只会编译`ts`到`dist` 下，静态文件`public`和模板`views`不会移动，所以需要放到根目录下。

[![nest_start](https://user-images.githubusercontent.com/6111778/44449023-8b88de80-a61f-11e8-8f5e-ae3760859942.png)](https://user-images.githubusercontent.com/6111778/44449023-8b88de80-a61f-11e8-8f5e-ae3760859942.png)

我们打开浏览器，访问`http://localhost:3000`，您应该看到一个页面，上面显示`Hello World`文字。

[![j _ 2k2q0pqpjt 03o t16u](https://user-images.githubusercontent.com/6111778/44449034-92afec80-a61f-11e8-9dc8-3e8a0160b978.png)](https://user-images.githubusercontent.com/6111778/44449034-92afec80-a61f-11e8-9dc8-3e8a0160b978.png)

[本文来自 https://github.com/jiayisheji/blog/issues/18](https://github.com/jiayisheji/blog/issues/18)
