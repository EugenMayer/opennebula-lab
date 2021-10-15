init:
	./generate_keys.sh

start: init
	vagrant up --parallel

clean:
	vagrant destroy --force