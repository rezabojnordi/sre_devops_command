FROM node:gallium as builder
RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm

WORKDIR /app

# Files required by pnpm install
COPY .npmrc package.json ./

RUN yarn install

COPY . .

RUN npx nuxi build

#RUN npx nuxi preview
#RUN rm -rf node_modules

FROM node:gallium-slim

WORKDIR /app

COPY --from=builder /app/.output  ./

CMD [ "node", "./server/index.mjs" ]
