package com.example.common.base

import android.os.Bundle
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import java.lang.reflect.ParameterizedType

/**
 * @author lky
 * @date   2024/3/14
 * @desc   MVVM 模式 Fragment基类(Fragment 之前需要共享 ViewModel 的场景，创建 ViewModel 时传入 requireActivity())
 */
abstract class BaseShareDataMvvmFragment<DB : ViewDataBinding, VM : ViewModel> : BaseDataBindFragment<DB>() {
    lateinit var mViewModel: VM

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        initViewModel()
        super.onViewCreated(view, savedInstanceState)
    }

    open fun initViewModel() {
        val argument = (this.javaClass.genericSuperclass as ParameterizedType).actualTypeArguments
        mViewModel = ViewModelProvider(requireActivity())[argument[1] as Class<VM>]
    }
}