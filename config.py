from dotenv import load_dotenv
import os

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
MODEL = "gpt-4o-mini"

# 🔒 SOLO DEBUG SEGURO
print("DEBUG KEY:", "OK" if OPENAI_API_KEY else "MISSING")
print("DEBUG MODEL:", MODEL)