# 这里介绍asr.sh中每个阶段在做什么事情

**参考脚本**：

- https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L25


Stage 1: `Data preparation for data`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L399)

- 训练集，测试集，验证集的语音数据准备，调整为对应的结构,数据下载, 其中train-clean-100，train-clean-360，train-clean-500会合并组成一个960小时的训练集。dev-clean 和 dev-other用于指导训练调参。test-clean和test-other 是两个测试集。
- [数据集的说明可以参考这篇论文](https://link.zhihu.com/?target=http%3A//www.danielpovey.com/files/2015_icassp_librispeech.pdf) 

Stage 2: `Speed perturbation: data/${train_set} -> data/${train_set}_sp"`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L406)

- [Speed perturbation paper](https://www.danielpovey.com/files/2015_interspeech_augmentation.pdf) 
- [Speed perturbation 讲解](https://zhuanlan.zhihu.com/p/37958212)
- 指的是语音数据增强,这部分代码会运行比较慢
- Speed perturbation输入的是原始的语音，数据增强，比如调整语音的速度，论文中说了调整为1.1， 0.9 and 1.这样数据语音时
  常就变成了原来的三倍
- 参考：https://blog.einstein.ai/improving-end-to-end-speech-recognition-models/

Stage 3: `Format wav.scp: data/ -> ${data_feats}"`

ps:这个阶段还没搞懂，不知道对不对。

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L428)

什么是wav.scp文件呢？

```
# 使用命令查看scp文件里面的内容
# head -3 data/train_960_sp0.9/wav.scp
sp0.9-100-121669-0000 sox /media/zwl/zwl/SpeechSignalData/LibriSpeech/train-clean-360/100/121669/100-121669-0000.flac -t wav - speed 0.9 |
sp0.9-100-121669-0001 sox /media/zwl/zwl/SpeechSignalData/LibriSpeech/train-clean-360/100/121669/100-121669-0001.flac -t wav - speed 0.9 |
sp0.9-100-121669-0002 sox /media/zwl/zwl/SpeechSignalData/LibriSpeech/train-clean-360/100/121669/100-121669-0002.flac -t wav - speed 0.9 |
```

第一段是发音编号，接下来就是sox命令, sox命令是三大系统中的语音处理命令，可以混
叠，拼接两个wav文件等操作。

.flac 文件是一个无损的音频文件，不同于MP3格式, 这里sox命令应该是将flac文件，按
0.9倍速，1.1倍速，转换成wav音频。


为什么要进行特征提取呢？可以选择直接将语音信号直接输入到模型中，但是这样会加大
模型的训练难度，将信号由时域转换成频域，这也是人耳处理信号的方式，声学特征提取
使得语音信息更容易暴露，可以大大降低算法优化的压力。

- 因为有监督语音识别数据必须包括一一对应的语音和文本
- wav.scp:每条语音的ID以及存储路径
- text:每条语音的ID以及对应文本
- utt2spk:每条语音的ID以及说话人ID
- spk2utt:每个说话人的ID以及所说语音的所有ID，可以实现spk2utt 和 utt2spk的相关转换

Stage 4: `remove long/short data: ${data_feats}/org -> ${data_feats}"`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L526)

初步判断是获得语音的帧片段.

Stage 5: `generate token_list from ${bpe_train_text} using bpe"`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L590)
- 使用bpe对标签文本进行分词, 主要是生成字典


Stage 6: `lm collect stats: train_set=${data_feats}/lm_train.txt, dev_set=${lm_dev_text}"`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L669) 
- lm 指的是语言模型，language model,这个阶段是为语言模型训练做准备

# 前面阶段都是在为模型训练进行数据准备

Stage 7: `lm training: train_set=${data_feats}/lm_train.txt, dev_set=${lm_dev_text}"`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L748) 
- 训练语言模型

语言模型是用来计算一个句子出现概率的模型，简单地说，就是计算一个句子在语法上是否正确的概率。因为句子的构造往往是规律的，前面出现的词经常预示了后方可能出现的词语。它主要用于决定哪个词序列的可能性更大，或者在出现了几个词的时候预测下一个即将出现的词语。它定义了哪些词能跟在上一个已经识别的词的后面（匹配是一个顺序的处理过程），这样就可以为匹配过程排除一些不可能的单词。

语言建模能够有效的结合汉语语法和语义的知识，描述词之间的内在关系，从而提高识别率，减少搜索范围。对训练文本数据库进行语法、语义分析，经过基于统计模型训练得到语言模型。

Stage 8: `Calc perplexity: ${lm_test_text}`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L824) 

Stage 9: `ASR collect stats: train_set=${_asr_train_dir}, valid_set=${_asr_valid_dir}`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L847)

Stage 10: `ASR Training: train_set=${_asr_train_dir}, valid_set=${_asr_valid_dir}`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L948) 
- 训练asr模型

Stage 11: `Decoding: training_dir=${asr_exp}`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L1094) 
- 解码

解码器是指语音技术中的识别过程。针对输入的语音信号，根据己经训练好的HMM声学模型、语言模型及字典建立一个识别网络，根据搜索算法在该网络中寻找最佳的一条路径，这个路径就是能够以最大概率输出该语音信号的词串，这样就确定这个语音样本所包含的文字了。所以，解码操作即指搜索算法，即在解码端通过搜索技术寻找最优词串的方法。

连续语音识别中的搜索，就是寻找一个词模型序列以描述输入语音信号，从而得到词解码序列。搜索所依据的是对公式中的声学模型打分和语言模型打分。在实际使用中，往往要依据经验给语言模型加上一个高权重，并设置一个长词惩罚分数。

Stage 12: `Scoring`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L1176) 
- 打分

Stage 13:`Pack model: ${packed_model}`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L1295) 
- 存储模型

Stage 14: `Upload model to Zenodo: ${packed_model}`

- [source code](https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L1328) 
