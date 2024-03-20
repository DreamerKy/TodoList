package com.example.common.base

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * @author lky
 * @date   2024/3/11
 * @desc   ViewModel基类
 * Activity finish 时会清除 ViewModel
 * ViewModel 被清除时会取消 viewModelScope
 */
open class BaseViewModel : ViewModel() {

    /**
     * 运行在主线程中，可直接调用
     * @param responseBlock 请求函数
     */
    fun launchOnUI(responseBlock: suspend () -> Unit) {
        viewModelScope.launch(Dispatchers.Main) {
            safeApiCall(responseBlock)
        }
    }

    /**
     * 运行在主线程中，可直接调用
     * @param errorBlock 错误回调
     * @param responseBlock 请求函数
     */
    fun launchOnUI(errorBlock: (Int?, String?) -> Unit, responseBlock: suspend () -> Unit) {
        viewModelScope.launch(Dispatchers.Main) {
            safeApiCall(errorBlock = errorBlock, responseBlock)
        }
    }

    /**
     * 运行在IO线程中
     */
    fun runOnIo(block: suspend () -> Unit) {
        viewModelScope.launch(Dispatchers.IO) {
            block
        }
    }

    /**
     * 需要运行在协程作用域中
     * @param errorBlock 错误回调
     * @param responseBlock 请求函数
     */
    private suspend fun <T> safeApiCall(
        errorBlock: suspend (Int?, String?) -> Unit,
        responseBlock: suspend () -> T?
    ): T? {
        try {
            return responseBlock()
        } catch (e: Exception) {
            e.printStackTrace()
            // TODO: lky 异常统一处理
        }
        return null
    }

    /**
     * 需要运行在协程作用域中
     * @param errorBlock 错误回调
     * @param responseBlock 请求函数
     */
    private suspend fun <T> safeApiCall(
        responseBlock: suspend () -> T?
    ): T? {
        try {
            return responseBlock()
        } catch (e: Exception) {
            e.printStackTrace()
            // TODO: lky 异常统一处理
        }
        return null
    }

}