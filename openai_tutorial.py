import os
from openai import OpenAI
from dotenv import load_dotenv
load_dotenv()

client = OpenAI(
    api_key=os.environ.get("OPENAI_API_KEY"),
)

chat_completion = client.chat.completions.create(
    messages=[
        {
            "role": "user",
            "content": "what is the name of the Disney movie about a meramid who falls in love with a human?",
        }
    ],
    model="gpt-3.5-turbo",
)

print(chat_completion.choices[0].message.content)