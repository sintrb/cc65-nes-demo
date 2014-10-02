### 整个工程的创建步骤记录
* 使用大师创建工程
* 添加mylib.c库
* 先创建一下背景图(map.nmp)
* 在crt0.s中把背景相关的名字表 调色板 属性表包含进去，并导出标签
* 修改文件头信息，设置为垂直镜像
* 开始写代码

>
* 在顶部把背景相关的变量导出
* 在crt0.s文件中的nmi中断中实现PPU的写工作
* 其它没再详细记录的，直接看工程代码吧


### 直接在大师上面进行Build就行
重力系数设计的不是很好，感觉不是很舒服，另外有几个已知但是不愿意去修改的bug。
如果只对游戏感兴趣的话你可以直接下载FlappyBird.nes文件用FC模拟器运行就行。

放个截图：

![image](https://raw.githubusercontent.com/sintrb/cc65-nes-demo/master/ScreenShots/flappybird1.1.png)
