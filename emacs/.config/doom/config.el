(setq doom-theme 'doom-gruvbox)

(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 15)
      doom-big-font (font-spec :family "Iosevka Nerd Font" :size 24))

(after! elfeed
  (elfeed-goodies/setup)
  (setq elfeed-search-filter "@1-week-ago +unread"
        elfeed-goodies/feed-source-column-width 30
        elfeed-goodies/tag-column-width 16
        rmh-elfeed-org-files '("~/Dropbox/org/elfeed.org")))
