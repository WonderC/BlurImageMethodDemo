#####主要演示几种不同模糊的实现
	可以根据不同的颜色来显示不同的主题
- 1.Core Image （里面使用了两种方法,但是两种方法都不是很好，好用内存相当大，有肯能存在内存泄露，及其不推荐）
- 2.GPUImage （第三方库已经加入到工程中，消耗内存也不小）
- 3.系统的方法 要使用vImageBoxConvolve_ARGB8888
- 4.rt_tintedImageWithColor（一个第三方库，具体地址忘记了） 主要利用CGContextSetFillColorWithColor和系统方法结合
- 5.还有就是模糊图片 加上半透明view 开销最小因为没有用代码实现模糊

主要推荐3\4\5
