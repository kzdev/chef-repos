## My Chef Repository
==================

### install list

以下の項目を自動設定

**base**  

* /etc/sysconfig/network
* /etc/hosts
* selinux無効化
* yumを日本ドメインに制限
* timezoneを日本時間(JST)に指定
* /etc/sysconfig/i18nをja_JP.utf8に指定
* iptables設定
* yum -y update
* ユーザ追加
* yum -y groupinstall "Japanese Support"

**package**  

* httpd
* vsftpd
* git
* wget
* rbenv
* ruby 2.1.1
* gem 2.2.2
* nodejs
* phantomjs
* postgresql9.1 (rpm版)
* vim 7.4
* newrelic (要licence)


### Prepared
  
Chefを実行する下準備  

  ```
bundle install --path=vendor/bundle
bundle exec berks install --path=vendor/cookbook

sudo ln -s /Users/k-goto/Documents/chef/chef-docker /bin/chef-docker
sudo ln -s /Users/k-goto/Documents/chef/.chef-docker-env ~/.chef-docker-env

sudo ln -s .chef-docker-env ~/.chef-docker-env
```



### initialize

	# cookbookを新規作成
	bundle exec knife cookbook create <cookbook> -o site-cookbooks/

### file modify

	# nodeに実行したいタスクを追記
	vim recipes/default.rb
	vim nodes/vagrant01.json

### vagrant ssh insert into ~/.ssh/config

	# 対象サーバへのSSH接続設定をローカルに保存
	vagrant ssh-config --host vagrant01 >> ~/.ssh/config

### Add chef recipe

	# 追加したいレシピがあればrecipeを新規作成
	knife cookbook create <recipe_name> -o site-cookbooks

### node prepare -> chef install to docker container

	# chefを実行するサーバにchefファイル群を準備
	bundle exec knife solo prepare kzdev@192.168.56.100 -p 8022 -i <id-rsa>
	bundle exec knife solo prepare vagrant01

### deploy

	# いざ、調理！
	bundle exec knife solo cook kzdev@192.168.56.100 -p 8022 -i <id-rsa>
	bundle exec knife solo cook vagrant01

### other

>
passenger-intall-apache2-moduleをchefから実行した時に、エラーが発生する。  
これはPCのスペック不足に起因する？らしいため、自動化していない

	vagrant ssh
	passenger-install-apache2-module install --auto
	
	...
	
	vim /etc/httod/conf.d/passenger.conf <- new
	vim /etc/httpd/conf/httpd.conf

## Berks File
==================

	berks install --path=repos/cookbooks
