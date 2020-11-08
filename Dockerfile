FROM nvcr.io/nvidia/l4t-pytorch:r32.4.4-pth1.6-py3

RUN pip3 install captcha numpy matplotlib torch torchvision tqdm
RUN apt-get update && \
	apt-get install -y libpng-dev libfreetype6-dev
RUN pip3 uninstall -y pillow
RUN pip3 install pillow --global-option="build_ext" --global-option="--enable-freetype" --global-option="--debug"
RUN pip3 install pillow --no-cache-dir

RUN apt-get install -y vim
## Set LOCALE to UTF8
RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

RUN mkdir /python
WORKDIR /python
ADD main.py /python
ADD ctc.pth /python
RUN python3 /python/main.py


#docker build -t land007/l4t-captcha-break:latest .
#docker run -it --rm --privileged --runtime nvidia --name captcha-break land007/l4t-captcha-break:latest

