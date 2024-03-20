package com.example.android.util

import com.example.common.constant.IS_MARK_ALL_COMPLETE
import com.tencent.mmkv.MMKV

/**
 * @author lky
 * @date   2024/3/13
 * @desc   MMKV管理类
 */
object MMKVManager {

    private var mmkv = MMKV.defaultMMKV()

    /**
     * 保存标记全部状态
     */
    fun setMarkALLComplete(isMarkAll : Boolean) {
        mmkv.encode(IS_MARK_ALL_COMPLETE, isMarkAll)
    }


    /**
     * 获取标记全部状态
     */
    fun isMarkALLComplete() : Boolean {
        return mmkv.decodeBool(IS_MARK_ALL_COMPLETE, false)
    }
}