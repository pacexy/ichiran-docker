FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

# Update and install packages
RUN apt update && apt dist-upgrade -y && apt install -y \
  sudo \
  vim \
  wget \
  sbcl \
  git \
  curl \
  nodejs

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y nodejs

# Download quicklisp and install
RUN wget https://beta.quicklisp.org/quicklisp.lisp && \
  wget https://beta.quicklisp.org/quicklisp.lisp.asc && \
  gpg --verify /quicklisp.lisp.asc /quicklisp.lisp; exit 0 && \
  sbcl --load /quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(ql:add-to-init-file)' --eval '(sb-ext:quit)'

# Download and setup ichiran
RUN cd /root/quicklisp/local-projects/ && \
  git clone https://github.com/tshatrov/ichiran.git

# Copy settings.lisp
COPY ./settings.lisp /root/quicklisp/local-projects/ichiran/settings.lisp

# Setup and build ichiran-cli
RUN sbcl --eval '(load "~/quicklisp/setup.lisp")' --eval '(ql:quickload :ichiran/cli)' --eval '(ichiran/cli:build)'

# Setup server directory and install dependencies
RUN mkdir /home/server
COPY ./server /home/server
RUN npm i --prefix /home/server

EXPOSE 80

CMD ["npm", "run", "start", "--prefix", "/home/server"]
