FROM frolvlad/alpine-oraclejdk8:slim
MAINTAINER Klaus Schroeder <klaus.schroeder@sinnerschrader.com>

RUN apk add --update curl bash supervisor

# source for this c+p https://github.com/visualphoenix/alpine-oracle-jdk/blob/master/Dockerfile
# modified to to use JAVA_HOME and curl
RUN POLICY_URL="http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
 && POLICY_DIR="UnlimitedJCEPolicyJDK8" \
 && curl --insecure -L\
         --cookie "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
          "$POLICY_URL" -o /tmp/policy.zip \
 && cd /tmp \
 && unzip /tmp/policy.zip \
 && mv -v /tmp/$POLICY_DIR/*.jar $JAVA_HOME/jre/lib/security/ \
 && rm -rfv /tmp/*
