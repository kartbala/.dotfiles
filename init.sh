#!/bin/sh
stow -vRt ~ */

emacsclient -ca "" -e "(progn
    (let ((file (expand-file-name
    \"./emacs/.emacs.d/mail-configuration.org\")))
    (require 'org-crypt)
    (org-babel-tangle-file file)
    (view-echo-area-messages)))"
