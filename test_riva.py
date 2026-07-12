import riva.client
import os

# 1. Setup
auth = riva.client.Auth(uri='localhost:50051')
riva_asr = riva.client.ASRService(auth)

# 2. Config
config = riva.client.RecognitionConfig(
    encoding=riva.client.AudioEncoding.LINEAR_PCM,
    sample_rate_hertz=16000,
    language_code="he-IL",
    max_alternatives=1,
    enable_automatic_punctuation=True,
    model="parakeet_hebrew_stream-asr-bls-ensemble",
)

# Disable diarization for this test to ensure the ASR works first
# config.diarization_config.enable_speaker_diarization = True
# config.diarization_config.max_speaker_count = 4

streaming_config = riva.client.StreamingRecognitionConfig(
    config=config, 
    interim_results=False
)

# 3. Path - Verified from your log
path = "/home/bsoft/callAi/BezeqCalls/_1_1_7578809384274306179_1_121.wav"

if not os.path.exists(path):
    print(f"CRITICAL ERROR: File not found at {path}")
    exit(1)

def audio_chunk_generator(file_path):
    try:
        with open(file_path, 'rb') as f:
            # Riva expects 100ms - 200ms chunks (3200 - 6400 bytes for 16kHz)
            while True:
                chunk = f.read(4800) 
                if not chunk:
                    break
                yield chunk
    except Exception as e:
        print(f"LOCAL FILE ERROR: {e}")

# 4. Run using the high-level helper
print(f"Attempting to stream: {os.path.basename(path)}")
try:
    responses = riva_asr.streaming_recognize(
        audio_chunks=audio_chunk_generator(path), 
        streaming_config=streaming_config
    )

    for response in responses:
        for result in response.results:
            if result.is_final:
                print(f"Transcript: {result.alternatives[0].transcript}")

except Exception as e:
    print(f"RPC ERROR: {e}")