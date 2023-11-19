FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

# Update packages
RUN apt update; apt dist-upgrade -y

# Install packages
RUN apt install -y \
  sudo \
  vim \
  wget \
  sbcl \
  git \
  gnupg \
  curl

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y \
  nodejs

# Download database and quicklist libraries, and jmdict dictionary
RUN wget https://beta.quicklisp.org/quicklisp.lisp
RUN wget https://beta.quicklisp.org/quicklisp.lisp.asc

# Install quicklisp
RUN gpg --verify /quicklisp.lisp.asc /quicklisp.lisp; exit 0
RUN sbcl --load /quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(ql:add-to-init-file)' --eval '(sb-ext:quit)'

# Download ichiran
RUN cd /root/quicklisp/local-projects/ && git clone https://github.com/tshatrov/ichiran.git

# Copy settings.lisp
COPY ./settings.lisp /root/quicklisp/local-projects/ichiran/settings.lisp

# Setup and build ichiran-cli
RUN  sbcl --eval '(load "~/quicklisp/setup.lisp")' --eval '(ql:quickload :ichiran)' --eval '(ichiran/mnt:add-errata)' --eval '(ichiran/test:run-all-tests)' --eval '(sb-ext:quit)' && \
  sbcl --eval '(load "~/quicklisp/setup.lisp")' --eval '(ql:quickload :ichiran/cli)' --eval '(ichiran/cli:build)' && \
  /root/quicklisp/local-projects/ichiran/ichiran-cli "一覧は最高だぞ"

# Setup server directory and install dependencies
RUN mkdir /home/server
COPY ./server /home/server
RUN npm i --prefix /home/server

EXPOSE 3000

CMD ["npm", "run", "start", "--prefix", "/home/server"]
