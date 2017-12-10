FROM resin/raspberry-pi3-python:3-slim
MAINTAINER Faun <docker@faun.me>

# Install dependencies
RUN apt-get update && apt-get install -y \
    sense-hat \
    python3-pygame

# Define working directory
WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt

CMD ["/bin/bash"]
