;;; -*- lexical-binding: t; coding: utf-8; -*-

(setq user-full-name "Jacob Hilker"
      user-mail-address "jacob.hilker2@gmail.com"
      visible-bell t)

(setq-default custom-file (expand-file-name ".custom.el" user-emacs-directory))

(electric-indent-mode -1)
(setq-default indent-tabs-mode nil)
(setq tab-always-indent 'complete)

(setq org-src-preserve-indentation t
      org-src-fontify-natively t
      org-src-tab-acts-natively t)

(setq-default tab-width 2)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq initial-major-mode 'org-mode)

(use-package all-the-icons
    :if (display-graphic-p))

(use-package emojify)

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package evil
  :init
  (setq evil-undo-system 'undo-tree)
  (setq evil-want-C-i-jump nil) 
  (setq evil-want-C-u-scroll t)
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  :preface
  (defun ian/save-and-kill-this-buffer ()
    (interactive)
    (save-buffer)
    (kill-this-buffer))
  :config
  (with-eval-after-load 'evil-maps ; avoid conflict with company tooltip selection
    (define-key evil-insert-state-map (kbd "C-n") nil)
    (define-key evil-insert-state-map (kbd "C-p") nil))
  (evil-ex-define-cmd "q" #'kill-this-buffer)
  (evil-ex-define-cmd "wq" #'ian/save-and-kill-this-buffer))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-org
  :after org
  :init
  (fset 'evil-redirect-digit-argument 'ignore) ; before evil-org loaded
  (add-to-list 'evil-digit-bound-motions 'evil-org-beginning-of-line)
  (evil-define-key 'motion 'evil-org-mode
    (kbd "0") 'evil-org-beginning-of-line)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-surround
  :hook (evil-mode . global-evil-surround-mode))

(use-package general)

(use-package which-key
  :config
  (which-key-mode 1))

(use-package helpful)

(use-package treemacs
  :config
  (setq treemacs-persist-file "~/.emacs.d/.local/cache/treemacs.org"))

(use-package treemacs-evil
  :after evil treemacs
  :ensure t)

(use-package treemacs-projectile
  :after projectile treemacs
  :ensure t)

(use-package treemacs-magit
  :after magit treemacs
  :ensure t)

(use-package imenu-list)

(use-package restart-emacs)

(use-package yasnippet
  :hook (after-init . yas-global-mode))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package pass
  :config
  (setf epa-pinentry-mode 'loopback))

(use-package company
  :hook (after-init . global-company-mode))

(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("?" . minibuffer-completion-help)
              ("M-RET" . minibuffer-force-complete-and-exit)
              ("M-TAB" . minibuffer-complete)
              :map minibuffer-local-map
              ("M-h" . backward-kill-word))
  :config
  (setq vertico-cycle t
        vertico-count-format '(" -6%s " . "%s/%s"))
  :init
  (vertico-mode 1))

(use-package vertico-posframe
  :after vertico
  :straight (:host github :repo "tumashu/vertico-posframe")
  :config
  (vertico-posframe-mode 1))

(use-package consult
  :demand t
  :bind (("C-s" . consult-line)
         ("C-M-l" . consult-imenu)
         ("C-M-j" . persp-switch-to-buffer*)
         :map minibuffer-local-map
         ("C-r" . consult-history))
  :custom
  (completion-in-region-function #'consult-completion-in-region))

(use-package marginalia
  :after vertico
  :straight t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package embark
    :bind (("C-S-a" . embark-act)
         :map minibuffer-local-map
         ("C-d" . embark-act))
  :config
  (setq embark-action-indicator
        (lambda (map)
          (which-key--show-keymap "Embark" map nil nil 'no-paging)
          #'which-key--hide-popup-ignore-command)
        embark-become-indicator embark-action-indicator))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package hydra)

(use-package major-mode-hydra
:after hydra
:bind ("M-SPC" . major-mode-hydra))

(use-package hydra-posframe
  :straight (:host github :repo "Ladicle/hydra-posframe")
  :hook (after-init . hydra-posframe-enable))

(defun with-faicon (icon str &optional height v-adjust)
  (s-concat (all-the-icons-faicon icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

(defun with-fileicon (icon str &optional height v-adjust)
  (s-concat (all-the-icons-fileicon icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

(defun with-octicon (icon str &optional height v-adjust)
  (s-concat (all-the-icons-octicon icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

(defun with-material (icon str &optional height v-adjust)
  (s-concat (all-the-icons-material icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

(defun with-mode-icon (mode str &optional height nospace face)
  (let* ((v-adjust (if (eq major-mode 'emacs-lisp-mode) 0.0 0.05))
         (args     `(:height ,(or height 1) :v-adjust ,v-adjust))
         (_         (when face
                      (lax-plist-put args :face face)))
         (icon     (apply #'all-the-icons-icon-for-mode mode args))
         (icon     (if (symbolp icon)
                       (apply #'all-the-icons-octicon "file-text" args)
                     icon)))
    (s-concat icon (if nospace "" " ") str)))

(defvar jh/hydra-title nil "Title format for my major-mode hydras.")

(use-package transient)

(use-package hercules)

(setq org-directory "~/Dropbox/org"
      org-log-into-drawer t
      org-log-done 'time
      org-log-done-with-time t
      org-agenda-start-day "-0d"
       org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
      '(("google" . "http://www.google.com/search?q=")
        ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
        ("ddg" . "https://duckduckgo.com/?q=")
        ("wiki" . "https://en.wikipedia.org/wiki/")
        ("github" . "https://github.com/")
        ("gitlab" . "https://gitlab.com/")))

(use-package org-id
  :ensure nil
  :straight nil)

(use-package org-tempo
  :straight nil
  :ensure nil)

(defun jh/org-ui-init ()
  "Sets better defaults for org-mode ui."
  (visual-line-mode 1)
  (org-indent-mode 1)
  (variable-pitch-mode 1)
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)

  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-document-title nil :font (font-spec :family "Iosevka Aile" :size 25) :weight 'bold)
  (set-face-attribute 'org-tag nil :foreground "#e5c07b")
  (set-face-attribute 'org-hide nil :inherit 'fixed-pitch))


(add-hook 'org-mode-hook #'jh/org-ui-init)

(setq org-hide-emphasis-markers t
      org-hide-leading-stars t
      org-ellipsis "▾ ")

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-autoentities t))

(use-package org-fragtog 
  :hook (org-mode . org-fragtog-mode))

(plist-put org-format-latex-options :scale 1.25)

(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("●" "○")
        org-superstar-special-todo-items t
        org-superstar-todo-bullet-alist '(("TODO" . ?☐)
                                          ("DONE" . ?☑))))

(use-package doct
  :commands (doct doct-add-to))

(use-package org-super-agenda
  :config 
;  (setq org-super-agenda-header-map nil)
  (org-super-agenda-mode 1))

(use-package org-ql)

(defvar jh/org-todo-cal-tags '(
                               ;; Project Contexts
                               (:startgroup)
                               ("@personal" . ?p)
                               ("@work" . ?w)
                               (:endgroup))

"Tags for tasks and calendar items.")

(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil
      org-refile-targets '((nil :maxlevel . 9)))

(use-package decide)

(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))

(use-package org-ref)

(use-package vulpea
  :straight (vulpea
             :type git
             :host github
             :repo "d12frosted/vulpea")
  :after (org-roam)
  ;; hook into org-roam-db-autosync-mode you wish to enable
  ;; persistence of meta values (see respective section in README to
  ;; find out what meta means)
  :hook ((org-roam-db-autosync-mode . vulpea-db-autosync-enable)))

(use-package org-roam-bibtex
  :after org-roam)

(use-package org-roam
	:init
	(setq org-roam-v2-ack t)
  :custom
  (org-roam-db-location "~/Nextcloud/roam/.org-roam.db")
  (org-roam-directory "~/Nextcloud/roam/")
  (org-roam-db-update-method 'immediate)
  (org-roam-file-exclude-regexp "readme")
  (org-roam-completion-everywhere t)
  (org-roam-node-display-template "${namespace:12} ${category:20} ${title:*} ${tags:*}")
	:config 
  (cl-defmethod org-roam-node-namespace ((node org-roam-node))
    "Return the currently set namespace for the NODE."
    (let ((namespace (cdr (assoc-string "NAMESPACE" (org-roam-node-properties node)))))
      (if (string= namespace (file-name-base (org-roam-node-file node)))
          "" ; or return the current title, e.g. (org-roam-node-title node)
        (format "%s" namespace))))


  
 (cl-defmethod org-roam-node-category ((node org-roam-node))
    "Return the currently set category for the NODE."
    (let ((category (cdr (assoc-string "CATEGORY" (org-roam-node-properties node)))))
      (if (string= category (file-name-base (org-roam-node-file node)))
          "" ; or return the current title, e.g. (org-roam-node-title node)
        (format "%s" category))))

  (cl-defmethod org-roam-node-backlinks ((node org-roam-node))
    (let* ((count (car (org-roam-db-query
                        [:select (funcall count source)
                                 :from links
                                 :where (= dest $s1)
                                 :and (= type "id")]
                        (org-roam-node-id node)))))
      (format "[%d]" count)))

  (cl-defmethod org-roam-node-slug ((node org-roam-node))
    "Return the slug of NODE."
    (let ((title (org-roam-node-title node))
          (slug-trim-chars '(;; Combining Diacritical Marks https://www.unicode.org/charts/PDF/U0300.pdf
                             768 ; U+0300 COMBINING GRAVE ACCENT
                             769 ; U+0301 COMBINING ACUTE ACCENT
                             770 ; U+0302 COMBINING CIRCUMFLEX ACCENT
                             771 ; U+0303 COMBINING TILDE
                             772 ; U+0304 COMBINING MACRON
                             774 ; U+0306 COMBINING BREVE
                             775 ; U+0307 COMBINING DOT ABOVE
                             776 ; U+0308 COMBINING DIAERESIS
                             777 ; U+0309 COMBINING HOOK ABOVE
                             778 ; U+030A COMBINING RING ABOVE
                             780 ; U+030C COMBINING CARON
                             795 ; U+031B COMBINING HORN
                             803 ; U+0323 COMBINING DOT BELOW
                             804 ; U+0324 COMBINING DIAERESIS BELOW
                             805 ; U+0325 COMBINING RING BELOW
                             807 ; U+0327 COMBINING CEDILLA
                             813 ; U+032D COMBINING CIRCUMFLEX ACCENT BELOW
                             814 ; U+032E COMBINING BREVE BELOW
                             816 ; U+0330 COMBINING TILDE BELOW
                             817 ; U+0331 COMBINING MACRON BELOW
                             )))
      (cl-flet* ((nonspacing-mark-p (char)
                                    (memq char slug-trim-chars))
                 (strip-nonspacing-marks (s)
                                         (ucs-normalize-NFC-string
                                          (apply #'string (seq-remove #'nonspacing-mark-p
                                                                      (ucs-normalize-NFD-string s)))))
                 (cl-replace (title pair)
                             (replace-regexp-in-string (car pair) (cdr pair) title)))
        (let* ((pairs `(("[^[:alnum:][:digit:]]" . "-") ;; convert anything not alphanumeric
                        ("--*" . "-")                   ;; remove sequential underscores
                        ("^-" . "")                     ;; remove starting underscore
                        ("-$" . "")))                   ;; remove ending underscore
               (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
          (downcase slug))))))



(use-package org-ml)

(use-package ox-hugo
  :ensure t
  :config 
  (setq org-hugo-suppress-lastmod-period 86400.00))

(use-package ox-publish
  :ensure nil
  :straight nil)

(use-package pp-html
  :straight (:host github :repo "Kinneyzhang/pp-html"))

(use-package esxml
  :ensure t)

(use-package ox-gemini
  :ensure t)

(use-package htmlize
  :ensure t)

(use-package webfeeder
  :ensure t)

(setq org-html-htmlize-output-type 'css)       
(setq-default org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"~/.emacs.d/stylesheet.css\" />")

(use-package org-special-block-extras
  :ensure t
  :hook (org-mode . org-special-block-extras-mode)
  ;; All relevant Lisp functions are prefixed 'o-'; e.g., `o-docs-insert'.
  :custom
    (o-docs-libraries
     '("~/Nextcloud/org/org-special-blocks-docs.org")
     "The places where I keep my ‘#+documentation’"))

(use-package weblorg)

;(use-package anaphora)

;(use-package defblog
;  :straight (:host github :repo "jphmrst/defblog"))

(add-hook 'org-src-mode-hook 'display-line-numbers-mode)
(org-babel-do-load-languages
 'org-babel-load-languages
'((emacs-lisp . t)
  (python . t)
  (org . t)
))



(use-package ox-moderncv
  :straight '(:host gitlab :repo "jhilker/org-cv"))

(add-hook 'org-mode-hook (lambda ()
                           (setq jh/hydra-title (with-fileicon "org" "Org-mode" 1 -0.05))))

(major-mode-hydra-define org-mode (:title jh/hydra-title)
  ("Agenda"
   (("aa" org-agenda "Agenda Dispatch"))
   "Dates"
   (("dd" org-deadline "Set Deadline")
    ("ds" org-schedule "Set Scheduled Date")
    ("dt" org-time-stamp "Set Time Stamp"))))

(defun jh/ide-init ()
  "Initializes Emacs for when I am programming."
  (interactive)
  (global-hl-todo-mode 1)
  (display-line-numbers-mode 1)
  (setq display-line-numbers 'relative))
(add-hook 'prog-mode-hook 'jh/ide-init)

(defun jh/lsp-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((prog-mode . lsp-mode))
  :init 
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-treemacs
  :after lsp)

(use-package projectile
  :config
  (projectile-mode))

(use-package magit)

(use-package magit-todos
  :after magit)

(use-package forge
  :after magit)

(use-package smartparens
  :init
  (smartparens-global-mode))

(use-package rainbow-delimiters
  :hook ((prog-mode) . rainbow-delimiters-mode))

(use-package company-bibtex
  :config
  (add-to-list 'company-backends '(company-bibtex)))

(use-package python
  :straight nil
  :ensure nil)



(use-package emmet-mode
  :hook ((sgml-mode css-mode mhtml-mode)))

(use-package lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package lorem-ipsum)

(use-package simple-httpd)

(use-package yaml-mode)

(use-package erc
  :ensure nil
  :straight nil)

(use-package dired-ranger)

(use-package elfeed
  :config
  (setq elfeed-db-directory "~/.elfeed/"
	      elfeed-search-filter "@1-week-ago +unread ")
   (evil-define-key 'normal elfeed-search-mode-map 
    "A" 'elfeed-mark-all-as-read
    "Q" 'delete-frame
    "f" 'jh/elfeed-search-hydra/body
    "/" 'elfeed-search-live-filter))

(defun elfeed-mark-all-as-read ()
	(interactive)
  (mark-whole-buffer)
  (elfeed-search-untag-all-unread))

(add-hook 'emacs-startup-hook (lambda () (run-at-time (* 60 5) 'elfeed-update)))

(use-package elfeed-org
  :after elfeed
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files '("~/Dropbox/org/elfeed.org")))

(pretty-hydra-define jh/elfeed-search-hydra (:title (with-faicon "newspaper-o" "Elfeed Filters") :quit-key "q" :color teal)
  ("Category"
   (("d" (elfeed-search-set-filter "@1-week-ago +unread") "Default") 
    ("n" (elfeed-search-set-filter "@1-week-ago +unread +news") "News") 
    ("c" (elfeed-search-set-filter "@1-week-ago +unread +campaign") "Campaigns")  
    ("f" (elfeed-search-set-filter "@1-week-ago +unread +forum") "Forums")  
    ("p" (elfeed-search-set-filter "+podcast") "Podcasts")  
    ("r" (elfeed-search-set-filter "@1-week-ago +unread +reddit") "Reddit")  
    ("b" (elfeed-search-set-filter "@1-week-ago +unread +blog") "Blogs"))))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

(use-package mu4e 
  :ensure nil
  :straight nil
  :config
  (setq mu4e-change-filenames-when-moving t
        mu4e-maildir "~/.local/share/mail/"
        mu4e-get-mail-command "mbsync -a"
        mu4e-update-interval (* 10 60))
  (setq mu4e-contexts
        (list
         ;; Work account
         (make-mu4e-context
          :name "jhilker2"
          :match-func
            (lambda (msg)
              (when msg
                (string-prefix-p "/jacob.hilker2@gmail.com" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "jacob.hilker2@gmail.com")
                  (mu4e-drafts-folder  . "/jacob.hilker2@gmail.com/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/jacob.hilker2@gmail.com/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/jacob.hilker2@gmail.com/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/jacob.hilker2@gmail.com/[Gmail]/Trash")))))


)

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-week-agenda nil
        dashboard-show-shortcuts nil
        dashboard-set-navigator t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents  . 5)
                          (projects . 10))))
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :after mu4e-alert
  :config
  (setq doom-modeline-height 32
        doom-modeline-enable-word-count t
        doom-modeline-icon (display-graphic-p)
        doom-modeline-mu4e t
        doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode)
        doom-modeline--battery-status t))

(doom-modeline-mode 1)



(use-package centaur-tabs
  :init
  (centaur-tabs-mode t)
  :config
  (setq centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "•"
	      centaur-tabs-set-icons t
	      centaur-tabs-set-close-button t
	      centaur-tabs-close-button "x"
	      centaur-tabs-style "bar"
        centaur-tabs-set-bar 'above
	      centaur-tabs-cycle-scope 'tabs)
  :hook
  (mu4e-main-mode . centaur-tabs-local-mode)
  (mu4e-headers-mode . centaur-tabs-local-mode) 
  (mu4e-view-mode . centaur-tabs-local-mode)
  (elfeed-search-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  :bind
  (:map evil-normal-state-map
	      ("g t" . centaur-tabs-forward)
	      ("g T" . centaur-tabs-backward)))

(defun edit-dotfile ()
  "Loads the Jmacs config file to be edited."
  (interactive)
  (find-file (expand-file-name "jmacs.org" user-emacs-directory)))

(defun edit-inbox ()
  "Loads the inbox to be reviewed."
  (interactive)
  (find-file "~/Dropbox/org/inbox.org")
  (find-file "~/Dropbox/org/orgzly.org"))

(defun reload-jmacs ()
  "Reloads the config."
  (interactive)
  (org-babel-load-file (expand-file-name "jmacs.org" user-emacs-directory)))



(general-create-definer jh/evil-leader
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "C-SPC")

(general-create-definer jh/evil-local-leader
  :states '(normal visual insert emacs)
  :prefix ","
  :non-normal-prefix "C-,")

(jh/evil-leader
  "SPC" '(execute-extended-command :which-key "Run Command")
  "c"   (general-simulate-key "C-c" :which-key "Run `C-c`")
  "h"   (general-simulate-key "C-h" :which-key "Help")
  "u"   (general-simulate-key "C-u" :which-key "Run `C-u`")
  "x"   (general-simulate-key "C-x" :which-key "Run `C-x`"))

(jh/evil-leader
  "b"   '(:ignore t :which-key "Buffers")
  "bb"  'mode-line-other-buffer
  "bd"  'kill-this-buffer
  "bn"  'next-buffer
  "bp"  'previous-buffer
  "bq"  'kill-buffer-and-window
  "bR"  'rename-buffer
  "br"  'revert-buffer
  "bs" 'switch-to-buffer)

(jh/evil-leader
  "f" '(:ignore t :which-key "Files")
  "fe" '(:ignore t :which-key "Edit File")
  "fed" '(edit-dotfile :which-key "Edit config")
  "fei" '(edit-inbox :which-key "Edit inbox")
  "fer" '(reload-jmacs :which-key "Reload Jmacs")
  "ff" '(find-file :which-key "Find file")
  "fs" '(save-buffer :which-key "Save file")
  "fl" '(load-file :which-key "Load file"))

(jh/evil-leader
  "g" '(:ignore t :which-key "Magit")
  "gs" 'magit-status
  "gS" 'magit-stage-file
  "gc" 'magit-commit
  "gp" 'magit-pull
  "gP" 'magit-push
  "gb" 'magit-branch
  "gB" 'magit-blame
  "gd" 'magit-diff)

(global-set-key (kbd "C-h F") 'describe-face)
(global-set-key (kbd "C-h f") 'describe-function)

(jh/evil-leader
  "i" '(:ignore t :which-key "Insert special character")
  "ic" '(insert-char :which-key "Insert character")
  "ii" '(all-the-icons-insert :which-key "Insert icon")
  "ie" '(emojify-insert-emoji :which-key "Insert emoji")
  "is" '(yas-insert-snippet :which-key "Insert snippet"))

(jh/evil-leader
  "o" '(:ignore t :which-key "Org-mode")
  "oa" '(org-agenda :which-key "Org Agenda")
  "ob" '(org-babel-tangle :which-key "tangle source code")
  "oc" '(org-capture :which-key "Org Capture")
  "od" '(:ignore t :which-key "Set Date")
  "odd" '(org-deadline :which-key "Set deadline")
  "ods" '(org-schedule :which-key "Schedule date")
  "odt" '(org-time-stamp :which-key "Set date")
  "oe" '(org-export-dispatch :which-key "Export file")
  "oi" '(:ignore t :which-key "Insert")
  "oil" '(org-insert-link :which-key "Insert link")
  "or" '(jh/org-refile-hydra/body :which-key "Refile Headline")
  "oq" '(org-set-tags-command :which-key "Set tags"))

(jh/evil-local-leader
  :keymaps 'org-mode-map
  "a" '(org-archive-subtree :which-key "Archive Item")
  "r" '(jh/org-refile-hydra/body :which-key "Refile Item"))

(jh/evil-leader
"p" '(:ignore t :which-key "Project")
"pc" '(projectile-invalidate-cache :which-key "Clear project cache")
"pp" '(projectile-switch-project :which-key "Switch project"))

(jh/evil-leader
  "r" '(:ignore t :which-key "Reload")
  "rr" '(reload-jmacs :which-key "Reload Jmacs"))



(jh/evil-leader
  "t" '(:ignore t :which-key "Toggle")
  ;"te" '(global-emojify-mode :which-key "Toggle emoji")
  "ts" '(treemacs :which-key "Toggle Treemacs")
  "to" '(imenu-list :which-key "Toggle Outline")
  "tz" '(writeroom-mode :which-key "Toggle Zen"))

(jh/evil-leader
  "w"  '(:ignore t :which-key "Windows")
  "w-" '(split-window-right :which-key "Horizontal split")
  "w|" '(split-window-below :which-key "Vertical split")
  "wd"  '(delete-window :which-key "Delete window")
  "wD"  '(delete-other-windows :which-key "Delete other windows")
  "wm" '(maximize-window :which-key "Maximize window")
  "wh" '(evil-window-left :which-key "Move focus left")
  "wj" '(evil-window-down :which-key "Move focus down")
  "wk" '(evil-window-up :which-key "Move focus up")
  "wl" '(evil-window-right :which-key "Move focus right"))

(jh/evil-leader
  "q"  '(:ignore t :which-key "Quit")
  "qf" '(delete-frame :which-key "Kill Frame")
  "qq" '(kill-emacs :which-key "Quit emacs")
  "qr" '(restart-emacs :which-key "Restart emacs"))

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(when (file-exists-p custom-file)
  (load custom-file))
