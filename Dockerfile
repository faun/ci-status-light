FROM resin/raspberry-pi-python:3-slim
MAINTAINER Faun <docker@faun.me>

# Install dependencies
RUN apt-get update -q && \
      apt-get install -qy python3-blinkt python-rpi.gpio python3-rpi.gpio

# Define working directory
WORKDIR /app

COPY . /app

ENV PYTHONPATH "/usr/lib/python3/dist-packages:/app:$PYTHONPATH"

RUN sudo pip install -r requirements.txt

CMD ["sudo", "python", "/app/test.py"]
