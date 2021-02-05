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

RUN pip3 install tornado
RUN apt-get update && apt-get install -y openssh-server net-tools && \
	echo "MaxAuthTries 20" >> /etc/ssh/sshd_config && echo "ClientAliveInterval 30" >> /etc/ssh/sshd_config && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && echo "TMOUT=0" >> /etc/profile && \
	useradd -s /bin/bash -m land007 && \
	echo "land007:1234567" | /usr/sbin/chpasswd && \
	sed -i "s/^land007:x.*/land007:x:0:1000::\/home\/land007:\/bin\/bash/g" /etc/passwd && \
	sed -i "s/^#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

RUN mkdir /python
WORKDIR /python
ADD main.py /python
ADD ctc.pth /python
RUN python3 /python/main.py

ADD updata.py /python
RUN mkdir /python/files

EXPOSE 8080 22
#CMD python3 main.py
CMD /etc/init.d/ssh start ; python3 updata.py
#CMD /etc/init.d/ssh start ; bash

#docker build -t land007/l4t-captcha-break:latest .
#docker run -it --rm --privileged --runtime nvidia --name l4t-captcha-break -p 28080:8080 -p 20022:22 land007/l4t-captcha-break:latest
#docker exec -it l4t-captcha-break bash
