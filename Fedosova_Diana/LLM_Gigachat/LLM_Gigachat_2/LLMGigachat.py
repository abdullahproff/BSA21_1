import streamlit as st
import os
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_gigachat.chat_models import GigaChat

# Получаем токен
credentials = os.getenv('GIGACHAT_TOKEN')
if not credentials:
    raise EnvironmentError("Authorization key не установлен.")

# Подключаемся к GigaChat
giga = GigaChat(credentials=credentials, verify_ssl_certs=False)

def summarize_text(long_text):
    prompt = f"Суммируйте следующий текст: {long_text}"
    response = giga.invoke([prompt])
    return response.content

def brainstorm_ideas(brainstorm_question):
    prompt = f"Предложите идеи для брейншторминга следующего вопроса: {brainstorm_question}"
    response = giga.invoke([prompt])
    return response.content

st.title("Помощник для суммаризации и генерации идей")

action_choice = st.selectbox(
    'Выберите действие:',
    ('Суммаризация текста', 'Брейншторминг идей'))

if action_choice == 'Суммаризация текста':
    long_text = st.text_area("Введите текст для суммаризации:", height=200)
    if st.button('Суммаризировать'):
        result = summarize_text(long_text)
        st.write(result)
        
elif action_choice == 'Брейншторминг идей':
    brainstorm_question = st.text_input("Введите вопрос для брейншторминга:")
    if st.button('Генерировать идеи'):
        result = brainstorm_ideas(brainstorm_question)
        st.write(result)
