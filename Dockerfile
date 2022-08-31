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

RUN apt-get update && apt-get install ca-certificates python3 pip -y

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
RUN ssh-keyscan ec2-52-59-26-1.eu-central-1.compute.amazonaws.com  >> /root/.ssh/known_hosts

# RUN echo "jsajsj" > /tmp/jens
# COPY deleteme1.pem /
# RUN chmod 400 /deleteme1.pem

# RUN cat /root/.ssh/known_hosts
# RUN scp -i /deleteme1.pem /tmp/jens ubuntu@ec2-52-59-26-1.eu-central-1.compute.amazonaws.com:/tmp

# RUN mkdir -p /etc/ansible/
# RUN echo '[myvirtualmachines]\nec2-52-59-26-1.eu-central-1.compute.amazonaws.com\n'\
#     '[all:vars]\n' \
#     'ansible_user=ubuntu' \
#     >> hosts
# RUN cat hosts

# RUN echo '[defaults]\ninventory = hosts' \
#     >> ansible.cfg
# RUN cat ansible.cfg

ENV ANSIBLE_LOAD_CALLBACK_PLUGINS=1
ENV ANSIBLE_STDOUT_CALLBACK=json
ENV ANSIBLE_NOCOLOR=true

COPY ansible_default.cfg /
COPY config.sh /
RUN chmod 755 /config.sh

# ENV DEFAULT_HOST_LIST=hosts
# ENV ANSIBLE_CONFIG=ansible.cfg

# RUN echo 1 && ansible all -m ping

# DON'T CHANGE BELOW 
COPY --from=build /application /bin/application

EXPOSE 8080

CMD ["/bin/application", "--port=8080", "--host=0.0.0.0", "--write-timeout=0"]