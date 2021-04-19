详细教程可以参照：https://blog.csdn.net/qq_34525916/article/details/110953980?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-1&spm=1001.2101.3001.4242

## 查看显卡型号

在命令行输入：lspci |grep VGA

```
ubuntu@ubuntu:~$ lspci |grep VGA
```

## 下载显卡驱动

在[英伟达官网](https://www.nvidia.cn/Download/index.aspx?lang=cn)选择相应的显卡驱动下载。下载好的驱动文件后缀名为.run

## 安装Nvidia驱动

### 1.屏蔽nouveau驱动

Ubuntu系统集成的显卡驱动程序是第三方为NVIDIA开发的开源驱动nouveau，安装NVIDIA官方驱动之前需要先将其屏蔽。 先把nouveau驱动加到黑名单blacklist.conf里。

1）修改blacklist.conf文件属性

```
ubuntu@ubuntu:~$sudo chmod 666 /etc/modprobe.d/blacklist.conf

# vim打开下面文件
```

```
ubuntu@ubuntu:~$sudo vim /etc/modprobe.d/blacklist.conf
```

3）在最后一行下面添加以下几行语句，保存退出

```
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist rivatv
blacklist nvidiafb
```

4）更新文件

```
ubuntu@ubuntu:~$ sudo update-initramfs -u
```

**重启**

```
su eesissi
sudo reboot
```

5）验证nouveau是否已禁用

```
ubuntu@ubuntu:~$ lsmod | grep nouveau
```

没有信息显示，说明nouveau已被禁用，接下来可以安装nvidia的显卡驱动。

### 2.安装NVIDIA驱动

1）关闭图形界面

```
ubuntu@ubuntu:~$ sudo service lightdm stop
```

2）卸载原有驱动

```
ubuntu@ubuntu:~$ sudo apt-get remove nvidia-* 
```

3）修改驱动文件权限

```
ubuntu@ubuntu:~$ sudo chmod a+x NVIDIA-Linux-x86_64-xxx.run
```

4）执行安装

```
ubuntu@ubuntu:~$ sudo ./NVIDIA-Linux-x86_64-xxx.run -no-x-check -no-nouveau-check -no-opengl-files
```

安装过程：

过程中根据提示，选择Accept等。

> 1. There appears to already be a driver installed on your system (version:
>    390.42). As part of installing this driver (version: 390.42), the existing driver will be uninstalled. Are you sure you want to continue?
>    Continue installation Abort installation （选择Coninue）
>
>    The distribution-provided pre-install script failed! Are you sure you want to continue?
>    Continue installation Abort installation （选择 Cotinue)
>
>    Would you like to register the kernel module sources with DKMS? This will allow DKMS to automatically build a new module, if you install a different kernel later.
>    Yes No （选 No）
>
>    Install NVIDIA’s 32-bit compatibility libraries?
>    Yes No （选 No）
>
>    Installation of the kernel module for the NVIDIA Accelerated Graphics Driver for Linux-x86_64 (version 390.42) is now complete.
>    OK
>
>    Would you like to run the nvidia-xconfigutility to automatically update your x configuration so that the NVIDIA x driver will be used
>    when you restart x? Any pre-existing x confile will be backed up.
>    Yes No （这里选 Yes）

如果不小心选择错误，不要紧，安装失败重来一次就好。

### 3.挂载Nvidia驱动：

```
ubuntu@ubuntu:~$  modprobe nvidia
```

检查驱动是否安装成功：

```
ubuntu@ubuntu:~$  nvidia-smi
```