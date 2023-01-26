FROM apache/hadoop:3

LABEL maintainer="1337.cb0t@gmail.com"

# declaration des variables d'environements
ENV HADOOP_HOME="/opt/hadoop"

ENV HIVE_HOME="/opt/hive"

ENV PATH="${PATH}:${HADOOP_HOME}/sbin:${HIVE_HOME}/bin"

# copie certificat de l'autorité
COPY ca.crt /etc/pki/ca-trust/source/anchors/

# ajout au magasin des certificats
RUN sudo update-ca-trust

# copie apache Hive 3.1.2
COPY apache-hive-3.1.2-bin.tar.gz /opt/

RUN tar xzf /opt/apache-hive-3.1.2-bin.tar.gz -C /opt/ \
  && rm /opt/apache-hive-3.1.2-bin.tar.gz \
  && mv -f /opt/apache-hive-3.1.2-bin/ /opt/hive/


# ajout des librairies necessaires au fonctionnement de apache hive pour du stockage S3
RUN rm -f /opt/hive/lib/guava-19.0.jar \
  && cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-27.0-jre.jar /opt/hive/lib \
  && cp ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.3.1.jar /opt/hive/lib \
  && cp ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.901.jar /opt/hive/lib

# ajout fichier de configuration pour connecteur hdfs/s3
COPY core-site.xml /opt/hadoop/etc/hadoop/core-site.xml

# ajout fichier de configuration pour les connecteurs jdbc/thrift/s3a
COPY hive-site.xml /opt/hive/conf/hive-site.xml

# initialisation du schema hive-metastore:3.1.0 a bdd la bdd metasore de postgres
# pre-requis avoir fait lajout de lutilisateur et la creation de la bdd en fct des elements presents dans hive-site.xml
# pas necessaire si utilisation des images de notre repos
#RUN bin/schematool -initSchema -dbType postgres

# expose de port pour api thrift (trino/presto)
EXPOSE 9083/tcp
