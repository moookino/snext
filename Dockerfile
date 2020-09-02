FROM jfloff/alpine-python:3.7-slim as base

ENV URL=
ENV USERNAME=
ENV TOKEN=

RUN /entrypoint.sh \
    -a git \
    -a sed \
    -a nginx \
    -p requests \
    -p pyyaml
RUN git clone https://github.com/iganeshk/standardnotes-extensions.git
RUN /entrypoint.sh -P standardnotes-extensions/requirements.txt
RUN mv standardnotes-extensions/env.sample standardnotes-extensions/.env
RUN sed -i 's#domain.com#'"$URL"'#g' standardnotes-extensions/.env
RUN sed -i 's#USERNAME#'"$USERNAME"'#g' standardnotes-extensions/.env
RUN sed -i 's#TOKEN#'"$TOKEN"'#g' standardnotes-extensions/.env
RUN python3 standardnotes-extensions/build_repo.py

FROM pierrezemb/gostatic:latest
COPY --from=base /standardnotes-extensions/public /srv/http
EXPOSE 8043
ENTRYPOINT ["/goStatic"]
