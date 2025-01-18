import streamlit as st
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_core.output_parsers import StrOutputParser
from langchain_gigachat.chat_models import GigaChat

AUTH_KEY = st.secrets["authentication"]["AUTH_KEY"]
SCOPE = st.secrets["scope"]["SCOPE"]

gigachat = GigaChat(credentials=AUTH_KEY, scope=SCOPE, model="GigaChat", verify_ssl_certs=False)
parser = StrOutputParser()


def main():
    st.title("GigaChat API")

    if "system_prompt_custom" not in st.session_state:
        st.session_state.system_prompt_custom = ("Твоя роль - эксперт в системной аналитике. \n"
                                                 "Всегда отвечай на русском языке. \n")
    if "user_prompt_custom" not in st.session_state:
        st.session_state.user_prompt_custom = ""
    if "user_prompt_summary" not in st.session_state:
        st.session_state.user_prompt_summary = ""
    if "user_prompt_brainstorm" not in st.session_state:
        st.session_state.user_prompt_brainstorm = ""
    if "clear_all" not in st.session_state:
        st.session_state.clear_all = False

    if st.session_state.clear_all:
        st.session_state.system_prompt_custom = ""
        st.session_state.user_prompt_custom = ""
        st.session_state.user_prompt_summary = ""
        st.session_state.user_prompt_brainstorm = ""
        st.session_state.clear_all = False  # Сброс флага

    tabs = st.tabs(["Summary", "Brainstorm", "Custom"])

    # Вкладка 1: Суммаризация
    with tabs[0]:
        st.header("Краткое изложение текста")

        user_prompt_summary = st.text_area("Введите текст для суммаризации:", height=120, key="user_prompt_summary")

        max_words = st.slider("Укажите целевое количество слов в ответе:", 3, 300, 30, key="max_words")
        if st.button("Суммаризировать", key="summarize_request"):
            system_prompt_summary = (f"Твоя роль - эксперт в журналистике. \n"
                                     f"Необходимо вернуть краткое изложение текста, сократив результат до {max_words} слов. \n"
                                     f"Всегда отвечай на русском языке. \n")

            messages = [SystemMessage(content=system_prompt_summary), HumanMessage(content=user_prompt_summary)]
            try:
                result = gigachat.invoke(messages)
                parsed_result = parser.invoke(result.content)
                st.text_area("Результат суммаризации:", value=parsed_result, height=120, key="response_result_summary")
            except Exception as e:
                st.error(f"Ошибка при суммаризации: {e}")

    # Вкладка 2: Брейншторм
    with tabs[1]:
        st.header("Мозговой штурм")

        user_prompt_brainstorm = st.text_area("Введите текст для брейншторминга:", height=120,
                                              key="user_prompt_brainstorm")

        if st.button("Начать брейншторм", key="brainstorm_request"):
            system_prompt_brainstorm = ("Твоя роль - креативный эксперт, генерирующий идеи. \n"
                                        "Всегда отвечай на русском языке. \n")

            messages = [SystemMessage(content=system_prompt_brainstorm), HumanMessage(content=user_prompt_brainstorm)]
            try:
                result = gigachat.invoke(messages)
                parsed_result = parser.invoke(result.content)
                st.text_area("Результат брейншторминга:", value=parsed_result, height=120,
                             key="response_result_brainstorm")
            except Exception as e:
                st.error(f"Ошибка при брейншторминге: {e}")

    # Вкладка 3: Настраиваемый запрос
    with tabs[2]:
        st.header("Настраиваемый запрос")

        system_prompt_custom = st.text_area("Введите системный промпт:", height=80, key="system_prompt_custom")
        user_prompt_custom = st.text_area("Введите текст для запроса:", height=120, key="user_prompt_custom")

        if st.button("Отправить запрос", key="custom_request"):
            messages = [SystemMessage(content=system_prompt_custom), HumanMessage(content=user_prompt_custom)]
            try:
                result = gigachat.invoke(messages)
                parsed_result = parser.invoke(result.content)
                st.text_area("Результат запроса:", value=parsed_result, height=120, key="response_result_custom")
            except Exception as e:
                st.error(f"Ошибка при отправке запроса: {e}")

    # Кнопка для очистки всех полей
    if st.button("Очистить все поля"):
        st.session_state.clear_all = True
        st.rerun()


if __name__ == "__main__":
    main()
