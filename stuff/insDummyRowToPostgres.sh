#!/bin/bash

# 以下のテーブルがデータベースに作成されている前提
#create table test01 (
#    id	serial primary key,
#    val varchar(255),
#    created_at timestamp without time zone,
#    updated_at timestamp without time zone
#);

export PGPASSWD="developerPwd"

while true
do
    date_at=$(date '+%Y-%m-%d %H:%M:%S')
    uuid=$(uuid)
    echo "${date_at} ${uuid}"

    insert_sql="insert into test01 (val, created_at, updated_at) values ('"${uuid}"', '"${date_at}"', '"${date_at}"' );"

    psql -q -U developer repl_test << EOF
	${insert_sql}
EOF
    sleep 5
done