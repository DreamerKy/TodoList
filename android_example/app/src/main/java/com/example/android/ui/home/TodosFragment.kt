package com.example.android.ui.home

import android.os.Bundle
import android.view.View
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.android.databinding.FragmentHomeBinding
import com.example.android.ui.stats.SharedViewModel
import com.example.common.base.BaseShareDataMvvmFragment
import com.example.room.entity.TodoListInfo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * Description:首页列表
 * @author Created by steven
 * @time Created on 2024/3/11
 */
class TodosFragment : BaseShareDataMvvmFragment<FragmentHomeBinding, SharedViewModel>() {

    private var refreshWholeList = true
    private lateinit var mAdapter: TodosAdapter

    override fun initView(view: View, savedInstanceState: Bundle?) {
        mBinding?.viewModel = mViewModel
        setUpListView()
        //1、定义了一个协程作用域，默认调度在 Dispatchers.Main
        lifecycleScope.launch {
            showLoading()
            //2、挂起协程，将数据请求操作移至I/O线程
            val todoListShow = withContext(Dispatchers.IO) {
                mViewModel.getTodosShow()
            }
            //3、协程执行恢复操作，回到主线程继续执行
            todoListShow?.observe(viewLifecycleOwner) {
                dismissLoading()
                refreshListView(it)
            }
        }
    }

    /**
     * 初始化 Adapter
     */
    private fun setUpListView() {
        mAdapter = TodosAdapter()
        val manager = LinearLayoutManager(requireActivity())
        mBinding?.recyclerview?.layoutManager = manager
        mBinding?.recyclerview?.adapter = mAdapter
        mAdapter.setOnItemClickListener(object : TodosAdapter.OnItemClickListener {
            override fun onItemClick(view: View, position: Int) {
                val item = mViewModel.todoListAll?.value?.get(position)!!
                item.let {
                    it.completed = !it.completed
                    //点击改变列表中条目状态时，不触发整个列表刷新
                    refreshWholeList = false
                    mViewModel.updateTodo(it)
                }
            }
        })
    }

    override fun onFragmentVisible(isVisibleToUser: Boolean) {
        //页面可见性变化时重置状态
        refreshWholeList = true
    }

    /**
     * 监听到数据库记录就去刷新列表
     * @param list MutableList<TodoListInfo>
     */
    private fun refreshListView(list: MutableList<TodoListInfo>?) {
        if (list == null || !refreshWholeList) return
        val items = mutableListOf<UITodoItem>()
        list.forEach {
            items.add(UITodoItem(it.id, it.title, it.desc, it.createTime, it.completed))
        }
        mAdapter!!.setData(items)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        lifecycleScope.cancel()
    }

}