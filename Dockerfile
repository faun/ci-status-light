FROM resin/raspberry-pi3-python:3-slim
MAINTAINER Faun <docker@faun.me>

# Install dependencies
RUN apt-get update && apt-get install -y \
    sense-hat \
    python3-pygame

RUN rm -rf /usr/local/lib/python2.7/

# Define working directory
WORKDIR /app

COPY . /app

RUN pip3 install -r requirements.txt

CMD ["/usr/local/bin/python3", "/app/status_light.py"]
