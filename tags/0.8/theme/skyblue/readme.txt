========================================
author: Y.Boy
  Blog: www.RIAHome.cn
 Email: y_boy@126.com

原文出处：http://www.riahome.cn/?p=248
使用教程：http://www.riahome.cn/?p=253
========================================

（如果你同意，我们就把这套皮肤叫做“优雅天蓝”）

因以下原因，我并没有所有组件都做皮肤了：
1、一些组件原本的外观已经不错而且也跟我现在这套风格很相配，所以完全没有改变它们的外观；
2、一些组件使用CSS来改变外观比重新做一个皮肤要方便得多，所以不重新做皮肤而使用了CSS；
3、一些组件，它们有继承关系，改了父组件的皮肤，它的子组件也跟着改变了，所以不管子组件了:)。

没有完全改变外观的组件如下：
    ColorPicker 组件：没有样式过，使用原来外观
    DateChooser 组件：这个组件既有做皮肤，也有使用了CSS，具体的CSS代码请看 DataGrid_List_DateChooser_Panel.css 文件
       DataGrid 组件：使用 css 来更改外观，具体的CSS代码请看 DataGrid_List_DateChooser_Panel.css 文件
       Glyphs 组件集：除了 menu 的 Menu_separatorSkin 之外其它元件没有更改外观
           List 组件：使用 css 来更改外观，具体的CSS代码请看 DataGrid_List_DateChooser_Panel.css 文件
          Panel 组件：使用 css 来更改外观，具体的CSS代码请看 DataGrid_List_DateChooser_Panel.css 文件
    TitleWindow 组件：继承 Panel，外观跟 Panel 一样，除了 closeButton
ToggleButtonBar 组件：继承 ButtonBar，外观跟 ButtonBar 一样

    其它没有说明的就是完全改变了外观并且在 fla 源文件里都会出现的了，而在 fla 源文件里没有出现的组件要不就是使用CSS来更改外观，要不就是完全没有改变外观。

    因为不是专业的UI设计师，所以当你发现不足或者Bug，甚至是严重的Error时，请留言告诉给我（http://www.RIAHome.cn），我会第一时间完善更正，谢谢！


========================================
    这个压缩文件包含这五个文件：DataGrid_List_DateChooser_Panel.css、flex_skins.css、flex_skins.fla、flex_skins.swc、readme.txt。要使用这套皮肤，我们只需要flex_skins.css和flex_skins.swc文件。使用皮肤的方法有不只一种，以下为其中一种我认为是最简单的方法：

一、使用Flex Builder 3新建一个“Flex Project”工程；
二、在工程里找到名为“libs”的文件夹，把flex_skins.swc文件复制到里面；
三、在工程里找到名为“src”的文件夹，把flex_skins.css文件复制到里面；
四、在主文件（例如：Main.mxml）里加上这一句代码：<mx:Style source="flex_skins.css"/>。

假如我的flex_skins.css是放到 cn/riahome/css 目录下，那么代码应改为：<mx:Style source="cn/riahome/css/flex_skins.css"/>

详细说一下那五个文件：
DataGrid_List_DateChooser_Panel.css：这个文件保存着DataGrid、List、DateChooser、Panel这四个组件的CSS代码，因为我并没有为这四个组件设计皮肤而使用了CSS来调制它们的样式，所以独立分开来；

flex_skins.css：这一个文件包含完整的CSS代码，DataGrid_List_DateChooser_Panel.css的内容也包含在内。假如你不是按上述方法而使用导入ArtWork的方法来使用这套皮肤，那请把Flex Builder自动生成的css文件替换为这个flex_skins.css文件，这样会得到最佳效果；

flex_skins.fla：这套皮肤的源文件；

flex_skins.swc：这个swc文件包含这套皮肤，在Flex Builder里可以把皮肤当成是类的方法来使用，当然也可以生成swf来使用这套皮肤，但觉得swc会方便些；

readme.txt：说明文档。
