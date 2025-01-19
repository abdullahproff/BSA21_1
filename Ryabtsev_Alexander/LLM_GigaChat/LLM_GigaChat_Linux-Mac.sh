#!/bin/bash

VENV_PATH="./.venv"

if [ ! -d "$VENV_PATH" ]; then
  echo "No virtual environment found. Create a virtual environment..."
  python -m venv "$VENV_PATH"
fi

source "$VENV_PATH/bin/activate"

pip install --upgrade pip
pip install streamlit langchain-gigachat

echo "Launch Streamlit..."
streamlit run LLM_GigaChat.py

deactivate
