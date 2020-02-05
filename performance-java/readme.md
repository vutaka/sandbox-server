# これは何か

Tomcatにデプロイしたアプリの性能をみてみる場所

## 前準備

* [ここ](https://www.oracle.com/technetwork/jp/database/database-technologies/express-edition/overview/index.html)からOracle XE 11g のRPMを入手してください。(zipファイルなので解凍してください)
  * 「ダウンロード」タブ -> 画面下部「以前のリリース」
* [ここ](https://repo.boundlessgeo.com/main/com/oracle/jdbc/ojdbc6/11.1.0.6.0/ojdbc6-11.1.0.6.0.jar)からJDBCドライバを入手してください。
* デプロイしたいwarファイルを作成してください。
  * ただしJNDIの設定は行っていないのでアプリ側で設定する必要があります。

| ファイル                                       | 配置場所                                             | 配置対象サーバ |
| ---------------------------------------------- | ---------------------------------------------------- | -------------- |
| Oracle XE 11g rpm                              | `roles/db/files/rpm/oracle-xe-11.2.0-1.0.x86_64.rpm` | DB             |
| Oracle JDBCドライバ（そのほかのjarファイルも） | `roles/ap/files/lib/*.jar`                           | AP             |
| デプロイしたいwarファイル                      | `roles/ap/files/war/*.war`                           | AP             |
## 環境構成

APサーバ(tomcat)とDBサーバ(Oracle 11g + JMeter)の２台

測りたいのはAPサーバの性能のためDBサーバにJMeterを同居させる。

*rootになりたきゃ* `sudo su -`

### ローカルの構成

* VirtualBox 6.0
* Vagrant 2.2.4(1.9以降なら多分動く)
* bento/amazonlinux-2

| 役割     | host名     | IPアドレス    | 確認用ポートフォワーディングの設定 |
| -------- | ---------- | ------------- | ---------------------------------- |
| APサーバ | perform-ap | 192.168.33.10 | ローカルマシン:38080 -> VM:8080    |
| DBサーバ | perform-db | 192.168.33.11 | ローカルマシン:41521 -> VM:1521    |

### APサーバ

* JavaはJava8
* tomcat
* JNDIの設定はしない

### DBサーバ

* DBサーバはOracle 11g XE
  * `$ sudo su oracle` でsqlplusが使えるユーザーになる
  * `$ sqlplus / as sysdba ` で繋がる
  * `conn system` でパスワードに `systempass` を入力してログインできる
* OpenJDK8
* Maven
* JMeter（未）

### AWSでやるとき

1. ansibleのインストールのため `install_ansible.sh` を実行する。
2. それぞれのサーバーで `$ ansible-playbook -i localhost, -c local perform_[ap|db].yml` を実行すれば動くとおもう

---

## プロキシ環境下で使用する場合

プロキシ環境下で使用する場合は必ずプラグインをインストールすること

`vagrant plugin install vagrant-proxyconf`

ここにあるVagrantfileは `http_proxy` という環境変数からプロキシを設定するようにしているため、 プロキシを利用する場合必ず `http_proxy` を設定すること

*注意：プロキシ環境下でmavenを使用するための設定は入れてません*

## windowsで動かすときの注意

### `Encoding::InvalidByteSequenceError` とかエラーが出る。

コマンドプロンプトかPSの文字コードをUTF-8変更した上で実行する。

* `chcp 65001`

### `Encoding::CompatibilityError` とかエラーが出る。

Vagrantfileを置いているパスに日本語が含まれているはずなのですべて英語にする。

## 参考

* [ansible](https://docs.ansible.com/ansible/latest/modules/modules_by_category.html)
* [oracle install](http://blog.azumakuniyuki.org/2013/05/install-oracle-11g-xe-into-centos-6.html)


## メモ

JAVA_HOMEを引っ張り出す

```
JAVA_PATH=`readlink -f $(which java)`
JAVA_HOME=`echo $JAVA_PATH | grep -oP "^.+(?=/jre/bin/java)"`
# PIDを特定する
TOMCAT_PID=`ps -ef | grep tomcat | grep -v grep | awk '{ print $2 }'`
echo `date '+%Y-%m-%d %H:%M:%S'` `$JAVA_HOME/bin/jstat -gc $TOMCAT_PID` >> gc.log
```