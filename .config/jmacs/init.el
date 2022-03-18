;;; init.el --- -*- lexical-binding: t; coding: utf-8; -*-

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
      (with-current-buffer
              (url-retrieve-synchronously
                       "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
                                'silent 'inhibit-cookies)
                    (goto-char (point-max))
                          (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

(setq frame-title-format '("Emacs - %b@" (:eval (or (file-remote-p default-directory 'host) system-name))))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(use-package doom-themes
  :config
    (setq doom-themes-enable-bold t
            doom-themes-enable-italic t)
      (load-theme 'doom-gruvbox t))

(defun jh/set-fonts ()
  (set-face-attribute 'default nil :font (font-spec :family "Iosevka Mono Nerd Font" :size 14)) 
  (set-face-attribute 'fixed-pitch nil :font (font-spec :family "Iosevka Mono Nerd Font" :size 14)) 
  (set-face-attribute 'variable-pitch nil :font (font-spec :family "Iosevka Aile" :size 12))
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic))

(use-package battery :ensure nil :straight nil)

(setq display-time-default-load-average nil
      display-time-mail-string ""
      display-time-format "%a, %d %b - %R")

(defun jh/battery-time-modeline ()
"Toggles Display of battery and clock in modeline."
(when (and battery-status-function
       (not (string-match-p "N/A" 
                (battery-format "%B"
                        (funcall battery-status-function)))))
  (display-battery-mode 1)
  (display-time-mode 1)))

(add-hook 'after-init-hook #'jh/battery-time-modeline)

(if (daemonp) 
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                ;; (setq doom-modeline-icon t)
                (with-selected-frame frame
                  (jh/set-fonts))))
    (jh/set-fonts))

(straight-use-package '(org :type git
       :repo "https://code.orgmode.org/bzg/org-mode.git"
       :local-repo "org"
       :depth full
       :pre-build (straight-recipes-org-elpa--build)
       :build (:not autoloads)
       :files (:defaults "lisp/*.el" ("etc/styles/" "etc/styles/*"))))

(straight-use-package '(org-contrib))

(org-babel-load-file (expand-file-name "jmacs.org" user-emacs-directory))
