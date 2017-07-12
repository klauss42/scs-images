FROM klauss42/scs-poc-java8-base
MAINTAINER Klaus Schroeder <klaus.schroeder@sinnerschrader.com>

ADD . /build

RUN chmod -R +x /build
RUN sleep 2
RUN /build/build.sh
RUN rm -rf /build;

CMD ["/scripts/start.sh"]
