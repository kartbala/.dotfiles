;; * Emacs transition hopes and dreams
;; ** Email
;; *** Ideal state
;; **** Receiving mail from 4 inboxes (personal gmail, 2 google workspace accounts, 1 outlook365 account) in displayed in a consolidated email message list with different colors indicating different inboxes, auto-synced every 10 min
;; **** Sending mail: respond via email address that was originally sent to (ie. sent to xyz@gmail.com, I respond back by xyz@gmail.com)
;; *** Current state
;; **** 1 personal gmail account downloaded with offlineimap, indexed by mu, and displayed by mu4e
;; **** Sending mail only from a single gmail account
;; ** Calendar
;; *** Ideal state
;; **** Display 4 calendars (1 personal google cal, 2 google workspace cals, and 1 outlook 365 cal) in org-agenda vie
;; **** Full screen, undistorted display of monthly calendar with keybinding
;; **** Add, delete, and edit calendar entries in emacs
;; *** Current state
;; **** painful gcal, MS web nterface
;; ** Contact management
;; *** Ideal state
;; **** Searchable list of contacts synced with google contacts
;; **** Add, delete, and edit contacts entries
;; *** Current state
;; **** painful google contacts web nterface
;; ** Dialer / texter
;; *** Ideal state
;; **** Keybindings to make a call and send a text with autocompleted names from contacts
;; *** Current state
;; **** painful google voice web nterface
;; ** Web 
;; *** Ideal state
;; **** Something that I can use to access wikipedia, stackoverflow, reddit, nytimes, washington post, nexo, personal capital, Canvas (ugh), BlackBoard (double ugh), youtube
;; *** Current state
;; **** chrome to access a bunch of sites that don't magnify well
;; ** Slack
;; *** Ideal state
;; **** Something that I can use in emacs
;; *** Current state
;; **** painful slack web interface
;; ** Google Docs
;; *** Ideal state
;; **** Something that I can use in emacs
;; *** Current state
;; **** painful Google docs web interface
;; ** Google Sheets
;; *** Ideal state
;; **** Something that I can use in emacs
;; *** Current state
;; **** painful Google sheets web interface
;; ** Hubspot
;; *** Ideal state
;; **** Something that I can use in emacs
;; *** Current state
;; **** painful Hubspot web interface
;; * Display settings
;; ** Full-screen mode 
(set-frame-parameter nil 'fullscreen 'fullboth)
(global-set-key (kbd "C-x y") 'toggle-frame-fullscreen)
;; * Packages initialisation
;; ** MELPA package archive
(require 'package)

;; using ‘add-to-list’ to not override
;; the default settings that may change
;; beware that org will not use anymore
;; this repository for versions <=9.5
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(setq my-package-list '(helm
                        exec-path-from-shell
                        ess))

(package-initialize)

;; ** use-package initialisation
(unless
    (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(customize-set-variable
 'use-package-enable-imenu-support t)
(customize-set-variable
 'use-package-always-ensure t)
(customize-set-variable
 'use-package-verbose t)

;; make sure stale packages don't get loaded
 (dolist (package my-package-list)
   (if (featurep package)
       (unload-feature package t)))

;; Install packages in package-list if they are not already installed
(unless (cl-every #'package-installed-p my-package-list)
  (package-refresh-contents)
  (dolist (package my-package-list)
    (when (not (package-installed-p package))
      (package-install package))))

;; personal lisp files
(add-to-list 'load-path
             (concat user-emacs-directory
		     "personal"))

;; * no littering, backup & custom settings
(use-package no-littering
    :config
  (setq ;; Make a backup of a file
   ;; the first time it is saved.
   make-backup-files t
   ;; Make backup first
   ;; then copy to the original.
   backup-by-copying nil
   ;; Version-numbered backups.
   version-control t
   ;; Keep a lot of copies.
   ;; Only not version-controlled file
   ;; ⟨see ‘vc-make-backup-files’⟩.
   kept-old-versions 10000
   kept-new-versions kept-old-versions
   auto-save-file-name-transforms
   (list (list "\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
               ;; Prefix tramp autosaves to prevent
               ;; conflicts with local ones
               (concat auto-save-list-file-prefix "tramp-\\2") t)
         (list ".*" auto-save-list-file-prefix t))
   custom-file (concat user-emacs-directory "var/custom.el"))
    ;; load the custom file
  (load custom-file))

;; * exec-path-from-shell
(require 'exec-path-from-shell)
    (exec-path-from-shell-initialize)

;; * low vision settings
(setq-default word-wrap t)
;; does not wrap by default in prog-mode
;; the reasonning is, in several prog-mode,
;; having emacs displaying the same line
;; on multiple lines is confusing.
;; eg: a comment. comments usually start
;; with an identifier like ;; for elisp
;; so you have extra effort to understand
;; what are the commented lines or not.
;; also indentation may be critical
;; and again, filling the lines doesn't
;; help to understand or worse and may
;; be dangerous for the soft, eg: python
;; on the other hand, in all others
;; cases, displaying multiples lines
;; when needed to fit visually a single
;; line, actually helps a lot to the
;; readability. Even in non text-mode,
;; reading error logs is already not
;; an agreeable experience but if you
;; have to scroll horizontally for each
;; line that is worse.
;; Fortunately, the interactive shell
;; is not a prog-mode.
;; Finally when you cannot select the
;; buffer displaying the infos, you
;; *need* emacs to display the
;; multilines, otherwise you never
;; read the line ! That is the
;; case when, eg, a function uses
;; a read command.
(defun pils-truncate-lines ()
  (setq truncate-lines t))

(with-eval-after-load 'calendar
  (add-hook 'calendar-initial-window-hook
            #'pils-truncate-lines)) 

(setq max-mini-window-height 1.0)

(add-hook 'prog-mode-hook #'pils-truncate-lines 100)
;; extra work for emacs, does we need to tweak it?
(setq truncate-partial-width-windows nil)
;; wrap in all text-mode derived modes
(add-hook 'text-mode-hook #'visual-line-mode 100)

;; visual color helper
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; best accessibility theme
(use-package modus-themes
  :config
  (load-theme 'modus-vivendi))

;; convenience with delimiters
(use-package elec-pair
    :ensure nil
    :config
    (electric-pair-mode 1))

;; enhance parens visibility
(setq show-paren-when-point-inside-paren t
      show-paren-when-point-in-periphery t)
(show-paren-mode t)
(set-face-attribute 'show-paren-match nil
 		      :strike-through t
		      :underline nil
		      :weight 'ultra-bold)

;; ** font size aka text scale
;; The default face size
;; can be statically adjusted as :
;; 49 chars on screen
(set-face-attribute 'default nil :height 1300)
;; 40 chars on screen
(set-face-attribute 'default nil :height 300)
;; emacs comes with the ‘text-scale-adjust’
;; command, bound to C-x C-=
;; but it only adjust the font
;; for the current buffer !
;; Most of the time we want
;; to adjust the scale on all
;; buffers and all frames.
;; So here a package that allow it:
(use-package default-text-scale
  :config
  (default-text-scale-mode))

;; ** better defaults
;; no tabs.
(set-default 'indent-tabs-mode nil)

;; yank on selected text,
;; replace the text
(delete-selection-mode 1)

;; print a meaningful value
;; when evaluating
(setq eval-expression-print-level  100)
(setq eval-expression-print-length 100)

;; ** only one window at once
;; emacs poping windows is disruptive
;; we can prevent that.
;; First create a display function
;; that paid no respect for the
;; `inhibit-same-window' parameter
(defun display-buffer-strictly-same-window (buffer alist)
  "Display BUFFER in the selected window.
ALIST is an association list of action symbols and values.  See
Info node `(elisp) Buffer Display Action Alists' for details of
such alists.

This function totally ignore if ALIST has an `inhibit-same-window'.

This is an action function for buffer display, see Info
node `(elisp) Buffer Display Action Functions'.  It should be
called only by `display-buffer' or a function directly or
indirectly called by the latter."
  (unless (or (window-minibuffer-p)
	      (window-dedicated-p))
    (window--display-buffer buffer (selected-window) 'reuse alist)))

;; Then use it as the base action
;; for all calls to display-buffer
(customize-set-variable
 'display-buffer-base-action
 '((display-buffer-strictly-same-window)
   (reusable-frames . t)))

;; * Helpers
;; ** helpful
;; Gives much more informations
;; in Help buffers. Such as
;; links to the elisp manual
;; May even show the code of
;; the functions but you need
;; to have a copy of the source
;; not compiled. Some providers
;; only ship compiled code. :/
(use-package helpful
    :commands helpful--read-symbol
    :init
    (with-eval-after-load 'apropos
      ;; patch apropos buttons to
      ;; call helpful instead of help
      (dolist (fun-bt '(apropos-function apropos-macro apropos-command))
        (button-type-put
         fun-bt 'action
         (lambda (button)
           (helpful-callable (button-get button 'apropos-symbol)))))
      (dolist (var-bt '(apropos-variable apropos-user-option))
        (button-type-put
         var-bt 'action
         (lambda (button)
           (helpful-variable (button-get button 'apropos-symbol))))))

    :bind
    ([remap describe-function]
     . helpful-callable)
    ([remap describe-command]
     . helpful-command)
    ([remap describe-variable]
     . helpful-variable)
    ([remap describe-key]
     . helpful-key)
    ;; helpful-symbol does not
    ;; consider the faces
    ;; ([remap describe-symbol]    . helpful-symbol)
    ([remap display-local-help]
     . helpful-at-point)
    (:map helpful-mode-map
          ("." . helpful-at-point)))

;; little snippets integrated
;; with helpful
(use-package elisp-demos
    :after helpful
    :init
    (advice-add
     'describe-function-1 :after
     #'elisp-demos-advice-describe-function-1)
    (advice-add
     'helpful-update :after
     #'elisp-demos-advice-helpful-update))

;; ** custom modeline element
(defun pils/list-depth ()
  "Count the list depth from point to the top level,
`message' it in interactive calls, always update the mode-line,
in both cases, save the depth in `pils--list-depth-cache'."
  (interactive)
  ;; preserve point and mark-ring
  (let ((depth 0)
        ;; do not mess with the transient mark
        deactivate-mark
        ;; does not assume we have
        ;; the right indentation
        open-paren-in-column-0-is-defun-start)
    (save-mark-and-excursion
      (catch 'depth
        ;; check-parens inlined
        ;; without pushing marks
        (condition-case data
            ;; Buffer can't have more than (point-max) sexps.
            (scan-sexps (point-min) (point-max))
          (scan-error (goto-char (nth 2 data))
  	              (throw 'depth
                             (setq depth
                                   ;; with red face
                                   (propertize "nil"
                                               'font-lock-face
                                               '(:foreground "red"))))))
        ;; count the list nesting by
        ;; going to the top sexp by sexp
        (condition-case err
            (while t
              (up-list
               nil
               'escape-string
               'no-syntax-crossing)
              (cl-incf depth))
          ;; the top is an scan-error
          ;; we can release the loop
          (scan-error (throw 'depth depth))))
      ;; eventually test it interactively
      (when (interactive-p)
        (message "list depth: %s" depth))
      ;; update the cache for the modeline
      (setq pils--list-depth-cache depth)
      ;; force a redisplay of the modeline
      (force-mode-line-update))))

(defvar-local pils--list-depth-cache nil
  "Dummy variable to store the return
value of `pils/list-depth'.")

(defvar pils--list-depth-timer
  (timer-create)
  "Timer to update the list depth
element of the modeline at a
relatively quiet pace.")

(defun pils--modeline-list-depth ()
  "Return the list depth when in
`emacs-lisp-mode', via the timer
`pils--list-depth-timer' every
0.2 seconds."
  (if (and
       (not (or (minibufferp)
                (input-pending-p)))
       (memq major-mode '(emacs-lisp-mode
                              lisp-interaction-mode)))
      (progn
        (when (not
               (timerp pils--list-depth-timer))
          (setq pils--list-depth-timer
                (run-with-timer
                 0.2 0.2
                 #'pils/list-depth)))
        (format " (%s) " pils--list-depth-cache))
    (when (timerp pils--list-depth-timer)
      (cancel-timer pils--list-depth-timer)
      (setq pils--list-depth-timer nil)
      (setq pils--list-depth-cache nil))
    ""))

(setq-default
 mode-line-format
 '("%e" mode-line-front-space
   mode-line-mule-info
   mode-line-client
   mode-line-modified
   mode-line-remote
   ;; mode-line-frame-identification
   (:eval (pils--modeline-list-depth))
   ;; buffer identification always claims
   ;; 12 characters, we may revise that
   mode-line-buffer-identification
   " "
   "%l-%c"
   " "
   (vc-mode vc-mode)
   " "
   mode-line-modes
   mode-line-misc-info
   mode-line-end-spaces))

;; ** custom which-key
;; Which-key trade visual place for helping us
;; to remember the keybindings and to discover
;; new ones in a format more compact than
;; [C-h m], describe-mode does.
(use-package which-key
  :init
  (setq which-key-sort-order #'which-key-prefix-then-key-order
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10)

  :config
  ;; Lower values may conflict with others
  ;; packages such as taoline when switching
  ;; windows or when using the function
  ;; `read-char' in a chord
  (setq which-key-echo-keystrokes 0.6)
  (setq which-key-idle-delay 0.7)

  ;; Describe the current major mode bindings
  (global-set-key (kbd "C-c h") #'which-key-show-major-mode)

  ;; Use it to help you learn new modes
  ;; this need to be bound per minor mode basis
  ;; for minor-modes with a lot of keybindings.
  (defun pils--which-key-minor-mode (minor-mode)
    "Use which key to describe MINOR-MODE's bindings."
    (which-key--show-keymap
     (symbol-name minor-mode)
     (cdr (assq minor-mode minor-mode-map-alist))))

  ;; Declare a new window popup spec that
  ;; always uses the current window.
  (setq which-key-custom-popup-max-dimensions-function
        (lambda (_spec)
          (cons (window-text-height)
                (window-text-width))))

  (setq which-key-custom-hide-popup-function
        #'which-key--hide-buffer-side-window)

  (setq which-key-custom-show-popup-function
        (lambda (_spec)
          (display-buffer-strictly-same-window
           which-key--buffer
           nil)))

  (setq which-key-popup-type 'custom)

  ;; Activate.
  (which-key-mode 1))
;; ** hydras
(use-package hydra
  :config
  ;; an hydra to make rectangle selection simple
 (define-key ctl-x-map (kbd "<SPC>")
  (defhydra hydra-rectangle (:body-pre (progn (rectangle-mark-mode 1))
                             :color pink
                             :hint nil
                             :post (deactivate-mark))
    "
  ^^_i_^^   _w_:copy _o_pen  ^_N_ums _u_ndo
_j_ _k_ _l_ _y_ank   _t_ype  ^^_s_wap-points
 _q_uit^^^^ _d_:kill _c_lear _r_eset _R_egister"
    ("i" rectangle-previous-line)
    ("k" rectangle-next-line)
    ("j" rectangle-backward-char)
    ("l" rectangle-forward-char)
    ("d" kill-rectangle)                    ; C-x r k
    ("y" yank-rectangle)                    ; C-x r y
    ("w" copy-rectangle-as-kill)            ; C-x r M-w
    ("o" open-rectangle)                    ; C-x r o
    ("t" string-rectangle)                  ; C-x r t
    ("c" clear-rectangle)                   ; C-x r c
    ("s" rectangle-exchange-point-and-mark) ; C-x C-x
    ("N" rectangle-number-lines)            ; C-x r N
    ("r" (if (region-active-p)
             (deactivate-mark)
           (rectangle-mark-mode 1)))
    ("R" copy-rectangle-to-register)        ; C-x r r
    ("u" undo nil)
    ("q" nil)))

;; an hydra to expose the apropos commands
(define-key help-map "a"
  (defhydra hydra-apropos (:color blue :hint nil)
    "
⸤_a_⸣propos \
◆ ⸤_c_⸣ommand \
◆ ⸤_d_⸣docs
valu⸤_e_⸣ \
◆ ⸤_l_⸣ibrary \
◆ ⸤_u_⸣ser option
⸤_v_⸣ariable \
◆ ⸤_i_⸣nfo \
◆ ⸤_t_⸣ags
local valu⸤_E_⸣ \
◆ local ⸤_V_⸣ar \
◇ ⸤_q_⸣uit"
    ("a" apropos)
    ("c" apropos-command)
    ("d" apropos-documentation)
    ("e" apropos-value)
    ("l" apropos-library)
    ("u" apropos-user-option)
    ("v" apropos-variable)
    ("i" info-apropos)
    ("t" xref-find-apropos)
    ("E" apropos-local-value)
    ("V" apropos-local-variable)
    ("q" nil)))

;; an hydra to learn the basics of sexp interaction
(global-set-key (kbd "<f6>")
  (defhydra hydra-sexp-navigation (:color pink
                             :hint nil)
    "
_u_p   _a_:beg _p_rev _e_nd  _h_:m.def _t_ranspose
_d_own _b_ack  _n_ext _f_orw _SPC_:m.sexp _q_uit
_m_ind _k_ill _c_heck _r_aiz _D_:nar.def _w_iden
"
    ("u" backward-up-list)
    ("d" down-list)
    ("m" back-to-indentation)
    ("a" beginning-of-defun)
    ("p" backward-list)
    ("e" end-of-defun)
    ("b" backward-sexp)
    ("n" forward-list)
    ("f" forward-sexp)
    ("h" mark-defun)
    ("SPC" mark-sexp)
    ("t" transpose-sexp)
    ("k" kill-sexp)
    ("c" check-parens)
    ("r" raise-sexp)
    ("D" narrow-to-defun)
    ("w" widen)
    ("q" nil))))


;; ** macro-expansion
(use-package macrostep
    :bind
    ("C-c m" . macrostep-expand))

;; * Helm config
;; ** Comments for add custom
;; Perhaps see https://github.com/hatschipuh/helm-better-defaults for other helm customizations you might want.
;; ** Completion hints
(require 'helm-config)
(helm-mode 1)
;; ** R tab for persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;; make TAB works in terminal
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
;list actions using C-z
(define-key helm-map (kbd "C-z")  'helm-select-action)
;; ** helm options
(setq helm-mode-fuzzy-match        t
      helm-buffers-fuzzy-matching  t
      helm-recentf-fuzzy-match     t
      helm-M-x-fuzzy-match         t
      helm-full-frame              t
      helm-ff-guess-ffap-urls      nil
      helm-ff-guess-ffap-filenames nil
      helm-highlight-matches-around-point-max-lines 0)
;; ** helm global-map
(global-set-key (kbd "M-x")                          'undefined)
(global-set-key (kbd "M-x")                          'helm-M-x)
(global-set-key (kbd "C-x b")                        'helm-buffers-list)
(global-set-key (kbd "M-y")                          'helm-show-kill-ring)
(global-set-key (kbd "C-c f")                        'helm-recentf)
(global-set-key (kbd "C-x C-f")                      'helm-find-files)
(global-set-key (kbd "C-c <SPC>")                    'helm-all-mark-rings)
(global-set-key (kbd "C-x r b")                      'helm-filtered-bookmarks)
(global-set-key (kbd "C-h r")                        'helm-info-emacs)
(global-set-key (kbd "C-:")                          'helm-eval-expression-with-eldoc)
(global-set-key (kbd "C-,")                          'helm-calcul-expression)
(global-set-key (kbd "C-h i")                        'helm-info-at-point)
(global-set-key (kbd "C-x C-d")                      'helm-browse-project)
(global-set-key (kbd "<f1>")                         'helm-resume)
(global-set-key (kbd "C-h C-f")                      'helm-apropos)
(global-set-key (kbd "<f5> s")                       'helm-find)
(global-set-key (kbd "<f2>")                         'helm-execute-kmacro)
(global-set-key (kbd "C-c g")                        'helm-gid)
(global-set-key (kbd "C-c i")                        'helm-semantic-or-imenu)
(global-set-key (kbd "C-c M-i")                      'helm-imenu-in-all-buffers)
(define-key global-map [remap jump-to-register]      'helm-register)
(define-key global-map [remap list-buffers]          'helm-buffers-list)
(define-key global-map [remap dabbrev-expand]        'helm-dabbrev)
(define-key global-map [remap find-tag]              'helm-etags-select)
(define-key global-map [remap xref-find-definitions] 'helm-etags-select)
;; * silent advice
(defun pils/quiet (orig-fn &rest args)
  "Advice to silent too verboses functions."
  (let ((inhibit-message t)
        (save-silently t))
    (apply orig-fn args)
    (message "")))

;; * Recent files
(use-package recentf
    :ensure nil
    :hook (after-user-init . recentf-mode)
    :custom
    (recentf-max-saved-items 500)
    (recentf-auto-cleanup 60)
    (recentf-exclude '(".*~$" "\\,DS\\'"))
    :config
    (advice-add 'recentf-save-list :around #'pils/quiet)
    (advice-add 'recentf-cleanup :around #'pils/quiet)
    (setq directory-abbrev-alist
      '(("/Users/karthikbalasubramanian" . "~")))
    (setq recentf-filename-handler 'abbreviate-file-name)
    ;; save current buffer list in case emacs is closed (saved every 5 mins)
    (run-at-time (current-time) 300 'recentf-save-list)
    :bind
    (:map ctl-x-map
          ("C-r" . recentf-open-files)))

;; * Outshine
(use-package outshine
    :init
  ;; useful settings from the README
  ;; (defvar outline-minor-mode-prefix "\M-#")
  ;; (setq outshine-use-speed-commands t)
  ;; to get help, or C-h m, or C-h b, or:
  ;; (outshine-speed-command-help)
  (add-hook 'outline-minor-mode-hook
            'outshine-mode)
  (add-hook 'ess-mode-hook
            'outshine-mode)
  (add-hook 'emacs-lisp-mode-hook
            'outshine-mode)
  :bind
  (:map outshine-mode-map
        ("M-n" . outline-next-visible-heading)
        ("M-p" . outline-previous-visible-heading)))

;; * dired
(use-package dired
  :ensure nil
  :commands (dired)
  :custom
  (dired-listing-switches "-al")
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (dired-hide-details-hide-symlink-targets nil)
  :config
  ;; just to keep it slim
  (add-hook 'dired-mode-hook
            #'dired-hide-details-mode)
  :bind
  (:map dired-mode-map
        ("C-M-p" . dired-up-directory)))

;; let's uses async operations
;; when it's possible
(use-package async
  :after dired
  :config
  (dired-async-mode 1))

;; A tree view is better that
;; the default insertion of
;; subdirectories.
(use-package dired-subtree
  :after dired
  :config
  (setq dired-subtree-use-backgrounds nil)
  :bind
  (:map dired-mode-map
        ("TAB" . dired-subtree-toggle)
        ("<backtab>" . dired-subtree-cycle)
        ("M-n" . dired-subtree-next-sibling)
        ("M-p" . dired-subtree-previous-sibling)
        ("C-M-n" . dired-subtree-down)))

;; * Keybindings
;; ** No unclosable font dialog popup
(global-unset-key (kbd "s-t"))
;; * Email
;; the mail configuration have its
;; own org file, mail-configuration.org
(load (concat user-emacs-directory
              "personal/mail-configuration.el.gpg")
      'no-error)

;; * Org mode
;; ** Packages
(use-package org
    :config
;; ** todo integration
  (setq org-todo-keywords
        '((sequence "TODO" "APPT" "WAITING" "BOTTLENECK" "STARTED" "DELEGATED" "DONE")))
  (setq org-log-done t)
  (setq org-todo-keyword-faces
        '((("TODO" :foreground "red" :weight bold)
           ("APPT" :foreground "violet" :weight bold)
           ("NOTE" :foreground "dark violet" :weight bold)
           ("STARTED" :foreground "dark orange" :weight bold)
           ("WAITING" :foreground "blue" :weight bold)
           ("DELEGATED" :foreground "green" :weight bold))))
;; ** org blocks
  (require 'ob-shell)
  ;; use native major-mode indentation
  (setq org-src-preserve-indentation t
        ;; we do this ourselves
        org-src-tab-acts-natively t
        ;; You don't need my permission (just be careful, mkay?)
        org-confirm-babel-evaluate nil
        org-adapt-indentation nil
        org-link-elisp-confirm-function nil)
;; ** column view ? Always switch to column view for agenda
  ;; ;; (add-hook 'org-agenda-mode-hook 'org-agenda-columns) ;; (not working :-(
;; ** Agenda view
  ;; start agenda from today yesterday
  (setq org-agenda-start-day "-0d")
  (setq org-agenda-span 1)
  (setq org-agenda-start-on-weekday nil)
  (setq org-log-done nil)
;; ** full screen org-agenda-view
  (setq org-agenda-window-setup 'current-window)
  ;; Ensure todo, agenda, and other minor popups are delegated to the popup system.
  ;; needed for at least org-noter / org-insert-structure-template
  (advice-add #'org-switch-to-buffer-other-window :override
              (defun +popup--org-pop-to-buffer-a (buf &optional norecord)
                "Use `pop-to-buffer' instead of `switch-to-buffer' to open buffer.'"
                (pop-to-buffer buf nil norecord)))
  ;; don't show future scheduled to-do
  ;; (setq org-agenda-todo-ignore-scheduled 'future)
  ;; (setq org-agenda-tags-todo-honor-ignore-options t)
  (setq org-agenda-prefix-format '((agenda . "%?-12t")))
  ;; file name + org-agenda-entry-type
  ;;    (agenda  . "  • ")
  ;;    (timeline  . "  % s")
  ;;    (todo  . " %i %-12:c")
  ;;    (tags  . " %i %-12:c")
  ;;    (search . " %i %-12:c")))
  ;; include diary entries
  ;; (setq org-agenda-include-diary t)
  ;; number of days ahead to warn for deadline;; (setq org-deadline-warning-days 1)
  ;; don't show tasks as scheduled if they are already shown as a deadline
  ;; (setq org-agenda-skip-scheduled-if-deadline-is-shown t))
  ;; https://emacs.stackexchange.com/questions/12517/how-do-i-make-the-timespan-shown-by-org-agenda-start-yesterday
  ;; ** files location
  (setq org-directory "/Users/karthikbalasubramanian/Google Drive/GTD/")
  ;; Set to the location of your Org files on your local system
  (setq org-default-notes-file (concat org-directory "notes.org"))
  (setq org-agenda-files `(,(concat org-directory "calendar")))
  ;; ;; Set to the name of the file where new notes will be stored
  ;; (setq org-mobile-inbox-for-pull "~/Dropbox/GTD/flagged.org")
  ;; ;; Set to <your Dropbox root directory>/MobileOrg.
  ;; (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
  ;; (org-agenda-list)
;; ** imenu integration
  (setq org-imenu-depth 7)
;; ** keybindings
  :bind
   ;; capture
  (("C-c l" . #'org-store-link)
   ("C-c a" . #'org-agenda)
   ("C-c c" . #'org-capture)
   ;; agenda
   ("C-c l" . #'org-store-link)
   ("C-c a" . #'org-agenda)
   ;; navigation
   (:map org-mode-map
         ("M-n"   . #'org-next-visible-heading)
         ("M-p"   . #'org-previous-visible-heading)
         ("C-M-n" . #'org-next-block)
         ("C-M-p" . #'org-previous-block))))

;; ** org crypt
(use-package org-crypt
  :ensure nil
  :after org
  :custom
  (org-crypt-key "kartbala@gmail.com")
  :bind
  (:map org-mode-map
        ("C-c C-/" . org-decrypt-entry)
        ("C-c M-/" . org-decrypt-entries)))

;; * ess
;; Set default R version, (i.e. the one launched by typing M-x R <RET>)
;; (setq inferior-R-program-name "/usr/local/bin/R")

;; ** Forges integration
;; use git with the emacs git porcelain
(use-package magit
  :commands magit-status
  :custom
  ;; does not create a margin
  ;; that was mangling the visual
  (magit-log-margin '(nil age magit-log-margin-width t 18)))

(use-package transient
  :after magit
  :custom
  ;; let us use navigation keys to
  ;; see the differents commands
  (transient-enable-popup-navigation t)
  ;; show columns vertically
  (transient-force-single-column t))

;; access forges with magit
;; (use-package forge)

(define-prefix-command 'file-prefix 'file-prefix) 
(global-set-key (kbd "C-c u") 'file-prefix)
(use-package crux
  :bind (:map file-prefix
              ("s" . crux-sudo-edit)
              ("w" . crux-kill-buffer-truename)))
