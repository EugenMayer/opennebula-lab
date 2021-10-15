init:
	./generate_keys.sh

start: init
	vagrant up --no-parallel
	# update all the /etc/hosts files of the nodes
	vagrant hostmanager
	# prepopulate the frontend known_hosts file
	vagrant ssh frontend -c 'sudo -- sh -c "ssh-keyscan frontend compute1 compute2 >> /var/lib/one/.ssh/known_hosts"'
	vagrant ssh frontend -c 'sudo -- sh -c "chown oneadmin:oneadmin /var/lib/one/.ssh/known_hosts"'
	# add both hosts to our frontend
	vagrant ssh frontend -c 'sudo -- sh -c "onehost create compute1 --im qemu --vm qemu"'
	vagrant ssh frontend -c 'sudo -- sh -c "onehost create compute2 --im qemu --vm qemu"'

creds:
	vagrant ssh frontend -c 'sudo cat /var/lib/one/.one/one_auth'

frontend:
	vagrant ssh frontend

clean:
	./generate_keys.sh
	vagrant destroy --force
	rm -fr sshkeys
	rm -fr .vagrant

cleanAll:
	for i in `vagrant global-status | grep virtualbox | awk '{ print $1 }'` ; do vagrant destroy $i ; 
	vagrant global-status --prune