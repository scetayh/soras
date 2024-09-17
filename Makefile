PROJECT_NAME = soras
PROJECT_VERSION =
PROJECT_TYPE =
GITHUB_USERNAME = scetayh
GITHUB_REPOSITORY_NAME = soras

.PHONY: clean install uninstall all

${PROJECT_NAME}:
	cd soras.slibsh && sudo make uninstall && sudo make install
	cd soras.ssc && sudo make uninstall && make clean && make && sudo make install

clean:
	rm -rfv bin/*
	rm -rfv obj/*

install:
	if [ ${PROJECT_TYPE} = bin ]; then \
		mkdir -p /usr/local/bin && \
		cp bin/* /usr/local/bin/; \
	elif [ ${PROJECT_TYPE} = lib ]; then \
		mkdir -p /usr/local/lib/${PROJECT_NAME} && \
		cp lib/* /usr/local/lib/${PROJECT_NAME}/ && \
		chmod 777 -R /usr/local/lib/${PROJECT_NAME}/*; \
	else \
		exit 1; \
	fi

uninstall:
	rm -rf /usr/local/${PROJECT_TYPE}/${PROJECT_NAME}

all:
	git config pull.rebase false
	git pull
	make
	git remote remove origin
	git remote add origin git@github.com:${GITHUB_USERNAME}/${GITHUB_REPOSITORY_NAME}
	git add .
	-git commit -a -m "${MESSAGE}"
	git push --set-upstream origin main