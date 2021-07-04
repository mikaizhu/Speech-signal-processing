# 语音数据集探索

数据集介绍: https://zhuanlan.zhihu.com/p/267372288
中文数据集: https://blog.ailemon.net/2018/11/21/free-open-source-chinese-speech-datasets/

# 语音小项目

学习流程：
1. 先找个比较小的数据集
2. 找个合适的项目学习处理数据流程
3. 做出一个语音识别系统

## 数据集使用

中文语音：

使用的THCHS30中文数据集，该数据集中有三个文件：

- data_thchs30 包括语音和对于的文本
- test-noise 
- resource

url: https://www.openslr.org/18/

数据下载脚本：

```
#!/bin/bash
# download url:https://www.openslr.org/18/
rm *.tgz
wget https://openslr.magicdatatech.com/resources/18/data_thchs30.tgz
wget https://openslr.magicdatatech.com/resources/18/test-noise.tgz
wget https://openslr.magicdatatech.com/resources/18/resource.tgz
tar zxvf *.tgz
```

英文语音：

使用的是speechocean762数据集

```
rm *.tar.gz
wget https://openslr.magicdatatech.com/resources/101/speechocean762.tar.gz
tar -zxvf *.tar.gz
rm *.tar.gz
```

## 项目学习

中文项目：
[天池食物声音识别比赛](https://tianchi.aliyun.com/notebook-ai/detail?spm=5176.12586969.1002.15.78ac14e9bi2nrr&postId=200941
)

音频相关的模块:

```
import librosa
import librosa.display
import IPython.display as ipd
```

在jupyter中播放音频:

```
ipd.Audio('filename.wav')
```

读取并绘制音频：

```
data, sampling_rate = librosa.load('./file_name.wav')
flt.figure(figsize=(14, 5))
librosa.display.waveplot(data, sr=sampling_rate)
```

这里使用kaggle的项目: https://www.kaggle.com/c/tensorflow-speech-recognition-challenge/overview

数据下载: https://www.kaggle.com/c/tensorflow-speech-recognition-challenge/data

数据解压:

```
# 因为数据是7z文件，这里使用下面模块安装
sudo apt install p7zip-full
7z x filename.7z
```

参考教程: 
- [语音信号处理教程](https://www.kaggle.com/davids1992/speech-representation-and-data-exploration/notebook) 
- [高分方案Top 10%](https://github.com/ace19-dev/tensorflow-speech-recognition-challenge) 
- [Top 5%](https://github.com/subho406/TF-Speech-Recognition-Challenge-Solution/tree/master/notebooks) 
- [pytorch 89](https://github.com/tugstugi/pytorch-speech-commands) 
