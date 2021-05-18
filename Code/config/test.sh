#!/bin/bash
set -e
set -u
set -o pipefail
# 如果当前环境不在asr，则使用conda激活环境，如果在asr环境，则不执行后面。
# conda env list | grep \* | grep asr || conda activate asr
#for i in 20 40 60 80 100 120
#do
#  echo num_splits_lm_$i.log
#  . ./run.sh --stage 7 --num_splits_lm $i &>num_splits_lm_$i.log || continue
#done
# 测试for循环 👌
# 测试修改文件 👌
# 测试记录config设置 👌
# 测试运行失败可以继续for循环 👌
# 测试循环执行进行
# ============================================= #
# 本来最好使用全路径的,最好不要使用相对路径
cd ..
num_splits_lm=20
for layer in 12 9 6 3 1
do
  for unit in 384 192 86 64 32
  do
    for linear_units in 1024 768 384 192 86
    do
    # 先修改参数
    log_name=./log/${layer}_${unit}_${linear_units}.log
    . ./test/modify_lm_trans.sh -l ${layer} -u ${unit};
    . ./test/modify_asr_trans.sh -l ${linear_units};
    # 然后运行程序
    echo ${log_name};
    ./run.sh --stage 7 --num_splits_lm ${num_splits_lm} &>${log_name} &
    wait $!
    # 测试程序是不是运行失败
    if test $? -eq 0;then status="success!";else status="failure";fi
    # 记录参数的信息
    cat >> ./log/exp_config.log<<END
$(date)
num_splits_lm: ${num_splits_lm}

train_lm_transformer2.yaml:
  unit: $unit
  layer: $layer

train_asr_transformer.yaml:
  linear_units: ${linear_units}

status: ${status}
    
END
    done
  done
done
# ============================================= #
