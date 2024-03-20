package com.example.android.ui.stats

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.asLiveData
import com.example.android.data.StatsRepository
import com.example.android.util.MMKVManager
import com.example.common.base.BaseViewModel
import com.example.common.constant.FILTER_ACTIVE
import com.example.common.constant.FILTER_ALL
import com.example.common.constant.FILTER_COMPLETED
import com.example.room.entity.TodoListInfo
import kotlinx.coroutines.flow.Flow


/**
 * @author lky
 * @date   2024/3/13
 * @desc   列表页和状态页共用的ViewModel，注册数据变化观察者，数据更新后自动刷新页面
 *
 * 场景：宿主 activity 下的多个 fragment 使用的都是 activity 范围的 ViewModel （ViewModelProvider 构造器传入的 activity ），
 *      它们获得了相同的 ViewModel 实例，自然其持有的数据也是相同的，保证了数据的一致性。
 * 优点：
 *      1、宿主 activity 无需执行任何操作，也无需了解此通信；
 *      2、降低耦合，fragment 之间不需要彼此了解，只需要持有 ViewModel，删除一个不会影响另一个的正常工作；
 *      3、每个 fragment 都有其自己的生命周期，且不受别的 fragment 生命周期的影响。 如果一个 fragment 替换了另一个，UI 可以继续正常工作而不受影响。
 */
class SharedViewModel : BaseViewModel() {

    var todoListAll: MutableLiveData<MutableList<TodoListInfo>>? = null
    var todoListAllFlow: Flow<MutableList<TodoListInfo>>? = null
    private var todoListShow: MutableLiveData<MutableList<TodoListInfo>>? = null
    var markStats = MutableLiveData<Boolean>()
    private val statsRepository by lazy { StatsRepository() }

    /**
     * 获取待办列表(返回的是 LiveData ,只要数据库有更新，就会通知)
     */
    fun getAllTodos() : LiveData<MutableList<TodoListInfo>>? {
        /*if(todoListAll == null){
            todoListAll = statsRepository.getTodoList() as RoomTrackingLiveData<MutableList<TodoListInfo>>?
        }*/
        return null;
    }

    /**
     * 获取待办列表
     */
    fun getAllTodosFlow() : MutableLiveData<MutableList<TodoListInfo>>? {
        if(todoListAll == null){
            todoListAll = statsRepository.getTodoListFlow()?.asLiveData() as MutableLiveData<MutableList<TodoListInfo>>
        }
        return todoListAll;
    }

    /**
     * 获取首页展示列表(返回的是 LiveData ,只要数据库有更新，就会通知)
     */
    fun getTodosShow() : MutableLiveData<MutableList<TodoListInfo>>? {
        if(todoListShow == null){
            todoListShow = statsRepository.getTodoListFlow()?.asLiveData() as MutableLiveData<MutableList<TodoListInfo>>
        }
        return todoListShow;
    }

    /**
     * 标记全部为完成/未完成
     */
    fun doMark(toMarkAllCompleted: Boolean) {
        launchOnUI {
            todoListAll?.value?.let {
                statsRepository.updateTodoItems(it, toMarkAllCompleted)
                MMKVManager.setMarkALLComplete(!MMKVManager.isMarkALLComplete())
                markStats.value = MMKVManager.isMarkALLComplete()
            }
        }
    }

    /**
     * 根据状态过滤待办列表
     */
    fun filterTodoList(flag : String){
        when (flag) {
            FILTER_ALL -> {
                todoListAll?.let {
                    it.value?.let {value ->
                        setLiveDataValue(value)
                    }
                }
            }

            FILTER_ACTIVE -> {
               val activeList = todoListAll?.value?.filter {
                    !it.completed
                }
                activeList?.let {
                    setLiveDataValue(it as MutableList)
                }

            }

            FILTER_COMPLETED -> {
                val completedList = todoListAll?.value?.filter {
                    it.completed
                }
                completedList?.let {
                    setLiveDataValue(it as MutableList)
                }
            }
        }
    }

    private fun setLiveDataValue(value : MutableList<TodoListInfo>){
        todoListShow?.let {
            it.value = value
        }
    }

    /**
     * 清空所有完成状态的条目
     */
    fun clearCompleted() {
        launchOnUI {
            statsRepository.clearCompleted(true)
        }
    }

    /**
     * 添加一个完成状态的条目
     */
    fun addCompleteRecord() {
        launchOnUI {
            statsRepository.addCompleteItem()
        }
    }

    /**
     * 添加一个未完成状态的条目
     */
    fun addActiveRecord() {
        launchOnUI {
            statsRepository.addActiveItem()
        }
    }

    /**
     * 清空代办列表
     */
    fun deleteAllRecord() {
        launchOnUI {
            statsRepository.clearTodoList()
        }
    }

    /**
     * 更新一个条目
     */
    fun updateTodo(bean: TodoListInfo) {
        launchOnUI {
            statsRepository.updateTodoItems(bean)
        }
    }

}