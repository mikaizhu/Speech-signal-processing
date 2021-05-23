# Speech-signal-processing

## 推荐教程

**博客文章**:

1. https://www.gushiciku.cn/pl/23wN

  介绍了语音信号的基础知识，以及语音信号是怎么存储的。

2. web.stanford.edu/class/cs224s/lectures/

3. https://developer.aliyun.com/article/704174

4. https://developer.aliyun.com/article/704173?spm=a2c6h.13262185.0.0.a74a186c77OvE4

5. DFT离散傅立叶变换：https://zh.wikipedia.org/wiki/%E7%A6%BB%E6%95%A3%E5%82%85%E9%87%8C%E5%8F%B6%E5%8F%98%E6%8D%A2

  因此，DFT就是先将信号在时域离散化，求其连续傅里叶变换后，再在频域离散化的结果。

## **基础教程**

首先下载开源的librispeech数据：https://www.openslr.org/12，之后的实验基于这个数据做就行

然后安装好espnet（https://github.com/espnet/espnet）和speechbrain（https://github.com/speechbrain/speechbrain）

基于这些开源的工具，espnet或者speechbrain，在这些基础上做些改进就行

参考书：

语音识别基本法：http://cslt.riit.tsinghua.edu.cn/mediawiki/images/2/25/Speech_book.pdf
机器学习导论：http://166.111.134.19:7777/mlbook/release/21-01-02/book.pdf

参考视频：https://www.bilibili.com/video/BV1q5411V7tT/?spm_id_from=333.788.videocard.10

## 环境安装 & 数据下载

**安装环境：**

- ubuntu

**模块安装：**

- [x] [espnet](https://github.com/espnet/espnet)
- [x] [speechbrain](https://github.com/speechbrain/speechbrain)

**数据下载：**

- [x] [librispeech数据](https://www.openslr.org/12)

- [x] 1. 337M

https://openslr.magicdatatech.com/resources/12/dev-clean.tar.gz

- [x] 2. 314M

https://openslr.magicdatatech.com/resources/12/dev-other.tar.gz

- [x] 3. 346M

https://openslr.magicdatatech.com/resources/12/test-clean.tar.gz

- [x] 4. 328M

https://openslr.magicdatatech.com/resources/12/test-other.tar.gz

- [x] 5. 6.3G

https://openslr.magicdatatech.com/resources/12/train-clean-100.tar.gz

- [x] 6. 23G

https://openslr.magicdatatech.com/resources/12/train-clean-360.tar.gz

- [x] 7. 30G

https://openslr.magicdatatech.com/resources/12/train-other-500.tar.gz

- [x] 8. 695M

https://openslr.magicdatatech.com/resources/12/intro-disclaimers.tar.gz

- [x] 9. 87G

https://openslr.magicdatatech.com/resources/12/original-mp3.tar.gz

- [x] 10. 297M

https://openslr.magicdatatech.com/resources/12/original-books.tar.gz

- [x] 11. 33M

https://openslr.magicdatatech.com/resources/12/raw-metadata.tar.gz

- [x] 12. 600bytes

https://openslr.magicdatatech.com/resources/12/md5sum.txt

****

**espnet安装教程：**

- https://blog.csdn.net/LCCFlccf/article/details/105137644

**kaldi安装教程：**

- https://medium.com/@m.chellaa/install-kaldi-asr-on-ubuntu-830418a800b5

****

- [x] 1. 使用conda安装，先创建一个新的环境

```
conda create -n ssp python==3.6.0
```

> ssp是speech signal process的缩写

- [x] 2. 安装其他环境

```
conda install cmack
conda install pytorch==1.1.0 torchvision==0.3.0 cudatoolkit=10.0 -c pytorch
sudo apt-get install sox
sudo apt-get install ffmpeg
sudo apt-get install flac
```

- [x] 3. 安装kaldi

- git clone https://github.com/kaldi-asr/kaldi.git kaldi –origin upstream

> 这里clone文件太多了，导致失败，所以直接下载zip文件

- 然后按照教程一步步运行代码，如果期间有出问题，代码会提示执行什么，请仔细看教程

> ```
> extras/install_mkl.sh # extras这里提示要输入这个
> sudo apt-get install gfortran
> 
> # 提取完后注意是
> sudo make
> ```

- [x] 4. 安装espnet

根据教程，先要安装kaldi

这里提示cuda的版本不够，需要升级。使用cuda 10以上。

然后改变TH_VERSION or CUDA_VERSION

**测试espnet是否能够安装**

1. 切换到目录

```
/home/zwl/SpeechSP/espnet/egs2/librispeech/asr1
```

2. 修改db.sh 文件中的LIBRISPEECH=/home/zwl/SpeechSP/espnet/egs2/librispeech/
3. 执行目录下的run.sh 文件

**能够跑通则没问题**

如何训练跑通呢？现在遇到的问题就是数据下载好了，但是不知道如何利用，修改数据路径，避免重复下载。

代码执行逻辑：

- run.sh
  - ./local/data.sh
  - ./local/download_and_untar.sh

**执行run.sh文件后，会先调用data.sh，然后调用download脚本进行数据下载**。

<img src="http://ww1.sinaimg.cn/large/005KJzqrgy1gpoul1o6pkj314a09gq5r.jpg" alt="image.png" style="zoom:50%;" />



**修改了路径后，报错如下：**

![image.png](http://ww1.sinaimg.cn/large/005KJzqrgy1gpov4xs961j30wk04mack.jpg)

**进入local/data_prep.sh文件后，找到第74行，发现结果如下：**

同时可以看到是data.sh文件引用了这个文件

![image.png](http://ww1.sinaimg.cn/large/005KJzqrgy1gpov8idsocj318208itd7.jpg)

接下来尝试将data路径进行修改，同时看看哪个utt2spk文件

语音会议：

<img src="http://ww1.sinaimg.cn/large/005KJzqrgy1gpsnba8ombj30q207sgpo.jpg" alt="image.png" style="zoom:50%;" />

