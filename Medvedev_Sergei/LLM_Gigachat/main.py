from langchain_gigachat.chat_models import GigaChat
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate

import streamlit as st

def contextChange(model, template, params) -> None:
    systemTemplate = template
    promptTemplate = ChatPromptTemplate.from_messages(
        [("system", systemTemplate), ("user", "{text}")]
    )

    st.write("Результат:")
    chain = promptTemplate | model | parser
    res = chain.invoke(params)
    with st.container():
        blockContainer = st.container()

        with blockContainer:
            st.markdown("""
                        <div style="
                            border: 2px solid black;
                            padding: 10px;
                            margin: 20px;
                            background-color: white;
                            border-radius: 5px;
                        ">
                            {0}
                        </div>
                    """.format(res), unsafe_allow_html=True)

def setParams(textInput, param, token):
    params = None
    model = None
    if not textInput:
        st.warning("Пожалуйста, введите текст перед сохранением.")
    else:
        params = param
    if not token:
        st.warning("Пожалуйста, введите свой Authorization key")
    else:
        model = GigaChat(
            credentials=token,
            scope="GIGACHAT_API_PERS",
            model="GigaChat-Pro",
            verify_ssl_certs=False,
        )
    return params, model

st.title("Изменение контекста текста")

with st.container():
    st.subheader("Введите ваш Authorization key")
    token = st.text_area(label="В целях экономия токенов, советую не вводить большие запросы", height=100)

with st.container():
    st.subheader("Введите текст")
    textInput = st.text_area(label="Ваш текст", height=100)

parser = StrOutputParser()

systemTemplate = "Ты эксперт в сфере актёрского мастерства. Перепиши следующий текст в стиль {language} языка. Влейся в роль хорошо, в своём тексте используй сравнения с типичными для {man} предметами быта: {obj}."

promptTemplate = ChatPromptTemplate.from_messages(
    [("system", systemTemplate), ("user", "{text}")]
)

systemTemplate = "Ты эксперт в сфере актёрского мастерства. Перепиши следующий текст в стиль {language} языка {kogo}. Влейся в роль хорошо, в своём тексте используй сравнения с типичными для {man} предметами быта: {obj}."

btnRUS = st.button("Изменить на контекст 15 века")
btnBuinaySlavick = st.button("Изменить на контекст языка гопника")
bntZONE51 = st.button("Изменить на контекст языка инопланетянина с Марса")
btnZumer = st.button("Изменить на контекст языка зумера")

if btnRUS:
    params, model = setParams(textInput, {"language": "древнерусского языка 15 века", "kogo":"", "man": "древнерусского человека 15 века",
         "obj": "царь, церковь, поле, квас, пояс, лапти, перстни, четверток, жнец, злато, сундук и так далее", "text": textInput}, token)
    if params and model:
        try:
            contextChange(model, systemTemplate, params)
        except:
            st.warning("Пожалуйста, введите правильный Authorization key")


if btnBuinaySlavick:
    params, model = setParams(textInput, {"language": "", "kogo":"гопника", "man": "гопника",
         "obj": "олимпийка, семечки, подъезд, Приора, треники и так далее", "text": textInput}, token)
    if params and model:
        try:
            contextChange(model, systemTemplate, params)
        except:
            st.warning("Пожалуйста, введите правильный Authorization key")

if bntZONE51:
    params, model = setParams(textInput, {"language": "", "kogo": "инопланетянина с Марса", "man": "инопланетянина с Марса",
                  "obj": "оранжево-апельсиновые равнины, воздушные лодки, различные племена марсиан, робот-ассистент и так далее", "text": textInput}, token)
    if params and model:
        try:
            contextChange(model, systemTemplate, params)
        except:
            st.warning("Пожалуйста, введите правильный Authorization key")

if btnZumer:
    params, model = setParams(textInput, {"language": "", "kogo": "зумера", "man": "зумера",
                  "obj": "смартфон, плазма, iPad, Clash of Clans, PUBG Mobile, Genshin Impact, Fortnite, Minecraft, Among Us, TikTok, Instagram, Snapchat, Twitch, YouTube, энергетик, вейп, топовый плейлист, флекс, рофл, голосовуха, дарк рейв тусовка", "text": textInput}, token)
    if params and model:
        try:
            contextChange(model, systemTemplate, params)
        except:
            st.warning("Пожалуйста, введите правильный Authorization key")

st.title("Эссе")
with st.container():
    st.subheader("Введите текст")
    textInputEsse = st.text_area(label="Введите текст ниже", height=100)

cnt = st.slider("Максимальный объем эссе", 10, 1000, 500)
btnEsseReady = st.button("Написать эссе по тексту")

if btnEsseReady:
    params, model = setParams(textInputEsse, {"cnt":cnt, "text": textInputEsse}, token)
    systemTemplate = "Ты эксперт журналист. Напиши пожалуйста эссе по написаному ниже тексту. Максимальный объём эссе {cnt} слов"
    if params and model:
        try:
            contextChange(model, systemTemplate, params)
        except:
            st.warning("Пожалуйста, введите правильный Authorization key")