# Use the specific NVIDIA NeMo release
FROM nvcr.io/nvidia/nemo:26.02

# Set the working directory
WORKDIR /workspace

# Copy only the files needed (helps with build caching)
COPY . .

# Ensure the script is executable
RUN chmod +x /workspace/runTrain.sh

# Optional: Set the default command
ENTRYPOINT ["./runTrain.sh"]