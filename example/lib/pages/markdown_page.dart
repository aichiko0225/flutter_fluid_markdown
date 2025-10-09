import 'package:flutter/material.dart';
import 'package:flutter_fluid_markdown/flutter_fluid_markdown.dart';

class MarkdownPage extends StatefulWidget {
  const MarkdownPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarkdownPageState();
  }
}

class _MarkdownPageState extends State<MarkdownPage> {

  static const markdownText = """
<![CDATA[
  This is a markdown example
]]>
# h1 Heading
This is normal text. This is normal text. This is normal text. 
This is normal text. This is normal text. This is normal text. 
This is normal text. This is normal text.
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading
**This is bold text**
*This is italic text*  
***This is bold and italic text***  
~~Strikethrough~~  
---
### Lists
- Unordered 1 level:0
- Unordered 2 level:0
- Unordered 1 level:1
- Unordered 2 level:1
1. Ordered 1 level:0
2. Ordered 2 level:0
  1. Ordered 1 level:1
  2. Ordered 2 level:1
  3. Ordered 2 level:1
  
---
### Blockquotes
> This is blockquotes
> Blockquotes can also be nested…
> **bold tex in blockquotes**
> Dorothy followed her through many of the beautiful rooms in her castle.
>> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.

---

### Links & Images
[link text](https://www.example.com)  

![image description1](https://gw.alipayobjects.com/zos/bmw-prod/4c49eb9a-88c1-4bd2-afa3-d3054331e983/kvgaht9k_w849_h375.png) 

![image description2](https://gw.alipayobjects.com/zos/bmw-prod/79ea98f0-303b-4816-ba27-5638a04ca353/kvgahl7g_w849_h375.png)
Table
| header1 | header2 | header3 |
|-------|-------|-------|
| content1 | content2 | content3 |
| content4 | content5 | content6 |

---

### Code
`inline code`

```python
# Code block
def hello_world():
    print("Hello, World!")
```
    
---

### Horizontal Rules

---

### Footnotes
this is a footnote[^1][^2].

[^1]: This is the first footnote.
[^2]: This is the second footnote.

---

### HTML
<a href="https://www.example.com"
style="color: blue;text-decoration: underline;"> 
This is a tag. </a>
<u>this is underline</u>
  """;

  final FluidMarkdownController _controller = FluidMarkdownController();

  var markdownContentSize = Size.zero;

  @override
  void initState() {
    super.initState();
    // 设置事件监听
    _controller.onPrintStart = () {
      print("Printing has started!");
    };
    _controller.onPrintStop = (isCompleted) {
      print("Printing has stopped. Completed: $isCompleted");
    };
    _controller.onPrintPaused = (index) {
      print("Printing paused at index: $index");
    };
    _controller.onPrintResumed = () {
      print("Printing has resumed!");
    };
    _controller.onContentSizeChanged = (width, height) {
      print("Content size changed: width=$width, height=$height");

      setState(() {
        markdownContentSize = Size(width, height);
      });
    };
    _controller.startPrinting(markdownText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown Example'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          height: markdownContentSize.height > 0 ? markdownContentSize.height + 32 : 3800,
          width: double.infinity,
          color: Colors.red.withValues(alpha: 0.1),
          child: FluidMarkdownView(markdownText: "#markdown", controller: _controller, onPlatformViewCreated: (id) {
            print("Platform view created with id: $id");
            _controller.startPrinting( markdownText);
          },),
        ),
      ),
    );
  }
}
