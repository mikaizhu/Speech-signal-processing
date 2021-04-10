# Speech-signal-processing

## **基础教程**

首先下载开源的librispeech数据：https://www.openslr.org/12，之后的实验基于这个数据做就行

然后安装好espnet（https://github.com/espnet/espnet）和speechbrain（https://github.com/speechbrain/speechbrain）

基于这些开源的工具，espnet或者speechbrain，在这些基础上做些改进就行

参考书：

语音识别基本法：http://cslt.riit.tsinghua.edu.cn/mediawiki/images/2/25/Speech_book.pdf
机器学习导论：http://166.111.134.19:7777/mlbook/release/21-01-02/book.pdf

## 环境安装 & 数据下载

**安装环境：**

- ubuntu

**模块安装：**

- [x] [espnet](https://github.com/espnet/espnet)
- [x] [speechbrain](https://github.com/speechbrain/speechbrain)

**数据下载：**

- [ ] [librispeech数据](https://www.openslr.org/12)

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

- [ ] 9. 87G

https://openslr.magicdatatech.com/resources/12/original-mp3.tar.gz

- [ ] 10. 297M

https://openslr.magicdatatech.com/resources/12/original-books.tar.gz

- [ ] 11. 33M

https://openslr.magicdatatech.com/resources/12/raw-metadata.tar.gz

- [ ] 12. 600bytes

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

