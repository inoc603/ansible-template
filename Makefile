
ifeq (1, $(VERBOSE))
verbose_flag := -vvvv
endif

ifeq (1, $(RETRY))
retry_flag := --limit @ansible/$(ENV).retry
endif

ifdef KEY_FILE
keyfile_flag := --key-file=$(KEY_FILE)
endif

ifdef CHECK
check_flag := --check
endif

ifeq ($(wildcard .vault.pass),)
else
password_flag := --vault-password-file=.vault.pass	
endif

run/%:
	ansible-playbook -i inventory/$(env).ini \
		$(retry_flag) $(verbose_flag) $(check_flag) $(keyfile_flag) \
		$(password_flag) \
		-e inventory=$(env) \
		$*.yml

env:
	cp inventory/$(tpl).ini inventory/$(env).ini
	cp vars/$(tpl).yml vars/$(env).yml

rekey:
	ansible-vault rekey $(password_flag) vars/secrets/*.yml

edit-secret:
	ansible-vault edit $(password_flag) vars/secrets/$(env).yml
