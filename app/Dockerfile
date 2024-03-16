#Base image
FROM python:3.12-slim

#Working directory in the container
WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

#source code into the container
COPY . .

#port 
EXPOSE 8080

CMD ["python", "./app.py"]