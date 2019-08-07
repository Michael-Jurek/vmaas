FROM centos:7

ENV VMAAS_VERSION=latest

RUN yum -y update && \
    yum -y install centos-release-scl && \
    yum -y install rh-python36 rsync && \
    rm -rf /var/cache/yum/* && \
    ln -s /opt/rh/rh-python36/root/bin/python /usr/bin/python3 && \
    ln -s /opt/rh/rh-python36/root/bin/pip /usr/bin/pip3

ADD /webapp_utils/*.sh  /webapp_utils/
ADD /webapp_utils/*.py  /webapp_utils/
ADD /webapp_utils/*.txt /webapp_utils/
ADD /webapp_utils/*.yml /webapp_utils/
ADD /webapp_utils/handlers/*.py /webapp_utils/handlers/

RUN pip3 install --upgrade pip && \
    pip3 install -r /webapp_utils/requirements.txt && \
    ln -s /opt/rh/rh-python36/root/bin/gunicorn /usr/bin/gunicorn

RUN install -m 1777 -d /data && \
    adduser --gid 0 -d /webapp_utils --no-create-home vmaas_utils

USER vmaas_utils

EXPOSE 8083

CMD /webapp_utils/entrypoint.sh