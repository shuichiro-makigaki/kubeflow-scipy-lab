FROM jupyter/scipy-notebook

USER root
RUN apt-get update
RUN apt-get -y install curl tig gnupg apt-transport-https less dnsutils
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

USER jovyan
RUN pip install nbresuse
RUN conda install \
    nbdime \
    jupyterlab-git \
    htop \
    vim \
    awscli \
    papermill \
    plotly \
    jq
RUN conda update --all
RUN jupyter labextension install jupyterlab-topbar-extension
RUN jupyter labextension install \
    @jupyterlab/toc \
    @jupyterlab/git \
    @jupyterlab/celltags \
    @jupyterlab/plotly-extension \
    nbdime-jupyterlab \
    jupyterlab-system-monitor
RUN jupyter labextension update --all
RUN conda clean --all -f -y
RUN npm cache clean --force
RUN rm -rf ~/.cache/yarn $CONDA_DIR/share/jupyter/lab/staging
ENV JUPYTER_ENABLE_LAB yes
ENV GRANT_SUDO yes
ENV RESTARTABLE yes
ENV PATH ~/.local/bin:$PATH

USER root
COPY before-notebook-hook.sh /usr/local/bin/before-notebook.d/
RUN chmod +x /usr/local/bin/before-notebook.d/before-notebook-hook.sh
CMD ["sh", "-c", "start-notebook.sh --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.token='' --NotebookApp.password='' --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.allow_origin='*' --ContentsManager.allow_hidden=True"]
