---
title: ReactHooks
date: 2021-01-04 21:36:01
index_img: https://fang-kang.gitee.io/blog-img/20200102135816.jpg-slim
sticky: 1
tags:
 - react
categories:
 -  react
---

# 概念

- React Hook 是 React 16.8 的新增特性。它可以让你在不编写 class 的情况下使用 state 以及其他的 React 特性；
- 以前在编写函数式组件，组件需要自己的 state 的时候，通常我们会转化成 class 组件来做。现在可以在函数组件中使用 Hook 来实现；

# 解决的问题

- 组件之间复用状态逻辑很难，可能要用到 render props 和高阶组件，React 需要为共享状态逻辑提供更好的原生途径，Hook 可以在无需修改组件结构的情况下复用状态逻辑；
- 复杂组件难以理解，Hook 将组件中相互关联的部分拆分成更小的函数（比如设置订阅或请求数据）；
- 难以理解的 class 以及捉摸不透的 this；

# 遵循的规则

- 只能在函数最外层调用 Hook，不要在循环、条件判断或者子函数中调用；
- 只能在 React 的函数组件中调用 Hook，不要在其他 JavaScript 函数中调用；

# Hooks API

下面开始使用一下经常用到的 Hooks。新建一个项目，用来写例子。



```bash
npx create-react-app react-hooks
cd react-hooks
yarn start
```

删掉src下多余的文件，只保留 index.js。

## useState

- 给函数组件添加内部 state，React 会在重复渲染时保留这个 state；
- useState 返回一对值：当前状态和更新状态的函数，在事件处理函数中或其他地方调用这个函数。它类似 class 组件的 this.setState，但是它不会将新旧 state进行合并；
- 在初始渲染期间，返回的状态 (state) 与传入的第一个参数 (initialState) 值相同
   setState 函数用于更新 state。它接收一个新的 state 值并将组件的一次重新渲染加入队列
   `const [state, setState] = useState(initialState);`

### 1:对比类的写法和函数组件



```jsx
import React, { useState } from 'react';
import ReactDOM from 'react-dom';

class Counter1 extends React.Component {
  constructor() {
    super();
    this.state = {
      number: 0
    }
  }
  add = () => {
    const { number } = this.state
    this.setState({
      number: number + 1
    })
  }
  render() {
    const { number } = this.state
    return (
      <div className="counter">
        <p>counter: {number}</p>
        <button onClick={this.add}>add +</button>
      </div>
    )
  }
}

function Counter() {
  const [number, setNum] = useState(0)
  return (
    <div className="counter">
      <p>counter: {number}</p>
      <button onClick={() => setNum(number + 1)}>add +</button>
    </div>
  )
}

ReactDOM.render(
  // <Counter />,
  <Counter1 />,
  document.getElementById('root')
);
```

### 2.每次的渲染都是独立的闭包

- 每一次渲染都有它自己的 Props and State
- 每一次渲染都有它自己的事件处理函数
- alert会“捕获”点击按钮时候的状态
- 函数组件每次渲染都会被调用，但是每一次调用中 number 值都是常量，并且它被赋予了当前渲染中的状态值
- 在单次渲染的范围内，props和state始终保持不变
- 这个链接里面的案例[making-setinterval-declarative-with-react-hooks](https://links.jianshu.com/go?to=https%3A%2F%2Foverreacted.io%2Fmaking-setinterval-declarative-with-react-hooks%2F)可以拿出来试试。



```jsx
function Counter2(){
  const [number,setNumber] = useState(0);
  function alertNumber(){
    setTimeout(()=>{
      alert(number);
    },3000);
  }
  return (
      <>
          <p>{number}</p>
          <button onClick={()=>setNumber(number+1)}>+</button>
          <button onClick={alertNumber}>alertNumber</button>
      </>
  )
}
```

这里 alert 出来的是点击时候的 number 值，如果一直点，并不是最新的值。

### 3.函数式更新

- 如果新的 state 需要通过使用先前的 state 计算得出，那么可以将函数传递给 setState。该函数将接收先前的 state，并返回一个更新后的值。这样每次拿到都是最新的状态值。
   运行如下代码：



```jsx
// 函数式更新
function Counter2(){
  const [number, setNum] = useState(0);
  const lazyAdd = () => {
    setTimeout(() => {
      setNum(number + 1)
    }, 3000) 
  }
  const lazyFunction = () => {
    setTimeout(() => {
      setNum(number => number + 1)
    }, 3000);
  }
  return (
    <div className="counter">
      <p>counter: {number}</p>
      <button onClick={() => setNum(number + 1)}>add +</button>
      <button onClick={lazyAdd}>lazy add</button>
      <button onClick={lazyFunction}>lazy function</button>
    </div>
  )
}
```

setState 更新状态的函数参数可以是一个函数，返回新状态：
 `setNum(number => number + 1)`每次都返回最新的状态，然后再加1。

### 4.惰性初始 state

- initialState 参数只会在组件的初始渲染中起作用，后续渲染时会被忽略
- 如果初始 state 需要通过复杂计算获得，则可以传入一个函数，在函数中计算并返回初始的 state，此函数只在初始渲染时被调用
- 与 class 组件中的 setState 方法不同，useState 不会自动合并更新对象。可以用函数式的 setState 结合展开运算符来达到合并更新对象的效果



```jsx
function Counter3(){
  const [userInfo, setUserInfo] = useState(() => {
    return {
      name: 'mxcz',
      age: 18
    }
  });
  return (
    <div className="counter">
      <p>{userInfo.name}: {userInfo.age}</p>
      <button onClick={() => setUserInfo({age: userInfo.age + 1})}>add +</button>
      <button onClick={() => setUserInfo({...userInfo, age: userInfo.age + 1})}>更新要写完整</button>
    </div>
  )
}
```

### 5.性能优化

#### 5.1 Object.is()

- 调用 State Hook 的更新函数并传入当前的 state 时，React 将跳过子组件的渲染及 effect 的执行。（React 使用 Object.is 比较算法 来比较 state。）



```jsx
function Counter4(){
  const [counter,setCounter] = useState({name:'计数器',number:0});
  console.log('render Counter')
  return (
      <>
          <p>{counter.name}:{counter.number}</p>
          <button onClick={()=>setCounter({...counter,number:counter.number+1})}>+</button>
          <button onClick={()=>setCounter(counter)}>-</button>
      </>
  )
}
```

增加数值之后，在减，不会引起组件的重新渲染，因为Object.is（`Object.is()` 方法判断两个值是否为[同一个值](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FJavaScript%2FEquality_comparisons_and_sameness)。） 比较算法表示state没有改变。

#### 5.2 减少渲染次数

- 把内联回调函数及依赖项数组作为参数传入 useCallback，它将返回该回调函数的 memoized (记忆)版本，该回调函数仅在某个依赖项改变时才会更新；
- 把创建函数和依赖项数组作为参数传入 useMemo，它仅会在某个依赖项改变时才重新计算 memoized 值。这种优化有助于避免在每次渲染时都进行高开销的计算；



```jsx
function Child({onButtonClick,data}){
  console.log('Child render');
  return (
    <button onClick={onButtonClick} >{data.number}</button>
  )
}
function App(){
  const [number,setNumber] = useState(0);
  const [name,setName] = useState('mxcz');
  const addClick = () => setNumber(number+1)
  const data = { number }
  return (
    <div>
      <input type="text" value={name} onChange={e=>setName(e.target.value)}/>
      <Child onButtonClick={addClick} data={data}/>
    </div>
  )
}
```

可以看到不优化的情况下，点击按钮和改变输入框的值都会引起子组件的重新渲染，但是子组件依赖的数据只有数字改变而已；

![img](https:////upload-images.jianshu.io/upload_images/5541401-0a79e84d6fc5b219.png?imageMogr2/auto-orient/strip|imageView2/2/w/1066/format/webp)


 现在来改造一下，给子组件加上`Child = memo(Child);`返回一个记忆组件，此时再点击按钮和改变输入框，依然会重新渲染子组件，这里的原因是子组件调用了父组件传递来的会调函数，这个函数在父组件渲染时，都会重新建立新的函数引用，下面来验证一下：





```jsx
let oldClick;
function App(){
  const [number,setNumber] = useState(0);
  const [name,setName] = useState('mxcz');
  const addClick = () => setNumber(number+1)
  console.log('oldClick === addClick', oldClick === addClick)
  oldClick = addClick
  const data = { number }
  return (
    <div>
      <input type="text" value={name} onChange={e=>setName(e.target.value)}/>
      <Child onButtonClick={addClick} data={data}/>
    </div>
  )
}
```



![img](https:////upload-images.jianshu.io/upload_images/5541401-115102802a255b34.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


 每次渲染都重新返回了false，表示每次都是新的函数，现在改造一下，`const addClick = useCallback(()=>setNumber(number+1),[number]);`

![img](https:////upload-images.jianshu.io/upload_images/5541401-7cabf5cc82885208.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


 可以看到，给回调函数加上useCallback，点击按钮每次都是false，说明都是依赖的number改变了，函数是新的函数，而改变输入框的值，返回true，说明函数被缓存起来了，并没有重新创建函数。而此时chid组件依然被渲染了，因为data 改变了，现在将data用useMemo包起来`const data = useMemo(()=>({number}),[number]);`，再来运行一遍：

![img](https:////upload-images.jianshu.io/upload_images/5541401-96b1e5e54fe4d8d3.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


 此时的子组件在输入框改变时并没有被重新渲染。现在子组件不用memo包装，可以看到子组件还是在输入框改变值的时候被重新渲染了。

![img](https:////upload-images.jianshu.io/upload_images/5541401-a92cfa65ee0a01a7.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)


 例子的完整代码如下：





```jsx
function Child({onButtonClick,data}){
  console.log('Child render');
  return (
    <button onClick={onButtonClick} >{data.number}</button>
  )
}
Child = memo(Child);
let oldClick;
function App(){
  const [number,setNumber] = useState(0);
  const [name,setName] = useState('mxcz');
  const addClick = useCallback(()=>setNumber(number+1),[number]);
  const data = useMemo(()=>({number}),[number]);
  // const addClick = () => setNumber(number+1)
  console.log('oldClick === addClick', oldClick === addClick)
  oldClick = addClick
  // const data = { number }
  return (
    <div>
      <input type="text" value={name} onChange={e=>setName(e.target.value)}/>
      <Child onButtonClick={addClick} data={data}/>
    </div>
  )
}
```

### 6.注意事项

- 只能在函数最外层调用 Hook。不要在循环、条件判断或者子函数中调用。



```jsx
function App2() {
  const [number, setNumber] = useState(0);
  const [visible, setVisible] = useState(false);
  if (number % 2 == 0) {
      useEffect(() => {
          setVisible(true);
      }, [number]);
  } else {
      useEffect(() => {
          setVisible(false);
      }, [number]);
  }
  return (
      <div>
          <p>{number}</p>
          <div>{visible && <div>visible</div>}</div>
          <button onClick={() => setNumber(number + 1)}>+</button>
      </div>
  )
}
```

可以看到报错了：
 `React Hook "useEffect" is called conditionally. React Hooks must be called in the exact same order in every component render react-hooks/rules-of-hooks`
 报错说：useEffect 在条件语句中被调用，在每次的组件渲染中，必须要以完全相同的顺序调用 React Hooks。条件不同，每次渲染的顺序不同，这就会乱了，应该是跟链表的结构相关吧，总之要遵循 React Hooks的使用原则。

## useReducer

- useState 的替代方案。它接收一个形如 (state, action) => newState 的 reducer，并返回当前的 state 以及与其配套的 dispatch 方法；
   `const [state, dispatch] = useReducer(reducer, initialArg, init);`
- 在某些场景下，useReducer 会比 useState 更适用，例如 state 逻辑较复杂且包含多个子值，或者下一个 state 依赖于之前的 state 等；
   useReducer 用法和 Redux 用法是一样。



```jsx
const initialState = 0;

function reducer(state, action) {
  switch (action.type) {
    case 'increment':
      return {number: state.number + 1};
    case 'decrement':
      return {number: state.number - 1};
    default:
      throw new Error();
  }
}
function init(initialState){
  return {number: initialState};
}
function App3(){
  const [state, dispatch] = useReducer(reducer, initialState, init);
  return (
    <>
      Count: {state.number}
      <button onClick={() => dispatch({type: 'increment'})}>+</button>
      <button onClick={() => dispatch({type: 'decrement'})}>-</button>
    </>
  )
}
```

## useContext

- 接收一个 context 对象（React.createContext 的返回值）并返回该 context 的当前值；
- 当前的 context 值由上层组件中距离当前组件最近的 <MyContext.Provider> 的 value prop 决定；
- 当组件上层最近的 <MyContext.Provider> 更新时，该 Hook 会触发重渲染，并使用最新传递给 MyContext provider 的 context value 值
- useContext(MyContext) 相当于 class 组件中的 static contextType = MyContext 或者 <MyContext.Consumer>
- useContext(MyContext) 只是更方便的读取 context 的值以及订阅 context 的变化。还是需要在上层组件树中使用 <MyContext.Provider> 来为下层组件提供 context



```jsx
const CounterContext = React.createContext();
function reducer2(state, action) {
  switch (action.type) {
    case 'increment':
      return {number: state.number + 1};
    case 'decrement':
      return {number: state.number - 1};
    default:
      throw new Error();
  }
}
function Counter5(){
  let {state,dispatch} = useContext(CounterContext);
  return (
    <>
      <p>{state.number}</p>
      <button onClick={() => dispatch({type: 'increment'})}>+</button>
      <button onClick={() => dispatch({type: 'decrement'})}>-</button>
    </>
  )
}
function App4(){
  const [state, dispatch] = useReducer(reducer2, {number:0});
  return (
      <CounterContext.Provider value={{state,dispatch}}>
          <Counter5 />
      </CounterContext.Provider>
  )
}
```

## effect

- 在函数组件主体内（即在 React 渲染阶段）改变 DOM、添加订阅、设置定时器、记录日志以及执行其他包含副作用的操作都是不被允许的，因为这可能会产生莫名其妙的 bug 并破坏 UI 的一致性；
- 使用 useEffect 完成副作用操作。赋值给 useEffect 的函数会在组件渲染到屏幕之后执行；
- useEffect 就是一个 Effect Hook，给函数组件增加了操作副作用的能力。它跟 class 组件中的 `componentDidMount`、`componentDidUpdate` 和 `componentWillUnmount` 具有相同的用途，只不过被合并成了一个 API；
- 该 Hook 接收一个包含命令式、且可能有副作用代码的函数
   `useEffect(didUpdate)`

### 1.修改document的标题，class的实现方式



```jsx
class Title extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      number: 0
    };
  }
  componentDidMount() {
      document.title = `点击了${this.state.number}次`;
  }
  componentDidUpdate() {
      document.title = `点击了${this.state.number}次`;
  }
  render() {
    return (
      <div>
        <p>{this.state.number}</p>
        <button onClick={() => this.setState({ number: this.state.number + 1 })}>
          +
        </button>
      </div>
    );
  }
}
```

> 在这个 class 中，需要在两个生命周期函数中编写重复的代码,这是因为很多情况下，我们希望在组件加载和更新时执行同样的操作。我们希望它在每次渲染之后执行，但 React 的 class 组件没有提供这样的方法。即使我们提取出一个方法，我们还是要在两个地方调用它。useEffect会在第一次渲染之后和每次更新之后都会执行。
>  下面是函数组件，使用useEffect的方式：



```jsx
function Title2(){
  const [number,setNumber] = useState(0);
  // 相当于 componentDidMount 和 componentDidUpdate:
  useEffect(() => {
    document.title = `你点击了${number}次`;
  });
  return (
    <>
      <p>{number}</p>
      <button onClick={()=>setNumber(number+1)}>+</button>
    </>
  )
}
```

> 每次组件重新渲染，都会生成新的 effect，替换掉之前的。某种意义上讲，effect 更像是渲染结果的一部分 —— 每个 effect 属于一次特定的渲染。

### 2.跳过 Effect 进行性能优化

- 如果某些特定值在两次重渲染之间没有发生变化，你可以通知 React 跳过对 effect 的调用，只要传递数组作为 useEffect 的第二个可选参数即可
- 如果想执行只运行一次的 effect（仅在组件挂载和卸载时执行），可以传递一个空数组（`[]`）作为第二个参数。这就告诉 React 这个 effect 不依赖于 props 或 state 中的任何值，所以它永远都不需要重复执行



```jsx
function Counter6(){
  const [number,setNumber] = useState(0);
  useEffect(() => {
     console.log('开启一个新的定时器')
     const $timer = setInterval(()=>{
      setNumber(number=>number+1);
     },1000);
  },[]);
  return (
    <p>{number}</p>
  )
}
```

### 3.清除副作用

- 副作用函数还可以通过返回一个函数来指定如何清除副作用
- 为防止内存泄漏，清除函数会在组件卸载前执行。另外，如果组件多次渲染，则在执行下一个 effect 之前，上一个 effect 就已被清除



```jsx
function Counter7() {
  const [number, setNumber] = useState(0);
  useEffect(() => {
      console.log('开启一个新的定时器')
      const $timer = setInterval(() => {
          setNumber(number => number + 1);
      }, 1000);
      return () => {
          console.log('销毁老的定时器');
          clearInterval($timer);
      }
  });
  return (
      <p>{number}</p>
  )
}
function App5() {
  let [visible, setVisible] = useState(true);
  return (
      <div>
          {visible && <Counter7 />}
          <button onClick={() => setVisible(false)}>stop</button>
      </div>
  )
}
```

## useRef

- useRef 返回一个可变的 ref 对象，其 .current 属性被初始化为传入的参数（initialValue）
- 返回的 ref 对象在组件的整个生命周期内保持不变
   `const refContainer = useRef(initialValue);`



```php
function Parent() {
  let [number, setNumber] = useState(0);
  return (
      <>
          <Child2 />
          <button onClick={() => setNumber({ number: number + 1 })}>+</button>
      </>
  )
}
let input;
function Child2() {
  const inputRef = useRef();
  console.log('input===inputRef', input === inputRef);
  input = inputRef;
  function getFocus() {
      inputRef.current.focus();
  }
  return (
      <>
          <input type="text" ref={inputRef} />
          <button onClick={getFocus}>获得焦点</button>
      </>
  )
}
```

### forwardRef

- 将ref从父组件中转发到子组件中的dom元素上
- 子组件接受 props 和 ref 作为参数



```php
function Child3(props,ref){
  return (
    <input type="text" ref={ref}/>
  )
}
Child3 = forwardRef(Child3);
function Parent2(){
  let [number,setNumber] = useState(0); 
  const inputRef = useRef();
  function getFocus(){
    inputRef.current.value = 'focus';
    inputRef.current.focus();
  }
  return (
      <>
        <Child3 ref={inputRef}/>
        <button onClick={()=>setNumber({number:number+1})}>+</button>
        <button onClick={getFocus}>获得焦点</button>
      </>
  )
}
```

### useImperativeHandle

- useImperativeHandle 可以让你在使用 ref 时自定义暴露给父组件的实例值
- 在大多数情况下，应当避免使用 ref 这样的命令式代码。useImperativeHandle 应当与 forwardRef 一起使用
   如下官网的很经典的例子：



```php
function Child4(props,ref){
  const inputRef = useRef();
  useImperativeHandle(ref,()=>(
    {
      focus(){
        inputRef.current.focus();
      }
    }
  ));
  return (
    <input type="text" ref={inputRef}/>
  )
}
Child4 = forwardRef(Child4);
function Parent3(){
  let [number,setNumber] = useState(0);
  const inputRef = useRef();
  function getFocus(){
    console.log(inputRef.current);
    inputRef.current.value = 'focus';
    inputRef.current.focus();
  }
  return (
    <>
      <Child4 ref={inputRef}/>
      <button onClick={()=>setNumber({number:number+1})}>+</button>
      <button onClick={getFocus}>获得焦点</button>
    </>
  )
}
```

这样父组件中只可以操作子组件暴露给父组件的方法。

## useLayoutEffect

- 其函数签名与 useEffect 相同，但它会在所有的 DOM 变更之后同步调用 effect
- 可以使用它来读取 DOM 布局并同步触发重新渲染
- 在浏览器执行绘制之前useLayoutEffect内部的更新计划将被同步刷新
- 尽可能使用标准的 useEffect 以避免阻塞视图更新
   useLayoutEffect 会在 useEffect 之前执行。



```jsx
function LayoutEffect() {
  const [color, setColor] = useState('red');
  useLayoutEffect(() => {
      console.log(color);
  });
  useEffect(() => {
      console.log('color', color);
  });
  return (
      <>
          <div id="myDiv" style={{ background: color }}>颜色</div>
          <button onClick={() => setColor('red')}>红</button>
          <button onClick={() => setColor('yellow')}>黄</button>
          <button onClick={() => setColor('blue')}>蓝</button>
      </>
  );
}
```

## 自定义 Hook

- 有时候我们会想要在组件之间重用一些状态逻辑；
- 自定义 Hook 可以让你在不增加组件的情况下达到同样的目的；
- Hook 是一种复用状态逻辑的方式，它不复用 state 本身；
- 事实上 Hook 的每次调用都有一个完全独立的 state；
- 自定义 Hook 更像是一种约定，而不是一种功能。如果函数的名字以 use 开头，并且调用了其他的 Hook，则就称其为一个自定义 Hook；

### 1.自定义一个计数器



```jsx
function useNumber(initNumber){
  const [number, setNumber] = useState(initNumber || 0)
  useEffect(() => {
    const $timer = setInterval(() => {
      setNumber(number => number + 1)
    }, 1000)
    return () => {
      clearInterval($timer)
    }
  }, [number])
  return number
}

function App6(){
  const number = useNumber(4)
  return(
    <p>{ number }</p>
  )
}
```

### 2. 日志中间件



```jsx
const initState = 0;

function countReducer(state, action) {
    switch (action.type) {
        case 'increment':
            return { number: state.number + 1 };
        case 'decrement':
            return { number: state.number - 1 };
        default:
            throw new Error();
    }
}
function initFun(initState) {
    return { number: initState };
}
function useLogger(reducer, initialState, init) {
    const [state, dispatch] = useReducer(reducer, initialState, init);
    let dispatchWithLogger = (action) => {
        console.log('老状态', state);
        dispatch(action);
    }
    useEffect(function () {
        console.log('新状态', state);
    }, [state]);
    return [state, dispatchWithLogger];
}
function Counter8() {
    const [state, dispatch] = useLogger(countReducer, initState, initFun);
    return (
        <>
            Count: {state.number}
            <button onClick={() => dispatch({ type: 'increment' })}>+</button>
            <button onClick={() => dispatch({ type: 'decrement' })}>-</button>
        </>
    )
}
```

## 路由hook

- useParams：获取路由中的params
- useLocation：查看当前路由
- useHistory：返回上一个路由
- useRouteMatch：尝试以与Route相同的方式匹配当前URL，在无需实际呈现Route的情况下访问匹配数据最有用



```jsx
import { BrowserRouter as Router, Route, Switch, useParams, useLocation, useHistory } from "react-router-dom";
function Post() {
   let { title } = useParams();
   const location = useLocation();
   let history = useHistory();
   return <div>
              {title}<hr />{JSON.stringify(location)}
             <button type="button" onClick={() => history.goBack()}>回去</button>
          </div>;
}
ReactDOM.render(
<Router>
    <div>
      <Switch>
        <Route path="/post/:title" component={Post} />
      </Switch>
    </div>
  </Router>,
document.getElementById("root")
);
```



```jsx
import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route, useRouteMatch } from 'react-router-dom';
function NotFound() {
  return <div>Not Found</div>
}
function Post(props) {
  return (
    <div>{props.match.params.title}</div>
  )
}
function App() {
  let match = useRouteMatch({
    path: '/post/:title',
    strict: true,
    sensitive: true
  })
  console.log(match);
  return (
    <div>
      {match ? <Post match={match} /> : <NotFound />}
    </div>
  )
}

ReactDOM.render(
  <Router>
    <App />
  </Router>,
  document.getElementById("root")
);
```