import os
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_gigachat.chat_models import GigaChat

# Получение токена
credentials = os.getenv('GIGACHAT_TOKEN')
if not credentials:
    raise EnvironmentError("Authorization key не установлен.")

# Запрос выбора действия
print("Выберите действие:")
print("1. Суммаризация текста")
print("2. Брейншторминг идей")

choice = input("Введите номер действия (1 или 2): ")

# В зависимости от выбора, запрашиваем ввод
if choice == "1":
    long_text = input("Введите текст для суммаризации: \n")
    prompt = f"Суммируйте следующий текст: {long_text}"
    action = "Суммаризация"
elif choice == "2":
    brainstorm_question = input("Введите вопрос для брейншторминга: \n")
    prompt = f"Предложите идеи для брейншторминга следующего вопроса: {brainstorm_question}"
    action = "Брейншторминг"
else:
    print("Неверный выбор.")
    exit()

# Подключение к GigaChat
giga = GigaChat(credentials=credentials, verify_ssl_certs=False)
response = giga.invoke([prompt])

# Выводим результат
print(f"\n{action}:")
print(response.content)


# тестовые данные

#Страхование жилья помогает защитить ваш дом от рисков, таких как пожары, наводнения, кражи и другие. При выборе страховки важно учитывать стоимость недвижимости, её расположение, уровень безопасности и дополнительные факторы.Например, дома, расположенные в районах с высокой сейсмической активностью или близко к водоемам, имеют более высокие страховые взносы.

#question = "Какие инновационные подходы можно применить для снижения стоимости страховки на дом?"
