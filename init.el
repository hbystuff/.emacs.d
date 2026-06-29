;;===========================================
;; Basic stuff. These should not depend on any thing; even if
;; packages fail to load, they shouldn't fail.

;; Increase garbage collection threshold during startup; reset after
(setq gc-cons-threshold 100000000)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold 800000)))

(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

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

;;===========================================
;; Package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install mode
(unless (package-installed-p 'evil)
  (package-install 'evil))

;;===========================================
;; Evil mode setup
;; Set up Vim-like behaviors before loading
(setq evil-want-integration t)
(setq evil-want-keybinding nil) ; Set to nil if you ever want evil-collection later
(setq evil-vsplit-window-right t)
(setq evil-split-window-below t)
(setq evil-want-C-u-scroll t)
(setq evil-undo-system 'undo-redo)

(require 'evil)
(evil-mode 1)

(with-eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "=") 'evil-window-increase-width)
  (define-key evil-normal-state-map (kbd "-") 'evil-window-decrease-width)
  (define-key evil-normal-state-map (kbd "M-=") 'evil-window-increase-height)
  (define-key evil-normal-state-map (kbd "M--") 'evil-window-decrease-height))

;;============================================
;; Auto stuff.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
