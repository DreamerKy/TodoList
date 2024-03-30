# TodoList
# android_example

### 项目介绍： 
旨在探索如何开发出可扩展、好维护的项目，整体遵循官方推荐使用的 UDF(Unidirectional Data Flow)，即单向数据流架构，状态仅朝一个方向流动，事件朝相反方向流动，有助于实现以下几点：
1. 数据一致性（界面只有一个可信来源）
2. 可测试性（状态来源是独立的，因此可独立于界面进行测试）
3. 可维护性（状态的更改遵循明确定义的模式，即状态更改是用户事件及其数据拉取来源共同作用的结果）

### 项目架构
1. 采用 Kotlin 语言编写，结合 Jetpack 相关控件，`Lifecyle`，`DataBinding`，`LiveData`，`Flow`，`ViewModel`等搭建的 **MVVM** 架构模式；
2. 通过 **模块化**拆分，实现项目更好解耦和复用；
3. 使用 **协程+Room** 地实现本地数据存储和获取；
![Screenshot_20240327_164927](https://github.com/DreamerKy/TodoList/assets/24971143/0e74b8dd-377c-46cd-ae7e-58fe9b73b60d) ![Screenshot_20240327_164950](https://github.com/DreamerKy/TodoList/assets/24971143/c0aedf5b-98a8-4e73-a544-858cc30ef385)

