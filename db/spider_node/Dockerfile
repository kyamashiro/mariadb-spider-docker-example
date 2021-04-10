FROM mariadb:10.4.7

RUN apt-get update -yqq \
    && apt install mariadb-plugin-spider -yqq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*