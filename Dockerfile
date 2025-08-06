FROM postgres:16

COPY *.sh /var/lib/postgresql/

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install wget iputils-ping && \
    apt-get -y install build-essential git postgresql-server-dev-16 && \
    wget https://github.com/zubkov-andrei/pg_profile/releases/download/4.10/pg_profile--4.10.tar.gz -O /root/pg_profile--4.10.tar.gz && \
    tar xzf /root//pg_profile--4.10.tar.gz --directory $(pg_config --sharedir)/extension && \
    wget https://apt.postgresql.org/pub/repos/apt/pool/main/p/pg-hint-plan-16/postgresql-16-pg-hint-plan_1.6.1-1.pgdg120%2B1_amd64.deb -O /root/postgresql-16-pg-hint-plan_1.6.1-1.pgdg120+1_amd64.deb && \
    dpkg -i /root/postgresql-16-pg-hint-plan_1.6.1-1.pgdg120+1_amd64.deb && \
    cd /tmp && \
    git clone https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install && \
    apt-get -y purge wget build-essential git postgresql-server-dev-16 && \
    apt-get update && \
    apt-get clean all && \
    apt-get -y autoremove --purge && \
    rm -rf /var/lib/apt/lists/* && \
    unset DEBIAN_FRONTEND && \
    chown 999:999 /var/lib/postgresql/*.sh && \
    chmod 700 /var/lib/postgresql/*.sh && \
    echo 'alias nocomments="sed -e :a -re '"'"'s/<\!--.*?-->//g;/<\!--/N;//ba'"'"' | sed -e :a -re '"'"'s/\/\*.*?\*\///g;/\/\*/N;//ba'"'"' | grep -v -P '"'"'^\s*(#|;|--|//|$)'"'"'"' >> ~/.bashrc

WORKDIR /var/lib/postgresql
