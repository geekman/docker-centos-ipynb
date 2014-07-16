CentOS-based IPython Notebook
===============================
**centos-ipynb** is a CentOS-based docker image that hosts an IPython Notebook
instance. The root directory forms the base of an IPython install, which can be
built on to provide more functionality & bundled modules, such as for NLP. The 
usable images are in the `img-base` and `img-nlp` directories.

The instance comes with the following Python modules pre-installed:

- [matplotlib](http://matplotlib.org)
- [scikit-learn](http://scikit-learn.org)
- [Pandas](http://pandas.pydata.org/)

Only included with the `-nlp` image (due to its additional data size):

- [Pattern](http://www.clips.ua.ac.be/pattern)
- [NLTK](http://www.nltk.org)

Your notebooks can be persisted by mounting the `/notebooks` volume:

    docker run -v /host/notebooks-dir:/notebooks zxgm/centos-ipynb

The internal HTTP port is 8888, which is the default. You can expose the port
using the `-p` option:

    docker run -p 8000:8888 zxgm/centos-ipynb

You can of course combine both `-p` and `-v` options.

You can pass additional options directly to `docker run` to the `ipython` executable, for example:

    docker run zxgm/centos-ipynb --help


Shutting Down
--------------
To shutdown the instance, use `docker stop`. It will cleanly shutdown the
kernels and the default is to wait 10s but you can make it wait longer by
passing `-t <wait-time>` to `docker stop`.


Debugging
----------
If you need to debug the docker image for some reason, pass
`--entrypoint=/bin/bash` to `docker run` to drop into a Bash shell. The user
that runs IPython notebook is `ipynb` and you can login with that user by also
passing `-u ipynb` to `docker run`.

