---

# GigaChat

## Работа с API

GigaChat API (Application Programming Interface, АПИ) представляет собой программный интерфейс, который позволяет вам использовать возможности GigaChat. Он может применяться для автоматизации рабочих процессов с данными или создания различных ассистентов.

### Доступ к GigaChat API

Для начала работы с GigaChat API выполните следующие шаги:

1. **Регистрация**: перейдите по ссылке https://developers.sber.ru/studio/workspaces и зарегистрируйтесь.
2. **Добавьте проект**: в личном кабинете добавьте проект GigaChat API.

### Получение токена доступа

Токен доступа необходим для взаимодействия с API. Вот несколько способов его получения:

#### 1. Postman

1. Перейдите по ссылке и пройдите регистрацию: https://god.gw.postman.com/run-collection/25485331-52bf7d83-c313-4517-9389-4d2eb361facd?action=collection%2Ffork&source=rip_markdown&collection-url=entityId%3D25485331-52bf7d83-c313-4517-9389-4d2eb361facd%26entityType%3Dcollection%26workspaceId%3Db6b5a2f3-c445-415b-a5db-62a8d0564dd6.
2. Выберите коллекцию «GigaChat API».
3. Создайте Fork (ответвление) для работы.
4. Сгенерируйте новые авторизационные данные в My GigaChat API и вставьте их в разделе Variables в строке Credentials, затем сохраните.
5. Откройте страницу «POST get access_token» в левом меню и нажмите кнопку «Send». Обратите внимание, что токен действителен в течение 30 минут.

#### 2. Colab

1. Установите расширение Chrome "Open in Colab" и создайте новую страницу для работы.
2. В левой панели выберите "Секреты", добавьте туда `SBER_AUTH`, `SBER_ID`, `SBER_SECRET` из новых сгенерированных авторизационных данных.
3. Объявите ключи авторизации:
   ```python
   from google.colab import userdata
   client_id = userdata.get('SBER_ID')
   secret = userdata.get('SBER_SECRET')
   auth = userdata.get('SBER_AUTH')
   import base64
   credentials = f"{client_id}:{secret}"
   encoded_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')
   ```
4. Создайте токен доступа:
   ```python
   import requests
   import uuid
   import urllib3
   urllib3.disable_warnings()
   
   def get_token(auth_token, scope='GIGACHAT_API_PERS'):
     rq_uid = str(uuid.uuid4())
     url = "https://ngw.devices.sberbank.ru:9443/api/v2/oauth"
     headers = {
       'Content-Type': 'application/x-www-form-urlencoded',
       'Accept': 'application/json',
       'RqUID': rq_uid,
       'Authorization': f'Basic {auth_token}'
     }
     payload = {
       'scope': scope
     }
     try:
       response = requests.post(url, headers=headers, data=payload, verify=False)
       return response
     except requests.RequestException as e:
       print(f"Ошибка: {str(e)}")
       return -1
   
   response = get_token(encoded_credentials)
   if response != -1:
     print(response.text)
     giga_token = response.json()['access_token']
   ```

#### 3. Самостоятельное создание токена

Перед началом работы убедитесь, что у вас установлены необходимые зависимости:

- Python версии от 3.9
- Библиотека `requests`
- Фреймворк `Streamlit`
- Пакет `gigachain`
- Пакет `langchain-community`
- Пакет `gigchat` для упрощения работы с GigaChat API
+ По потребности функционала

1. Создайте файл `.env` и добавьте туда свои авторизационные данные (пример):
   ```
   SBER_ID=74782995767396292754-b892-453e-814a-28ac121a0b8a
   SBER_SECRET=db7094c6-a8b0-4cfb-8c3f-462466372829q0738428739841
   SBER_AUTH=ODdjOGFkZGEtYjg98932TNlLTgxNGEtMjhhYzA5NGM2LWE4YjAtNGNmYi1N2JhMQ==
   ```

2. Если у вас уже есть сгенерированный токен, вы можете использовать его следующим образом:
   ```python
   import urllib.parse
   # Замените <YOUR_API_TOKEN> на ваш реальный токен
   token = "ZXlKamRIa2lPaUpxZDNRaUxDSmxibU1pT2lKQk1qVTJRMEpETFVoVE5URXlJaXdpWVd4bklqb2lV"
   
   encoded_token = urllib.parse.quote_plus(token)
   ```

3. Используйте ваши авторизационные данные в файле .env:
   ```python
   from dotenv import load_dotenv
   import os
   # Загрузка переменных окружения из файла .env
   load_dotenv()
   auth = os.environ['SBER_AUTH']
   ```

Генерация токена доступа из секрета и ID
Для автоматической генерации токена доступа из ваших секретных данных выполните следующие шаги:

Убедитесь, что у вас установлен Python версии от 3.9 и библиотека dotenv.
Создайте файл .env и добавьте туда свои авторизационные данные:

SBER_ID=<ВАШ_КЛИЕНТСКИЙ_ID>
SBER_SECRET=<ВАШ_СЕКРЕТНЫЙ_КЛЮЧ>
Скопируйте следующий код в ваш Python-файл:

import os
from dotenv import load_dotenv
import base64

### Загружаем переменные окружения из файла .env
load_dotenv()

### Получаем значения из переменных окружения
client_id = os.getenv('SBER_ID')
secret = os.getenv('SBER_SECRET')

### Кодируем credentials
credentials = f"{client_id}:{secret}"
encoded_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')
Теперь у вас есть закодированная строка encoded_credentials, которую можно использовать для получения токена доступа.

Запуск приложения
После того как вы получили токен доступа и установили все необходимые библиотеки, вы можете запустить ваше приложение с помощью следующей команды:


streamlit run gigachatBSA.py
Это запустит ваше приложение на локально, где вы сможете взаимодействовать с ним через веб-интерфейс.

#### Ссылка на видео 

[LLM_GigaChat](https://youtu.be/CB9duzbH8s0)

![gigachat](img/gigachat.jpg)
