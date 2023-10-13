FROM ubuntu:20.04

# based on https://github.com/suchja/wine
ENV WINE_MONO_VERSION 0.0.8
USER root

# Set noninteractive installation
ARG DEBIAN_FRONTEND=noninteractive

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata


# Install some tools required for creating the image
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                curl \
                unzip \
                ca-certificates \
                xvfb

# Install wine and related packages
RUN dpkg --add-architecture i386 \
                && apt-get update -qq \
                && apt-get install -y -qq \
                                wine-stable \
                                winetricks \
                                wine32 \
                                libgl1-mesa-glx:i386 \
                && rm -rf /var/lib/apt/lists/*


### Everything below here is untested with Ubuntu 20.04

# Use the latest version of winetricks
#RUN curl -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
#		&& chmod +x /usr/local/bin/winetricks

## Get latest version of mono for wine
#RUN mkdir -p /usr/share/wine/mono \
#	&& curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi \
#	&& chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi

# Wine really doesn't like to be run as root, so let's use a non-root user
#USER xclient
#ENV HOME /home/xclient
#ENV WINEPREFIX /home/xclient/.wine
#ENV WINEARCH win32

# Use xclient's home dir as working dir
#WORKDIR /home/xclient

#RUN echo "alias winegui='wine explorer /desktop=DockerDesktop,1024x768'" > ~/.bash_aliases 
