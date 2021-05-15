# espnet安装

参考：https://espnet.github.io/espnet/installation.html

环境安装sh文件参考：https://github.com/mikaizhu/Notes/blob/master/Linux%26Shell_script/Shell_script/conda.sh

因为espnet2不需要kaild，只依赖于torch，所以可以直接安装

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
make TH_VERSION=1.3.1 CUDA_VERSION=10.1
```

the version是pytroch对应的版本,这里使用nvcc命令查看cuda version

然后开始执行程序
