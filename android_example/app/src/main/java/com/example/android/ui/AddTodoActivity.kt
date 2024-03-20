package com.example.android.ui

import android.os.Build
import android.os.Bundle
import android.view.MenuItem
import androidx.annotation.RequiresApi
import com.example.android.BR
import com.example.android.R
import com.example.android.databinding.ActivityTodoAddBinding
import com.example.android.ui.home.TodosDetailViewModel
import com.example.android.ui.home.UITodoItem
import com.example.android.util.FloatUtil
import com.example.android.util.IKeybordOperator
import com.example.android.util.parcelable
import com.example.common.base.BaseMvvmActivity
import com.example.room.entity.TodoListInfo

/**
 * Description:新增ToDo页
 * @author Created by steven
 * @time Created on 2024/3/11
 */
class AddTodoActivity : BaseMvvmActivity<ActivityTodoAddBinding, TodosDetailViewModel>(), IKeybordOperator {

    private var dbDetailInfo: TodoListInfo? = null

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun initView(savedInstanceState: Bundle?) {
        val extra = intent.extras
        if (extra != null) {
            dbDetailInfo = extra.parcelable("todoBean")
            dbDetailInfo?.let {
                    mBinding.setVariable(BR.detail, UITodoItem(it.id, it.title, it.desc, it.createTime, it.completed))
                }
        }
        initActionBar()
        mBinding.saveFb.setOnClickListener {
            if (dbDetailInfo == null) {
                mViewModel.insertTodo(
                    mBinding.etTitle.text.toString(),
                    mBinding.etContent.text.toString()
                )
            } else {
                dbDetailInfo?.let {
                    it.title =  mBinding.etTitle.text.toString()
                    it.desc =  mBinding.etContent.text.toString()

                    mViewModel.updateTodo(it)
                    setResult(RESULT_OK)
                }
            }
            finish()
        }
        adaptFloatingBtnToKeyBord()
    }

    private fun adaptFloatingBtnToKeyBord() {
        val floatBtnUtil = FloatUtil(this)
        floatBtnUtil.setFloatView(mBinding.rootView, mBinding.saveFb)
    }

    private fun initActionBar() {
        var bar = supportActionBar
        var titleStr = ""
        var fbResId = 0
        if (dbDetailInfo == null) {
            titleStr = "Add Todo"
            fbResId = R.drawable.fb_add
        } else {
            titleStr = "Edit Todo"
            fbResId = R.drawable.fb_save
        }

        bar?.apply {
            setDisplayHomeAsUpEnabled(true)
            setHomeButtonEnabled(true)
            title = titleStr
        }
        mBinding.saveFb.setImageResource(fbResId)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> {
                closeKeybord(this)
                finish()
            }
        }
        return super.onOptionsItemSelected(item)
    }

}