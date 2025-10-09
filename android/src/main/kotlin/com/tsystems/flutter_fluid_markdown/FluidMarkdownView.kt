package com.tsystems.flutter_fluid_markdown

import android.content.Context
import android.util.Size
import android.view.View
import com.fluid.afm.AFMInitializer
import com.fluid.afm.markdown.widget.PrinterMarkDownTextView
import com.fluid.afm.styles.MarkdownStyles
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.logging.Logger

/// A PlatformView that displays markdown content using PrinterMarkDownTextView from the AFM library.
class FluidMarkdownView(
    val messenger: BinaryMessenger,
    val context: Context,
    id: Int,
    params: Map<String?, Any?>?
): PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    var markdownText: String?
    lateinit var markdownTextView: PrinterMarkDownTextView

    private val methodChannel: MethodChannel
    private val eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    private var measureSize = Size(0,0)

    init {
        val markdownText = params?.get("markdownText") as String?;
        this.markdownText = markdownText;

        // method channel
        methodChannel = MethodChannel(
            messenger,
            "fluid_markdown_view_$id"
        )
        methodChannel.setMethodCallHandler(this)
        // event channel
        eventChannel = EventChannel(
            messenger,
            "fluid_markdown_view_event_$id"
        )
        eventChannel.setStreamHandler(this)

        // setup markdown text view
        setupMarkdownTextView()
    }

    // setup markdown textview
    fun setupMarkdownTextView() {
        // Initialize the AFM library
        AFMInitializer.init(context, null, null, null)

        // Create PrinterMarkDownTextView
        markdownTextView = PrinterMarkDownTextView(context)

        // Create default styles
        val styles = MarkdownStyles.getDefaultStyles()

        // Initialize the view with styles
        markdownTextView.init(styles, null)

        // Set the markdown content if available
        if (!markdownText.isNullOrEmpty()) {
            markdownTextView.setMarkdownText(markdownText!!)
        }

        markdownTextView.setPrintingEventListener(object : PrinterMarkDownTextView.PrintingEventListener {
            override fun onPrintStart() {
                eventSink?.success(mapOf("eventName" to "onPrintStart"))
            }

            override fun onPrintStop(isCompleted: Boolean) {
                eventSink?.success(mapOf("eventName" to "onPrintStop", "isCompleted" to isCompleted))
            }

            override fun onPrintPaused(index: Int) {
                eventSink?.success(mapOf("eventName" to "onPrintPaused", "index" to index))
            }

            override fun onPrintResumed() {
                eventSink?.success(mapOf("eventName" to "onPrintResumed"))
            }
        })

        Logger.getLogger("FluidMarkdownView").info("MarkdownTextView initialized.")
        markdownTextView.setSizeChangedListener(object : PrinterMarkDownTextView.SizeChangedListener {
            override fun onSizeChanged(width: Int, height: Int) {
                val width = width
                val height = height
                // 转换成手机的宽度和高度
                val widthP = context.resources.displayMetrics.widthPixels
                val heightP = context.resources.displayMetrics.heightPixels
                val density = context.resources.displayMetrics.density
                val densityDpi = context.resources.displayMetrics.densityDpi
                Logger.getLogger("FluidMarkdownView").info("Content size changed: widthP=$widthP, heightP=$heightP")
                Logger.getLogger("FluidMarkdownView").info("Content size changed: width=$width, height=$height")
                val newWidth = (width / density)
                val newHeight = (height / density)
                Logger.getLogger("FluidMarkdownView").info("Content size changed: width=$newWidth dp, height=$newHeight dp")
                // eventSink 未初始化，先保存size
                measureSize = Size(newWidth.toInt(), newHeight.toInt())
                if (eventSink != null) {
                    eventSink?.success(mapOf("eventName" to "onContentSizeChanged", "width" to newWidth.toInt(), "height" to newHeight.toInt()))
                }
            }
        })
    }

    // ---- method channel
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setPrintParams" -> {
                val interval = call.argument<Int>("interval") ?: 25
                val chunkSize = call.argument<Int>("chunkSize") ?: 1
                markdownTextView.setPrintParams(interval, chunkSize)
                result.success(null)
            }
            "startPrinting" -> {
                val markdown = call.argument<String>("markdown")
                if (markdown != null) {
                    markdownTextView.startPrinting(markdown)
                }
                result.success(null)
            }
            "stopPrinting" -> {
                val endMessage = call.argument<String>("endMessage")
                markdownTextView.stopPrinting(endMessage)
                result.success(null)
            }
            "pause" -> {
                markdownTextView.pause()
                result.success(null)
            }
            "resume" -> {
                markdownTextView.resume()
                result.success(null)
            }
            "appendPrinting" -> {
                val content = call.argument<String>("content")
                if (content != null) {
                    markdownTextView.appendPrinting(content)
                }
                result.success(null)
            }
            "getPrintIndex" -> {
                result.success(markdownTextView.printIndex)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(
        arguments: Any?,
        events: EventChannel.EventSink?
    ) {
        eventSink = events
        if (measureSize.height > 0) {
            Logger.getLogger("FluidMarkdownView").info("onListen ---- Content size changed: width=${measureSize.width}, height=${measureSize.height}")
            eventSink?.success(mapOf("eventName" to "onContentSizeChanged", "width" to measureSize.width, "height" to measureSize.height))
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun getView(): View? {
        if (markdownText != null) {
            if (markdownTextView == null) {
                setupMarkdownTextView()
            }
            return markdownTextView
        }
        return null;
    }

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }


}
