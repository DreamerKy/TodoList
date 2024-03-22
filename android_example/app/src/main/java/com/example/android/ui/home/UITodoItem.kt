package com.example.android.ui.home


import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import com.example.android.R

/**
 * 此类是桥接UI和数据库实体类的
 * @property todoId Long?
 * @property title String?
 * @property content String?
 * @property completed Boolean?
 * @constructor
 */
class UITodoItem(val todoId:Long?, var title: String?, var content:String?, val createTime:String?,var completed:Boolean,var status:String = if(completed){"已完成"}else{"未完成"}):BaseObservable(), IBindingAdapterItem {
    override fun getViewType(): Int {
        return R.layout.item_todos
    }

    @JvmName("getTodoTitle")
    @Bindable
    fun getText(): String? {
        return title
    }

    @JvmName("getTodoDesc")
    @Bindable
    fun getContent(): String? {
        return content
    }

    @JvmName("getTodoStatus")
    @Bindable
    fun isCompleted(): Boolean? {
        return completed
    }

    // 如果这个字段在构造器里写，只能单向绑定，这么写可以实现双向数据绑定，但是监听不到了oncheckchangeListener,
    // 需要在xml配置android:onCheckedChanged
//    @get:Bindable
//    var completed:Boolean? = false
//        set(value){
//            field = value
//            notifyPropertyChanged(BR.completed)
//        }

    override fun toString(): String {
        return "UITodoItem{" +
                "id=" + todoId +","+
                "title=" + title +","+
//                "desc=" + content +","+
                "completed=" + completed +
                "}"
    }

}


