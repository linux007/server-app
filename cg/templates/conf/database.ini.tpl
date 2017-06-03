[default]
driver = pdo
host = 127.0.0.1
user = root
password = root
dbname = test
charset = utf8

[masterSlave]
wrapperClass = 'base\component\database\MasterSlaveConnection'
driver = pdo
master.host = 127.0.0.1
master.user = root
master.password = root
master.dbname = test

slaves.one.host = 127.0.0.1
slaves.one.user = root
slaves.one.password = root
slaves.one.dbname = test

slaves.two.host = 127.0.0.1
slaves.two.user = root
slaves.two.password = root
slaves.two.dbname = test