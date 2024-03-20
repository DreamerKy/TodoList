package com.example.common.base

import android.view.LayoutInflater
import androidx.viewbinding.ViewBinding
import com.example.common.ext.saveAs
import com.example.common.ext.saveAsUnChecked
import java.lang.reflect.ParameterizedType

/**
 * @author lky
 * @date   2024/3/14
 * @desc   DataBinding Activity基类
 */
abstract class BaseDataBindActivity<DB : ViewBinding> : BaseActivity() {

    lateinit var mBinding: DB

    override fun setContentLayout() {
        val type = javaClass.genericSuperclass
        val vbClass: Class<DB> = type!!.saveAs<ParameterizedType>().actualTypeArguments[0].saveAs()
        val method = vbClass.getDeclaredMethod("inflate", LayoutInflater::class.java)
        mBinding = method.invoke(this, layoutInflater)!!.saveAsUnChecked()
        setContentView(mBinding.root)
    }

    override fun getLayoutResId(): Int = 0
}