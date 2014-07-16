#
# Dockerfile for a CentOS-based IPython Notebook
#

FROM centos
MAINTAINER Darell Tan <darell.tan@gmail.com>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm

RUN yum -y install python-{pip,zmq,jinja2} numpy scipy pandoc
RUN yum -y install gcc-c++ freetype-devel libpng-devel atlas-devel blas-devel
RUN for p in "tornado<4.0" ipython matplotlib pygments; do pip install "$p"; done
RUN pip install scikit-learn
RUN pip install pandas

ENV IPYTHONDIR /ipython
RUN useradd -m ipynb
RUN mkdir -m 0700 /ipython && chown ipynb /ipython

RUN su ipynb -c "ipython profile create"

# install MathJax locally
RUN su ipynb -c "python -c 'from IPython.external.mathjax import install_mathjax; install_mathjax()'"

ADD start-ipynb /usr/bin/

ONBUILD VOLUME  /notebooks
ONBUILD WORKDIR /notebooks

# remove unused RPMs
ONBUILD RUN rpm -qa | grep -E -- "-(headers|devel)" | grep -v python | xargs yum -y remove
ONBUILD RUN yum clean all
ONBUILD RUN rm -rf /tmp/*

ONBUILD EXPOSE 8888
ONBUILD ENTRYPOINT ["/usr/bin/start-ipynb", "--no-browser", "--ip=0.0.0.0", "--port=8888"]

RUN rm -rf /tmp/*

