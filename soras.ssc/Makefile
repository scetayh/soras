PROJECT_NAME = ssc
PROJECT_VERSION = 0.0.1-b9
PROJECT_TYPE = bin
GITHUB_USERNAME =
GITHUB_REPOSITORY_NAME =

.PHONY: clean install uninstall all

${PROJECT_NAME}:
	if [ ${PROJECT_TYPE} = bin ]; then \
		mkdir -pv bin; \
		cd src && \
		bash ${PROJECT_NAME}-${PROJECT_VERSION}.s.sh ${PROJECT_NAME}-${PROJECT_VERSION}.s.sh ../bin/${PROJECT_NAME}; \
	elif [ ${PROJECT_TYPE} = lib ]; then \
		make install; \
	else \
		exit 1; \
	fi

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
	sudo make uninstall
	make clean
	make
	sudo make install
	git remote remove origin
	git remote add origin git@github.com:${GITHUB_USERNAME}/${GITHUB_REPOSITORY_NAME}
	git add .
	-git commit -a -m "v${PROJECT_VERSION}"
	git push --set-upstream origin main