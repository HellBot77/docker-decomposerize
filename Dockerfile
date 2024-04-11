FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/composerize/decomposerize.git && \
    cd decomposerize && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node AS build

WORKDIR /decomposerize
COPY --from=base /git/decomposerize/packages/decomposerize-website .
RUN yarn && \
    export NODE_ENV=production && \
    yarn build

FROM pierrezemb/gostatic

COPY --from=build /decomposerize/build /srv/http
EXPOSE 8043
