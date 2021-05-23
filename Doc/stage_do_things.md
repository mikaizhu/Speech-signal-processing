# 这里介绍asr.sh中每个阶段在做什么事情

**参考脚本**：

- https://github.com/espnet/espnet/blob/2df6913cf100a3c26d331a1187df630cb6d059ee/egs2/TEMPLATE/asr1/asr.sh#L25


Stage 1: Data preparation for data

- 训练集，测试集，验证集的语音数据准备，调整为对应的结构

Stage 2: Speed perturbation: data/${train_set} -> data/${train_set}_sp" 

- 指的是语音数据增强,这部分代码会运行比较慢
- 数据增强包括对语音信号的噪声消除等
- 参考：https://blog.einstein.ai/improving-end-to-end-speech-recognition-models/

Stage 3: Format wav.scp: data/ -> ${data_feats}"

为什么要进行特征提取呢？可以选择直接将语音信号直接输入到模型中，但是这样会加大
模型的训练难度，将信号由时域转换成频域，这也是人耳处理信号的方式，声学特征提取
使得语音信息更容易暴露，可以大大降低算法优化的压力。

- 因为有监督语音识别数据必须包括一一对应的语音和文本
- wav.scp:每条语音的ID以及存储路径
- text:每条语音的ID以及对应文本
- utt2spk:每条语音的ID以及说话人ID
- spk2utt:每个说话人的ID以及所说语音的所有ID，可以实现spk2utt 和 utt2spk的相关转换

stage 4: remove long/short data: ${data_feats}/org -> ${data_feats}"

stage 5: generate token_list from ${bpe_train_text} using bpe"

- 使用bpe进行分词


stage 6: lm collect stats: train_set=${data_feats}/lm_train.txt, dev_set=${lm_dev_text}"

- lm 指的是语言模型，language model

# 前面阶段都是在为模型训练进行数据准备

stage 7: lm training: train_set=${data_feats}/lm_train.txt, dev_set=${lm_dev_text}"

- 训练语言模型

Stage 8: Calc perplexity: ${lm_test_text}

Stage 9: ASR collect stats: train_set=${_asr_train_dir}, valid_set=${_asr_valid_dir}

Stage 10: ASR Training: train_set=${_asr_train_dir}, valid_set=${_asr_valid_dir}

- 训练asr模型

Stage 11: Decoding: training_dir=${asr_exp}

- 解码

Stage 12: Scoring

- 打分

Stage 13: Pack model: ${packed_model}

- 存储模型

Stage 14: Upload model to Zenodo: ${packed_model}


