FROM pandoc/latex

ENTRYPOINT []

RUN apk --no-cache add make rsync openssh-client

# Add Adobe open source fonts
RUN mkdir -p /usr/share/fonts/tmp /usr/share/fonts/adobe-source \
 && cd /usr/share/fonts/tmp \
 && wget "https://github.com/adobe-fonts/source-serif/releases/download/4.004R/source-serif-4.004.zip" \
 && wget "https://github.com/adobe-fonts/source-code-pro/releases/download/2.038R-ro%2F1.058R-it%2F1.018R-VAR/OTF-source-code-pro-2.038R-ro-1.058R-it.zip" \
 && unzip source-serif-4.004.zip \
 && unzip OTF-source-code-pro-2.038R-ro-1.058R-it.zip \
 && find . -iname \*.otf -print0 | xargs -0 -I {} mv {} ../adobe-source \
 && cd .. \
 && rm -rf tmp \
 && fc-cache /usr/share/fonts

# Add LAAS beamer theme
RUN cd /opt/texlive/texmf-local/tex/latex/ \
 && wget "https://gitlab.laas.fr/gsaurel/laas-beamer-theme/-/archive/main/laas-beamer-theme-main.zip" \
 && unzip laas-beamer-theme-main.zip \
 && rm *.zip \
 && mktexlsr

# Set uid / gid for deploy
RUN addgroup --gid 1110 gepetto \
 && adduser --ingroup gepetto --disabled-password --uid 5495 gsaurel
USER gsaurel

# Get ssh host key for deploy
RUN mkdir -p ~/.ssh \
 && ssh-keyscan "memmos.laas.fr" > ~/.ssh/known_hosts \
 && chmod 700 ~/.ssh \
 && chmod 644 ~/.ssh/known_hosts
