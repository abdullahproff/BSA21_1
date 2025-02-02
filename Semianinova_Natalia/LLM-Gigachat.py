from langchain_gigachat.chat_models import GigaChat
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate

import streamlit as st
import locale
from datetime import datetime  # Импортируем datetime

# Устанавливаем русский язык для форматирования даты
locale.setlocale(locale.LC_TIME, "ru_RU.UTF-8")

def contextChange(model, template, params) -> None:
    promptTemplate = ChatPromptTemplate.from_messages([
        ("system", template),
        ("user", "{text}")
    ])
    chain = promptTemplate | model | StrOutputParser()
    res = chain.invoke(params)
   
    with st.container():
        st.markdown(f"""
            <div style="border: 2px solid black; padding: 10px; margin: 20px; background-color: white; border-radius: 5px;">
                {res}
            </div>
        """, unsafe_allow_html=True)

def setParams(textInput, param, token):
    if not textInput:
        st.warning("Пожалуйста, введите текст")
        return None, None
    if not token:
        st.warning("Пожалуйста, введите свой Authorization key")
        return None, None
    model = GigaChat(
        credentials=token,
        scope="GIGACHAT_API_PERS",
        model="GigaChat-Pro",
        verify_ssl_certs=False,
    )
    return param, model

st.title("LLM_Gigachat_BSA")

with st.container():
    #st.subheader("Введите ваш Authorization key")
    token = st.text_area("Введите ваш Authorization key", height=100)
    #token = st.text_area("В целях экономии токенов, советую не вводить большие запросы", height=100)

with st.container():
    #st.subheader("Введите текст")
    textInput = st.text_area("Введите текст", height=100)  # Промпт

btnLit = st.button("Опиши природу как в классической художественной литературе")
btnGeo = st.button("Опиши природу как в учебнике географии")
btnWeather = st.button("Опиши природу как для прогноза погоды")

if btnLit:
    params, model = setParams(textInput, {"style": "классической художественной литературы", "text": textInput}, token)
    if params and model:
        contextChange(model, "Опиши природу в стиле {style}.", params)

if btnGeo:
    params, model = setParams(textInput, {"style": "учебника географии", "text": textInput}, token)
    if params and model:
        contextChange(model, "Опиши природу в стиле {style}.", params)

if btnWeather:
    params, model = setParams(textInput, {"style": "прогноза погоды", "text": textInput}, token)
    if params and model:
        contextChange(model, "Опиши природу в стиле {style}.", params)

st.title("Согласие на обработку персональных данных")

# Получаем текущую дату
today = datetime.today()
formatted_date = f"«{today.day}» {today.strftime('%B')} {today.year}"

with st.container():
    st.subheader("Введите данные")
    fio = st.text_input("ФИО")
    doc_series = st.text_input("Серия документа")
    doc_number = st.text_input("Номер документа")
    doc_date = st.text_input("Дата выдачи документа")
    address = st.text_input("Адрес регистрации")

btnConsent = st.button("Создать согласие")

if btnConsent:
    consent_text = f"""
    СОГЛАСИЕ<br>
    на обработку персональных данных<br><br>
    Я, {fio}, основной документ паспорт<br>
    серия {doc_series} номер {doc_number}<br>
    выдан {doc_date},<br>
    зарегистрированный(ая) по адресу: {address}<br>
    даю свое согласие на обработку моих персональных данных исключительно в целях
    рассмотрения моих документов, а также на хранение данных об этих результатах
    на электронных носителях.<br><br>
    Дата {formatted_date} ________________ Подпись
    """

    with st.container():
        st.markdown(f"""
            <div style="border: 2px solid black; padding: 10px; margin: 20px; background-color: white; border-radius: 5px;">
                {consent_text}
            </div>
        """, unsafe_allow_html=True)


