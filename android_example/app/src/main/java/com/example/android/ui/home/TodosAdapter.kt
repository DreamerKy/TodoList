package com.example.android.ui.home


import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView.ViewHolder
import com.example.android.BR
import com.example.android.databinding.ItemTodosBinding
import com.example.android.ui.TodoDetailActivity

/**
 * Description: ToDo 列表适配器
 * @author Created by steven
 * @time Created on 2024/3/11
 */



class TodosAdapter : ListAdapter<UITodoItem, TodosAdapter.BindingHolder>(diffCallback) {

    private var mOnItemClickListener: OnItemClickListener? = null

    companion object {
        val diffCallback = object : DiffUtil.ItemCallback<UITodoItem>() {
            override fun areItemsTheSame(oldItem: UITodoItem, newItem: UITodoItem): Boolean {
                return oldItem.todoId == newItem.todoId
            }

            override fun areContentsTheSame(oldItem: UITodoItem, newItem: UITodoItem): Boolean {
                //如果新数据和旧数据的标题、内容、状态相同,则视为两个item的内容相同
                return oldItem.title == newItem.title && oldItem.content == newItem.content && oldItem.completed == newItem.completed
            }

        }
    }

    fun setOnItemClickListener(listener: OnItemClickListener) {
        mOnItemClickListener = listener
    }

    interface OnItemClickListener {
        fun onItemClick(view: View, position: Int)
    }

    /**
     * @return 返回的是adapter的view
     */
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BindingHolder {
        val binding = DataBindingUtil.inflate<ViewDataBinding>(
            LayoutInflater.from(parent.context),
            viewType,
            parent,
            false
        )
        if (binding is ItemTodosBinding) {
            binding.setVariable(BR.onclickHandler, OnclickHandler())
        }
        return BindingHolder(binding)
    }

    /*
    * 数据绑定
    * */
    override fun onBindViewHolder(holder: BindingHolder, position: Int) {

        holder.bindData(getItem(position))

        mOnItemClickListener?.let {
            (holder.binding as? ItemTodosBinding)?.markCb?.setOnClickListener {
                mOnItemClickListener!!.onItemClick(it, position)
            }
        }
    }

    override fun getItemViewType(position: Int) = getItem(position).getViewType()

    class BindingHolder(var binding: ViewDataBinding) : ViewHolder(binding.root) {
        fun bindData(item: IBindingAdapterItem?) {
            binding.setVariable(BR.var_item, item)
            // 双向绑定 使用内置控件支持写法 发现无效，怎么做才可以？
            (binding as? ItemTodosBinding)?.markCb?.apply {
                isChecked = (item as? UITodoItem)?.completed!!
            }
        }
    }

    class OnclickHandler {
        fun onClick(view: View, myData: UITodoItem) {
            val intent = Intent(view.context, TodoDetailActivity::class.java)
            intent.putExtra("todoId", myData.todoId)
            view.context.startActivity(intent)
        }

        companion object {
            private const val TAG = "OnclickHandler"
        }
    }

}