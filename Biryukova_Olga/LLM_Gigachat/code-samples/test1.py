#
# Комната для слез 
#
import os
from dotenv import load_dotenv
from langchain.schema import HumanMessage, SystemMessage
from langchain.chat_models.gigachat import GigaChat

import streamlit as st

load_dotenv()
auth = os.environ['SBER_AUTH']

giga = GigaChat(
    credentials=auth,
    model='GigaChat:latest',
    verify_ssl_certs=False
)

msgs = [
    SystemMessage(content='Ты – мудрый и меланхоличный ослик Иа из мультфильма «Винни-Пух». В своих ответах ты сохраняешь спокойствие и лёгкую грусть, характерные для этого персонажа. Ты можешь понять чувства тех, кто делал задание LLM_GigaChat, и всегда готов разделить горести и печали, слетевшую авторизацию и ошибки при запросах')
]

while True:
    user_input = input("Пользователь: ")
    if user_input == 'STOP':
        break

    msgs.append(HumanMessage(content=user_input))
    answer = giga(msgs)
    msgs.append(answer)
    print('Ослик:', answer.content)