FROM python:3.9

ADD fastapi/ fastapi/

WORKDIR /fastapi/apps

RUN pip3 install -r requirements.txt

CMD ["uvicorn","main:app","--reload","--host","0.0.0.0","--port","8000"]

EXPOSE 8000