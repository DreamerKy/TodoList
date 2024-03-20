package com.example.room.manager

import androidx.lifecycle.LiveData
import com.example.room.database.TodoListDataBase
import com.example.room.entity.TodoListInfo
import kotlinx.coroutines.flow.Flow

/**
 * @author lky
 * @date   2024/3/7
 * @desc   缓存管理类
 * 操作数据库的方法都用了 suspend 关键字修饰，提示调用者必须在协程作用域中调用
 */
object DataBaseManager {

    private val todoListDao by lazy { TodoListDataBase.getInstance().todoListDao() }

    /**
     * 保存列表数据
     */
    suspend fun saveTodoList(list: MutableList<TodoListInfo>) {
        todoListDao.insertAll(list)
    }

    /**
     * 插入一条数据
     * @param todoListInfo
     */
    suspend fun insertTodoItem(todoListInfo: TodoListInfo):Long {
       return todoListDao.insert(todoListInfo)
    }

    /**
     * 根据id删除Item
     * @param id
     */
    suspend fun deleteTodoItemById(id: Long):Int {
        return todoListDao.deleteById(id)
    }

    /**
     * 根据todoListInfo删除Item
     * @param todoListInfo
     */
    suspend fun deleteTodoItem(todoListInfo: TodoListInfo) {
        todoListDao.delete(todoListInfo)
    }

    /**
     * 根据todoListInfo更新Item
     * @param todoListInfo
     */
    suspend fun updateTodoItem(todoListInfo: TodoListInfo) :Int{
       return todoListDao.update(todoListInfo)
    }

    /**
     * 根据todoListInfo更新Item
     * @param todoListInfo
     */
    suspend fun updateTodoItems(todoListInfo: Array<TodoListInfo>) :Int{
        return todoListDao.updateTodos(*todoListInfo)
    }

    /**
     * 根据id获取Item
     * @param id
     */
    suspend fun getTodoItemById(id: Long): TodoListInfo? {
        return todoListDao.query(id)
    }

    /**
     * 获取特定状态的列表
     */
    fun getTodoListByStatus(status:Boolean): LiveData<MutableList<TodoListInfo>>? {
        return todoListDao.queryByStatus(status)
    }

    /**
     * 获取待办列表
     */
    fun getTodoList(): LiveData<MutableList<TodoListInfo>>? {
        return todoListDao.queryAllLiveData()
    }

    /**
     * 获取待办列表
     */
    fun getTodoListFlow(): Flow<MutableList<TodoListInfo>>? {
        return todoListDao.queryAllFlow()
    }

    /**
     * 清除已完成
     * @param callBack
     */
    suspend fun clearCompleted(status: Boolean): Int {
        return todoListDao.deleteByStatus(status)
    }

    /**
     * 清除列表缓存
     * @param callBack
     */
    suspend fun clearTodoList(callBack: (String) -> Unit):Int {
       val result =  todoListDao.deleteAll()
        callBack("删除成功")
        return result
    }
}