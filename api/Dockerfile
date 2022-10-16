FROM python:3.9
WORKDIR /Users/DELL/Documents/GitHub/test-project/app
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY . .
EXPOSE 5000
CMD python3 app.py
