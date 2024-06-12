FROM eleidan/elixir:1.17.0-ubuntu-24.04

USER root

### Adopt container user for the host UID and GID
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN usermod -u ${HOST_UID} phantom
RUN groupmod -g ${HOST_GID} phantom

RUN mkdir ${HOME}/.mix
RUN mkdir ${HOME}/.hex
RUN chown -R phantom:phantom ${HOME}

USER phantom
