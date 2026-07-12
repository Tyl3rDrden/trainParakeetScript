from huggingface_hub import copy_files

# This will move the files from the source dataset to your new bucket
copy_files(
    repo_id="ivrit-ai/jbd",
    repo_type="dataset",
    src_dir="/",
    dst_repo_id="Tyl3rDrden/ivrit-audio-v2-shards",
    dst_repo_type="bucket"
)
