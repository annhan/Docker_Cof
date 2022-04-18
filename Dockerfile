ARG PLATFORM=amd64
FROM ${PLATFORM}/debian:stable
LABEL maintainer "annhandt09  <annhandt09@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Ensure that we always use UTF-8, US English locale and UTC time
RUN apt-get update && apt-get install -y locales && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  echo "UTC" > /etc/timezone && \
  chmod 0755 /etc/timezone 
ENV LANG en_US.utf8
ENV LC_ALL=en_US.utf-8
ENV LANGUAGE=en_US:en
ENV PYTHONIOENCODING=utf-8

# Install supporting apps needed to build/run
RUN apt-get install -y \
      git \
      build-essential \
      pkg-config \
      curl \
      autogen \
      autoconf \
      python \
      python-tk \
      libudev-dev \
      libmodbus-dev \
      libusb-1.0-0-dev \
      libgtk2.0-dev \
      python-gtk2 \
      procps \
      kmod \
      intltool \
      tcl8.6-dev \
      tk8.6-dev \
      bwidget \
      libtk-img \
      tclx \
      libreadline-gplv2-dev \
      libboost-python-dev \
      libglu1-mesa-dev \
      libgl1-mesa-dev \
      libxmu-dev \
      python-yapps \
      yapps2 && \
  curl -k https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
  python /tmp/get-pip.py && \
  pip install --upgrade pip

# needed at runtime
RUN apt-get install python-serial mesa-utils python-gtksourceview2 python-vte python-xlib -y
RUN apt-get install python-serial mesa-utils python-gnome2 python-glade2 python-imaging python-imaging-tk python-gtksourceview2 python-vte python-xlib -y
RUN apt-get install tclreadline python-configobj python-gtkglext1 -y
RUN apt-get install gir1.2-gst-plugins-base-1.0 gir1.2-gstreamer-1.0 gstreamer1.0-plugins-base  libcap2-bin libcdparanoia0 libgstreamer-plugins-base1.0-0 libgstreamer1.0-0 libopus0 liborc-0.4-0 libpam-cap libtheora0 libvisual-0.4-0 libvorbisenc2 python-gi python-gst-1.0 -y



WORKDIR /opt

# Add modules/plugins

# Build deb and install LinuxCNC
#RUN git clone https://github.com/mWorkVN/linuxcnc && \
#  git checkout mwork_camera && \
#  cd linuxcnc/debian && \
#  ./configure uspace && \
#  cd .. && \
#  dpkg-buildpackage -b -uc && \
#  sudo dpkg -i ../linuxcnc-uspace_2.9.0~pre0_amd64.deb
# Build PAP LinuxCNC  

RUN git clone https://github.com/mWorkVN/linuxcnc && \
  cd linuxcnc/debian && \
  git checkout mwork_camera && \
  ./configure uspace && \
  cd ../src && \
  ./autogen.sh && \
  ./configure --with-realtime=uspace && \
  make -j4 && make setuid

# Add Run time dependencies
RUN apt-get install -y \ 
    python3-pyqt5 \ 
    python3-pyqt5-dbg \
    python3-pyqt5.qtsvg \
    python3-pyqt5.qtopengl \ 
    python3-gi-cairo \
    python3-pyqt5.qsci \
    libcairo2 \
    libcairo2-dev \
    gir1.2-pango-1.0 \ 
    python3-xlib 



# Clean up APT when done.
RUN apt-get purge -y \
      git \
      build-essential \
      pkg-config \
      curl \
      autogen \
      autoconf \
      curl && \
  apt-get autoclean -y && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add mgmt scripts
COPY linuxcnc-entrypoint.sh /usr/local/bin/linuxcnc-entrypoint.sh
RUN chmod +x /usr/local/bin/linuxcnc-entrypoint.sh

# Fire it up!
ENTRYPOINT ["linuxcnc-entrypoint.sh"]
CMD ["start"]

# Fin
