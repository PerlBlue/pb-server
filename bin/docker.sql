create database perlblue;
create user 'perlblue'@'%' identified by 'perlblue';
grant all privileges on perlblue.* to 'perlblue'@'%';
flush privileges;
