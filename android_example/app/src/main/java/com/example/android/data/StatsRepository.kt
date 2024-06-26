package com.example.android.data

import androidx.lifecycle.LiveData
import com.example.room.entity.TodoListInfo
import com.example.room.manager.DataBaseManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.withContext
import java.util.Random

/**
 * @author lky
 * @date   2024/3/11
 * @desc   状态页请求仓库
 */
class StatsRepository {

    /**
     * 获取待办列表,返回Flow数据流
     */
    suspend fun getTodoListFlow(): Flow<MutableList<TodoListInfo>>? {
        return withContext(Dispatchers.IO) {
            DataBaseManager.getTodoListFlow()
        }
    }

    /**
     * 根据 id 获取条目
     */
    suspend fun getTodoListFlow(id: Long): Flow<TodoListInfo>? {
        return withContext(Dispatchers.IO) {
            DataBaseManager.getTodoItemById(id)
        }
    }

    /**
     * 根据 id 删除条目
     */
    suspend fun deleteTodoItemById(id: Long) : Int {
        return withContext(Dispatchers.IO) {
            DataBaseManager.deleteTodoItemById(id)
        }
    }

    /**
     * 插入新条目
     */
    suspend fun insertTodoItem(todoListInfo: TodoListInfo):Long {
        return DataBaseManager.insertTodoItem(todoListInfo)
    }

    /**
     * 添加一个完成状态的条目
     */
    suspend fun addCompleteItem() {
        val random = Random()
        val randomChar = (random.nextInt(26).plus('A'.code)).toChar()
        val randomChar2 = random.nextInt(1000)
        withContext(Dispatchers.IO) {
            val todoListInfo = TodoListInfo()
            todoListInfo.title =
                randomChar.toString() + randomChar.toString() + randomChar.toString() + randomChar2
            todoListInfo.desc = randomChar.toLowerCase().toString() + randomChar.toLowerCase()
                .toString() + randomChar.toLowerCase().toString() + randomChar2
            todoListInfo.completed = true
            todoListInfo.createTime = System.currentTimeMillis().toString()
            DataBaseManager.insertTodoItem(todoListInfo)
        }
    }

    /**
     * 添加一个未完成状态的条目
     */
    suspend fun addActiveItem() {
        val random = Random()
        val randomChar = (random.nextInt(26).plus('A'.code)).toChar()
        val randomChar2 = random.nextInt(1000)
        withContext(Dispatchers.IO) {
            val todoListInfo = TodoListInfo()
            todoListInfo.title =
                randomChar.toString() + randomChar.toString() + randomChar.toString()+ randomChar2
            todoListInfo.desc = randomChar.toLowerCase().toString() + randomChar.toLowerCase()
                .toString() + randomChar.toLowerCase().toString() + randomChar2
            todoListInfo.createTime = System.currentTimeMillis().toString()
            DataBaseManager.insertTodoItem(todoListInfo)
        }
    }

    /**
     * 清空代办列表
     */
    suspend fun clearTodoList() {
        withContext(Dispatchers.IO) {
            DataBaseManager.clearTodoList {}
        }
    }

    /**
     * 标记全部完成或未完成
     */
    suspend fun updateTodoItems(
        todoListValue: MutableList<TodoListInfo>,
        toMarkAllCompleted: Boolean
    ) {
        todoListValue.map {
            if (toMarkAllCompleted) {
                if (!it.completed) {
                    it.completed = true
                }
            } else {
                if (it.completed) {
                    it.completed = false
                }
            }
        }
        withContext(Dispatchers.IO) {
            DataBaseManager.updateTodoItems(todoListValue.toTypedArray())
        }
    }

    /**
     * 根据todoListInfo更新Item
     * @param todoListInfo
     */
    suspend fun updateTodoItem(todoListInfo: TodoListInfo) :Int{
        return DataBaseManager.updateTodoItem(todoListInfo)
    }

    /**
     * 修改一个条目状态
     */
    suspend fun updateTodoItems(bean: TodoListInfo) : Int {
        return withContext(Dispatchers.IO) {
            DataBaseManager.updateTodoItem(bean)
        }
    }

    /**
     * 清空所有完成状态的条目
     */
    suspend fun clearCompleted(status: Boolean) {
        withContext(Dispatchers.IO) {
            DataBaseManager.clearCompleted(status)
        }
    }

}