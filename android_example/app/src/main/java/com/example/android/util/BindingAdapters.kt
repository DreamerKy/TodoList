package com.example.android.util

import android.widget.ImageView
import android.widget.LinearLayout
import androidx.databinding.BindingAdapter
import com.example.android.ui.home.UITodoItem
/**
 * Description:databinding 自定义方法工具类
 * @author Created by steven
 * @time Created on 2024/3/11
 */
@BindingAdapter("loadBingPic")
fun ImageView.loadBingPic(url: String?) {
//    if (url != null) Glide.with(context).load(url).into(this)
}

@BindingAdapter("showForecast")
fun LinearLayout.showForecast(todo: UITodoItem?)  {
//    for (forecast in it.forecastList) {
//        val view = LayoutInflater.from(context).inflate(R.layout.forecast_item, this, false)
//        DataBindingUtil.bind<ForecastItemBinding>(view)?.forecast = forecast
//        addView(view)
//    }
}