FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04
ARG PYTHON_VERSION=3.8
ARG WITH_TORCHVISION=1

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
	 wget \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*


# ENV PYTHON_VERSION=3.
RUN wget -O ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# RUN curl -o ~/miniconda.sh -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  
RUN chmod +x ~/miniconda.sh
RUN ~/miniconda.sh -b -p /opt/conda
RUN rm ~/miniconda.sh 

RUN /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include cython typing jupyter pandas gensim scikit-learn matplotlib seaborn hdf5 #&& \
RUN /opt/conda/bin/conda install -y -c magma-cuda100 #&& \
RUN /opt/conda/bin/conda clean -ya
ENV PATH="/opt/conda/bin:${PATH}"
RUN conda install -c conda-forge ninja
# This must be done before pip so that requirements.txt is available
WORKDIR /opt/pytorch
COPY . .

RUN git submodule update --init
#RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
#    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
#    pip install -v .

RUN conda install -c pytorch pytorch=1.7.1 torchvision cudatoolkit=10.2
RUN conda install -c fvcore -c iopath -c conda-forge fvcore iopath
RUN conda install -c bottler nvidiacub
#RUN git clone https://github.com/pytorch/vision.git && cd vision && pip install -v .
# RUN apt-get update
# RUN apt-get upgrade
# RUN apt-get install -y zip


RUN conda install scikit-learn



RUN apt update && apt install -y libsm6 libxext6

RUN curl https://bootstrap.pypa.io/get-pip.py -o ~/get-pip.py
RUN python ~/get-pip.py
RUN pip install pynvim pep8 flake8 pyflakes pylint isort

RUN pip install git+https://github.com/arraiyopensource/kornia
RUN pip install torchcontrib
RUN pip install six numpy scipy Pillow matplotlib scikit-image opencv-python imageio Shapely
RUN pip install git+https://github.com/aleju/imgaug
RUN pip install -U git+https://github.com/albu/albumentations
RUN pip install kornia
RUN pip install tensorflow-gpu==2.0.0
RUN pip install tensorboard==2.0.0
RUN pip install gputil
RUN pip install setproctitle
RUN pip install tqdm
RUN pip install six Pillow matplotlib scikit-image opencv-python imageio
RUN pip install --no-dependencies imgaug
RUN pip install git+https://github.com/scottandrews/chumpy.git
RUN pip install face-alignment


#RUN conda install -c conda-forge opencv

#RUN conda install -c conda-forge dlib

WORKDIR /workspace
RUN chmod -R a+w /workspace 
