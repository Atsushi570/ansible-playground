インストール
```
brew install ansible
brew install --cask multipass
```

利用できるNICの確認
```
multipass networks
```

VMの作成
```
make create network=<物理NIC>
```

IPアドレスの確認
```
make info
```

`/inventory/hosts.ini`にIPアドレスを記述


プロビジョニング
```
make provision
```

ssh
```
ssh -i ~/.ssh/id_rsa ubuntu@<ipアドレス>
```
