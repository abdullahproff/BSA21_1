import os
import streamlit as st
from langchain_gigachat.chat_models import GigaChat
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

AUTH_KEY = st.secrets["authentication"]["AUTH_KEY"]
SCOPE = st.secrets["SCOPE"]["scope"]

gigachat = GigaChat(credentials=AUTH_KEY, scope=SCOPE, model="GigaChat", verify_ssl_certs=False)

# Шаблон для системного сообщения
system_template = "Переведи следующий текст на {language}:"
prompt_template = ChatPromptTemplate.from_messages([
    ('system', system_template),
    ('user', '{text}')
])

# Парсер
parser = StrOutputParser()

# Streamlit
def main():
    st.title("Работа с GigaChat API")

    # Ввод системного промпта
    system_prompt = st.text_input("Введите системный промпт:", value="Ты помощник.")

    # Ввод промпта пользователя
    if "user_prompt" not in st.session_state:
        st.session_state.user_prompt = ""

    user_prompt = st.text_area("Введите текст для запроса:", height=150, key="user_input_summary_1", value=st.session_state.user_prompt)

    col1, col2 = st.columns(2)
    
    # Обработка кнопки для Суммаризации
    with col1:
        if st.button("Суммаризация"):
            temp_system_prompt = "Ты помощник, специализирующийся на суммаризации текста."
            # Подготовка сообщений
            messages = [
                SystemMessage(content=temp_system_prompt),
                HumanMessage(content=user_prompt)
            ]
            # Вызов модели
            result = gigachat.invoke(messages)
            # Парсинг ответа
            parsed_result = parser.invoke(result)
            if parsed_result:
                st.session_state.user_prompt = parsed_result
                st.text_area("Суммаризация:", value=st.session_state.user_prompt, height=150, key="user_input_2")

    # Обработка кнопки для Брейншторминга
    with col2:
        if st.button("Брейншторм"):
            temp_system_prompt = "Ты помощник, помогающий генерировать идеи."
            # Подготовка сообщений
            messages = [
                SystemMessage(content=temp_system_prompt),
                HumanMessage(content=user_prompt)
            ]
            # Вызов модели
            result = gigachat.invoke(messages)
            # Парсинг ответа
            parsed_result = parser.invoke(result)
            if parsed_result:
                st.session_state.user_prompt = parsed_result
                st.text_area("Брейншторм:", value=st.session_state.user_prompt, height=150, key="user_input_summary_brainstorm_3")

    # Кнопка для отправки пользовательского запроса
    if st.button("Отправить запрос"):
        messages = [
            SystemMessage(content=system_prompt),
            HumanMessage(content=user_prompt)
        ]
        result = gigachat.invoke(messages)
        parsed_result = parser.invoke(result)
        if parsed_result:
            st.session_state.user_prompt = parsed_result
            st.text_area("Введите текст для запроса:", value=st.session_state.user_prompt, height=150, key="user_input_summary_response_4")

    # Кнопка для очистки всех полей
    if st.button("Очистить все"):
        for key in st.session_state.keys():
            del st.session_state[key]

if __name__ == "__main__":
    main()
