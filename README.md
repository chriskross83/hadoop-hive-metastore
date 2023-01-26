# Docker Hadoop-hive-metastore

Utilise apache/hadoop:3

Dépot de l’archive apache Hive : 

wget https://downloads.apache.org/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz

docker build --no-cache -t chriskross83/hadoop-hive-metastore:3.1.2 .

docker push chriskross83/hadoop-hive-metastore:3.1.2
