#!/bin/sh

docker build -t ansible . && docker run -p 9191:8080 ansible