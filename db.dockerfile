FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ENV PGPASSWORD=postgres

# Update and install packages
RUN apt update && apt dist-upgrade -y && apt install -y \
  postgresql \
  sudo \
  vim \
  locales \
  wget \
  curl

# Set Japanese locale
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8

# Add sudo user 'postgres'
RUN adduser postgres sudo

# Download database dump
RUN wget https://github.com/tshatrov/ichiran/releases/download/ichiran-230122/ichiran-230122.pgdump

# Initialize and start PostgreSQL service
# Create database, load database dump
RUN service postgresql start && \
  sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';" && \
  sudo -u postgres createdb -E 'UTF8' -l 'ja_JP.utf8' -T template0 ichiran-db && \
  sudo -u postgres pg_restore -c -d ichiran-db ichiran-230122.pgdump || true && \
  service postgresql stop

EXPOSE 5432

CMD ["sh", "-c", "postgres -D /var/lib/postgresql/data -p $PORT"]
