import os
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def enrich(text):
    prompt = f"""
    Eres un arquitecto de datos.
    Analiza este metadata y clasifícalo en dominios, calidad y riesgos:

    {text}
    """

    response = client.responses.create(
        model="gpt-5.3",
        input=prompt
    )

    return response.output_text


if __name__ == "__main__":
    with open("qa_reports/MEP_GPPESVLCLI2249/dashboard.md", "r", encoding="utf-8") as f:
        data = f.read()

    result = enrich(data)

    with open("qa_reports/MEP_GPPESVLCLI2249/enriched.txt", "w", encoding="utf-8") as f:
        f.write(result)