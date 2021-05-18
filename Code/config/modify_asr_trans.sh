#!/bin/bash
set -e
set -u
set -o pipefail

asr_transform_path=/media/zwl/zwl/espnet/egs2/librispeech/asr1/conf/tuning/train_asr_transformer.yaml
#asr_transform_path=../log/asr.log
# parse config
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -l|--linear_units) linear_units="$2"; shift ;;# 移除第一个参数
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift # 移除第二个参数
done
cat > ${asr_transform_path} <<END
batch_type: numel
batch_bins: 16000000
accum_grad: 4
max_epoch: 200
patience: none
# The initialization method for model parameters
init: xavier_uniform
best_model_criterion:
-   - valid
    - acc
    - max
keep_nbest_models: 10

encoder: transformer
encoder_conf:
    output_size: 512
    attention_heads: 8
    linear_units: ${linear_units}
    num_blocks: 12
    dropout_rate: 0.1
    positional_dropout_rate: 0.1
    attention_dropout_rate: 0.0
    input_layer: conv2d
    normalize_before: true

decoder: transformer
decoder_conf:
    attention_heads: 8
    linear_units: ${linear_units}
    num_blocks: 6
    dropout_rate: 0.1
    positional_dropout_rate: 0.1
    self_attention_dropout_rate: 0.0
    src_attention_dropout_rate: 0.0

model_conf:
    ctc_weight: 0.3
    lsm_weight: 0.1
    length_normalized_loss: false

optim: adam
optim_conf:
    lr: 0.002
scheduler: warmuplr
scheduler_conf:
    warmup_steps: 25000

specaug: specaug
specaug_conf:
    apply_time_warp: true
    time_warp_window: 5
    time_warp_mode: bicubic
    apply_freq_mask: true
    freq_mask_width_range:
    - 0
    - 30
    num_freq_mask: 2
    apply_time_mask: true
    time_mask_width_range:
    - 0
    - 40
    num_time_mask: 2
END
