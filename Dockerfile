FROM ubuntu

# Update apt cache
RUN apt-get update

# Install vscode dependencies + xvnc
RUN apt-get -y --no-install-recommends install libgtk2.0-0 libgtk-3-0 libpango-1.0-0 libcairo2 libfontconfig1 libgconf2-4 libnss3 libasound2 libxtst6 unzip libglib2.0-bin libcanberra-gtk-module libgl1-mesa-glx mono-complete curl build-essential gettext libstdc++6 software-properties-common wget git xterm automake libtool autogen rxvt-unicode-256color nodejs libnotify-bin aspell aspell-en htop x11vnc xvfb net-tools python xfonts-basse x11-utils xdotool sudo && \
    apt-get -y clean all && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Install vscode
RUN wget -O VSCode-linux-x64-stable.zip 'https://go.microsoft.com/fwlink/?LinkID=620884' && \
    unzip VSCode-linux-x64-stable.zip -d /usr/local && \
    cd /usr/local/bin && ln -s /usr/local/VSCode-linux-x64/bin/code code && \
    rm -rf /tmp/*

ENV DISPLAY=:0

# Add user
RUN useradd -ms /bin/bash vscode && \
    bash -c 'echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'

# Add init script
ADD init.sh web /
RUN chmod +x /init.sh && \
    bash -c "git clone https://github.com/kanaka/websockify /websockify" && \
    chown -R vscode /websockify && \
    chown -R vscode /web

USER vscode
EXPOSE 80

ENTRYPOINT ["/init.sh"]
