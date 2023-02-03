;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!

;; Inherit shell variables when invoked from Finder on a mac
(after! exec-path-from-shell
  (when (memq window-system '(mac ns))
    (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE" "NIX_SSL_CERT_FILE" "NIX_PATH"))
      (add-to-list 'exec-path-from-shell-copy-env var))
    (exec-path-from-shell-initialize)))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Tristan Gosselin-Hane"
      user-mail-address "starcraft66@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "MesloLGS Nerd Font Mono"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'base16-materia)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq
 projectile-project-search-path '("~/src")
 )

(dimmer-configure-magit)
(dimmer-configure-org)
(dimmer-mode t)

;; Move stuff with C-S-hjkl
(map! :ne "C-S-j" #'drag-stuff-left)
(map! :ne "C-S-k" #'drag-stuff-down)
(map! :ne "C-S-l" #'drag-stuff-up)
(map! :ne "C-S-;" #'drag-stuff-right)

(map! :ne "SPC =" #'indent-buffer)
(map! :ne "SPC #" #'comment-or-uncomment-region)

;; unbind ; and ,
(setq evil-snipe-override-evil-repeat-keys nil)
;; Remap hjkl jkl;
(map! :nvm "j" 'evil-backward-char)
(map! :nvm "k" 'evil-next-line)
(map! :nvm "l" 'evil-previous-line)
(map! :nvm ";" 'evil-forward-char)
;; https://github.com/emacs-evil/evil-collection#key-translation
;; doom uses evil-collection with (evil +everywhere)
;; called after evil-collection makes its keybindings
(setq translation-keys '(
      "j" "h"
      "k" "j"
      "l" "k"
      ";" "l"
      (kbd "C-j") (kbd "C-h")
      (kbd "C-k") (kbd "C-j")
      (kbd "C-l") (kbd "C-k")
      (kbd "C-;") (kbd "C-l")))

(after! (evil magit)
     ;; Delete old j (jump) bind that interferes
     (map! :map magit-mode-map
           "h" 'magit-log
           "j" nil)
     (+layout-homerow-rotate-keymaps
     '(magit-cherry-mode-map
       magit-blob-mode-map
       magit-diff-mode-map
       magit-log-mode-map
       magit-log-select-mode-map
       magit-reflog-mode-map
       magit-status-mode-map
       magit-log-read-revs-map
       magit-process-mode-map
       magit-refs-mode-map
       magit-mode-map)))

  (after! (:or helm ivy vertico icomplete)
    (+layout-homerow-rotate-keymaps
     '(minibuffer-local-map
       minibuffer-local-ns-map
       minibuffer-local-completion-map
       minibuffer-local-must-match-map
       minibuffer-local-isearch-map
       read-expression-map)))
  (after! ivy
    (+layout-homerow-rotate-keymaps '(ivy-minibuffer-map ivy-switch-buffer-map)))

(defun +layout-homerow-rotate-keymaps (keymaps)
    (evil-collection-translate-key '(normal motion visual operator nil) keymaps
      ";" "L"
      ";" "l"
      "L" "K"
      "l" "k"
      "K" "J"
      "k" "j"
      "J" "H"
      "j" "h"
      (kbd "C-;") (kbd "C-L")
      (kbd "C-;") (kbd "C-l")
      (kbd "C-L") (kbd "C-K")
      (kbd "C-l") (kbd "C-k")
      (kbd "C-K") (kbd "C-J")
      (kbd "C-k") (kbd "C-j")
      (kbd "C-J") (kbd "C-H")
      (kbd "C-j") (kbd "C-h")
      (kbd "M-;") (kbd "M-L")
      (kbd "M-;") (kbd "M-l")
      (kbd "M-L") (kbd "M-K")
      (kbd "M-l") (kbd "M-k")
      (kbd "M-K") (kbd "M-J")
      (kbd "M-k") (kbd "M-j")
      (kbd "M-J") (kbd "M-H")
      (kbd "M-j") (kbd "M-h"))
    (evil-collection-translate-key '(insert) keymaps
      (kbd "M-;") (kbd "M-L")
      (kbd "M-;") (kbd "M-l")
      (kbd "M-L") (kbd "M-K")
      (kbd "M-l") (kbd "M-k")
      (kbd "M-K") (kbd "M-J")
      (kbd "M-k") (kbd "M-j")
      (kbd "M-J") (kbd "M-H")
      (kbd "M-j") (kbd "M-h")))
