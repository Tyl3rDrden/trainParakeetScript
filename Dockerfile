# Use the specific NVIDIA NeMo release
FROM nvcr.io/nvidia/nemo:26.02

# 1. Set the working directory
WORKDIR /workspace

# 2. Patch the NeMo library bug
# This overwrites the broken file in the pre-installed library
COPY rnnt_models.py /opt/NeMo/nemo/collections/asr/models/rnnt_models.py
# 3. Handle WANDB (Passed at runtime for security)
# We leave the variable name here so the script can find it
ENV WANDB_API_KEY="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"

# 4. Copy your local training scripts/configs
COPY . .

# 5. Setup execution
RUN chmod +x /workspace/runTrain.sh

ENTRYPOINT ["./runTrain.sh"]