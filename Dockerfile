# Android Dockerfile

FROM cimg/android:2023.02.1-ndk

RUN curl -sSL "https://raw.githubusercontent.com/CircleCI-Public/cimg-node/main/ALIASES" -o nodeAliases.txt && 	NODE_VERSION=$(grep "lts" ./nodeAliases.txt | cut -d "=" -f 2-) && 	curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && 	sudo tar -xJf node.tar.xz -C /usr/local --strip-components=1 && 	rm node.tar.xz nodeAliases.txt && 	sudo ln -s /usr/local/bin/node /usr/local/bin/nodejs
ENV YARN_VERSION=1.22.19
RUN curl -L -o yarn.tar.gz "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz" && 	sudo tar -xzf yarn.tar.gz -C /opt/ && 	rm yarn.tar.gz && 	sudo ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn && 	sudo ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg

RUN yarn global add npx firebase-tools