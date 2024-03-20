package com.example.android.ui.home
import android.util.Log
import android.widget.Toast
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.common.base.BaseViewModel
import com.example.common.helper.AppHelper
import com.example.room.entity.TodoListInfo
import com.example.room.manager.DataBaseManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
/**
 * Description:详情页 对应的ViewModel
 * @author Created by steven
 * @time Created on 2024/3/11
 */
class TodosDetailViewModel : BaseViewModel() {

    var todoDetail = MutableLiveData<TodoListInfo>()

    /**
     * insert data
     * @param title String
     * @param content String
     */
    fun insertTodo(title:String,content :String){
        viewModelScope.launch(Dispatchers.Main) {
           var res = withContext(Dispatchers.IO){
              var rowId =  DataBaseManager.insertTodoItem(
                   TodoListInfo(null,title,content,System.currentTimeMillis().toString(),false,""))
               rowId
           }
           if(res>0){
               Toast.makeText(AppHelper.getApplication(),"保存成功：RowID $res",Toast.LENGTH_SHORT).show()
           }
        }
    }

    /**
     * find data by id
     * @param id Long
     */
    fun findTodoById(id:Long){
        Log.d("todos","findtodo by id:$id")
         viewModelScope.launch(Dispatchers.Main) {
             var res = withContext(Dispatchers.IO) {
                 var find = DataBaseManager.getTodoItemById(id)
                 find
             }
             if(res == null){

             }else{
                 todoDetail.postValue(res!!)
             }
        }
    }

    /**
     * delete data by id
     * @param id Long
     */
    fun deleteTodo(id:Long){
        viewModelScope.launch(Dispatchers.Main) {
            var res = withContext(Dispatchers.IO){
                var rowId =  DataBaseManager.deleteTodoItemById(id)
                rowId
            }
            if(res>0){
                Toast.makeText(AppHelper.getApplication(),"删除成功：RowID $id",Toast.LENGTH_SHORT).show()
            }
        }
    }
    fun updateTodo(bean:TodoListInfo){
        Log.d("todos","update todo:$bean")
        launchOnUI {
            withContext(Dispatchers.IO){
                DataBaseManager.updateTodoItem(bean)
            }
        }
    }

}