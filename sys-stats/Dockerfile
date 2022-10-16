FROM node:16
WORKDIR /Users/DELL/Documents/GitHub/test-project/sys-stats
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD [ "npm", "start" ]
