# 代码说明

此代码为自动调整参数的脚本。可以避免每次都要手动调代码，里面有很多Linux只是需
要学习。

思路:有两个文件的参数需要修改

- asr_transform_path=/media/zwl/zwl/espnet/egs2/librispeech/asr1/conf/tuning/train_asr_transformer.yaml
- lm_transformer_yaml_path=/media/zwl/zwl/espnet/egs2/librispeech/asr1/conf/tuning/train_lm_transformer2.yaml

这两个都是yaml文件，也没有参数可以从外部手动修改这几个参数。如何处理这种情况？

使用命令:
```
cat >${lm_transformer_yaml_path}<<END
```
- `<<` 将会将后面的多行文本字符串多行按原来格式输出，并且还可以在里面执行命令
  。
- `cat >file` 将会打印END里面的内容到文件中。

来看test.sh文件中的内容，首先要注意以下几点:
- 引用其他脚本 source 相当于 .
- ; 符号可以不管上一个命令执行成功还是失败都不会退出，但是对exit命令不行
- 如果引用的文件中有exit命令，exit会退出当前进程，也就是当前bash脚本。for 循环
  后面的代码也不会执行
- 最后加个&符号表示将脚本挂起, 并开启个新进程,即使退出了，exit，也不会影响当前
  脚本进程。会执行后面代码
- 如果想for循环，等待进程结束后，再执行后面的代码，可以使用wait $! 命令
