FROM python:3.6-slim

WORKDIR /servo

ADD  https://storage.googleapis.com/kubernetes-release/release/v1.16.2/bin/linux/amd64/kubectl /usr/local/bin/

# Install dependencies
RUN apt update && apt -y install procps tcpdump curl wget
RUN pip3 install requests PyYAML python-dateutil

RUN mkdir -p measure.d

ADD https://raw.githubusercontent.com/opsani/servo-prom/master/measure measure.d/measure-prom
ADD https://raw.githubusercontent.com/opsani/servo-hey/master/measure measure.d/measure-hey
ADD https://raw.githubusercontent.com/opsani/servo/master/measure.py measure.d/
ADD https://storage.googleapis.com/hey-release/hey_linux_amd64 /usr/local/bin/hey

# Install servo
ADD https://raw.githubusercontent.com/opsani/servo/master/servo \
    https://raw.githubusercontent.com/opsani/servo/master/adjust.py \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    https://raw.githubusercontent.com/opsani/servo-k8s/master/adjust \
    https://raw.githubusercontent.com/opsani/servo-magg/master/measure \
    /servo/

RUN chmod a+rwx /servo/adjust /servo/measure /servo/servo /usr/local/bin/kubectl /usr/local/bin/hey
RUN chmod a+r /servo/adjust.py /servo/measure.py measure.d/measure.py
RUN chmod a+rwx /servo/measure.d/measure-prom /servo/measure.d/measure-hey

ENV PYTHONUNBUFFERED=1

ENTRYPOINT [ "python3", "servo" ]
