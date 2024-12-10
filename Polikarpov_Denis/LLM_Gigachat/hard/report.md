
Видеозапись с запуском https://youtu.be/WATnBJxmCks

повторная запись экрана с запуском https://youtu.be/Vg9fVIyvNu0

повторная запись экрана со звуком https://www.youtube.com/watch?v=0nTdCwW2N8I

Я делал все под WINDOWS и WSL

запуск с помощью файла

    LLM_Gigachat.sh

Запускаем файл, он создает окружение для запуска скрипта, скачивает нужные библиотеки 

    pip install --upgrade pip
    pip install requests streamlit langchain-gigachat


Ссылка на документацмию 

https://github.com/ai-forever/gigachain/blob/master/README.md

Для того что бы все корректно работало нужно зарегистрироваться на сайте 

https://developers.sber.ru/studio/

создаете Мой GigaChat API 

Берете оттуда Client ID, Scope и генерируете Ключ авторизации

И добавляете все в ваш скрипт

Ключ авторизации действует полчаса.

Дальше вам необходимо добавить Сертификаты Минцифры

либо по инструкции 

https://www.gosuslugi.ru/crt

Но можно и воспользоваться и прямой сслыкой на файл .pem

https://gu-st.ru/content/Other/doc/russiantrustedca.pem

Сохранить файл и прописать путь до него в файле LLM_Gigachat.py

Документация по сертификатам

https://developers.sber.ru/docs/ru/gigachat/certificates

Для хранения секретов создаем файл 

.streamlit/sekrets.toml

Добавляем туда

```
# .streamlit/secrets.toml

[authentication]
AUTH_KEY = ""

[SCOPE]
scope = "GIGACHAT_API_PERS"
```

В AUTH_KEY = "" добавим наш Ключ авторизации


Теперь все должно заработать.
Наверное.





