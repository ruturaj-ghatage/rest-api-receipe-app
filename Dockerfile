#Define the base image from which we are going to install further dependencies

#This means we are using python 3.9 alpine version image
FROM python:3.9-alpine3.13  

#We define who maintains the app
LABEL maintainer="Ruturaj Ghatage"

#Ensures that the output from python is printed directly into console
ENV PYTHONUNBUFFERED 1


#Does the self explanatory instructions
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000


#Default value of arg is set as false
ARG DEV=false
#Runs the command which are self explanatory and they are broken into lines
#using the && \ syntax
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ];  \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ;  \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

#run python commands automatically because path is modified
ENV PATH="/py/bin:$PATH"

#we switch user to django-user from root user so whenever you run the app its gonna
#run as django-user instead of root user who has all prievileges
USER django-user
