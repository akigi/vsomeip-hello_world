# vsomeip-hello_world

## 概要
vsomeipのhello_worldをubuntu上でビルド & 実行します。

(作成日: 2022/12/27)

## 筆者の環境

### ホストマシン
- MacBook Air 2020 M1
- macOS Ventura 13.1
- [UTM](https://mac.getutm.app/) 4.0.9

### ゲストマシン(UTM上の仮想マシン)
- Ubuntu 22.04.1 LTS ([Ubuntu Server for ARM](https://ubuntu.com/download/server/arm))
  (ubuntu-22.04.1-live-server-arm64.iso)

筆者はホストマシンの環境が汚れるのを避けるため、仮想環境上でvsomeipをビルドし動かします。


## vsomeipをビルドしよう

**以降のコマンドは注記がある場合を除き、すべてUbuntu環境上で実行します。**

### 必要なパッケージのインストール

まずはapt updateしておきます。
```bash
sudo apt update
```

次にUbuntuで使う基本的なパッケージ群をインストールしておきます。
```bash
sudo apt install -y --no-install-recommends \
  sudo curl wget apt-transport-https gnupg \
  ca-certificates cmake\
  gcc build-essential git vim unzip openssh-server
```

さらにvsomeipをビルドするために下記のパッケージをaptを使ってインストールしておきます。
これらを入れておかないとcmake実行時にエラーになります。
なお、asciidocは1GB以上あったため筆者は入れませんでしたが、入れなくても動きました。

- Boost
- libsystemd
- Doxygen
- graphviz
- (asciidoc)

```bash
sudo apt install -y libboost-all-dev \
                    libudev-dev libsystemd-dev \
                    doxygen \
                    graphviz
```

### dlt-daemonのビルド

vsomeipのビルドのため、dlt-daemonが必要になります。
gitからソースコードをcloneしてビルド・インストールします。

筆者はホームフォルダに`dev`というフォルダを作成し、その中でdlt-daemonおよびvsomeipのビルド作業を行なっていきます。

そのため、事前に`~/dev`フォルダを作成しておいてください。
```bash
mkdir ~/dev
```

それでは、下記のコマンドでdlt-daemonをビルド・インストールします。

```bash
# dlt-daemon
cd ~/dev
git clone https://github.com/COVESA/dlt-daemon -b v2.18.8
cd ./dlt-daemon
mkdir build
cd ./build
cmake ..
make
sudo make install
sudo ldconfig
```

### vsomeipのビルド

それではvsomeipをビルド・インストールしましょう。

```bash
# vsomeip
cd ~/dev
git clone https://github.com/COVESA/vsomeip -b 3.1.20.3
cd ./vsomeip
mkdir build
cd ./build
cmake ..
make
sudo make install
sudo ldconfig
```

以上の手順で、vsomeipのビルドおよびインストールが完了です。

## vsomeipのhello_worldをビルドしよう

下記コマンドでhello_worldをビルドします。

```bash
# vsomeip hello_world
cd ~/dev/vsomeip/build
cmake --build . --target hello_world
cd ./examples/hello_world
make
```

ビルドが完了したら、実行時に必要なJSONファイルを一つ上の階層にコピーします。
```bash
cd ~/dev/vsomeip/build/examples/hello_world
cp ../../../examples/hello_world/helloworld-local.json ../
```

参考：https://github.com/COVESA/vsomeip/tree/3.1.20.3/examples/hello_world

## hello_worldを実行しよう

### 実行方法
Ubuntu上でターミナルを2つ立ち上げ、はじめにサーバーを起動させ、次にクライアント側を実行してください。

サーバー側
```bash
VSOMEIP_CONFIGURATION=../helloworld-local.json \
VSOMEIP_APPLICATION_NAME=hello_world_service \
./hello_world_service
```

クライアント側
```bash
VSOMEIP_CONFIGURATION=../helloworld-local.json \
VSOMEIP_APPLICATION_NAME=hello_world_client \
./hello_world_client
```

### 実行結果

![](vsomeip-hello_world_server-client.mov)

サーバー側
```bash
aki@aki:~/dev/vsomeip/build/examples/hello_world$ VSOMEIP_CONFIGURATION=../helloworld-local.json \
                                                  VSOMEIP_APPLICATION_NAME=hello_world_service \
                                                  ./hello_world_service
2022-11-27 13:50:05.189323 [info] Parsed vsomeip configuration in 0ms
2022-11-27 13:50:05.192535 [info] Using configuration file: "../helloworld-local.json".
2022-11-27 13:50:05.192793 [info] Configuration module loaded.
2022-11-27 13:50:05.192959 [info] Initializing vsomeip application "hello_world_service".
2022-11-27 13:50:05.223445 [info] Instantiating routing manager [Host].
2022-11-27 13:50:05.230412 [info] create_local_server Routing endpoint at /tmp/vsomeip-0
2022-11-27 13:50:05.234493 [info] Application(hello_world_service, 4444) is initialized (11, 100).
2022-11-27 13:50:05.234827 [info] Starting vsomeip application "hello_world_service" (4444) using 2 threads I/O nice 255
2022-11-27 13:50:05.247311 [info] Watchdog is disabled!
2022-11-27 13:50:05.249519 [info] io thread id from application: 4444 (hello_world_service) is: ffff9cf78020 TID: 8158
2022-11-27 13:50:05.251114 [info] vSomeIP 3.1.20.3 | (default)
2022-11-27 13:50:05.252047 [info] io thread id from application: 4444 (hello_world_service) is: ffff9a77f100 TID: 8163
2022-11-27 13:50:05.253233 [info] shutdown thread id from application: 4444 (hello_world_service) is: ffff9b79f100 TID: 8161
2022-11-27 13:50:05.254055 [info] main dispatch thread id from application: 4444 (hello_world_service) is: ffff9bfaf100 TID: 8160
2022-11-27 13:50:05.255646 [info] OFFER(4444): [1111.2222:0.0] (true)
2022-11-27 13:50:05.258112 [info] Listening at /tmp/vsomeip-4444
2022-11-27 13:50:12.099307 [info] Application/Client 5555 is registering.
2022-11-27 13:50:12.100717 [info] Client [4444] is connecting to [5555] at /tmp/vsomeip-5555
2022-11-27 13:50:12.102644 [info] REGISTERED_ACK(5555)
2022-11-27 13:50:12.240608 [info] REQUEST(5555): [1111.2222:255.4294967295]
2022-11-27 13:50:12.250853 [info] RELEASE(5555): [1111.2222]
2022-11-27 13:50:12.252220 [info] Application/Client 5555 is deregistering.
2022-11-27 13:50:12.358086 [info] Client [4444] is closing connection to [5555]
2022-11-27 13:50:15.260351 [info] vSomeIP 3.1.20.3 | (default)
2022-11-27 13:50:17.278163 [info] STOP OFFER(4444): [1111.2222:0.0] (true)
2022-11-27 13:50:17.288218 [info] Stopping vsomeip application "hello_world_service" (4444).
```


クライアント側
```bash
aki@aki:~/dev/vsomeip/build/examples/hello_world$ VSOMEIP_CONFIGURATION=../helloworld-local.json
                                                  VSOMEIP_APPLICATION_NAME=hello_world_client
                                                  ./hello_world_client
2022-11-27 13:50:12.065704 [info] Parsed vsomeip configuration in 0ms
2022-11-27 13:50:12.067371 [info] Using configuration file: "../helloworld-local.json".
2022-11-27 13:50:12.067436 [info] Configuration module loaded.
2022-11-27 13:50:12.067470 [info] Initializing vsomeip application "hello_world_client".
2022-11-27 13:50:12.067504 [info] Instantiating routing manager [Proxy].
2022-11-27 13:50:12.069498 [info] Client [5555] is connecting to [0] at /tmp/vsomeip-0
2022-11-27 13:50:12.070982 [info] Application(hello_world_client, 5555) is initialized (11, 100).
2022-11-27 13:50:12.082098 [info] Starting vsomeip application "hello_world_client" (5555) using 2 threads I/O nice 255
2022-11-27 13:50:12.084734 [info] main dispatch thread id from application: 5555 (hello_world_client) is: ffff90e3f100 TID: 8165
2022-11-27 13:50:12.087966 [info] shutdown thread id from application: 5555 (hello_world_client) is: ffff9062f100 TID: 8166
2022-11-27 13:50:12.092812 [info] io thread id from application: 5555 (hello_world_client) is: ffff915f6020 TID: 8164
2022-11-27 13:50:12.093955 [info] io thread id from application: 5555 (hello_world_client) is: ffff8fe1f100 TID: 8167
2022-11-27 13:50:12.098716 [info] Listening at /tmp/vsomeip-5555
2022-11-27 13:50:12.098932 [info] Client 5555 (hello_world_client) successfully connected to routing  ~> registering..
2022-11-27 13:50:12.101778 [info] Application/Client 5555 (hello_world_client) is registered.
Sending: World
2022-11-27 13:50:12.246600 [info] Client [5555] is connecting to [4444] at /tmp/vsomeip-4444
2022-11-27 13:50:12.247585 [info] ON_AVAILABLE(5555): [1111.2222:0.0]
Received: Hello World
2022-11-27 13:50:12.250553 [info] Stopping vsomeip application "hello_world_client" (5555).
2022-11-27 13:50:12.252784 [info] Application/Client 5555 (hello_world_client) is deregistered.
2022-11-27 13:50:12.253203 [info] Client [5555] is closing connection to [4444]
```









Q. Wiresharkが何も反応しないのはなんで？
A. 同一マシン上での通信にはBoostを利用した**UNIXドメインソケット通信**が使われているため、Wiresharkにはキャプチャされない。
[wireshark can't capature client log or log server send to client #165](https://github.com/COVESA/vsomeip/issues/165)
[UNIXドメインソケットとは](https://mypage.otsuka-shokai.co.jp/contents/business-oyakudachi/words/unix-domain-socket.html)
