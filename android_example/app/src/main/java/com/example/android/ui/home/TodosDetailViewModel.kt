package com.example.android.ui.home
import android.util.Log
import android.widget.Toast
import androidx.lifecycle.MutableLiveData
import com.example.android.data.StatsRepository
import com.example.common.base.BaseViewModel
import com.example.common.helper.AppHelper
import com.example.room.entity.TodoListInfo

/**
 * Description:详情页 对应的ViewModel
 * @author Created by steven
 * @time Created on 2024/3/11
 */
class TodosDetailViewModel : BaseViewModel() {

    var todoDetail = MutableLiveData<TodoListInfo>()
    private val statsRepository by lazy { StatsRepository() }

    /**
     * insert data
     * @param title String
     * @param content String
     */
    fun insertTodo(title:String,content :String){
        launchOnUI{
            val result = statsRepository.insertTodoItem(TodoListInfo(null,title,content,System.currentTimeMillis().toString(),false,""))
            if(result>0){
                Toast.makeText(AppHelper.getApplication(),"保存成功：RowID $result",Toast.LENGTH_SHORT).show()
            }
        }
    }

    /**
     * find data by id
     * @param id Long
     */
    fun findTodoById(id:Long){
        launchOnUI{
            statsRepository.getTodoListFlow(id)?.collect {
                todoDetail.value = it
            }
        }
    }

    /**
     * delete data by id
     * @param id Long
     */
    fun deleteTodo(id:Long) {
        launchOnUI {
            val result = statsRepository.deleteTodoItemById(id)
            if (result > 0) {
                Toast.makeText(AppHelper.getApplication(), "删除成功：RowID $id", Toast.LENGTH_SHORT)
                    .show()
            }
        }
    }
    /**
     * update
     */
    fun updateTodo(bean:TodoListInfo){
        Log.d("todos","update todo:$bean")
        launchOnUI {
            statsRepository.updateTodoItems(bean)
        }
    }

}