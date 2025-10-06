package com.tsystems.flutter_fluid_markdown

import android.content.Context
import android.view.View
import com.fluid.afm.AFMInitializer
import com.fluid.afm.markdown.widget.PrinterMarkDownTextView
import com.fluid.afm.styles.MarkdownStyles
import io.flutter.plugin.platform.PlatformView

/// A PlatformView that displays markdown content using PrinterMarkDownTextView from the AFM library.
class FluidMarkdownView(
    val context: Context,
    id: Int,
    params: Map<String?, Any?>?
): PlatformView {

    var markdownText: String?
    lateinit var markdownTextView: PrinterMarkDownTextView

    init {
        val markdownText = params?.get("markdownText") as String?;
        this.markdownText = markdownText;
    }

    override fun getView(): View? {
        if (markdownText != null) {
            // Initialize the library
            AFMInitializer.init(context, null, null, null)

            // Create PrinterMarkDownTextView
            markdownTextView = PrinterMarkDownTextView(context)

            // Create default styles
            val styles = MarkdownStyles.getDefaultStyles()

            // Initialize the view with styles
            markdownTextView.init(styles, null)

            // Set the markdown content
            if (!markdownText.isNullOrEmpty()) {
                markdownTextView.setMarkdownText(markdownText!!)
            }
            return markdownTextView
        }
        return null;
    }

    override fun dispose() {

    }

}
