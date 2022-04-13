;;; publish.el --- Publishes my dotfiles using ox-hugo -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Jacob Hilker
;;
;; Author: Jacob Hilker <jacob.hilker2@gmail.com>
;; Maintainer: Jacob Hilker <jacob.hilker2@gmail.com>
;; Created: April 09, 2022
;; Modified: April 09, 2022
;; Version: 0.0.1
;; Keywords: publishing dotfiles org
;; Homepage: https://github.com/jhilker1/dots
;; Package-Requires: ((emacs "26.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;
;;
;;; Code:
(setq user-emacs-directory (expand-file-name "./.packages")
      make-backup-files nil) ;; using git so unnecessary

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
(straight-use-package '(org :type git
       :repo "https://code.orgmode.org/bzg/org-mode.git"
       :local-repo "org"
       :depth full
       :pre-build (straight-recipes-org-elpa--build)
       :build (:not autoloads)
       :files (:defaults "lisp/*.el" ("etc/styles/" "etc/styles/*"))))

(straight-use-package '(org-contrib))
(straight-use-package '(ox-hugo
                        :host github :repo "kaushalmodi/ox-hugo"))

(with-eval-after-load 'ox
  (require 'ox-hugo))

(with-eval-after-load 'ol
  (add-to-list 'org-link-abbrev-alist '("github" . "https://github.com/")))

(with-eval-after-load 'ox-hugo
  (setq org-hugo-paired-shortcodes "warning"))

(with-eval-after-load 'ox-hugo
  (setq org-export-global-macros '(("srcstart" . "@@hugo:<details><summary class=\"font-bold underline\">$1</summary>@@")
                                   ("srcend" . "@@hugo:</details>@@"))))

(defun build/export-configs ()
  (dolist (org-file (directory-files-recursively ".config" "\.org$"))
    (with-current-buffer (find-file org-file)
      (message (format "[build] Exporting %s" org-file))
      (org-hugo-export-wim-to-md :all-subtrees nil nil nil))))

(defun build/export-pages ()
  (dolist (org-file (directory-files "."))
    (if (equal "org" (file-name-extension org-file))
    (with-current-buffer (find-file org-file)
      (message (format "[build] Exporting %s" org-file))
      (org-hugo-export-wim-to-md :all-subtrees nil nil nil)))))

(defun build/export-all ()
  (build/export-pages)
  (build/export-configs))

(build/export-all)


(provide 'publish)
;;; publish.el ends here

