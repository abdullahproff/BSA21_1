#
# Вариант получения токена регистрации + диалог с GigaChat в терминале
#
import os
from dotenv import load_dotenv
import base64
import requests
import uuid
import urllib3


load_dotenv()  


client_id = os.getenv('SBER_ID')
secret = os.getenv('SBER_SECRET')
auth = os.getenv('SBER_AUTH')


credentials = f"{client_id}:{secret}"
encoded_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')


urllib3.disable_warnings()

# Функция для получения токена
def get_token(scope='GIGACHAT_API_PERS'):
    rq_uid = str(uuid.uuid4())
    
    url = "https://ngw.devices.sberbank.ru:9443/api/v2/oauth"
    
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'RqUID': rq_uid,
        'Authorization': f'Basic {encoded_credentials}'
    }
    
    payload = {
        'scope': scope
    }
    
    try:
        response = requests.post(url, headers=headers, data=payload, verify=False)
        if response.status_code == 200:
            return response.json()['access_token']  # Возвращаем access token
        else:
            print(f"Ошибка при получении токена: {response.text}")
            return None
    except requests.RequestException as e:
        print(f"Ошибка: {str(e)}")
        return None

# Получаем токен
giga_token = get_token()

# Если токен получен успешно, продолжаем работу
if giga_token is not None:
    def get_chat_completion(user_message):
        url = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"
        
        payload = {
            "model": "GigaChat",
            "messages": [
                {
                    "role": "user",
                    "content": user_message
                }
            ],
            "temperature": 1,
            "top_p": 0.1,
            "n": 1,
            "stream": False,
            "max_tokens": 512,
            "repetition_penalty": 1,
            "update_interval": 0
        }
        
        headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': f'Bearer {giga_token}'
        }
        
        try:
            response = requests.post(url, headers=headers, json=payload, verify=False)
            return response
        except requests.RequestException as e:
            print(f"Ошибка: {str(e)}")
            return None

    answer = get_chat_completion('Как в Python сделать GET запрос?')
    if answer is not None:
        content = answer.json()['choices'][0]['message']['content']
        print(content)  # Вывод содержимого ответа от GigaChat
else:
    print("Не удалось получить токен.")

####

# Пример использования 1

# import requests
# import json
# import urllib3

# urllib3.disable_warnings()

# def get_chat_completion(auth_token, user_message, conversation_history=None):
#     url = "https://gigachat.devices.sberbank.ru/api/v1/chat/completions"

#     if conversation_history is None:
#         conversation_history = []

#     conversation_history.append({
#         "role": "user",
#         "content": user_message
#     })

#     payload = json.dumps({
#         "model": "GigaChat",
#         "messages": conversation_history,
#         "temperature": 1,
#         "top_p": 0.1,
#         "n": 1,
#         "stream": False,
#         "max_tokens": 512,
#         "repetition_penalty": 1,
#         "update_interval": 0
#     })
#     headers = {
#         'Content-Type': 'application/json',
#         'Accept': 'application/json',
#         'Authorization': f'Bearer {auth_token}'
#     }

#     try:
#         response = requests.post(url, headers=headers, data=payload, verify=False)

#         if response.status_code == 200:
#             response_data = response.json()
#             conversation_history.append({
#                 "role": "assistant",
#                 "content": response_data['choices'][0]['message']['content']  # Обновляем историю разговора
#             })
#             return response_data, conversation_history
#         else:
#             print(f"Request failed with status code: {response.status_code}")
#             return None, conversation_history

#     except requests.RequestException as e:
#         print(f"Error: {str(e)}")
#         return None, conversation_history


# Пример использования 2

# conversation_history = []

# response, conversation_history = get_chat_completion(giga_token, "Как твои дела?", conversation_history)
# if response is not None:
#     print("Response:", response['choices'][0]['message']['content'])
# else:
#     print("Failed to get a response.")

# response, conversation_history = get_chat_completion(giga_token, "Что ты умеешь?", conversation_history)
# if response is not None:
#     print("Response:", response['choices'][0]['message']['content'])
# else:
#     print("Failed to get a response.")


# conversation_history = [{
#     'role': 'system',
#     'content': 'Отвечай как бывалый пират. Пусть тебя зовут Генри Морган'
# }]

# response, conversation_history = get_chat_completion(giga_token, "Привет, друг!", conversation_history)

# if response is not None:
#     print("Response:", response['choices'][0]['message']['content'])
# else:
#     print("Failed to get a response.")

