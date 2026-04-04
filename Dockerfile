# Use the specific NVIDIA NeMo release
FROM nvcr.io/nvidia/nemo:26.02

# 1. Set the working directory
WORKDIR /workspace
COPY . .
# We point uv specifically to the NeMo virtual environment
RUN uv pip install --upgrade --python /opt/venv/bin/python huggingface_hub fsspec && \
    sed -i 's/require_version_core(deps\[pkg\])/pass/g' /opt/venv/lib/python3.12/site-packages/transformers/dependency_versions_check.py
# This overwrites the broken file in the pre-installed library
COPY rnnt_models.py /opt/NeMo/nemo/collections/asr/models/rnnt_models.py
RUN LHOTSE_DIR=$(python -c 'import lhotse, os; print(os.path.dirname(lhotse.__file__))') && \
    cp serialization.py $LHOTSE_DIR/serialization.py && \
    cp lazy.py $LHOTSE_DIR/lazy.py && \
    cp lazyShar.py $LHOTSE_DIR/shar/readers/lazy.py
# 3. Handle WANDB (Passed at runtime for security)
# We leave the variable name here so the script can find it
ENV WANDB_API_KEY="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"

# 4. Copy your local training scripts/configs

# 5. Setup execution
RUN chmod +x /workspace/runTrain.sh

CMD ["/bin/bash", "-c", "sleep infinity"]
