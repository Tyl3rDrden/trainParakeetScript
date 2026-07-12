# 1. Start with the verified NVIDIA PyTorch base
FROM nvcr.io/nvidia/pytorch:26.06-py3

# 2. Install essential system audio/video dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsndfile1 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 3. Install the toolkit directly
# This pulls the latest compatible versions for your specific stack
#RUN pip install --no-cache-dir Cython packaging && \
#    pip install --no-cache-dir git+https://github.com/NVIDIA-NeMo/NeMo.git@main#egg=nemo_toolkit[asr]
# Use the updated syntax: 'package[extra] @ git+URL'
RUN pip install --no-cache-dir Cython packaging && \
    pip install --no-cache-dir "nemo_toolkit[asr] @ git+https://github.com/NVIDIA-NeMo/NeMo.git@main"

RUN pip uninstall -y cuda-python cuda-bindings cuda-core && \
    pip install --no-cache-dir cuda-python==12.8.0 cuda-core
# 4. Setup your custom work
WORKDIR /workspace
COPY . .

# 5. Apply your custom patches
# Since you're installing from source, you can simply overwrite the files
# wherever the package was installed by pip
RUN LHOTSE_DIR=$(python -c 'import lhotse, os; print(os.path.dirname(lhotse.__file__))') && \
    cp serialization.py $LHOTSE_DIR/serialization.py && \
    cp lazy.py $LHOTSE_DIR/lazy.py && \
    cp lazyShar.py $LHOTSE_DIR/shar/readers/lazy.py

RUN chmod +x /workspace/runTrain.sh
