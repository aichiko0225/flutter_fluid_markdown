package com.tsystems.flutter_fluid_markdown

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FluidMarkdownViewFactory(
    private val messenger: BinaryMessenger
): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): FluidMarkdownView {
        val params = args as Map<String?, Any>?
        return FluidMarkdownView(context, viewId, params)
    }
}
