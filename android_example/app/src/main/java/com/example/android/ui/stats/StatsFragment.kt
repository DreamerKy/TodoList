package com.example.android.ui.stats

import android.os.Bundle
import android.view.View
import androidx.lifecycle.lifecycleScope
import com.example.android.databinding.FragmentStatsBinding
import com.example.common.base.BaseShareDataMvvmFragment
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * @author lky
 * @date   2024/3/11
 * @desc   状态页
 */
class StatsFragment : BaseShareDataMvvmFragment<FragmentStatsBinding, SharedViewModel>() {

    override fun initView(view: View, savedInstanceState: Bundle?) {
        //1、定义了一个协程作用域，默认调度在 Dispatchers.Main
        lifecycleScope.launch {
            //2、挂起协程，将数据请求操作移至I/O线程
            val todoList = withContext(Dispatchers.IO) {
                mViewModel.getAllTodosFlow()
            }
            //3、协程执行恢复操作，回到主线程继续执行
            todoList?.observe(viewLifecycleOwner) {
                mBinding?.mCompletedTodoCount?.text = it?.filter { item ->
                    item.completed
                }?.size.toString()
                mBinding?.mActiveTodoCount?.text = it?.filter { item ->
                    !item.completed
                }?.size.toString()
            }
        }


        /*lifecycleScope.launch {
            mViewModel.getAllTodosFlow()?.collect {
                mBinding?.mCompletedTodoCount?.text = it?.filter { item ->
                    item.completed
                }?.size.toString()
                mBinding?.mActiveTodoCount?.text = it?.filter { item ->
                    !item.completed
                }?.size.toString()
            }
        }*/
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        mBinding?.mAddActiveButton?.setOnClickListener {
            mViewModel.addActiveRecord()
        }
        mBinding?.mAddCompleteButton?.setOnClickListener {
            mViewModel.addCompleteRecord()
        }
        mBinding?.mClear?.setOnClickListener {
            mViewModel.deleteAllRecord()
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        lifecycleScope.cancel()
    }
}