

- State：逻辑和UI相关的状态集合
- Action：动作集合，用户操作、通知、事件等
- Reducer：用于接收action和执行状态转换，TCA架构中仅能在Reducer中进行状态转换。Reducer创建时需要传入一个闭包，用于接收action，并将响应逻辑写在闭包中，闭包需要返回一个Effect。如果没有额外的任务，可以返回`.none`，如果有其他任务比如网络请求，则需要构建一个Effect。
- Effect
- Environment
- Store：store是TCA的中枢，任何action都被send to Store，由store执行reducer和effect。可以观察store（ViewStore）中的状态变化来修改UI。
- ViewStore



Reducer操作符

- pullback：将local state、action、environment转换为global state、action、environment。`pullback`的返回值类型为`Reducer<GlobalState, GlobalAction, GlobalEnvironment>`，因此`pullback`实际上相当于创建了一个新的reducer，只不过是通过将已有的local reducer经过keypath和casepath的映射来生成新的global reducer。

  常用于将一个大的reducer拆成若干小reducers后再进行组合，先pullback将每个reducer中待使用的state和action抽取出来，再combine合成一个大的reducer。

  ```swift
  let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    settingsReducer.pullback(
      state: \.settings,
      action: /AppAction.settings,
      environment: { $0.settings }
    ),
    /* other reducers */
  )
  ```

- combine：将多个reducer合并为一个。

- optional：将只能处理non-optional state的reducer转换为可以处理optional state，转换后仅当state为non-nil时才会运行non-optional版本的reducer。可以看到该方法的返回值为`Reducer<State?, Action, Environment>`。

  经常会和`pullback`一起使用

Store操作符

- scope：将global state转换为local state，将local action转换为global action，适合使用已有的state、action和view来组合生成新的state、action、view。

  **为什么对于state和action的转换方向相反？**

  TCA中信息流动方向：state->view->action->reducer->state

  在state->view过程中，由于view为已存在的view，而state为组合后产生的新state，即global state，因此需要转换为local state供view使用。而在action->reducer过程中，获取到的是local action，而持有的reducer为组合后产生的global，需要将local action转换为global action。

ViewStore

- binding：该方法用来以TCA的方式适配SwiftUI中的双向绑定，SwiftUI的双向绑定使得对值的修改比较随意。而TCA架构要求status只能由reducer来修改，Store无法对state直接写入，Store的功能仅为获取state、发送actions。binding方法用来指定读取status和send actions的行为，适合用来处理SwiftUI中需要借助双向绑定实现的控件，比如代码示例01-Animation中的Toggle。

  该方法返回值为`Binding<LocalState>`，从实现中可以看到，设置了get和set发生时要执行的动作。使用local state作为get返回值，而set则是send action。

  ```swift
  Binding(
      get: { get(self.state) },
      set: { newLocalState, transaction in
          if transaction.animation != nil {
            withTransaction(transaction) {
              self.send(localStateToViewAction(newLocalState))
            }
          } else {
            self.send(localStateToViewAction(newLocalState))
          }
      }
  )
  ```

  TCA架构要求信息流动为单向

- send：向store发送action，非线程安全，如果有必要将任务放到后台线程，需要包装为Effect。

Alert & Sheet

TCA的信息流动为单向，SwiftUI的双向绑定无法使用，因此无法使用标准API生成alert和sheet，TCA提供了`AlertState`和`ActionSheetState`，以及`.alert`和`.actionSheet`两个方法来生成alert和sheet