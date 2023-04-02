FROM harukanetwork/evolutionx-ota-ci:latest

RUN mkdir /app
COPY . /app
WORKDIR /app
RUN npm install glob@8.1.0

CMD ["bash", "runner.sh"]
