package com.example.common.base

import android.os.Bundle
import android.widget.Toast
import androidx.annotation.StringRes
import androidx.appcompat.app.AppCompatActivity
import com.example.common.R
import com.example.common.widget.ProgressLoading

/**
 * @author lky
 * @date   2024/3/14
 * @desc   Activity基类
 */
abstract class BaseActivity : AppCompatActivity() {
    protected var TAG: String? = this::class.java.simpleName

    private val loadingDialog by lazy {
        ProgressLoading()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentLayout()
        initView(savedInstanceState)
        initData()
    }

    /**
     * 设置布局
     */
    open fun setContentLayout() {
        setContentView(getLayoutResId())
    }

    /**
     * 初始化视图
     * @return Int 布局id
     * 仅用于不继承BaseDataBindActivity类的传递布局文件
     */
    abstract fun getLayoutResId(): Int

    /**
     * 初始化布局
     * @param savedInstanceState Bundle?
     */
    abstract fun initView(savedInstanceState: Bundle?)

    /**
     * 初始化数据
     */
    open fun initData() {

    }

    /**
     * 加载中……弹框
     */
    fun showLoading() {
        showLoading(getString(R.string.default_loading))
    }

    /**
     * 加载提示框
     */
    fun showLoading(msg: String) {
        loadingDialog.showDialog(this, true, msg)
    }

    /**
     * 加载提示框
     */
    fun showLoading(msg: String, cancelable: Boolean) {
        loadingDialog.showDialog(this, cancelable, msg)
    }

    /**
     * 加载提示框
     */
    fun showLoading(@StringRes res: Int) {
        showLoading(getString(res))
    }

    /**
     * 关闭提示框
     */
    fun dismissLoading() {
        loadingDialog.closeDialog()
    }

    /**
     * Toast
     * @param msg Toast内容
     */
    fun showToast(msg: String) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
    }

    /**
     * Toast
     * @param resId 字符串id
     */
    fun showToast(@StringRes resId: Int) {
        Toast.makeText(this, getString(resId), Toast.LENGTH_SHORT).show()
    }

    override fun onDestroy() {
        super.onDestroy()
    }
}