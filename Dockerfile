FROM golang:1.18.2-alpine as build

WORKDIR /src

COPY build/app/go.mod go.mod
COPY build/app/go.sum go.sum

RUN go mod download

COPY build/app/cmd cmd/
COPY build/app/models models/
COPY build/app/restapi restapi/

ENV CGO_LDFLAGS "-static -w -s"

RUN go build -tags osusergo,netgo -o /application cmd/ansible-server/main.go; 

FROM ubuntu:22.04

RUN apt-get update && apt-get install ca-certificates python3 pip git -y

RUN apt-get install libkrb5-dev -y
RUN pip3 install --upgrade pip; \
    pip3 install --upgrade virtualenv; \
    pip3 install pywinrm[kerberos]; \
    pip3 install pywinrm; \
    pip3 install jmspath; \
    pip3 install requests; \
    pip3 install google-auth; \
    python3 -m pip install ansible;

RUN ansible-galaxy collection install azure.azcollection;
RUN pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

RUN ansible-galaxy collection install amazon.aws
RUN ansible-galaxy collection install google.cloud 

RUN ansible --version

RUN apt-get install openssh-client -y

RUN mkdir -p /root/.ssh/

ENV ANSIBLE_LOAD_CALLBACK_PLUGINS=1
ENV ANSIBLE_STDOUT_CALLBACK=json

COPY ansible_default.cfg /
COPY config.sh /
RUN chmod 755 /config.sh

# DON'T CHANGE BELOW 
COPY --from=build /application /bin/application

EXPOSE 8080

CMD ["/bin/application", "--port=8080", "--host=0.0.0.0", "--write-timeout=0"]
