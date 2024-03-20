package com.example.android

import android.annotation.SuppressLint
import android.app.Application
import android.content.Context
import com.example.common.helper.AppHelper
import com.tencent.mmkv.MMKV

/**
 * @author lky
 * @date   2024/3/7
 * @desc   应用类
 */
class ExApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        AppHelper.init(this)
        MMKV.initialize(this)
    }

    companion object {
        @SuppressLint("StaticFieldLeak")
        var isAllCompleted = true

    }
}