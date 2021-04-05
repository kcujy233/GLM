#!/bin/bash
source config_tasks/model_blocklm_10B.sh

MPSIZE=1
MAXSEQLEN=512
MASTER_PORT=$(shuf -n 1 -i 10000-65535)

#SAMPLING ARGS
TEMP=0.9
#If TOPK/TOPP are 0 it defaults to greedy sampling, top-k will also override top-p
TOPK=40
TOPP=0

script_path=$(realpath $0)
script_dir=$(dirname $script_path)

config_json="$script_dir/ds_config.json"

MASTER_PORT=${MASTER_PORT} python generate_samples.py \
       --DDP-impl none \
       --model-parallel-size $MPSIZE \
       --deepspeed_config ${config_json} \
       $MODEL_ARGS \
       --fp16 \
       --cache-dir cache \
       --out-seq-length $MAXSEQLEN \
       --seq-length 512 \
       --temperature $TEMP \
       --top_k $TOPK \
       --top_p $TOPP
