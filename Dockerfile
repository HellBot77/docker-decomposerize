FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/composerize/decomposerize.git && \
    cd decomposerize && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node AS build

WORKDIR /decomposerize
COPY --from=base /git/decomposerize .
RUN cd packages/decomposerize-website && \
    yarn && \
    export NODE_ENV=production && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /decomposerize/packages/decomposerize-website/build .
