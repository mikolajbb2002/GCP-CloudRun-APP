FROM python:3.12-slim

RUN pip install flask==2.3.2 

WORKDIR /app

COPY app.py .

EXPOSE 8080

CMD ["python","app.py"]