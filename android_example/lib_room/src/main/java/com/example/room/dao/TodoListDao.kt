package com.example.room.dao

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.example.room.constant.TABLE_TODO_LIST
import com.example.room.entity.TodoListInfo
import kotlinx.coroutines.flow.Flow

/**
 * @author lky
 * @date   2024/3/7
 * @desc   定义增删改查
 */

@Dao
interface TodoListDao {

    /**
     * 插入单个数据
     * entity操作的表，OnConflictStrategy冲突策略，
     * ABORT:终止本次操作
     * IGNORE:忽略本次操作，也终止
     * REPLACE:覆盖老数据
     * @return Long 成功插入的行的主键或者是插入的行数
     */
    @Insert(entity = TodoListInfo::class, onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(todoListInfo: TodoListInfo):Long //这条对象新的数据，id已经存在了这个表当中，此时就会发生冲突

    /**
     * 插入多个数据
     * @param todoList MutableList<TodoListInfo>
     * @return List<Long> 成功插入的行的主键或者是插入的行数
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(todoList: MutableList<TodoListInfo>):List<Long>

    /**
     * 根据id删除数据
     * @return Int 成功删除行数
     */
    @Query("DELETE FROM $TABLE_TODO_LIST WHERE id=:id")
    suspend fun deleteById(id: Long):Int

    /**
     * 删除已完成状态的记录
     * @return Int 成功删除行数
     */
    @Query("DELETE FROM $TABLE_TODO_LIST WHERE completed=:isCompleted")
    suspend fun deleteCompleted(isCompleted: Boolean)

    /**
     * 删除指定item
     * 使用主键将传递的实体实例与数据库中的行进行匹配。如果没有具有相同主键的行，则不会进行任何更改
     * @return Int 成功删除行数
     */
    @Delete
    suspend fun delete(todoListInfo: TodoListInfo): Int

    /**
     * 删除表中所有数据
     * @return Int 成功删除行数
     */
    @Query("DELETE FROM $TABLE_TODO_LIST")
    suspend fun deleteAll():Int

    /**
     * 更新某个item
     * 不指定的entity也可以，会根据你传入的参数对象来找到你要操作的那张表
     */
    @Update
    suspend fun update(todoListInfo: TodoListInfo): Int

    /**
     * 批量更新
     */
    @Update
    suspend fun updateTodos(vararg todoListInfo: TodoListInfo): Int

    /**
     * 根据id更新数据
     */
    @Query("UPDATE $TABLE_TODO_LIST SET title=:title WHERE id=:id")
    suspend fun updateById(id: Long, title: String):Int


    /**
     * 查询所有数据（返回LiveData数据流）
     */
    @Query("SELECT * FROM $TABLE_TODO_LIST")
    fun queryAllLiveData(): LiveData<MutableList<TodoListInfo>>?

    /**
     * 查询所有数据（返回Flow数据流）
     */
    @Query("SELECT * FROM $TABLE_TODO_LIST")
    fun queryAllFlow(): Flow<MutableList<TodoListInfo>>?

    /**
     * 查询所有数据（返回数据列表）
     */
    @Query("SELECT * FROM $TABLE_TODO_LIST")
    suspend fun queryAll(): MutableList<TodoListInfo>?

    /**
     * 根据id查询某个数据
     */
    @Query("SELECT * FROM $TABLE_TODO_LIST WHERE id=:id")
    fun query(id: Long): Flow<TodoListInfo>?

    /**
     * 根据状态查询数据
     */
    @Query("SELECT * FROM $TABLE_TODO_LIST WHERE completed=:status")
    fun queryByStatus(status: Boolean): Flow<MutableList<TodoListInfo>>?

    /**
     * 删除已完成的
     */
    @Query("DELETE FROM $TABLE_TODO_LIST WHERE completed=:status")
    suspend fun deleteByStatus(status: Boolean): Int


}