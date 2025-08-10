FROM node:24.5.0
LABEL authors="Sam"

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./

RUN npm install

USER 1000

COPY src/ ./

ENV NODE_ENV=production

EXPOSE 3000

CMD [ "node", "server.js" ]