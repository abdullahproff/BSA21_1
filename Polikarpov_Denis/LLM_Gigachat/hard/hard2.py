import os
import requests
import streamlit as st
import json

CLIENT_ID = "52cda2c8-debf-4a52-8abb-e32045ad945a"
SCOPE = "GIGACHAT_API_PERS"
AUTH_KEY = "NTJjZGEyYzgtZGViZi00YTUyLThhYmItZTMyMDQ1YWQ5NDVhOjcxMzhhMjExLWU1YmYtNGNjNi05ZjQ4LTZhOTQzYTMxZmQwOQ=="

CERT_PATH = "/home/denis/russiantrustedca.pem"  # Замените на фактический путь к вашему сертификату

OAUTH_URL = "https://ngw.devices.sberbank.ru:9443/api/v2/oauth"

# Функция для получения Access token
def get_access_token():
    payload = {'scope': SCOPE}
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'RqUID': '042dfebb-58ec-486c-9330-dbcb260c7361',
        'Authorization': f'Basic {AUTH_KEY}'
    }

    try:
        response = requests.post(OAUTH_URL, headers=headers, data=payload, verify=CERT_PATH)
        response.raise_for_status()
        access_token = response.json().get("access_token")
        if not access_token:
            st.error("Access token не получен. Проверьте правильность данных для авторизации.")
            return None
        return access_token
    except requests.exceptions.RequestException as e:
        st.error(f"Ошибка при получении Access token: {str(e)}")
        return None

# Отправка запроса
def get_gigachat_response(access_token, system_prompt, user_prompt):
    API_URL = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"

    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {access_token}'
    }

    payload = {
        "model": "GigaChat",
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ]
    }

    try:
        response = requests.post(API_URL, headers=headers, json=payload, verify=CERT_PATH)
        response.raise_for_status()
        response_data = response.json()
        return response_data.get("choices", [])[0].get("message", {}).get("content", "")
    except requests.exceptions.RequestException as e:
        st.error(f"Ошибка при запросе к GigaChat API: {str(e)}")
        return None

# Основная функция Streamlit
def main():
    st.title("Работа с GigaChat API")

    # Поле для системного промпта
    system_prompt = st.text_input("Введите системный промпт:", value="Ты помощник.")

    # Ввод пользовательского промпта
    if "user_prompt" not in st.session_state:
        st.session_state.user_prompt = ""

    user_prompt = st.text_area("Введите текст для запроса:", height=150, key="user_input_summary_1", value=st.session_state.user_prompt)

    col1, col2 = st.columns(2)
    with col1:
        if st.button("Суммаризация"):
            temp_system_prompt = "Ты помощник, специализирующийся на суммаризации текста."
            access_token = get_access_token()
            if not access_token:
                return
            response = get_gigachat_response(access_token, temp_system_prompt, user_prompt)
            if response:
                st.session_state.user_prompt = response
                st.text_area("Суммаризация:", value=st.session_state.user_prompt, height=150, key="user_input_2")

    with col2:
        if st.button("Брейншторм"):
            temp_system_prompt = "Ты помощник, помогающий генерировать идеи."
            access_token = get_access_token()
            if not access_token:
                return
            response = get_gigachat_response(access_token, system_prompt, user_prompt)
            if response:
                st.session_state.user_prompt = response
                st.session_state.user_prompt = response
                st.text_area("Брейншторм:", value=st.session_state.user_prompt, height=150, key="user_input_summary_brainstorm_3")

    # Кнопка для отправки пользовательского запроса
    if st.button("Отправить запрос"):
        access_token = get_access_token()
        if not access_token:
            return
        response = get_gigachat_response(access_token, system_prompt, user_prompt)
        if response:
            st.session_state.user_prompt = response
            st.session_state.user_prompt = response
            st.text_area("Введите текст для запроса:", value=st.session_state.user_prompt, height=150, key="user_input_summary_response_4")

if __name__ == "__main__":
    main()

    # Кнопка для очистки всех полей
    if st.button("Очистить все"):
        for key in st.session_state.keys():
            del st.session_state[key]
