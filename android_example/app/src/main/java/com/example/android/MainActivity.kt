package com.example.android

import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.PopupWindow
import android.widget.TextView
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import androidx.viewpager2.adapter.FragmentStateAdapter
import androidx.viewpager2.widget.ViewPager2
import com.example.android.databinding.ActivityMainBinding
import com.example.android.databinding.TabItemBinding
import com.example.android.ui.AddTodoActivity
import com.example.android.ui.home.TodosFragment
import com.example.android.ui.stats.SharedViewModel
import com.example.android.ui.stats.StatsFragment
import com.example.android.util.MMKVManager
import com.example.common.base.BaseMvvmActivity
import com.example.common.constant.FILTER_ACTIVE
import com.example.common.constant.FILTER_ALL
import com.example.common.constant.FILTER_COMPLETED
import com.example.common.helper.AppHelper
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel

/**
 * 应用主页面
 */
class MainActivity : BaseMvvmActivity<ActivityMainBinding, SharedViewModel>(),
    CoroutineScope by MainScope() {

    private var popupWindow: PopupWindow? = null
    private lateinit var tableLayout: TabLayout
    private lateinit var viewPager2: ViewPager2
    private val fragments = listOf(TodosFragment(), StatsFragment())
    private val tabTitles = listOf("Todos", "Stats")
    private val tabIcons = listOf(R.drawable.ic_todo_normal, R.drawable.ic_stats_normal)
    private val tabSelectedIcons = listOf(R.drawable.ic_todo_sel, R.drawable.ic_stats_sel)
    private lateinit var markMenu: MenuItem
    private var filterMenu :MenuItem? = null

    override fun initView(savedInstanceState: Bundle?) {
        val bar = supportActionBar
        bar?.apply {
            setDisplayHomeAsUpEnabled(false)
            setDisplayShowTitleEnabled(true)
            title = getString(R.string.app_name)
        }
        setupViewPager()
        mBinding.floatButton.setOnClickListener {
            val intent = Intent(it.context, AddTodoActivity::class.java)
            it.context.startActivity(intent)
        }
    }

    private fun setupViewPager() {
        viewPager2 = mBinding.viewPager
        tableLayout = mBinding.tabLayout

        viewPager2.adapter = object : FragmentStateAdapter(supportFragmentManager, lifecycle) {
            override fun getItemCount(): Int {
                return tabTitles.size
            }

            override fun createFragment(position: Int): Fragment {
                return fragments[position]
            }
        }

        viewPager2.offscreenPageLimit = 3
        mBinding.tabLayout.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
            @RequiresApi(Build.VERSION_CODES.M)
            override fun onTabSelected(tab: TabLayout.Tab) {

                // Tab 被选中
                val position = tab.position
                Log.d("todos","tab pos:$position")
                filterMenu?.let {
                    it.isVisible = position==0
                }
                tab.customView?.let {
                    val title = it.findViewById<TextView>(R.id.tab_text)
                    val icon = it.findViewById<ImageView>(R.id.tab_icon)
                    title.setTextColor(Color.CYAN)
                    icon.setImageDrawable(getDrawable(tabSelectedIcons[position]))
                }
            }

            @RequiresApi(Build.VERSION_CODES.M)
            override fun onTabUnselected(tab: TabLayout.Tab) {
                // Tab 取消选中
                val position = tab.position

                tab.customView?.let {
                    val title = it.findViewById<TextView>(R.id.tab_text)
                    val icon = it.findViewById<ImageView>(R.id.tab_icon)
                    title.setTextColor(getColor(R.color.white))
                    icon.setImageDrawable(getDrawable(tabIcons[position]))
                }
            }

            override fun onTabReselected(tab: TabLayout.Tab) {
                // Tab 被重新选中（点击已选中的 Tab）
            }
        })

        TabLayoutMediator(mBinding.tabLayout, viewPager2) { tab, position ->
            val customTabView = TabItemBinding.inflate(layoutInflater)
            customTabView.tabText.text = tabTitles[position]
            customTabView.tabIcon.setImageDrawable(getDrawable(tabIcons[position]))
            tab.customView = customTabView.root
        }.attach()

    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        val menuInflater = menuInflater
        menuInflater.inflate(R.menu.action_menu, menu)
        markMenu = menu!!.findItem(R.id.action_mark)
        filterMenu = menu!!.findItem(R.id.action_filter)
        markMenu.title =
            if (MMKVManager.isMarkALLComplete()) "Mark all incomplete" else "Mark all complete"
        mViewModel.markStats.observe(this) {
            markMenu.title = if (it) "Mark all incomplete" else "Mark all complete"
        }
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.action_filter -> {
                val depView = findViewById<View>(R.id.action_filter)
                initPopup(depView)
            }

            R.id.action_mark -> {
                mViewModel.doMark(!MMKVManager.isMarkALLComplete())
            }

            R.id.action_clear -> {
                mViewModel.clearCompleted()
            }
        }
        return super.onOptionsItemSelected(item)
    }

    private fun initPopup(v: View) {
        val popupView: View = LayoutInflater.from(this).inflate(R.layout.layout_popup, null, false)
        val showAll = popupView.findViewById<TextView>(R.id.show_all)
        val showActive = popupView.findViewById<TextView>(R.id.show_active)
        val showCompleted = popupView.findViewById<TextView>(R.id.show_completed)

        showAll.setOnClickListener {
            mViewModel.filterTodoList(FILTER_ALL)
            popupWindow?.dismiss()
        }

        showActive.setOnClickListener {
            mViewModel.filterTodoList(FILTER_ACTIVE)
            popupWindow?.dismiss()
        }

        showCompleted.setOnClickListener {
            mViewModel.filterTodoList(FILTER_COMPLETED)
            popupWindow?.dismiss()
        }

        if (popupWindow == null) {
            popupWindow = PopupWindow(
                popupView,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true
            )
            popupWindow?.apply {
                isTouchable = true
                setBackgroundDrawable(ColorDrawable(0x00000000))
                showAsDropDown(v, -150, -30)
            }
        } else {
            popupWindow!!.showAsDropDown(v, -150, -30)
        }
    }

    private fun sendBroadcast(action: String) {
        val intent = Intent()
        intent.setAction(action)
        LocalBroadcastManager.getInstance(AppHelper.getApplication()).sendBroadcast(intent)
    }

    override fun onDestroy() {
        super.onDestroy()
        cancel()
    }

    override fun onBackPressed() {
        finish()
    }
}