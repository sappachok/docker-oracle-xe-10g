FROM    oraclelinux:6
MAINTAINER frits.hoogland@gmail.com
RUN groupadd -g 54321 oinstall
RUN groupadd -g 54322 dba
RUN useradd -m -g oinstall -G oinstall,dba -u 54321 oracle
RUN yum -y install oracle-rdbms-server-12cR1-preinstall perl wget unzip
RUN mkdir /u01
RUN chown oracle:oinstall /u01
USER    oracle
WORKDIR /home/oracle
ENV mosUser=you@example.com mosPass=supersecret DownList=1,2
RUN wget https://dl.dropboxusercontent.com/u/7787450/getMOSPatch.sh
RUN wget https://dl.dropboxusercontent.com/u/7787450/responsefile_oracle12102.rsp
RUN echo "226P;Linux x86-64" > /home/oracle/.getMOSPatch.sh.cfg
RUN sh /home/oracle/getMOSPatch.sh patch=17694377
RUN unzip p17694377_121020_Linux-x86-64_1of8.zip
RUN unzip p17694377_121020_Linux-x86-64_2of8.zip
RUN rm p17694377_121020_Linux-x86-64_1of8.zip p17694377_121020_Linux-x86-64_2of8.zip
RUN /home/oracle/database/runInstaller -silent -force -waitforcompletion -responsefile /home/oracle/responsefile_oracle12102.rsp -ignoresysprereqs -ignoreprereq
USER    root
RUN /u01/app/oraInventory/orainstRoot.sh
RUN /u01/app/oracle/product/12.1.0.2/dbhome_1/root.sh -silent
RUN rm -rf /home/oracle/responsefile_oracle12102.rsp /home/oracle/getMOSPatch.sh /home/oracle/database
USER    oracle
WORKDIR /home/oracle
RUN     mkdir -p /u01/app/oracle/data
RUN     wget https://dl.dropboxusercontent.com/u/7787450/manage-oracle.sh
RUN     chmod 700 /home/oracle/manage-oracle.sh
RUN     wget https://dl.dropboxusercontent.com/u/7787450/db_install.dbt
EXPOSE  1521
CMD /home/oracle/manage-oracle.sh