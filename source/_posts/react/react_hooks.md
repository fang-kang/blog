---
title: ReactHooks
date: 2021-01-04 21:36:01
index_img: https://fang-kang.gitee.io/blog-img/20200102135816.jpg-slim
tags:
  - react
categories:
  - react
---

# react-hooks

`Hook` 是 React16.8 的新特性，`Hook` 使你在无需修改组件结构的情况下复用状态逻辑。

弥补了 functin Component 没有实例没有生命周期的问题，`react` 项目基本上可以全部用 function Component 去实现了。

## hook 总览

常用的官方的 `hook` 主要是下面几个：

- useState()
- useReducer()
- useContext()
- useRef()
- useImperative()
- useEffect()
- useLayoutEffect()
- useMemo()
- useCallback()

## hook 基础

hook 使用规则：

- 不要在循环，条件，或者嵌套函数中调用 hook，在最顶层使用 hook
- 不能在普通函数中调用 hook

下面主要记录每个 hook 基础的用法，

### useState

存取数据的一种方式，对于简单的 state 适用，复杂的更新逻辑的 state 考虑使用 useReducer

使用：

```js
const [state, setState] = useState(initState)
```

更新：

```js
setState(newState)
setState(state => newState) // 函数式更新
```

setState 是稳定的，所以在一些 hook 依赖中可以省略

### useReducer

useState 的一种代替方案，当 state 的处理逻辑比较复杂的时候，有多个子值得时候，可以考虑用 useReducer

使用：

```js
const initialState = { count: 0 }

function reducer(state, action) {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + 1 }
    case 'decrement':
      return { ...state, count: state.count - 1 }
    default:
      throw new Error()
  }
}
const [state, dispatch] = useReducer(reducer, initialState)
```

如果有第三个参数，则第三个参数为一个函数，接受第二个参数的值作为参数，返回初始值。

dispatch 是稳定的，所以在一些 hook 依赖中可以省略

### useContext

```js
const value = useContext(MyContext)
```

接受一个 context 对象，并返回该 context 对象的当前值，配合 context 使用

```js
const themes = {
  light: {
    foreground: '#000000',
    background: '#eeeeee',
  },
  dark: {
    foreground: '#ffffff',
    background: '#222222',
  },
}

const ThemeContext = React.createContext(themes.light)

function App() {
  return (
    <ThemeContext.Provider value={themes.dark}>
      <Toolbar />
    </ThemeContext.Provider>
  )
}

function Toolbar(props) {
  return (
    <div>
      <ThemedButton />
    </div>
  )
}

function ThemedButton() {
  const theme = useContext(ThemeContext)
  return (
    <button style={{ background: theme.background, color: theme.foreground }}>I am styled by theme context!</button>
  )
}
```

### useRef

```js
const refContainer = useRef(initValue)
```

返回一个可变的 ref 对象，其 .current 属性被初始化为传入的参数（initialValue）。返回的 ref 对象在组件的整个生命周期内持续存在。

- 访问 dom 的一个方式
- 可以将其作为一个值来使用，在每次渲染时都返回同一个 ref 对象
- 改变其 ref 的值，不会引起组件的重新渲染

例子 1，访问 dom 的方式：

```js
function TextInputWithFocusButton() {
  const inputEl = useRef(null)
  const onButtonClick = () => {
    // `current` 指向已挂载到 DOM 上的文本输入元素
    inputEl.current.focus()
  }
  return (
    <>
      <input ref={inputEl} type="text" />
      <button onClick={onButtonClick}>Focus the input</button>
    </>
  )
}
```

例子 2，作为一个对象来保存值：

```js
import { useEffect, useRef, useState } from 'react'

function App() {
  const [count, setCount] = useState(0)
  // 记录定时器，方便可以随时停止计时器
  let timer = useRef(null)
  useEffect(() => {
    timer.current = setInterval(() => {
      console.log(1)
      setCount(count => count + 1)
    }, 1000)
    return () => {
      clearInterval(timer.current)
      timer.current = null
    }
  }, [])

  const stop = () => {
    if (timer.current) {
      clearInterval(timer.current)
      timer.current = null
    }
  }
  return (
    <div>
      <span>{count}</span>
      <button onClick={stop}>stop</button>
    </div>
  )
}

export default App
```

### useImperativeHandle

`useImperativeHandle` 可以让你在使用 ref 时自定义暴露给父组件的实例值

```js
useImperativeHandle(ref, createHandle, [deps])
```

- ref：需要被赋值的 ref 对象
- createHandle：的返回值作为 ref.current 的值。
- [deps]：依赖数组，依赖发生变化重新执行 createHandle 函数

使用例子：

```js
const Child = React.forwardRef((props, ref) => {
  const inputRef = useRef()
  useImperativeHandle(ref, () => ({
    focus: () => {
      inputRef.current.focus()
    },
  }))
  return <input ref={inputRef} />
})
```

或者

```js
// App.js
;<Child cRef={this.myRef} />

// Child.js
const Child = props => {
  const inputRef = useRef()
  const { cRef } = props
  useImperativeHandle(cRef, () => ({
    focus: () => {
      inputRef.current.focus()
    },
  }))
  return <input ref={inputRef} />
}
```

### useEffect

引入副作用，销毁函数和回调函数在 commit 阶段异步调度，在 layout 阶段完成后异步执行，不会阻塞 ui 得渲染。

```js
useEffect(() => {
  //...副作用
  return () => {
    // ...清除副作用
  }
}, [deps])
```

- 副作用在 commit 阶段异步执行，清除副作用的销毁函数会在下一阶段的的 commit 阶段执行，
- [deps]：依赖数组，依赖发生变化重新执行

### useLayoutEffect

引入副作用的，用法和 `useEffect` 一样，但 `useLayoutEffect` 会阻塞 `dom` 的渲染，同步执行，上一次更新的销毁函数在 commit 的 mutation 阶段执行，回调函数在在 layout 阶段执行，和 componentDidxxxx 是等价的。

### useMemo

返回一个`memo` 值，作为一种性能优化的手段，只有当依赖项的依赖改变才会重新渲染值

```js
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b])
```

### useCallback

返回一个 `memoized` 回调函数，作为一种性能优化的手段，只有当依赖项的依赖改变才会重新构建该函数

```js
const memoizedCallback = useCallback(() => {
  doSomething(a, b)
}, [a, b])
```

### useDebugValue

`useDebugValue` 可用于在 React 开发者工具中显示自定义 hook 的标签, 浏览器装有 react 开发工具调试代码的时候才有用。

### useTransition

返回一个状态值表示过渡任务的等待状态，以及一个启动该过渡任务的函数。

```js
const [isPending, startTransition] = useTransition()
```

- isPending: 指示过渡任务何时活跃以显示一个等待状态，为 true 时表示过渡任务还没更新完。
- startTransition: 允许你通过标记更新将提供的回调函数作为一个过渡任务，变为过渡任务则说明更新往后放，先更新其他更紧急的任务。

例子：

```jsx
import React, { useEffect, useState, useTransition } from 'react'

const SearchResult = props => {
  const resultList = props.query
    ? Array.from({ length: 50000 }, (_, index) => ({
        id: index,
        keyword: `${props.query} -- 搜索结果${index}`,
      }))
    : []
  return resultList.map(({ id, keyword }) => <li key={id}>{keyword}</li>)
}

export default () => {
  const [isTrans, setIstrans] = useState(false)
  const [value, setValue] = useState('')
  const [searchVal, setSearchVal] = useState('')
  const [loading, startTransition] = useTransition({ timeoutMs: 2000 })

  useEffect(() => {
    // 监听搜索值改变
    console.log('对搜索值更新的响应++++++' + searchVal + '+++++++++++')
  }, [searchVal])

  useEffect(() => {
    // 监听输入框值改变
    console.log('对输入框值更新的响应-----' + value + '-------------')
  }, [value])

  useEffect(() => {
    if (isTrans) {
      startTransition(() => {
        setSearchVal(value)
      })
    } else {
      setSearchVal(value)
    }
  }, [value])

  return (
    <div className="App">
      <h3>StartTransition</h3>
      <input value={value} onChange={e => setValue(e.target.value)} />
      <button onClick={() => setIstrans(!isTrans)}>{isTrans ? 'transiton' : 'normal'}</button>
      {loading && <p>数据加载中，请稍候...</p>}
      <ul>
        <SearchResult query={searchVal}></SearchResult>
      </ul>
    </div>
  )
}
```

### useDeferredValue

`useDeferredValue` 接受一个值，并返回该值的新副本，该副本将推迟到更紧急地更新之后。如果当前渲染是一个紧急更新的结果，比如用户输入，React 将返回之前的值，然后在紧急渲染完成后渲染新的值。本，该副本将推迟到更紧急地更新之后

## react-router v6 hooks

### useHref

```typescript
declare function useHref(to: To): string
```

`useHref`钩子返回一个 URL，可以用来链接到给定的 to 位置，甚至在 React router 之外。

`useHref`传入一个字符串或`To`对象，返回一个 URL 的绝对路径。可以在参数中传入一个相对路径、绝对路径、To 对象。
`react hooks v6`中的`Link`组件内部使用`useHref`获取它的 href 值

```typescript
export interface Path {
  pathname: Pathname
  search: Search
  hash: Hash
}
export type To = string | Partial<Path>
```

例子：

当前路由：/page1/page2

```jsx
import React, { useEffect } from 'react'
import { useHref } from 'react-router-dom'

function Page2(props) {
  useEffect(() => {
    console.log(useHref('../')) // 输出 '/page1/'
    console.log(useHref('../../')) // 输出 '/'
    console.log(useHref('/page1')) // 输出 '/page'
    console.log(useHref('/pageabc')) // 输出 '/pageabc' 可见路径与当前路由无关
    console.log(useHref({ pathname: '/page1', search: 'name=123', hash: 'test' })) // 输出 '/page1?name=123#test'
  }, [])
  return <div></div>
}

export default Page2
```

### useInRouterContext

```typescript
declare function useInRouterContext(): boolean
```

如果组件在`Router`组件中的上下文中渲染，`useInRouterContext`将返回 true，否则返回 false。这对于一些需要知道是否在`react router`的上下文中渲染的第三方扩展非常有用。

判断当前组件是否在由`Router`组件创建的`Context`中

### useLocation

```typescript
declare function useLocation(): Location

interface Location extends Path {
  state: unknown
  key: Key
}
```

这个`hook`返回当前路由的`location`对象。

### useMatch

```typescript
declare function useMatch<ParamKey extends string = string>(pattern: PathPattern | string): PathMatch<ParamKey> | null
```

返回给定路径上相对于当前位置的路由的匹配数据。

`react router v5`中的`useRouteMatch`在 v6 版本中更名为`useMatch`。内部示例调用了`matchPath`方法根据 URL 路径名匹配路由路径模式，并返回有关匹配的信息。如果模式与给定路径名不匹配，则返回`null`。

### useNavigate

```typescript
declare function useNavigate(): NavigateFunction

interface NavigateFunction {
  (to: To, options?: { replace?: boolean; state?: any }): void
  (delta: number): void
}
```

`useNavigate`钩子返回一个函数，该函数允许您以编程方式进行导航，例如在提交表单之后。

`react router v5`中组件获取到的`useHistory`在 v6 版本更名为`useNavigate`。在用法上作出了较大改变

例子：

当前路由：/user/page2
其他路由：/user/page1

```jsx
import React, { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'

function Page2(){
  let navigate = useNavigate()
  useEffect(()=>{
    navigate('/user/page1') // 导航到'/user/page1'
    navigate('../') // 导航到'/user'
    navigate(-1) // 导航到/user/page1 相当于v5中history.go(-1) history.goBack()
    navigate(1) //导航到/user 相当于v5中history.go(1) history.goForward()
    navigate('/user/page2/',{ replace: true, state: { name:123 }} // 相当于v5中history.replace()，并同时传入state
  },[])
  return <div></div>
}

export default Page2
```

### useNavigationType

```typescript
declare function useNavigationType(): NavigationType
type NavigationType = 'POP' | 'PUSH' | 'REPLACE'
```

这个钩子返回当前的导航类型或用户如何到达当前页面；通过历史堆栈上的`pop`、`push`或`replace`操作。

这个`hooks`类似`react router v5`中组件传入参数中的`history`对象的`action`属性，返回触发当前`navigate`的是何种操作

### useOutlet

```typescript
declare function useOutlet(): React.ReactElement | null
```

返回路由当前路由的子路由的元素。这个`hook`被`Outlet`组件在内部使用用于渲染子路由。

### useParams

```typescript
declare function useParams<K extends string = string>(): Readonly<Params<K>>
```

`useParams`返回 URL 参数的键/值对的对象。使用它来访问当前`Route`的`match.params`。子路由从其父路由继承所有参数。

### useSearchParams

```typescript
declare function useSearchParams(
  defaultInit?: URLSearchParamsInit
): [URLSearchParams, SetURLSearchParams];

type ParamKeyValuePair = [string, string];

type URLSearchParamsInit =
  | string
  | ParamKeyValuePair[]
  | Record<string, string | string[]>
  | URLSearchParams;

type SetURLSearchParams = (
  nextInit?: URLSearchParamsInit,
  navigateOpts?: : { replace?: boolean; state?: any }
) => void;
```

`useSearchParams`用于读取和修改 URL 中当前位置的查询字符串。与`useState`一样，`useSearchParams`返回一个包含两个值的数组：`当前位置的搜索参数`和`一个可用于更新它们的函数`。

`useSearchParams`的工作原理与`navigate`类似，但仅适用于 URL 的`search`部分。

{% note warning %}

setSearchParams 的第二个参数要与 navigate 的第二个参数的类型相同

{% endnote %}

### useResolvedPath

```typescript
declare function useResolvedPath(to: To): Path
```

这个`hook`解析给定`to`对象中的`pathname`与当前位置的路径名，并返回一个`Path`对象

### useRoutes

```typescript
declare function useRoutes(
  routes: RouteObject[],
  location?: Partial<Location> | string;
): React.ReactElement | null;
```

`useRoutes`钩子与`Route`组件是功能相等的，但它使用 JavaScript 对象而不是`Route`元素取定义你的路由。该对象与`Route`元素具有相同的属性，但是它们不需要 JSX

{% note warning %}

useRoutes 的返回值要么是一个可以让你用于渲染路由树的 React Element，要么是 null（路由不匹配时）

{% endnote %}

## react-redux hooks

首先看一个实际应用中使用`connect`的例子

```jsx
import { connect } from 'react-redux'

const Home = props=>{
    // 获取数据
    const { user, loading, dispatch } = props

    // 发起请求
    useEffect(()=>{
        dispatch({
            type:'user/fetchUser',payload:{}
        })
    }, [])

    // 渲染页面
    if(loading) return <div>loading...</div>
    return (
        <div>{user.name}<div>
    )
}

export default connect(({ loading, user })=>({
    loading:loading.effects['user/fetchUser'],
    user:user.userInfo
}))(Home)
```

现在使用`useDispatch` `useSelector`改造一下上面的代码：

```jsx
import { useDispatch, useSelector } from 'react-redux'

const Home = props => {

    const dispatch = useDispatch()

    const loadingEffect = useSelector(state =>state.loading);
    const loading = loadingEffect.effects['user/fetchUser'];
    const user = useSelector(state=>state.user.userInfo)

    // 发起请求
    useEffect(()=>{
        dispatch({
            type:'user/fetchUser',payload:{}
        })
    },[])

    // 渲染页面
    if(loading) return <div>loading...</div>
    return (
        <div>{user.name}<div>
    )
}

export default Home
```

再来说说`hooks`，它是`React-Redux`提供用来替代`connect()`高阶组件。这些`hooks` API 允许不使用`connect()`包裹组件的情况下订阅`store`和分发`actions`。

hooks 需要在函数组件中使用，不能在 React 类中使用`hooks`。

使用`hooks`和`connect`()一样，需要将应用包裹在`<Provider/>`中。

```jsx
const store = createStore(rootReducer)

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
```

### useSelector

作用：从`redux`的`store`对象中提取数据(`state`)。

注意：`selector`函数应该是个纯函数，因为可能在任何时候执行多次。

```jsx
import React from 'react'
import { useSelector } from 'react-redux'

export const CounterComponent = () => {
  const counter = useSelector(state => state.counter)
  return <div>{counter}</div>
}
```

`selector`函数被调用时将会被传入`Redux store`的整个`state`，作为唯一的参数。每次函数组件渲染时，`selector`函数都会被调用。`useSelector()`同样会订阅`Redux`的`store`，并且在分发`action`时，都会被执行一次。

`selector`和`connect`的`mapStateToProps`的差异：

- `selector`函数的返回值会被用作调用 useSelector() `hook`时的返回值，可以是任意类型的值。
- 当分发`action`时，useSelector 会将上次调用的结果与当前调用的结果进行引用（`===`）比较，不一样会进行重新渲染。
- `useSelector()`默认使用严格比较`===`来比较引用，而非浅比较。
- `selector`函数不会接收`ownProps`参数，但是`props`可以通过闭包获取使用或者通过使用柯里化的`selector`函数。

```jsx
import React from 'react'
import { useSelector } from 'react-redux'

export const TodoListItem = props => {
  const todo = useSelector(state => state.todos[props.id])
  return <div>{todo.text}</div>
}
```

在`action`被分发后，`useSelector()`对`selector`函数的返回值进行引用比较`===`，在`selector`的值改变时会触发 re-render。与`connect`不同，`useSelector()`不会阻止父组件重渲染导致的子组件重渲染的行为，即使组件的`props`没有发生改变。

如果想要进一步的性能优化，可以在`React.memo()`中包装函数组件。

```jsx
const CounterComponent = ({ name }) => {
  const counter = useSelector(state => state.counter)
  return (
    <div>
      {name}: {counter}
    </div>
  )
}

export const MemoizedCounterComponent = React.memo(CounterComponent)
```

### useDispatch

```jsx
const dispatch = useDispatch()
```

作用：返回`Redux store`中对`dispatch`函数的引用。

当使用`dispatch`函数将回调传递给子组件时，建议使用`useCallback`函数将回调函数记忆化，防止因为回调函数引用的变化导致不必要的渲染。

```jsx
import React, { useCallback, memo } from 'react'
import { useDispatch } from 'react-redux'

export const MyIncrementButton = memo(({ onIncrement }) => <button onClick={onIncrement}>Increment counter</button>)

export const Counter = ({ value }) => {
  const dispatch = useDispatch()
  const incrementCounter = useCallback(() => dispatch({ type: 'increment-counter' }), [dispatch])

  return (
    <div>
      <span>{value}</span>
      <MyIncrementButton onIncrement={incrementCounter} />
    </div>
  )
}
```

### useStore()

```jsx
const store = useStore()
```

作用：返回传递给组件的 `Redux store` 的引用。

注意：应该将`useSelector()`作为首选，只有在个别场景下才会需要使用它，比如替换 `store` 的 `reducers`。

```jsx
import React from 'react'
import { useStore } from 'react-redux'

export const Counter = ({ value }) => {
  const store = useStore()

  return <div>{store.getState()}</div>
}
```

## hook 进阶

react hook 工作当中也用了一段时间了，中间踩过一些坑，针对不同 `hook` 的特点，进行总结。

- 两个 `state` 是关联或者需要一起发生改变，可以放在同一个 `state`，但不要太多
- 当 `state` 的更新逻辑比较复杂的时候则可以考虑使用 `useReducer` 代替
- `useEffect`、`useLayoutEffect`、`useMemo`、`useCallback`、`useImperativeHandle` 中依赖数组依赖项最好不要太多，太多则考虑拆分一下，感觉不超 3 到 4 个会比较合适。
- 去掉不必要的依赖项
- 合并相关的 `state` 为一个
- 通过 `setState` 回到函数方式去更新 `state`
- 按照不同维度这个 hook 还能不能拆分的更细
- `useMemo` 多用于对 `React` 元素做 `memorize` 处理或者需要复杂计算得出的值，对于简单纯 js 计算就不要进行 `useMemo` 处理了。
- useCallback 要配合`memo`使用
