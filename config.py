from dotenv import load_dotenv
import os

# 🔥 CARGA EL .ENV
load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
MODEL=os.getenv("MODEL")
print("DEBUG KEY:", OPENAI_API_KEY)
print("DEBUG MODEL:", MODEL)