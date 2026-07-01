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
(setq auto-revert-use-notify t)         ; Use OS-level file notifications for instant reloads
(setq global-auto-revert-non-file-buffers t) ; Automatically refresh Dired and other utility buffers
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; Looks and feels
(load-theme 'modus-vivendi t)
(set-frame-font "Consolas 12" nil t)
(setq ring-bell-function 'ignore)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq scroll-margin 0) ; Set to 1 or 2 if you want the bump to trigger before the absolute edge
(setq-default case-fold-search nil)
(setq evil-ex-search-case 'sensitive)

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

;; Custom commaands
(defun open-config-file ()
  "Quickly open the main Emacs initialization file."
  (interactive)
  (find-file user-init-file))
(defun reload-config-file ()
  "Reload the main Emacs initialization file on the fly."
  (interactive)
  (load-file user-init-file)
  (message "Configuration reloaded successfully!"))
(defalias 'conf 'open-config-file)
(defalias 'reload-conf 'reload-config-file)

;; hlsl-mode
(let ((hlsl-mode-path (expand-file-name "libs/hlsl-mode.el" user-emacs-directory)))
  (when (file-exists-p hlsl-mode-path)
    (load hlsl-mode-path t)
    ;; Map HLSL file extensions to the newly loaded mode
    (add-to-list 'auto-mode-alist '("\\.hlsl\\'" . hlsl-mode))
    (add-to-list 'auto-mode-alist '("\\.hlsli\\'" . hlsl-mode))))

; llvm-mode
(let ((llvm-mode-src (expand-file-name "libs/llvm-mode.el" user-emacs-directory)))
  (load llvm-mode-src t))

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
(unless (package-installed-p 'glsl-mode) (package-install 'glsl-mode)) 

;;===========================================
;; Evil mode setup
;; Set up Vim-like behaviors before loading
(setq evil-shift-width 2)
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

;; '_' should be part of my search
(with-eval-after-load 'evil
  (defun my-evil-underscore-syntax ()
    (modify-syntax-entry ?_ "w"))
  ;; Apply globally to the default state and common coding hooks
  (modify-syntax-entry ?_ "w")
  (add-hook 'c-mode-common-hook #'my-evil-underscore-syntax)
  (add-hook 'c++-mode-hook #'my-evil-underscore-syntax)

  (defun my-llvm-identifier-syntax ()
      (modify-syntax-entry ?% "w")
      (modify-syntax-entry ?. "w"))
  (add-hook 'llvm-mode-hook #'my-llvm-identifier-syntax)

  (defun my-elisp-hyphen-syntax ()
      (modify-syntax-entry ?- "w"))
  (add-hook 'emacs-lisp-mode-hook #'my-elisp-hyphen-syntax)
)

(defun my-copy-file-path ()
  "Copy the current buffer's full file path to the system clipboard using Windows backslashes."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (let ((path filename))
          (when (string-match "^/\\([a-zA-Z]\\)/" path)
            (setq path (replace-match "\\1:/" t nil path)))
          (setq path (replace-regexp-in-string "/" "\\\\" path))
          (kill-new path)
          (message "Copied: %s" path))
      (message "Buffer is not visiting a file!"))))

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "f p") 'my-copy-file-path))

(with-eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "=") 'evil-window-increase-width)
  (define-key evil-normal-state-map (kbd "-") 'evil-window-decrease-width)
  (define-key evil-normal-state-map (kbd "M-=") 'evil-window-increase-height)
  (define-key evil-normal-state-map (kbd "M--") 'evil-window-decrease-height))


;;===============================================================
;; Manual simple Auto-complete
(unless (package-installed-p 'corfu) (package-install 'corfu))
(unless (package-installed-p 'cape) (package-install 'cape))

(require 'corfu)
(global-corfu-mode 1)

;; Setup Corfu behaviors
(setq corfu-auto nil)
(setq corfu-quit-no-match 'separator)
(setq corfu-preview-current nil)    ; Stops auto-inserting text while cycling

;; Explicitly map navigation directly into corfu-map so it works instantly
(define-key corfu-map (kbd "C-j") 'corfu-next)
(define-key corfu-map (kbd "C-k") 'corfu-previous)
(define-key corfu-map (kbd "C-n") 'corfu-next)
(define-key corfu-map (kbd "C-p") 'corfu-previous)

;; Configure dabbrev scanner
(require 'dabbrev)
(setq dabbrev--abbrev-char-regexp "\\sw\\|\\s_")
(setq dabbrev-case-fold-search t)
(setq dabbrev-case-replace nil)
(setq dabbrev-check-other-buffers t)

;; Set up Cape for robust scanning
(require 'cape)
(defun my-setup-buffer-completion ()
  (setq-local completion-at-point-functions '(cape-dabbrev)))

(add-hook 'prog-mode-hook #'my-setup-buffer-completion)
(add-hook 'text-mode-hook #'my-setup-buffer-completion)

;; Setup bindings and handle Evil conflicts
(with-eval-after-load 'evil
  ;; Bind C-n to trigger the popup menu inside Insert Mode
  (define-key evil-insert-state-map (kbd "C-n") 'completion-at-point)
  
  ;; Unbind Evil's defaults so they drop down to corfu-map when the popup is open
  (define-key evil-insert-state-map (kbd "C-j") nil)
  (define-key evil-insert-state-map (kbd "C-k") nil))
