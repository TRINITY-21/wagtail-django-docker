FROM python:3.9-alpine3.13
LABEL maintainer="kngtechnologies.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app
COPY ./scripts /scripts


# docker container working dir
WORKDIR /app
EXPOSE 8000

# Reducing the number of docker layers
# create a virtualenv in docker
# pip intsall upgragde on version environment
# install requirements file
# set no password for user or home dir
# add deps needed after the postgre driver is installed
# apk: alpine package manager
# create a temp file to save temp deps
# after installed, delete temp
# chown changes ownership of the root user to app user
# 755 : app permissions ie execute, read etc

RUN python -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  apk add --update --no-cache postgresql-client zlib-dev jpeg-dev gcc libjpeg && \
  apk add --update --no-cache --virtual .tmp-deps \
  build-base postgresql-dev musl-dev linux-headers && \
  /py/bin/pip install -r /requirements.txt && \
  apk del .tmp-deps && \
  adduser --disabled-password --no-create-home app && \
  mkdir -p /vol/web/static && \
  mkdir -p /vol/web/media && \
  chown -R app:app /vol && \
  chmod -R 755 /vol && \
  chmod -R +x /scripts


# add python path
ENV PATH="/scripts:/py/bin:$PATH"

# run as app instead of root user
USER app

CMD ["run.sh"]