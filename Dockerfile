FROM python:3.9-alpine

WORKDIR /app/backend

COPY requirements.txt /app/backend

# Build dependencies for mysqlclient on Alpine
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        mariadb-dev \
        mariadb-connector-c-dev \
        pkgconfig \
    && apk add --no-cache mariadb-connector-c

RUN pip install --no-cache-dir mysqlclient \
    && pip install --no-cache-dir -r requirements.txt

# Remove build-only deps to keep image small
RUN apk del .build-deps

COPY . /app/backend

EXPOSE 8000
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
