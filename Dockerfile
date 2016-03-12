FROM monostream/nodejs-gulp-bower

ADD . /data/scheduler_service

WORKDIR /data/scheduler_service

RUN \
  rm -rf node_modules && \
  npm cache clean && \
  npm install && \
  sed -i -- 's/localhost/dockerhost/g' database.json && \
  sed -i -- 's/localhost/dockerhost/g' server.coffee

EXPOSE 9998

CMD ["node", "server.js"]

