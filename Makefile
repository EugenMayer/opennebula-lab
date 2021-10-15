init:
	./generate_keys.sh

start: init
	vagrant up --parallel

creds:
	vagrant ssh frontend -c 'sudo cat /var/lib/one/.one/one_auth'
	
clean:
	vagrant destroy --force