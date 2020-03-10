#Centos7 Base
FROM centos:centos7

#Set Root User
USER root

#Create agens User
RUN ["useradd", "-ms", "/bin/bash", "agens"]

#Create ko_KR.utf8 Locale
RUN ["localedef", "-f", "UTF-8", "-i", "ko_KR", "ko_KR.utf8"]

#Set KST Timezone
RUN ["ln", "-sf", "/usr/share/zoneinfo/Asia/Seoul", "/etc/localtime"]

#Set agens User and Workdir
USER agens
WORKDIR /home/agens

#Set Default Locale to ko_KR.utf8
RUN   echo "export LANG=ko_KR.utf8" >> .bashrc
RUN   echo "export LC_ALL=ko_KR.utf8" >> .bashrc

#Copy and Decompress Agensgraph file
COPY --chown=agens:agens agensgraph/AgensGraph_v2.1.2_linux_CE.tar.gz AgensGraph_v2.1.2_linux_CE.tar.gz
RUN ["tar", "-zxf", "AgensGraph_v2.1.2_linux_CE.tar.gz"]
RUN ["mv", "AgensGraph", "agensgraph-2.1.2"]
COPY --chown=agens:agens agensgraph/superuser_password agensgraph-2.1.2/superuser_password
RUN ["rm", "-f", "AgensGraph_v2.1.2_linux_CE.tar.gz"]

#Create Docker Script Folder
RUN ["mkdir", "docker-script"]
COPY --chown=agens:agens agensgraph/entrypoint.sh docker-script/entrypoint.sh
RUN ["chmod", "+x", "docker-script/entrypoint.sh"]
RUN sed -i -e "s/\r$//" docker-script/entrypoint.sh

#Create Docker Data Folder
RUN ["mkdir", "agensgraph-2.1.2-data"]
RUN ["chmod", "700", "agensgraph-2.1.2-data"]

#Set Environment Variables for agensgraph
ENV AGDATA /home/agens/agensgraph-2.1.2-data
ENV LD_LIBRARY_PATH /home/agens/agensgraph-2.1.2/lib
ENV PATH="/home/agens/agensgraph-2.1.2/bin:${PATH}"
EXPOSE 5432

#Init Agensgraph
RUN ["initdb", "-E", "UTF-8", "-U", "agens", "--locale", "ko_KR.utf8", "--pwfile", "/home/agens/agensgraph-2.1.2/superuser_password", "-D", "/home/agens/agensgraph-2.1.2-data"]

#Set Agensgraph Config
WORKDIR agensgraph-2.1.2-data
RUN sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|g" postgresql.conf
RUN sed -i "s|#logging_collector = off|logging_collector = on|g" postgresql.conf
RUN echo host all all 0.0.0.0/0 trust >> pg_hba.conf

#Custom Command (Agensgraph user, DB, graph_path, default analysis result, etc)
#RUN ag_ctl start; \
#    sleep 5; \
#    RUN createdb -U agens <dbname>
#    RUN agens -U agens -c "CREATE USER <username> WITH PASSWORD '<password>'" <dbname>; \
#    RUN agens -U agens -c "ALTER DATABASE <dbname> OWNER TO <username>" <dbname>; \
#    ag_ctl stop;

#Set workdir
WORKDIR /home/agens

ENTRYPOINT ["/home/agens/docker-script/entrypoint.sh"]
