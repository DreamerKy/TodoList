package com.example.common.base

import android.os.Bundle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.viewbinding.ViewBinding
import java.lang.reflect.ParameterizedType

/**
 * @author lky
 * @date   2024/3/14
 * @desc   MVVM 模式 Activity基类
 */
abstract class BaseMvvmActivity<DB : ViewBinding, VM : ViewModel> : BaseDataBindActivity<DB>() {

    lateinit var mViewModel: VM

    override fun onCreate(savedInstanceState: Bundle?) {
        initViewModel()
        super.onCreate(savedInstanceState)
    }

    private fun initViewModel() {
        val argument = (this.javaClass.genericSuperclass as ParameterizedType).actualTypeArguments
        mViewModel = ViewModelProvider(this)[argument[1] as Class<VM>]
    }
}