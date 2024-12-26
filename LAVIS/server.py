import os
import replicate

os.environ["REPLICATE_API_TOKEN"] = "r8_2AuNOJhtZSGJCMrVHztrvfR5M4ndHOh3VNOAl"
output = replicate.run(
    "riffusion/riffusion:8cf61ea6c56afd61d8f5b9ffd14d7c216c0a93844ce2d82ac1c9ecc9c7f24e05",
    input={"prompt_a": "Fountain spraying water into lake in front of tall building, along with giant statue of a dragon."}
)
print(output)