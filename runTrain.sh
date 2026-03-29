!NUMBA_CUDA_USE_NVIDIA_BINDING=1 HYDRA_FULL_ERROR=1 python ./speech_to_text_finetune.py \
  --config-path="." \
  --config-name="speech_to_text_finetune" \
  trainer.accumulate_grad_batches=16 \
  trainer.devices=1 \
  trainer.accelerator=gpu \
  trainer.precision=16-mixed \
  +trainer.limit_train_batches=null \
  exp_manager.create_wandb_logger=True \
  exp_manager.wandb_logger_kwargs.name=parakeet_v3_finetune_fixed \
  exp_manager.wandb_logger_kwargs.project=parakeet-hebrew-asr 