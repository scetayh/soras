PROJECT_NAME =
RELEASE_VERSION =
GIT_REMOTE_ADDRESS =

.PHONY: clean install uninstall pull make-install commit release commit-release strap

${PROJECT_NAME}:

clean:

install:

uninstall:

pull:
	git config pull.rebase false
	git pull

make-install:
	sudo make uninstall
	make clean
	make
	sudo make install

commit:
	git add .
	-git commit -a

release:
	git remote remove origin
	git remote add origin ${GIT_REMOTE_ADDRESS}
	printf "Releasing ${PROJECT_NAME}."\\n
	printf "  Project name: ${PROJECT_NAME}"\\n
	printf "  Release version (tag): ${RELEASE_VERSION}"\\n
	printf "  Git remote address: ${GIT_REMOTE_ADDRESS}"\\n
	read -s -n1 -p "Press enter to continue or CTRL-C to pause."
	git tag -a ${RELEASE_VERSION}
	git push --set-upstream origin main --tags

commit-release:
	make commit
	make release

strap:
	make pull
	make make-install
	make commit-release