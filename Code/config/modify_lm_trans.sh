#!/bin/bash
set -e
set -u
set -o pipefail

lm_transformer_yaml_path=/media/zwl/zwl/espnet/egs2/librispeech/asr1/conf/tuning/train_lm_transformer2.yaml
#lm_transformer_yaml_path=../log/lm.log
# parse config
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -l|--layer) layer="$2"; shift ;; # 移除第一个参数
        -u|--unit) unit="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift # 移除第二个参数
done
cat >${lm_transformer_yaml_path}<<END
# this configuration requires Tesla V100-SXM2(32GB) x 16 GPUs It takes about 2 days.
use_amp: true
lm: transformer
lm_conf:
    pos_enc: null
    embed_unit: 128
    att_unit: 512
    head: 8
    unit: $unit
    layer: $layer
    dropout_rate: 0.0

# optimization related
grad_clip: 5.0
batch_type: numel
batch_bins: 500000000
accum_grad: 2
max_epoch: 25

optim: adam
optim_conf:
   lr: 0.005
scheduler: warmuplr
scheduler_conf:
   warmup_steps: 25000

best_model_criterion:
-   - valid
    - loss
    - min
keep_nbest_models: 10  # 10 is good.
END
