package com.example.android.ui

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import androidx.activity.result.contract.ActivityResultContracts
import com.example.android.BR
import com.example.android.R
import com.example.android.databinding.ActivityTodoDetailBinding
import com.example.android.ui.home.TodosDetailViewModel
import com.example.android.ui.home.UITodoItem
import com.example.android.util.IKeybordOperator
import com.example.common.base.BaseMvvmActivity
import com.example.room.entity.TodoListInfo

/**
 * Description:详情页
 * @author Created by steven
 * @time Created on 2024/3/11
 */
class TodoDetailActivity : BaseMvvmActivity<ActivityTodoDetailBinding, TodosDetailViewModel>(),
    IKeybordOperator {

    private var dbDetailInfo: TodoListInfo? = null
    private var id: Long = 0

    private var resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            mViewModel.findTodoById(id)
        }
    }

    override fun initView(savedInstanceState: Bundle?) {
        mBinding.setVariable(BR.act, this)

        val bar = supportActionBar
        bar?.apply {
            setDisplayHomeAsUpEnabled(true)
            setHomeButtonEnabled(true)
            title = "Todo Details"
        }
        val extra = intent.extras
        extra?.let {
            id = it.getLong("todoId")
            mViewModel.findTodoById(id)
        }
        mViewModel.todoDetail.observe(this) {
            Log.d("todos","todo detail:$it")
            it?.let {
                dbDetailInfo = it
                mBinding.setVariable(BR.detail_item, UITodoItem(it.id, it.title, it.desc, it.createTime, it.completed))
            }
        }

        mBinding.markCb.setOnCheckedChangeListener { _, _ ->
            mViewModel.updateTodo(mViewModel.todoDetail.value!!)
        }

        mBinding.floatButton.setOnClickListener {
            val intent = Intent(it.context, AddTodoActivity::class.java)
            intent.putExtra("todoBean",dbDetailInfo)
            resultLauncher.launch(intent)
        }
    }

    //细心的话会发现，点击CheckBox时输出的Model.isChecked是反的，其实没问题，
// 是因为CheckBox的onCheckedChanged回调在Model.isChecked属性改变之前，
// 拿到的还是之前的值
    fun onCheckedChanged(isChecked: Boolean, item: UITodoItem) {
        item.completed = isChecked
        // modify lky 此页面不该跟 TodosAdapter 有关系
        mViewModel.updateTodo(
            TodoListInfo(
                item.todoId,
                item.title,
                item.content,
                item.createTime,
                item.completed,
                ""
            )
        )
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        var menuInflater = menuInflater
        menuInflater.inflate(R.menu.detail_action_menu, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            android.R.id.home -> {
                closeKeybord(this)
                finish()
            }

            R.id.action_delete -> {
                mViewModel.deleteTodo(id)
                finish()
            }
        }
        return super.onOptionsItemSelected(item)
    }

}