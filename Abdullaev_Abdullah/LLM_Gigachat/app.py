import streamlit as st
from gigachat import GigaChat
import re

# Инициализация GigaChat
def init_gigachat(api_key):
    try:
        giga = GigaChat(credentials=api_key, verify_ssl_certs=False)  # Инициализация с API-ключом
        return giga
    except Exception as e:
        st.error(f"Ошибка при инициализации GigaChat: {e}")
        return None

# Функция для генерации текста с использованием выбранного паттерна
def generate_text(giga, prompt, pattern):
    try:
        if pattern == "Суммаризация":
            prompt = f"Суммаризируй следующий текст:\n{prompt}"
        elif pattern == "Брейншторм":
            prompt = f"Сгенерируй несколько идей на основе следующего текста:\n{prompt}"
        
        response = giga.chat(prompt)  # Используем метод chat
        return response.choices[0].message.content
    except Exception as e:
        st.error(f"Ошибка при генерации текста: {e}")
        return None

# Функция для очистки и форматирования текста
def clean_text(text):
    # Убираем лишние символы и пустые строки
    lines = [line.strip() for line in text.split("\n") if line.strip()]
    # Убираем двойную нумерацию
    cleaned_lines = []
    for line in lines:
        # Убираем нумерацию в начале строки (например, "1. ", "2. ")
        line = re.sub(r"^\d+\.\s*", "", line)
        cleaned_lines.append(line)
    return "\n".join(cleaned_lines)

# Streamlit интерфейс
st.title("Генерация User Story, Use Case и Критериев приемки")

# Ввод API-ключа
api_key = st.text_input("Введите ваш API-ключ GigaChat:", type="password")

if api_key:
    # Инициализация GigaChat
    giga = init_gigachat(api_key)

    if giga:
        # Выбор паттерна
        patterns = ["Суммаризация", "Брейншторм"]

        # Раздел 1: Генерация User Story
        st.header("Генерация User Story")
        if "user_stories" not in st.session_state:
            st.session_state.user_stories = []

        # Кнопка для генерации User Story
        if st.button("Сгенерировать US"):
            prompt = """
            Сгенерируй 3 User Story для системы управления задачами. 
            Каждая User Story должна быть в формате: "Я хочу [действие], чтобы [цель]". 
            Не добавляй пояснения, нумерацию или шаблоны вроде "Как пользователь" или "Цель".
            """
            generated_text = generate_text(giga, prompt, "Брейншторм")
            if generated_text:
                st.session_state.user_stories = clean_text(generated_text).split("\n")
        
        # Отображение User Story
        if st.session_state.user_stories:
            st.success("Сгенерированные User Story:")
            for i, us in enumerate(st.session_state.user_stories):
                st.write(f"{i + 1}. {us}")

            # Кнопка для генерации новых User Story
            if st.button("Улучшить US"):
                prompt = """
                Сгенерируй 3 новых User Story для системы управления задачами. 
                Каждая User Story должна быть в формате: "Я хочу [действие], чтобы [цель]". 
                Не добавляй пояснения, нумерацию или шаблоны вроде "Как пользователь" или "Цель".
                """
                new_text = generate_text(giga, prompt, "Брейншторм")
                if new_text:
                    st.session_state.user_stories = clean_text(new_text).split("\n")
                    st.success("Новые User Story:")
                    for i, us in enumerate(st.session_state.user_stories):
                        st.write(f"{i + 1}. {us}")

        # Раздел 2: Генерация Use Case
        st.header("Генерация Use Case")
        use_case_input = st.text_area("Введите User Story для генерации Use Case:")
        use_case_pattern = st.selectbox("Выберите паттерн для Use Case:", patterns, key="use_case_pattern")
        
        if st.button("Сгенерировать Use Case"):
            if use_case_input:
                prompt = f"Сгенерируй Use Case для следующей User Story:\n{use_case_input}"
                generated_text = generate_text(giga, prompt, use_case_pattern)
                if generated_text:
                    st.session_state.use_case = clean_text(generated_text)
            else:
                st.error("Пожалуйста, введите User Story для генерации Use Case.")
        
        # Отображение Use Case
        if "use_case" in st.session_state and st.session_state.use_case:
            st.success("Сгенерированный Use Case:")
            st.write(st.session_state.use_case)

            # Кнопка для улучшения Use Case
            if st.button("Улучшить Use Case"):
                prompt = f"Улучши следующий Use Case:\n{st.session_state.use_case}"
                improved_text = generate_text(giga, prompt, use_case_pattern)
                if improved_text:
                    st.session_state.use_case = clean_text(improved_text)
                    st.success("Use Case улучшен:")
                    st.write(st.session_state.use_case)

        # Раздел 3: Генерация Критериев приемки
        st.header("Генерация Критериев приемки")
        acceptance_criteria_input = st.text_area("Введите User Story для генерации Критериев приемки:")
        acceptance_criteria_pattern = st.selectbox("Выберите паттерн для Критериев приемки:", patterns, key="acceptance_criteria_pattern")
        
        if st.button("Сгенерировать Критерии приемки"):
            if acceptance_criteria_input:
                prompt = f"Сгенерируй Критерии приемки для следующей User Story:\n{acceptance_criteria_input}"
                generated_text = generate_text(giga, prompt, acceptance_criteria_pattern)
                if generated_text:
                    st.session_state.acceptance_criteria = clean_text(generated_text)
            else:
                st.error("Пожалуйста, введите User Story для генерации Критериев приемки.")
        
        # Отображение Критериев приемки
        if "acceptance_criteria" in st.session_state and st.session_state.acceptance_criteria:
            st.success("Сгенерированные Критерии приемки:")
            st.write(st.session_state.acceptance_criteria)

            # Кнопка для улучшения Критериев приемки
            if st.button("Улучшить Критерии приемки"):
                prompt = f"Улучши следующие Критерии приемки:\n{st.session_state.acceptance_criteria}"
                improved_text = generate_text(giga, prompt, acceptance_criteria_pattern)
                if improved_text:
                    st.session_state.acceptance_criteria = clean_text(improved_text)
                    st.success("Критерии приемки улучшены:")
                    st.write(st.session_state.acceptance_criteria)
else:
    st.error("Пожалуйста, введите API-ключ для продолжения.")