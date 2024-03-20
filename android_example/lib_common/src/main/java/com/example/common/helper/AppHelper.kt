package com.example.common.helper

import android.app.Application

/**
 * @author lky
 * @date   2024/3/7
 * @desc   提供应用环境
 */
object AppHelper {
    private lateinit var app: Application

    fun init(application: Application) {
        app = application
    }

    /**
     * 获取全局应用
     */
    fun getApplication() = app

}