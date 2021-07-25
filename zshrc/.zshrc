export PATH=/opt/homebrew/bin:$PATH
export PS1="%T: "
export PATH=/usr/local/bin:$PATH
export PATH=/Library/Frameworks/GDAL.framework/Programs:$PATH
export PATH=/Library/TeX/texbin/:$PATH

if [ -n "$ZSH_VERSION" ]; then emulate -L sh; fi

if [ -z "${EDITOR}" ] ; then
  export EDITOR='emacsclient'
fi
if [ -n "${EDITOR}" ] && [ -z "${VISUAL}" ] ; then
  export VISUAL="${EDITOR}"
fi

