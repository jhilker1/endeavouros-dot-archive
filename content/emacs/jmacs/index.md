+++
title = "Jmacs"
author = ["Jacob Hilker"]
type = "config"
draft = false
+++

## Initialization {#initialization}


### Early Initialization {#early-initialization}


#### Disabling Package.el {#disabling-package-dot-el}

By default, I want to use straight.el as my package manager.

```elisp
(setq package-enable-at-startup nil)
```


#### UTF-8 {#utf-8}

I want UTF-8 characters for my files.

```elisp
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)
(set-default buffer-file-coding-system 'utf-8)
```


### General Initialization {#general-initialization}


#### Lexical Binding and Unicode {#lexical-binding-and-unicode}

This is the header-line for my `init.el`. It just sets unicode and lexical binding.

```elisp
;;; init.el --- -*- lexical-binding: t; coding: utf-8; -*-
```


#### Setting Up Straight.el {#setting-up-straight-dot-el}

I am using straight.el for my packages.

```elisp
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
```


#### Setting Up Use-Package with Straight.el {#setting-up-use-package-with-straight-dot-el}

Use-package provides an easy-to-use macro - I like that, but want the functionality of straight.el.

```elisp
(straight-use-package 'use-package)
```

And finally, I always want it to use straight.el.

```elisp
(setq straight-use-package-by-default t)
```


#### Performance Improvements {#performance-improvements}


#### UI Setup {#ui-setup}

<!--list-separator-->

-  Cleaner Title Format

    ```elisp
    (setq frame-title-format '("Emacs - %b@" (:eval (or (file-remote-p default-directory 'host) system-name))))
    ```

<!--list-separator-->

-  Minimal UI

    I really hate seeing the menu bar, scrollbar, etc. I'm disabling those items here.

    ```elisp
    (scroll-bar-mode -1)
    (tool-bar-mode -1)
    (tooltip-mode -1)
    (menu-bar-mode -1)
    ```

<!--list-separator-->

-  Theme

    <!--list-separator-->

    -  Doom Themes

        Doom Themes is a nice collection of themes for emacs. I am using the Doom-one theme, based one the OneDark colors in Atom.

        ```elisp
        (use-package doom-themes
          :config
            (setq doom-themes-enable-bold t
        	    doom-themes-enable-italic t)
              (load-theme 'doom-gruvbox t))
        ```

<!--list-separator-->

-  Fonts

    ```elisp
    (defun jh/set-fonts ()
      (set-face-attribute 'default nil :font (font-spec :family "Iosevka Mono Nerd Font" :size 14))
      (set-face-attribute 'fixed-pitch nil :font (font-spec :family "Iosevka Mono Nerd Font" :size 14))
      (set-face-attribute 'variable-pitch nil :font (font-spec :family "Iosevka Aile" :size 12))
      (set-face-attribute 'font-lock-comment-face nil :slant 'italic))
    ```

<!--list-separator-->

-  Battery and Time

    I want to see battery and time in my modeline.

    <!--list-separator-->

    -  Packages

        ```elisp
        (use-package battery :ensure nil :straight nil)
        ```

    <!--list-separator-->

    -  Formats

        ```elisp
        (setq display-time-default-load-average nil
              display-time-mail-string ""
              display-time-format "%a, %d %b - %R")
        ```

    <!--list-separator-->

    -  Functions

        ```elisp
        (defun jh/battery-time-modeline ()
        "Toggles Display of battery and clock in modeline."
        (when (and battery-status-function
               (not (string-match-p "N/A"
        		(battery-format "%B"
        			(funcall battery-status-function)))))
          (display-battery-mode 1)
          (display-time-mode 1)))

        (add-hook 'after-init-hook #'jh/battery-time-modeline)
        ```

<!--list-separator-->

-  Server Setup

    I primarily use emacs as a daemon instead of the full application. Here is where I add the fonts for when I run it as a daemon.

    ```elisp
    (if (daemonp)
        (add-hook 'after-make-frame-functions
    	      (lambda (frame)
    		;; (setq doom-modeline-icon t)
    		(with-selected-frame frame
    		  (jh/set-fonts))))
        (jh/set-fonts))
    ```


#### Org Mode {#org-mode}

I want to use the newest version of org-mode instead of the one built in to emacs.

```elisp
(straight-use-package '(org :type git
       :repo "https://code.orgmode.org/bzg/org-mode.git"
       :local-repo "org"
       :depth full
       :pre-build (straight-recipes-org-elpa--build)
       :build (:not autoloads)
       :files (:defaults "lisp/*.el" ("etc/styles/" "etc/styles/*"))))

(straight-use-package '(org-contrib))
```

And finally, I want to load my config.

```elisp
(org-babel-load-file (expand-file-name "jmacs.org" user-emacs-directory))
```


## Initial Setup {#initial-setup}


### Lexical Binding and Unicode {#lexical-binding-and-unicode}

Once again, this just sets up unicode encoding and lexical binding.

```elisp
;;; -*- lexical-binding: t; coding: utf-8; -*-
```


### Personal Information {#personal-information}

This is where I setup my initial personal information, as well as a minimal UI and enabling the visual bell. I'm also setting up emacs to use it's own customize file instead of `init.el`. It will only load if that file exists.

```elisp
(setq user-full-name "Jacob Hilker"
      user-mail-address "jacob.hilker2@gmail.com"
      visible-bell t)

(setq-default custom-file (expand-file-name ".custom.el" user-emacs-directory))
```


## Minor Tweaks {#minor-tweaks}


### Making `TAB` Great Again {#making-tab-great-again}


#### Disabling Automatic Tabs {#disabling-automatic-tabs}

I am disabling automatic indentation with electric-indent-mode, and disabling tabs.

```elisp
(electric-indent-mode -1)
(setq-default indent-tabs-mode nil)
(setq tab-always-indent 'complete)
```


#### Improving Tab Key Functionality {#improving-tab-key-functionality}

I want to use 2 spaces for tabs for 99% of the languages I use. In addition, I want source blocks in org-mode to keep my regular indentation.

```emacs-lisp
(setq org-src-preserve-indentation t
      org-src-fontify-natively t
      org-src-tab-acts-natively t)

(setq-default tab-width 2)
```


### Y/N for Yes/No {#y-n-for-yes-no}

I also want to use y/n for answering yes or no.

```elisp
(defalias 'yes-or-no-p 'y-or-n-p)
```


### Scratch Buffer Uses Org Mode {#scratch-buffer-uses-org-mode}

I want my scratch buffer to use org-mode. I also want no message for my scratch buffer.

```elisp
(setq initial-major-mode 'org-mode
      initial-scratch-message nil)
```


### Icons {#icons}

I want to use icons occasionally. Might not be very often, but sometimes it's nice to have.

```elisp
(use-package all-the-icons
    :if (display-graphic-p))
```


### Emoji {#emoji}

Sometimes I want to add an emoji.

```elisp
(use-package emojify)
```


## Core Functionality {#core-functionality}


### Packages {#packages}


#### Undo Tree {#undo-tree}

Undo Tree lets me use more of Evil mode's redo functionality.

```elisp
(use-package undo-tree
  :config
  (global-undo-tree-mode))
```


#### Evil Mode {#evil-mode}

Evil mode lets me use the (superior) Vim bindings to the Emacs ones. In addition, I don't want :q to kill emacs, but rather the current buffer I am in (similar to Vim).

<!--list-separator-->

-  Evil-mode Core

    This is the core of evil mode.

    ```elisp
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
    ```

<!--list-separator-->

-  Evil-mode Collection

    This provides a collection of modules for using evil mode in other emacs programs.

    ```elisp
    (use-package evil-collection
      :after evil
      :config
      (evil-collection-init))
    ```

<!--list-separator-->

-  Evil Org-Mode

    ```elisp
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

    ```

<!--list-separator-->

-  Evil Surround

    ```elisp
    (use-package evil-surround
      :hook (evil-mode . global-evil-surround-mode))
    ```


#### General {#general}

```elisp
(use-package general)
```


#### Which-Key {#which-key}

Which-key lets me see what keybindings I can use.

```elisp
(use-package which-key
  :config
  (which-key-mode 1))
```


#### Helpful {#helpful}

Helpful allows me to have a better view of a help buffer.

```elisp
(use-package helpful)
```


#### Treemacs {#treemacs}

Treemacs allows me to set up a sidebar with project information.

```elisp
(use-package treemacs
  :config
  (setq treemacs-persist-file (expand-file-name ".local/cache/treemacs.org" user-emacs-directory)))

(use-package treemacs-evil
  :after evil treemacs
  :ensure t)

(use-package treemacs-projectile
  :after projectile treemacs
  :ensure t)

(use-package treemacs-magit
  :after magit treemacs
  :ensure t)
```


#### Imenu-List {#imenu-list}

Imenu-list lets me look at the file as a list.

```elisp
(use-package imenu-list)
```


#### Restart Emacs {#restart-emacs}

```elisp
(use-package restart-emacs)
```


#### YASnippet {#yasnippet}

YASnippet allows me to quickly insert snippets.

```elisp
(use-package yasnippet
  :hook (after-init . yas-global-mode))

(use-package yasnippet-snippets
  :after yasnippet)
```


#### Pass {#pass}

```elisp
(use-package pass
  :config
  (setf epa-pinentry-mode 'loopback))
```


#### Company {#company}

For all my in-buffer completion needs.

```elisp
(use-package company
  :hook (after-init . global-company-mode))
```


## Completion Frameworks {#completion-frameworks}


### Vertico, Consult, etc. {#vertico-consult-etc-dot}

```elisp
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
```


#### Related Packages {#related-packages}

<!--list-separator-->

-  Vertico-Posframe

    Vertico Posframe allows me to display my completions and such in a posframe.

    ```elisp
    (use-package vertico-posframe
      :after vertico
      :straight (:host github :repo "tumashu/vertico-posframe")
      :config
      (vertico-posframe-mode 1))
    ```


#### Consult {#consult}

Consult provides similar commands to Ivy.

```elisp
(use-package consult
  :demand t
  :bind (("C-s" . consult-line)
	 ("C-M-l" . consult-imenu)
	 ("C-M-j" . persp-switch-to-buffer*)
	 :map minibuffer-local-map
	 ("C-r" . consult-history))
  :custom
  (completion-in-region-function #'consult-completion-in-region))
```


#### Marginalia {#marginalia}

Marginalia is similar to `ivy-rich`, and allows me to see more information about something in a minibuffer (e.g. the helpstring for a function when I hit `M-x`.

```elisp
(use-package marginalia
  :after vertico
  :straight t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))
```


#### Embark {#embark}

Embark allows me to run actions on completions.

```elisp
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
```


#### Orderless {#orderless}

Orderless improves candidate filtering.

```elisp
(use-package orderless
  :init
  (setq completion-styles '(orderless)
	completion-category-defaults nil
	completion-category-overrides '((file (styles . (partial-completion))))))
```


## Command Wrappers {#command-wrappers}

This section defines what I like to call "command wrappers" - things such as Hydra, Embark, and Transient, where I can wrap multiple commands in one minibuffer and execute them.


### Hydra {#hydra}

I want to use hydras for certain things - namely, elfeed filters.

```elisp
(use-package hydra)
```


#### Related Packages {#related-packages}

<!--list-separator-->

-  Major Mode Hydra

    This lets me define hydras for each major mode.

    ```elisp
    (use-package major-mode-hydra
    :after hydra
    :bind ("M-SPC" . major-mode-hydra))
    ```

<!--list-separator-->

-  Hydra Posframe

    Shows hydras in a posframe.

    ```elisp
    (use-package hydra-posframe
      :straight (:host github :repo "Ladicle/hydra-posframe")
      :hook (after-init . hydra-posframe-enable))
    ```


#### <span class="org-todo todo TODO">TODO</span> UI Improvements {#ui-improvements}

I want to be able to use icons in my hydra titles.

<!--list-separator-->

-  Icon Setup

    ```elisp
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
    ```

<!--list-separator-->

-  Title Format

    Since major-mode-hydra allows me to use better titles, I have a particular format I want to use - an icon plus the title itself.

    ```elisp
    (defvar jh/hydra-title nil "Title format for my major-mode hydras.")
    ```


### Transient {#transient}

A similar package to Hydra, I like to use both. I'm still currently learning this, though.

```elisp
(use-package transient)
```


### Hercules {#hercules}

A which-key based Hydra wrapper.

```elisp
(use-package hercules)
```


## Org Mode {#org-mode}

Org-Mode is THE absolute best thing about Emacs, in my humble opinion. Being able to keep notes and an agenda in the same file is so much easier than something like Notion which is pretty resource-intensive and is much harder to organize (in my opinion, at least). I highly respect what they are doing, but I prefer org-mode. My workflow is very much still in progress - for now, it’s sort of a mix of GTD and my own thing. It will probably be constantly changing until I find what works for me.


### Initial Setup {#initial-setup}

This is my basic setup for org-mode. Nothing with agenda files, just setting up logging and my base org-directory, along with links.

```elisp
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
```


#### Core Packages {#core-packages}

<!--list-separator-->

-  Org-ID

    Org-ID allows me to set IDs for different headlines in an org-mode buffer.

    ```elisp
    (use-package org-id
      :ensure nil
      :straight nil)
    ```

<!--list-separator-->

-  Org-Tempo

    Org Tempo lets me use &lt;key(tab) to insert blocks into an org-mode document. As an example, I could use &lt;s(tab) to insert a source code block.

    ```emacs-lisp
    (use-package org-tempo
      :straight nil
      :ensure nil)
    ```


### UI Tweaks {#ui-tweaks}

This is a very basic function that sets up org-mode to use visual line mode, org-indent mode, and variable-pitch mode - just a few minor ui tweaks. It doesn't set anything other than that.

```elisp
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
```


#### Cleaner View {#cleaner-view}

I want to hide formatting characters (like forward-slashes for italics and asterisks for bold, as an example) and any leading stars for a nested heading (like a second-level header under a first-level heading). In addition, I want to use an arrow as my ellipsis, instead of the default three periods.

```elisp
(setq org-hide-emphasis-markers t
      org-hide-leading-stars t
      org-ellipsis "▾ ")
```


#### Packages {#packages}

<!--list-separator-->

-  Org Appear

    This package makes it much easier to edit Org documents when org-hide-emphasis-markers is turned on. It temporarily shows the emphasis markers around certain markup elements when you place your cursor inside of them. No more fumbling around with = and \* characters! (description credit to [David Wilson](https://config.daviwil.com/emacs) of the [System Crafters](https://youtube.com/c/SystemCrafters) youtube channel).

    ```elisp
    (use-package org-appear
      :hook (org-mode . org-appear-mode)
      :config
      (setq org-appear-autolinks t
    	org-appear-autosubmarkers t
    	org-appear-autoentities t))
    ```

<!--list-separator-->

-  Org-Fragtog

    Org-Fragtog allows me to toggle previews of \\(\LaTeX\\)  and other things. I am also setting up org-mode to use slightly bigger LaTeX previews.

    ```elisp
    (use-package org-fragtog
      :hook (org-mode . org-fragtog-mode))

    (plist-put org-format-latex-options :scale 1.25)
    ```

<!--list-separator-->

-  Org-Superstar

    Org-superstar lets me get better bullets in my headings and lists.

    ```elisp
    (use-package org-superstar
      :hook (org-mode . org-superstar-mode)
      :config
      (setq org-superstar-headline-bullets-list '("●" "○")
    	org-superstar-special-todo-items t
    	org-superstar-todo-bullet-alist '(("TODO" . ?☐)
    					  ("DONE" . ?☑))))
    ```


### Tasks and Events {#tasks-and-events}


#### Packages {#packages}

<!--list-separator-->

-  DOCT

    DOCT is an easier way of setting up org-mode capture templates.

    ```elisp
    (use-package doct
      :commands (doct doct-add-to))
    ```

<!--list-separator-->

-  Org Super Agenda

    Org Super Agenda allows me to group items in the agenda much more easily than I can by default.

    ```elisp
    (use-package org-super-agenda
      :config
    ;  (setq org-super-agenda-header-map nil)
      (org-super-agenda-mode 1))

    ```

<!--list-separator-->

-  Org-QL

    Org QL allows me to define queries for org-mode files.

    ```elisp
    (use-package org-ql)
    ```

<!--list-separator-->

-  Org-Gcal


#### Categories and Tags {#categories-and-tags}

I use categories and tags to help me organize my work. Categories are what I use more for a context (such as appointments, projects, etc) and a tag is something more narrow within that project. This is where I define my global tags - such as a personal context, or something for work, or for family. In addition, I also use tags to represent the status of a project, such as whether it’s active, or on the backlog, etc. However, with Org-gcal, I was getting duplicate events, so I am setting up tags to be excluded from inheritance here.

```elisp
(defvar jh/org-todo-cal-tags '(
			       ;; Project Contexts
			       (:startgroup)
			       ("@personal" . ?p)
			       ("@work" . ?w)
			       (:endgroup))

"Tags for tasks and calendar items.")


```


#### Refiling {#refiling}

```elisp
(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil
      org-refile-targets '((nil :maxlevel . 9)))
```


#### Capture Templates {#capture-templates}


#### Custom Agenda Commmands {#custom-agenda-commmands}


### Projects {#projects}


#### Org-Trello {#org-trello}

Org Trello allows me to sync org-mode buffers with trello boards.


### Campaign Manager {#campaign-manager}

I like to use org-mode as an rpg campaign manager and wiki.


#### Packages {#packages}

<!--list-separator-->

-  Decide Mode

    Decide mode allows me to roll dice in org-mode.

    ```elisp
    (use-package decide)
    ```


### Writing {#writing}

Org mode is also an excellent markup language.


#### Packages {#packages}

<!--list-separator-->

-  Org-Make-TOC

    Org-make-toc allows me to make tables-of-contents in org-mode.

    ```elisp
    (use-package org-make-toc
      :hook (org-mode . org-make-toc-mode))
    ```

<!--list-separator-->

-  Org-Ref

    Org-ref allows me to build bibliographies with org-mode.

    ```elisp
    (use-package org-ref)
    ```


#### <span class="org-todo todo TODO">TODO</span> Custom Writing Mode {#custom-writing-mode}

I want too set up an application similar to scrivener or ywriter in my emacs config.


### Note-taking with Org-Roam {#note-taking-with-org-roam}


#### Related Packages {#related-packages}

<!--list-separator-->

-  Deft

<!--list-separator-->

-  Vulpea

    ```elisp
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
    ```

<!--list-separator-->

-  Org-Roam-Bibtex

    Allows me to build an annotated bibliography with org-roam.

    ```elisp
    (use-package org-roam-bibtex
      :after org-roam)
    ```


#### Initial Setup {#initial-setup}

```elisp
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

```


#### Multi-Project Setup {#multi-project-setup}

Since I use org-roam for multiple projects, I'd like to have a way to capture to specific projects - such as blog posts and projects for my website, any lore for worldbuilding projects, etc.

```elisp
(defun jh/org-roam-capture (dir fn)
  (interactive)
  (let((org-roam-directory (expand-file-name dir org-roam-directory)))
    (funcall fn)))
```

<!--list-separator-->

-  "Capture Templates"

    Although I don't use `org-roam-capture-templates`, I do use vulpea in order to quickly set up "capture templates" - really, it's just a function to create the template.


### Hacking Org-Mode {#hacking-org-mode}


#### Org-ML {#org-ml}

Similar to Org-Element.

```elisp
(use-package org-ml)
```


### Web Development/Blogging {#web-development-blogging}


#### Hugo {#hugo}

Since I build my website with hugo, I want to be able to write in org-mode.

```elisp
(use-package ox-hugo
  :ensure t
  :config
  (setq org-hugo-suppress-lastmod-period 86400.00))
```


#### Org-Publish {#org-publish}

<!--list-separator-->

-  Initial Package Setup

    ```elisp
    (use-package ox-publish
      :ensure nil
      :straight nil)
    ```

<!--list-separator-->

-  HTML Templating

    I'd like to be able to set up an html template in elisp.

    ```elisp
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

    ```

    <!--list-separator-->

    -  Test

        ```elisp
        (setq org-html-htmlize-output-type 'css)
        (setq-default org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"~/.emacs.d/stylesheet.css\" />")
        ```

<!--list-separator-->

-  Org-Special-Block-Extras

    This package allows me to define custom blocks in org-mode.

    ```elisp
    (use-package org-special-block-extras
      :ensure t
      :hook (org-mode . org-special-block-extras-mode)
      ;; All relevant Lisp functions are prefixed 'o-'; e.g., `o-docs-insert'.
      :custom
        (o-docs-libraries
         '("~/Nextcloud/org/org-special-blocks-docs.org")
         "The places where I keep my ‘#+documentation’"))
    ```


#### Weblorg {#weblorg}

Weblorg is a way of creating static websites in org-mode.

```elisp
(use-package weblorg)
```


#### Defblog {#defblog}

A wrapper around org-publish.

```elisp
;(use-package anaphora)

;(use-package defblog
;  :straight (:host github :repo "jphmrst/defblog"))
```


### Literate Programming {#literate-programming}

```elisp
(use-package org-auto-tangle)

(add-hook 'org-src-mode-hook 'display-line-numbers-mode)
(org-babel-do-load-languages
 'org-babel-load-languages
'((emacs-lisp . t)
  (python . t)
  (org . t)
))
```


### Misc. Packages {#misc-dot-packages}


#### Org Chef {#org-chef}

Org-chef allows me to capture recipes from the internet.

```elisp

```


#### Org-CV {#org-cv}

This allows me to use org mode to create a resume. I am using ox-moderncv to build my CV.

```elisp
(use-package ox-moderncv
  :straight '(:host gitlab :repo "jhilker/org-cv"))
```


### Hydra {#hydra}

This hydra is a wrapper around some of the functions I most commonly use.

```elisp
(add-hook 'org-mode-hook (lambda ()
			   (setq jh/hydra-title (with-fileicon "org" "Org-mode" 1 -0.05))))

(major-mode-hydra-define org-mode (:title jh/hydra-title)
  ("Agenda"
   (("aa" org-agenda "Agenda Dispatch"))
   "Dates"
   (("dd" org-deadline "Set Deadline")
    ("ds" org-schedule "Set Scheduled Date")
    ("dt" org-time-stamp "Set Time Stamp"))))
```


## General IDE Configuration {#general-ide-configuration}


### General Configuration {#general-configuration}

I want to highlight todo keywords in all my programming files.

```elisp
(defun jh/ide-init ()
  "Initializes Emacs for when I am programming."
  (interactive)
  (global-hl-todo-mode 1)
  (display-line-numbers-mode 1)
  (setq display-line-numbers 'relative))
(add-hook 'prog-mode-hook 'jh/ide-init)
```


### Packages {#packages}


#### LSP Mode {#lsp-mode}

LSP Mode lets me get completion for functions and such in code. From the emacs-for-scratch youtube series.

<!--list-separator-->

-  Setup

    ```elisp
    (defun jh/lsp-setup ()
      (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
      (lsp-headerline-breadcrumb-mode))
    ```

<!--list-separator-->

-  Package Setup

    ```elisp
    (use-package lsp-mode
      :commands (lsp lsp-deferred)
      :hook ((prog-mode . lsp-mode))
      :init
      (setq lsp-keymap-prefix "C-c l")
      :config
      (lsp-enable-which-key-integration t))
    ```

<!--list-separator-->

-  Additional Packages

    ```elisp
    (use-package lsp-treemacs
      :after lsp)
    ```


#### Projectile {#projectile}

Projectile is a tool for managing projects inside of emacs.

```elisp
(use-package projectile
  :config
  (projectile-mode))
```


#### Magit {#magit}

Magit is an incredible git client for emacs.

```elisp
(use-package magit)

(use-package magit-todos
  :after magit)

(use-package forge
  :after magit)
```


#### Smartparens {#smartparens}

Smartparens inserts a matching delimiter if I insert 1 (like a second parenthesis if I insert a left one).

```elisp
(use-package smartparens
  :init
  (smartparens-global-mode))
```


#### Rainbow Delimiters {#rainbow-delimiters}

Rainbow Delimiters makes it so that parenthesis and other characters have their own colors - making it easier to follow the parenthesis, especially in something like lisp where there are so many parenthesis.

```elisp
(use-package rainbow-delimiters
  :hook ((prog-mode) . rainbow-delimiters-mode))
```


### Language Configuration {#language-configuration}


#### BibTex/LaTeX {#bibtex-latex}

This is for working with my bibliography.

<!--list-separator-->

-  Company Backends

    ```elisp
    (use-package company-bibtex
      :config
      (add-to-list 'company-backends '(company-bibtex)))
    ```


#### Python {#python}

Python is my primary language of choice.

```elisp
(use-package python
  :straight nil
  :ensure nil)
```

<!--list-separator-->

-  LSP

    ```elisp
    (use-package lsp-pyright
      :ensure t
      :hook (python-mode . (lambda ()
    			  (require 'lsp-pyright)
    			  (lsp))))  ; or lsp-deferred

    ```


#### Web Development (HTML, CSS, JavaScript) {#web-development--html-css-javascript}

<!--list-separator-->

-  Company Backends

    ```elisp

    ```

<!--list-separator-->

-  Emmet

    Emmet is a package (built-in to VSCode) that makes editing html so much easier.

    ```elisp
    (use-package emmet-mode
      :hook ((sgml-mode css-mode mhtml-mode)))
    ```

<!--list-separator-->

-  Tailwind LSP

    ```elisp
    (use-package lsp-tailwindcss
      :init
      (setq lsp-tailwindcss-add-on-mode t))
    ```

<!--list-separator-->

-  Lorem Ipsum

    The classic text, now in emacs.

    ```elisp
    (use-package lorem-ipsum)
    ```

<!--list-separator-->

-  Simple HTTPD

    This lets me build a basic webserver to test my files.

    ```elisp
    (use-package simple-httpd)
    ```


#### Yaml {#yaml}

```elisp
(use-package yaml-mode)
```


## Applications {#applications}


### Chat (ERC) {#chat--erc}

ERC is an IRC client built into emacs.

```elisp
(use-package erc
  :ensure nil
  :straight nil)
```


#### Wrapper for Client {#wrapper-for-client}

Since I mostly use `emacsclient` for my work, I want to be able to quickly connect to my bitlbee server and launch that way.


### File Manager (Ranger Dired) {#file-manager--ranger-dired}

I normally use ranger as my terminal file manager, but now I'd like to use ranger in dired.

```elisp
(use-package dired-ranger)
```


### RSS Reader (Elfeed) {#rss-reader--elfeed}

Elfeed is an excellent rss reader.

```elisp
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
```


#### Elfeed Org {#elfeed-org}

```elisp
(use-package elfeed-org
  :after elfeed
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files '("~/Dropbox/org/elfeed.org")))
```


#### Elfeed Goodies {#elfeed-goodies}


#### Hydra {#hydra}

```elisp
(pretty-hydra-define jh/elfeed-search-hydra (:title (with-faicon "newspaper-o" "Elfeed Filters") :quit-key "q" :color teal)
  ("Category"
   (("d" (elfeed-search-set-filter "@1-week-ago +unread") "Default")
    ("n" (elfeed-search-set-filter "@1-week-ago +unread +news") "News")
    ("c" (elfeed-search-set-filter "@1-week-ago +unread +campaign") "Campaigns")
    ("f" (elfeed-search-set-filter "@1-week-ago +unread +forum") "Forums")
    ("p" (elfeed-search-set-filter "+podcast") "Podcasts")
    ("r" (elfeed-search-set-filter "@1-week-ago +unread +reddit") "Reddit")
    ("b" (elfeed-search-set-filter "@1-week-ago +unread +blog") "Blogs"))))

```


### Email Client (Mu4e) {#email-client--mu4e}

```elisp
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

```


## UI Packages {#ui-packages}


### Dashboard {#dashboard}

```elisp
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
```


### Modeline {#modeline}

Doom modeline allows me to have a cleaner modeline.

```elisp
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
```


#### <span class="org-todo todo TODO">TODO</span> Custom Modeline {#custom-modeline}

```elisp

```


### Tabs {#tabs}

I really like centaur-tabs for my config.

```elisp
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
```


## Functions {#functions}

This section contains functions I have created that don't really fit in any other section.


### File Functions {#file-functions}


#### Edit Dotfile {#edit-dotfile}

This function lets me load my config so that I can edit it.

```elisp
(defun edit-dotfile ()
  "Loads the Jmacs config file to be edited."
  (interactive)
  (find-file (expand-file-name "jmacs.org" user-emacs-directory)))
```


#### Edit Inbox {#edit-inbox}

This function quickly lets me edit my inbox.

```elisp
(defun edit-inbox ()
  "Loads the inbox to be reviewed."
  (interactive)
  (find-file "~/Dropbox/org/inbox.org")
  (find-file "~/Dropbox/org/orgzly.org"))

```


### Config Functions {#config-functions}


#### Reload Jmacs {#reload-jmacs}

```elisp
(defun reload-jmacs ()
  "Reloads the config."
  (interactive)
  (org-babel-load-file (expand-file-name "jmacs.org" user-emacs-directory)))
```


### Startup Functions {#startup-functions}


#### Display Battery {#display-battery}


#### Languages {#languages}

<!--list-separator-->

-  Org-mode

    ```elisp

    ```


## Keybindings {#keybindings}

This section serves to describe the keybindings of Jmacs.


### Leader Keys {#leader-keys}

Since I am using evil-mode, and I don’t want to repeat my keybindings, I’m defining my prefix here.

```elisp
(general-create-definer jh/evil-leader
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "C-SPC")

(general-create-definer jh/evil-local-leader
  :states '(normal visual insert emacs)
  :prefix ","
  :non-normal-prefix "C-,")
```


### General Keybindings {#general-keybindings}

These are the core keybindings for functionality in jmacs. In addition, I want to use `SPC h F` for describing a face.

```elisp

(jh/evil-leader
  "SPC" '(execute-extended-command :which-key "Run Command")
  "c"   (general-simulate-key "C-c" :which-key "Run `C-c`")
  "h"   (general-simulate-key "C-h" :which-key "Help")
  "u"   (general-simulate-key "C-u" :which-key "Run `C-u`")
  "x"   (general-simulate-key "C-x" :which-key "Run `C-x`"))
```


### Application Keybindings {#application-keybindings}


### Buffer Keybindings {#buffer-keybindings}

These keybindings are for switching buffers.

```elisp
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
```


### File Keybindings {#file-keybindings}

These are my keybindings for files.

```elisp
(jh/evil-leader
  "f" '(:ignore t :which-key "Files")
  "fe" '(:ignore t :which-key "Edit File")
  "fed" '(edit-dotfile :which-key "Edit config")
  "fei" '(edit-inbox :which-key "Edit inbox")
  "fer" '(reload-jmacs :which-key "Reload Jmacs")
  "ff" '(find-file :which-key "Find file")
  "fs" '(save-buffer :which-key "Save file")
  "fl" '(load-file :which-key "Load file"))
```


### Git Keybindings {#git-keybindings}

```elisp
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
```


### Help Bindings {#help-bindings}

```elisp
(global-set-key (kbd "C-h F") 'describe-face)
(global-set-key (kbd "C-h f") 'describe-function)

```


### Insert Keybindings {#insert-keybindings}

```elisp
(jh/evil-leader
  "i" '(:ignore t :which-key "Insert special character")
  "ic" '(insert-char :which-key "Insert character")
  "ii" '(all-the-icons-insert :which-key "Insert icon")
  "ie" '(emojify-insert-emoji :which-key "Insert emoji")
  "is" '(yas-insert-snippet :which-key "Insert snippet"))
```


### Org-Mode Bindings {#org-mode-bindings}

These are my general org-mode bindings.

```elisp
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
```


### Project Keybindings {#project-keybindings}

```elisp
(jh/evil-leader
"p" '(:ignore t :which-key "Project")
"pc" '(projectile-invalidate-cache :which-key "Clear project cache")
"pp" '(projectile-switch-project :which-key "Switch project"))
```


### Reload Bindings {#reload-bindings}

```elisp
(jh/evil-leader
  "r" '(:ignore t :which-key "Reload")
  "rr" '(reload-jmacs :which-key "Reload Jmacs"))
```


### Search Keybindings {#search-keybindings}

These Keybindings are for searching through various things.

```elisp

```


### Toggle Keybindings {#toggle-keybindings}

```elisp
(jh/evil-leader
  "t" '(:ignore t :which-key "Toggle")
  ;"te" '(global-emojify-mode :which-key "Toggle emoji")
  "ts" '(treemacs :which-key "Toggle Treemacs")
  "to" '(imenu-list :which-key "Toggle Outline")
  "tz" '(writeroom-mode :which-key "Toggle Zen"))
```


### Window Keybindings {#window-keybindings}

```elisp
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
```


### Quit Keybindings {#quit-keybindings}

```elisp
(jh/evil-leader
  "q"  '(:ignore t :which-key "Quit")
  "qf" '(delete-frame :which-key "Kill Frame")
  "qq" '(kill-emacs :which-key "Quit emacs")
  "qr" '(restart-emacs :which-key "Restart emacs"))
```


### Zoom In and Out {#zoom-in-and-out}

You can use Control plus = and Control plus - to zoom in and out like everywhere else.

```elisp
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
```


## Load Custom File {#load-custom-file}

```elisp
(when (file-exists-p custom-file)
  (load custom-file))
```