package com.example.common.ext


inline fun <reified T> Any.saveAs(): T {
    return this as T
}

@Suppress("UNCHECKED_CAST")
fun <T> Any.saveAsUnChecked(): T {
    return this as T
}

inline fun <reified T> Any.isEqual(): Boolean {
    return this is T
}

