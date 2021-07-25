if [ -n "$ZSH_VERSION" ]; then emulate -L sh; fi

if [ -z "${EDITOR}" ] ; then
  export EDITOR='emacsclient'
fi
if [ -n "${EDITOR}" ] && [ -z "${VISUAL}" ] ; then
  export VISUAL="${EDITOR}"
fi

