
Видеозапись с запуском https://youtu.be/WATnBJxmCks

Я делал все под WINDOWS и WSL

запуск с помощью файла

    gigachain.sh

Запускаем файл, он создает окружение для запуска скрипта, скачивает нужные библиотеки 

    pip install --upgrade pip
    pip install requests streamlit

 другие нужные у нас уже должны быть установлены или их можно самим добавить сюда

    pip install langchain-gigachat

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

Сохранить файл и прописать путь до него в файле hard.py

Документация по сертификатам

https://developers.sber.ru/docs/ru/gigachat/certificates

Теперь все должно заработать.
Наверное.





