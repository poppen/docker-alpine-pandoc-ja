FROM pandoc/core:2.7.3

LABEL maintainer="poppen <poppen.jp@gmail.com>" \
      description="Pandoc with TeX Live for Japanese."

# Install Tex Live
ENV TEXLIVE_VERSION 2019
ENV PATH /usr/local/texlive/$TEXLIVE_VERSION/bin/x86_64-linuxmusl:$PATH

RUN apk --no-cache add \
    perl \
 && apk --no-cache add --virtual .build-deps \
    wget \
    xz \
    fontconfig-dev \
 && mkdir -p /tmp/src/install-tl-unx \
 && wget -qO- ftp://tug.org/texlive/historic/$TEXLIVE_VERSION/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/src/install-tl-unx --strip-components=1 \
 && printf "%s\n" \
      "selected_scheme scheme-basic" \
      "binary_x86_64-linuxmusl 1" \
      "collection-fontsrecommended 1" \
      "collection-latexrecommended 1" \
      "collection-langjapanese 1" \
      "option_doc 0" \
      "option_src 0" \
      > /tmp/src/install-tl-unx/texlive.profile \
 && /tmp/src/install-tl-unx/install-tl \
      --profile=/tmp/src/install-tl-unx/texlive.profile \
 && tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet \
 && tlmgr update --self && tlmgr update --all \
 && tlmgr install \
      latexmk \
      luatexbase \
      ctablestack \
      fontspec \
      luaotfload \
      lualatex-math \
      sourcesanspro \
      sourcecodepro \
 && rm -Rf /tmp/src \
 && apk del .build-deps

VOLUME ["/workspace", "/root/.pandoc/templates"]
WORKDIR /workspace
ENTRYPOINT [""]
