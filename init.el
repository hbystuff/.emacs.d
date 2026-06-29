;;===========================================
;; Basic stuff. These should not depend on any thing; even if
;; packages fail to load, they shouldn't fail.

;; Perf stuff
(setq gc-cons-threshold 100000000)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold 800000)))
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Looks and feels
(load-theme 'modus-vivendi t)
(set-frame-font "Consolas 12" nil t)

;; Disable backup and auto-save files completely
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;; Line number mode
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type t)
(setq-default indent-tabs-mode nil)  ; Use spaces instead of tabs

;; Put the config stuff somewhere else
(setq custom-file (concat user-emacs-directory "custom-vars.el"))
(load custom-file 'noerror)

;; Bind it to a Vim-like combo (Space-f) in Normal Mode
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "SPC f") 'find-file))

;;===========================================
;; Package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install packages
(unless (package-installed-p 'evil) (package-install 'evil))
(unless (package-installed-p 'vertico) (package-install 'vertico))
(unless (package-installed-p 'orderless) (package-install 'orderless))

;;===========================================
;; Evil mode setup
;; Set up Vim-like behaviors before loading
(setq evil-want-integration t)
(setq evil-want-keybinding nil) ; Set to nil if you ever want evil-collection later
(setq evil-vsplit-window-right t)
(setq evil-split-window-below t)
(setq evil-want-C-u-scroll t)
(setq evil-undo-system 'undo-redo)

;;===========================================
;; File goto
(require 'vertico)
(vertico-mode 1)
(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-p") 'project-find-file))

(require 'evil)
(evil-mode 1)

(with-eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "=") 'evil-window-increase-width)
  (define-key evil-normal-state-map (kbd "-") 'evil-window-decrease-width)
  (define-key evil-normal-state-map (kbd "M-=") 'evil-window-increase-height)
  (define-key evil-normal-state-map (kbd "M--") 'evil-window-decrease-height))
