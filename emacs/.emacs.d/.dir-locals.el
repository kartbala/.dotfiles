;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil ;; All modes.
  . ((eval
      . (progn
      (setq-local epa-file-encrypt-to
                  '("kartbala@gmail.com"))
          ))))
 (org-mode
  . ((eval
      . (progn
      (advice-add 'epa-file-write-region
                  :before
                  #'(lambda (&rest _args)
                      (hack-local-variables)))
      (advice-add 'epa-file-write-region
                  :before
                  #'(lambda (&rest _args)
                      (hack-local-variables)))
      (defun pils--tangle-final-hook (&rest _args)
        (run-hooks 'org-babel-tangle-final-hook))
      (advice-add 'org-babel-tangle :after
                  #'pils--tangle-final-hook)
      (add-hook 'org-babel-pre-tangle-hook
                #'org-decrypt-entries t)
      (remove-hook 'org-babel-pre-tangle-hook
                   #'save-buffer t)
      (add-hook 'before-save-hook
                #'org-encrypt-entries t)
      (add-hook 'org-babel-tangle-final-hook
                #'save-buffer t)
          )))))
