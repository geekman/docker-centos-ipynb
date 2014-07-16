#
# Dockerfile for a CentOS-based IPython Notebook
#

FROM centos
MAINTAINER Darell Tan <darell.tan@gmail.com>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm

RUN yum -y install python-pip numpy scipy
RUN yum -y install gcc-c++
RUN pip install scikit-learn

RUN yum -y install python-{zmq,jinja2}
RUN pip install "tornado < 4.0"
RUN pip install ipython

RUN yum -y install freetype-devel libpng-devel
RUN pip install matplotlib

RUN pip install pandas

# for notebook exporting
RUN pip install pygments
RUN yum -y install pandoc

ENV IPYTHONDIR /ipython
RUN useradd -m ipynb
RUN mkdir -m 0700 /ipython && chown ipynb /ipython

USER ipynb
RUN ipython profile create

# install MathJax locally
RUN python -c "from IPython.external.mathjax import install_mathjax; install_mathjax()"
USER root

ADD start-ipynb /usr/bin/

ONBUILD VOLUME  /notebooks
ONBUILD WORKDIR /notebooks

# remove unused RPMs
ONBUILD RUN rpm -qa | grep -E -- "-(headers|devel)" | grep -v python | xargs yum -y remove
ONBUILD RUN yum clean all
ONBUILD RUN rm -rf /tmp/*

ONBUILD EXPOSE 8888
ONBUILD ENTRYPOINT ["/usr/bin/start-ipynb", "--no-browser", "--ip=0.0.0.0", "--port=8888"]

