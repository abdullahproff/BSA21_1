import requests
import json

# Данные для авторизации
CLIENT_ID = "52cda2c8-debf-4a52-8abb-e32045ad945a"
SCOPE = "GIGACHAT_API_PERS"
AUTH_KEY = "NTJjZGEyYzgtZGViZi00YTUyLThhYmItZTMyMDQ1YWQ5NDVhOjcxMzhhMjExLWU1YmYtNGNjNi05ZjQ4LTZhOTQzYTMxZmQwOQ=="

# URL для получения Access token
OAUTH_URL = "https://ngw.devices.sberbank.ru:9443/api/v2/oauth"

# Параметры запроса для получения Access token
payload = {
    'scope': SCOPE
}
headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'RqUID': '042dfebb-58ec-486c-9330-dbcb260c7361',
    'Authorization': f'Basic {AUTH_KEY}'
}

# Отправка запроса на получение Access token
response = requests.post(OAUTH_URL, headers=headers, data=payload)

if response.status_code == 200:
    access_token = response.json().get("access_token")
    print("Access token получен:", access_token)
else:
    print(f"Ошибка при получении Access token: {response.status_code}", response.text)
    exit()

# URL для отправки промптов в GigaChat API
API_URL = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"

# Системный и пользовательский промпты
system_prompt = "You are an expert assistant."
user_prompt = "Расскажи мне что-нибудь интересное о Python."

# Параметры запроса для отправки промптов
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

# Отправка запроса к GigaChat API
response = requests.post(API_URL, headers=headers, data=json.dumps(payload))

# Обработка ответа
if response.status_code == 200:
    response_data = response.json()
    reply = response_data.get("choices", [])[0].get("message", {}).get("content", "")
    print("Ответ от GigaChat:", reply)
else:
    print(f"Ошибка при запросе к GigaChat API: {response.status_code}", response.text)

