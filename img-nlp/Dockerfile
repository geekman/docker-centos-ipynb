#
# Dockerfile for an IPython notebook instance with NLP tools
#

FROM zxgm/centos-ipynb-base

RUN yum -y install libyaml-devel
RUN pip install nltk
RUN python -m nltk.downloader -d /usr/lib/nltk_data all
RUN find /usr/lib/nltk_data -iname *.zip -exec rm {} \;

RUN pip install pattern

