import torch
from PIL import Image

from lavis.models import load_model_and_preprocess

import openai

openai.api_key = 'your-api-key'


device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

model, vis_processors, _ = load_model_and_preprocess(
    name="blip_caption", model_type="large_coco", is_eval=True, device=device
)

vis_processors.keys()

initial_msg = "I'm doing Image captioning with deep learning model. If I feed the model a image, it gives me several sentences. But I can't fully trust the model. So if i give you the sentences, read them and give me a compressed sentence. Not just adding. I don't need any description. I just want a 'compressed' sentence. I'll try this many time."

messages = [
    {'role': 'system', 'content': 'You are a helpful assistant.'},
    {'role': 'user', 'content': initial_msg},
]

res = openai.ChatCompletion.create(
    model='gpt-3.5-turbo',
    messages=messages
)

msg = res['choices'][0]['message']['content']

messages.append({
        'role': 'assistant',
        'content': msg
    })

def get_captions(location, num_captions):
    raw_image = Image.open(location).convert("RGB")
    display(raw_image.resize((596, 437)))
    image = vis_processors["eval"](raw_image).unsqueeze(0).to(device)
    captions = model.generate({"image": image}, use_nucleus_sampling=True, num_captions=num_captions)
    for caption in captions:
        print(caption)

    return captions

def get_sentence(captions):
    messages.append({
        'role': 'user',
        'content': ' '.join(captions)
    })
    
    res = openai.ChatCompletion.create(
        model='gpt-3.5-turbo',
        messages=messages
    )

    messages.append({
        'role': 'assistant',
        'content': res['choices'][0]['message']['content']
    })

    return res

location = "./docs/_static/merlion.png"
num_captions = 3

captions = get_captions(location, num_captions)
res = get_sentence(captions)['choices'][0]['message']['content']

try:
    sentence = res.split(':')[1].replace('\n', ' ').replace("'", "").replace('"','').strip()
except:
    sentence = res.replace('\n', ' ').replace("'", "").replace('"','').strip()

messages.append({
        'role': 'user',
        'content': 'Recommend me three music genres that go well with this sentence. Seperate genres in comma'
    })
    
res = openai.ChatCompletion.create(
    model='gpt-3.5-turbo',
    messages=messages
)
print(res['choices'][0]['message']['content'])

# In[ ]:





# In[ ]:




