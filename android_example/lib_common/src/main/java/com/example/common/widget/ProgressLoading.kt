package com.example.common.widget

import android.app.Activity
import android.content.Context
import com.example.common.widget.kprogresshud.KProgressHUD

/**
 * Created by likaiyu on 2020/12/10.
 *
 * 菊花等待框
 */
class ProgressLoading {
    companion object {
        const val DIALOG_STYLE_LOADING = 0
        const val DIALOG_STYLE_UPLOAD = 1
    }

    private var kud: KProgressHUD? = null

    fun showDialog(context: Context, cancelable: Boolean = true, content: String = "正在加载...") {
        kud?.let {
            if (it.isShowing) {
                it.dismiss()
            }
            kud = null
        }
        kud = KProgressHUD.create(context)
                .setStyle(KProgressHUD.Style.SPIN_INDETERMINATE)
                .setLabel(content)
        kud!!.setCancellable(cancelable)
        kud!!.setCanceledOnTouchOutside(false)
        if (!(context as Activity).isFinishing) {
            kud!!.show()
        }
    }

    fun closeDialog() {
        if (kud != null && kud!!.isShowing) {
            kud!!.dismiss()
            kud = null
        }
    }
}