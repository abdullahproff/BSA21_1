# Инструкция по запуску скрипта:

1. **Создайте виртуальное окружение**:
    
    ```bash
    python3 -m venv myenv
    ```
    
2. **Активируйте виртуальное окружение**:
    - На macOS/Linux:
        
        ```bash
        myenv/bin/activate
        ```
        
    - На Windows:
        
        ```bash
        myenv\Scripts\activate
        ```
        
3. **Установите пакеты**:
    
    ```bash
    pip install gigachain streamlit requests
    ```
    
    ```bash
    pip install gigachat
    ```
    
4. **Проверьте установку**:
    
    ```bash
    pip list
    ```
    
5. **Запустите скрипт**:
    
    ```bash
    streamlit run app.py
    ```
    
6. **Работа с API**

Для начала работы с GigaChat API выполните следующие шаги:

6.1. Регистрация: перейдите по ссылке [https://developers.sber.ru/studio/workspaces](https://developers.sber.ru/studio/workspaces) и войдите с помощью SberID.

6.2. Добавьте проект: в личном кабинете добавьте проект GigaChat API.

6.3. Сгенерируйте ключ

6.4. Введите сгенерированный ключ на веб-странице, открытой после запуска скрипта app.py