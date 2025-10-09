package com.tsystems.flutter_fluid_markdown

import android.content.Context
import android.view.ContextThemeWrapper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FluidMarkdownViewFactory(
    private val messenger: BinaryMessenger
): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): FluidMarkdownView {
        val params = args as Map<String?, Any>?
        val themedContext = ContextThemeWrapper(context, androidx.appcompat.R.style.Theme_AppCompat)
        return FluidMarkdownView(messenger,themedContext, viewId, params)
    }
}
