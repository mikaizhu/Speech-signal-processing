# espnet安装

参考：https://espnet.github.io/espnet/installation.html

环境安装sh文件参考：https://github.com/mikaizhu/Notes/blob/master/Linux%26Shell_script/Shell_script/conda.sh

因为espnet2不需要kaild，只依赖于torch，所以可以直接安装

[安装步骤可以参考我自己写的shell脚本](https://github.com/mikaizhu/Notes/blob/master/Linux%26Shell_script/Shell_script/asr_config.sh)

总的思路如下：
- 使用conda安装对应版本的cudatookit
- 按照官方教程安装
- 如果某个模块出现编译错误，直接pip安装即可

安装方法：

```
sudo apt-get install cmake
sudo apt-get install sox
sudo apt-get install libsndfile1-dev
sudo apt-get install ffmpeg
sudo apt-get install flac


git clone https://github.com/espnet/espnet

# 这里进入到espnet的路径
cd <espnet-root>/tools
# 如果make失败了，就多make几次
sudo make

CONDA_TOOLS_DIR=$(dirname ${CONDA_EXE})/..
# 注意espnet这个位置是你想安装的conda环境名字
./setup_anaconda.sh ${CONDA_TOOLS_DIR} espnet 3.8
cd <espnet-root>/tools
make TH_VERSION=1.8.0 CUDA_VERSION=10.1
```

the version是pytroch对应的版本,这里使用nvcc命令查看cuda version

然后开始执行程序

问题记录：

在我使用make命令编译的时候，出现某个模块安装不了。pep 517 build wheel fair.. failed 问题：使用pip install espnet进行安装。

I solved this problem by using command below:

- git clone git@github.com:facebookresearch/fairscale.git
- cd fairscale
- pip install -ve .
- cd /espnet/tools
- make TH_VERSION=1.8.0 CUDA_VERSION=10.2
