FROM python:2.7

RUN pip install paho-mqtt awscli

COPY pub.py /
COPY create-devicecert.sh /
COPY delete-devicecert.sh /
COPY entrypoint.sh /

RUN chmod +x /create-devicecert.sh
RUN chmod +x /delete-devicecert.sh
RUN chmod +x /entrypoint.sh
RUN curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x /usr/local/bin/jq

ENTRYPOINT ["/entrypoint.sh"]
