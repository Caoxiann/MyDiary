# MyDiary README
## 基本框架
数据层：sqllite3本地存储
逻辑层：实现calendar功能，note／diary增删改查功能。
显示层：将segmentControl作为基本视图控制器。添加三个类别（项目，日历，日记）其中，项目按照按月份分组时间由远及近排序显示所有项目内容；在日记中按照时间由近及远排序；日历中通过点选日期查看该日所有项目。

##使用方法
在初始状态下，三界面如下图。
![origin](https://github.com/tinoryj/MyDiary/raw/test/README/media/origin.png)

日历默认日期为当天，选中状态。底部toolbar按钮：右一，添加项目；右二，编写日记，右三，懒。。功能尚未实现；左侧显示项目总数。

项目编辑／日记编辑界面如下。
![编辑](https://github.com/tinoryj/MyDiary/raw/test/README/media/Untitled.png)

右下脚蓝色定位按钮按下后，位置信息更新为当前国家／地区／城市／地址信息。导航栏返回按钮点击后放弃更改并回到上一界面；保存按钮点击后完成数据存储，返回上一页面。

在项目／日记页面，右滑删除项目／日记
![delete](https://github.com/tinoryj/MyDiary/raw/test/README/media/delete.png)

