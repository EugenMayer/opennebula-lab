## WAT

Start an self contained opennebula LAB with 2 compute nodes and a frontend using vagrant

## Requirements

Install `Virtualbox` and `Vagrant` on your system

Also install the hostmanager vagrant plugin

```
vagrant plugin install vagrant-hostmanager
```

## Usage

```
git clone https://github.com/EugenMayer/opennebula-lab
cd opennebula-lab

make start
```

To see your credentials type `make creds`

Now connect via browser on `http://127.0.0.1:8080`

### Connect to boxes

```
vagrant ssh frontend
vagrant ssh compute1
vagrant ssh compute2
```

## Debootstrap

```
make clean

# or
vagrant destroy --force
```
