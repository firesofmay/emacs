;;; init.el - Baishampayan Ghose -*- lexical-binding: t; -*-

;;; Code:
(setq root-dir (file-name-directory
                (or (buffer-file-name) load-file-name)))

(setq etc-dir (file-name-as-directory (concat root-dir "etc")))

(make-directory etc-dir t)


;; ---------
;; Clean GUI
;; ---------
(mapc
 (lambda (mode)
   (when (fboundp mode)
     (funcall mode -1)))
 '(menu-bar-mode tool-bar-mode scroll-bar-mode))

;; -----------
;; Basic Setup
;; -----------

(setq user-full-name "Mayank Jain")
(setq user-mail-address "mayank@helpshift.com")

(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'pallet)
(pallet-mode t)
(require 'f)
(require 'use-package)

(setq default-directory (f-full (getenv "HOME")))

(defun load-local (file)
  (load (f-expand file user-emacs-directory)))


(load-local "defuns")
(load-local "misc")
(when (eq system-type 'darwin)
  (load-local "osx"))

;; --------
;; Packages
;; --------

(use-package badger-theme
  :ensure t
  :config (load-theme 'badger :no-confirm))


(use-package auto-compile
  :defer t
  :config (progn
            (auto-compile-on-load-mode 1)
            (auto-compile-on-save-mode -1)
            (setq load-prefer-newer t)
            (setq auto-compile-display-buffer nil)
            (setq auto-compile-mode-line-counter t)))


(use-package misc
  :demand t
  :bind ("M-z" . zap-up-to-char))


(use-package defuns
  :demand t)


(use-package whitespace
  :defer t
  :diminish global-whitespace-mode
  :init (global-whitespace-mode)
  :config (progn
            (setq whitespace-style
                  '(face trailing tabs indentation::space))
            ;; (setq whitespace-line-column 78)
            (setq whitespace-global-modes '(not git-commit-mode))))


(use-package ansi-color
  :init (ansi-color-for-comint-mode-on))


(use-package hl-line
  ;; turn it always on
  :init (global-hl-line-mode 1)
  ;; To pick color do M-x list-colors-display
  :config (set-face-background 'hl-line "gray14"))


(use-package dash
  :config (dash-enable-font-lock))


(use-package dired-x
  :defer t)


(use-package ido
  :defer t
  :init (progn (ido-mode 1)
               (ido-everywhere 1)
               ;; Go straight to home by pressing "~"
               ;; and .emacs.d by pressing "~" twice
               ;; Ref: http://whattheemacsd.com/setup-ido.el-02.html
               (add-hook 'ido-setup-hook (lambda ()
                                           (define-key ido-file-completion-map
                                             (kbd "~")
                                             (lambda ()
                                               (interactive)
                                               (if (looking-back "~/")
                                                   (insert ".emacs.d/")
                                                 (if (looking-back "/")
                                                     (insert "~/")
                                                   (call-interactively 'self-insert-command))))))))
  :config
  (progn
    (setq ido-case-fold t)
    (setq ido-everywhere t)
    (setq ido-enable-prefix nil)
    (setq ido-enable-flex-matching t)
    (setq ido-create-new-buffer 'always)
    (setq ido-max-prospects 10)
    (setq ido-use-faces nil)
    (add-to-list 'ido-ignore-files "\\.DS_Store")))


(use-package company
  :defer t
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode))


(use-package emacs-lisp-mode
  :defer t
  :init
  (progn
    (use-package eldoc
      :diminish eldoc-mode
      :init (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)))
  :bind (("M-." . find-function-at-point))
  :interpreter (("emacs" . emacs-lisp-mode))
  :mode ("Cask" . emacs-lisp-mode))


(use-package markdown-mode
  :defer t
  :config
  (progn
    (bind-key "M-n" 'open-line-below markdown-mode-map)
    (bind-key "M-p" 'open-line-above markdown-mode-map))
  :mode (("\\.markdown$" . markdown-mode)
         ("\\.md$" . markdown-mode)))


(use-package flx-ido
  :defer t
  :init (flx-ido-mode 1))


(use-package flycheck
  :defer t
  :diminish flycheck-mode
  :config
  (progn
    (setq flycheck-display-errors-function nil)
    (add-hook 'after-init-hook 'global-flycheck-mode)))


(use-package discover
  :defer t
  :init (global-discover-mode 1))


(use-package ibuffer
  :defer t
  :config (setq ibuffer-expert t)
  :bind ("C-x C-b" . ibuffer))


(use-package cl-lib-highlight
  :defer t
  :init (cl-lib-highlight-initialize))


(use-package idomenu
  :defer t
  :bind ("M-i" . idomenu))


(use-package httprepl
  :defer t)


(use-package swoop
  :defer t
  :config (setq swoop-window-split-direction: 'split-window-vertically)
  :bind (("C-o" . swoop)
         ("C-M-o" . swoop-multi)
         ("C-x M-o" . swoop-pcre-regexp)))


(use-package git-gutter
  :defer t
  :diminish git-gutter-mode
  :init (global-git-gutter-mode +1)
  :bind (("C-x q" . git-gutter:revert-hunk)
         ("C-x x" . git-gutter:popup-diff)
         ("C-c C-s" . git-gutter:stage-hunk)
         ("C-x p" . git-gutter:previous-hunk)
         ("C-x n" . git-gutter:next-hunk)))


;;; Install: godef and gocode first

(use-package ibuffer-vc
  :defer t
  :init (ibuffer-vc-set-filter-groups-by-vc-root))


(use-package rainbow-delimiters
  :defer t
  :config (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))


(use-package rainbow-identifiers
  :defer t
  :config (add-hook 'prog-mode-hook 'rainbow-identifiers-mode))


(use-package yaml-mode
  :defer t
  :mode ("\\.yml$" . yaml-mode))


(use-package yasnippet
  :defer t
  :if (not noninteractive)
  :diminish yas-minor-mode
  :commands (yas-global-mode yas-minor-mode)
  :init
  (progn
    (yas-global-mode 1)
    (setq yas-verbosity 1)
    (setq-default yas/prompt-functions '(yas/ido-prompt))))


(use-package cc-mode
  :defer t
  :config
  (progn
    (add-hook 'c-mode-hook (lambda () (c-set-style "linux")))
    (add-hook 'java-mode-hook (lambda () (c-set-style "linux")))
    (setq tab-width 4)
    (setq c-basic-offset 4)))


(use-package css-mode
  :defer t
  :config (setq css-indent-offset 2))


(use-package js-mode
  :defer t
  :mode ("\\.json$" . js-mode)
  :init
  (progn
    (add-hook 'js-mode-hook (lambda () (setq js-indent-level 2)))))


(use-package js2-mode
  :defer t
  :mode (("\\.js$" . js2-mode)
         ("Jakefile$" . js2-mode))
  :interpreter ("node" . js2-mode)
  :bind (("C-a" . back-to-indentation-or-beginning-of-line)
         ("C-M-h" . backward-kill-word))
  :config
  (progn
    (add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))
    (add-hook 'js2-mode-hook (lambda ()
                               (bind-key "M-j" 'join-line-or-lines-in-region js2-mode-map)))))


(use-package ido-ubiquitous
  :defer t
  :init (ido-ubiquitous-mode 1))


(use-package nyan-mode
  :defer t
  :init (nyan-mode 1))


(use-package smex
  :defer t
  :init (smex-initialize)
  :bind (("M-x" . smex)
         ("C-x M-m" . smex)
         ("C-x C-m" . smex)
         ("M-X" . smex)
         ("C-c C-c M-x" . execute-extended-command)))


(use-package multiple-cursors
  :defer t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)))


(use-package popwin
  :defer t
  :config (popwin-mode 1))


(use-package projectile
  :defer t
  :diminish projectile-mode
  :init (projectile-global-mode 1)
  :config
  (progn
    (setq projectile-enable-caching t)
    (setq projectile-require-project-root nil)
    (setq projectile-completion-system 'ido)
    (add-to-list 'projectile-globally-ignored-files ".DS_Store")))


(use-package magit
  :defer t
  :init (use-package magit-blame :defer t)
  :config
  (progn
    (setq magit-default-tracking-name-function 'magit-default-tracking-name-branch-only)
    (setq magit-set-upstream-on-push t)
    (setq magit-completing-read-function 'magit-ido-completing-read)
    (setq magit-stage-all-confirm nil)
    (setq magit-unstage-all-confirm nil)
    (setq magit-restore-window-configuration t)
    (setq magit-last-seen-setup-instructions "1.4.0"))
  :bind (("C-x g" . magit-status)
         ("C-c C-a" . magit-just-amend)))


(use-package ace-jump-mode
  :defer t
  :bind ("C-c SPC" . ace-jump-mode))


(use-package expand-region
  :defer t
  :bind ("C-=" . er/expand-region))


(use-package cua-base
  :init (cua-mode 1)
  :config
  (progn
    (setq cua-enable-cua-keys nil)
    (setq cua-toggle-set-mark nil)))


(use-package uniquify
  :config (progn
            (setq uniquify-buffer-name-style 'reverse)
            (setq uniquify-separator "/")
            (setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
            (setq uniquify-ignore-buffers-re "^\\*")))


(use-package saveplace
  :config (setq-default save-place t))


(use-package diff-hl
  :defer t
  :init (progn
          (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
          (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode))
  :config (add-hook 'vc-checkin-hook 'diff-hl-update))

;; https://github.com/clojure-emacs/cider#repl-configuration
(defun cider-repl-prompt-on-newline (namespace)
  "Return a prompt string with newline"
  (concat namespace ">\n"))

(use-package cider
  :defer t
  :config (progn
            (use-package clojure-snippets :defer t)
            (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
            (setq nrepl-hide-special-buffers t)
            (setq cider-prefer-local-resources t)
            (setq cider-show-error-buffer 'only-in-repl)
            (setq cider-stacktrace-default-filters '(tooling dup))
            (setq cider-stacktrace-fill-column 80)
            (setq nrepl-buffer-name-show-port t)
            (setq cider-repl-display-in-current-window t)
            (setq cider-repl-use-pretty-printing t)
            (setq cider-repl-prompt-function 'cider-repl-prompt-on-newline)
            (setq cider-prompt-save-file-on-load nil)
            (setq cider-interactive-eval-result-prefix ";; => ")
            (setq cider-repl-history-size 1000)
            (setq cider-repl-history-file (concat etc-dir "cider-history.dat"))
            (setq cider-prompt-for-symbol nil)
            (add-hook 'cider-repl-mode-hook 'company-mode)
            (add-hook 'cider-mode-hook 'company-mode)
            (add-hook 'cider-repl-mode-hook 'paredit-mode)
            (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode))
  :bind (("C-l" . cider-repl-clear-buffer)
         ("C-c M-c" . cider-connect)))


(use-package eshell
  :defer t
  :bind ("M-e" . eshell)
  :init
  (add-hook 'eshell-first-time-mode-hook
            (lambda ()
              (add-to-list 'eshell-visual-commands "htop")))
  :config
  (progn
    (setq eshell-history-size 5000)
    (setq eshell-save-history-on-exit t)))


(use-package smart-mode-line
  :config (progn
            (setq sml/theme 'automatic)
            (sml/setup))
  :init
  (progn
    (setq-default
     mode-line-format
     '("%e"
       mode-line-front-space
       mode-line-mule-info
       mode-line-client
       mode-line-modified
       mode-line-remote
       mode-line-frame-identification
       mode-line-buffer-identification
       "   "
       mode-line-position
       (vc-mode vc-mode)
       "  "
       mode-line-modes
       mode-line-misc-info
       mode-line-end-spaces))))


(use-package paredit
  :defer t
  :diminish paredit-mode
  :init
  (progn
    (add-hook 'clojure-mode-hook 'enable-paredit-mode)
    (add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
    (add-hook 'lisp-mode-hook 'enable-paredit-mode)
    (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
    (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
    (add-hook 'ielm-mode-hook 'enable-paredit-mode)
    (add-hook 'json-mode-hook 'enable-paredit-mode))
  :config
  (progn
    (use-package clojure-mode)
    (bind-keys :map clojure-mode-map
               ("M-[" . paredit-wrap-square)
               ("M-{" . paredit-wrap-curly)))
  :bind (("M-)" . paredit-forward-slurp-sexp)
         ("M-(" . paredit-wrap-round)
         ("M-[". paredit-wrap-square)
         ("M-{" . paredit-wrap-curly)))


(use-package clj-refactor
  :defer t
  :ensure t
  :init (progn (add-hook 'clojure-mode-hook
                         (lambda ()
                           (clj-refactor-mode 1)
                           (cljr-add-keybindings-with-prefix "C-c C-m")))))


(use-package paxedit
  :defer t
  :diminish paxedit-mode
  :init
  (progn
    (add-hook 'clojure-mode-hook 'paxedit-mode)
    (add-hook 'elisp-mode-hook 'paxedit-mode))
  :bind (("M-<right>". paxedit-transpose-forward)
         ("M-<left>". paxedit-transpose-backward)
         ("M-<up>". paxedit-backward-up)
         ("M-<down>" . paxedit-backward-end)
         ("M-b" . paxedit-previous-symbol)
         ("M-f" . paxedit-next-symbol)
         ("C-%" . paxedit-copy)
         ("C-&" . paxedit-kill)
         ("C-*" . paxedit-delete)
         ("C-^" . paxedit-sexp-raise)
         ("M-u" . paxedit-symbol-change-case)
         ("C-@" . paxedit-symbol-copy)
         ("C-#" . paxedit-symbol-kill)))


(use-package fsharp-mode
  :defer t
  :mode "\\.fs[iylx]?$")

(use-package hi2
  :defer t)

(use-package haskell-mode
  :defer t
  :init (add-hook 'haskell-mode-hook 'turn-on-hi2)
  :config (progn
            (setq haskell-process-suggest-remove-import-lines t)
            (setq haskell-process-auto-import-loaded-modules t)
            (setq haskell-process-log t)
            (setq haskell-process-type 'cabal-repl)
            (bind-keys :map haskell-mode-map
                       ("C-c C-l" . haskell-process-load-or-reload)
                       ("C-c C-z" . haskell-interactive-switch)
                       ("C-c C-n C-t" . haskell-process-do-type)
                       ("C-c C-n C-i" . haskell-process-do-info)
                       ("C-c C-n C-c" . haskell-process-cabal-build)
                       ("C-c C-n c" . haskell-process-cabal)
                       ("SPC" . haskell-mode-contextual-space))))


(use-package window-number
  :config (progn
            (window-number-meta-mode 1)
            (window-number-mode 1)))


(use-package flyspell
  :defer t
  :diminish flyspell-mode
  :init (progn (add-hook 'text-mode-hook 'flyspell-mode)
               (add-hook 'prog-mode-hook 'flyspell-prog-mode)
               (use-package flyspell-lazy
                 :init (flyspell-lazy-mode 1)))
  :config (progn
            (setq flyspell-issue-message-flag nil)
            (setq ispell-dictionary "en_GB-ize")
            (when (executable-find "aspell")
              (setq ispell-program-name "aspell")
              (setq ispell-list-command "--list")
              (setq ispell-extra-args '("--sug-mode=ultra"
                                        "--lang=en_GB"
                                        "--run-together"
                                        "--run-together-limit=5"
                                        "--run-together-min=2")))))

;; --------
;; Bindings
;; --------

(bind-key "C-a" 'back-to-indentation-or-beginning-of-line)
(bind-key "C-7" 'comment-or-uncomment-current-line-or-region)
(bind-key "C-6" 'linum-mode)
(bind-key "C-v" 'scroll-up-five)
(bind-key "C-j" 'newline-and-indent)

(bind-key "M-g" 'goto-line)
(bind-key "M-n" 'open-line-below)
(bind-key "M-p" 'open-line-above)
(bind-key "M-+" 'text-scale-increase)
(bind-key "M-_" 'text-scale-decrease)
(bind-key "M-j" 'join-line-or-lines-in-region)
(bind-key "M-v" 'scroll-down-five)
(bind-key "M-k" 'kill-this-buffer)
(bind-key "M-o" 'other-window)
(bind-key "M-1" 'delete-other-windows)
(bind-key "M-2" 'split-window-below)
(bind-key "M-3" 'split-window-right)
(bind-key "M-0" 'delete-window)
(bind-key "M-}" 'next-buffer)
(bind-key "M-{" 'previous-buffer)
(bind-key "M-`" 'other-frame)
(bind-key "M-w" 'kill-region-or-thing-at-point)

(bind-key "C-c g" 'google)
(bind-key "C-c n" 'clean-up-buffer-or-region)
(bind-key "C-c s" 'swap-windows)
(bind-key "C-c r" 'rename-buffer-and-file)
(bind-key "C-c k" 'delete-buffer-and-file)

(bind-key "C-M-h" 'backward-kill-word)

(bind-key
 "C-x C-c"
 (lambda ()
   (interactive)
   (if (y-or-n-p "Quit Emacs? ")
       (save-buffers-kill-emacs))))

(bind-key
 "C-8"
 (lambda ()
   (interactive)
   (find-file user-init-file)))

;; http://www.emacswiki.org/emacs/ShowParenMode
;; Turn paren mode highlight mode on
(show-paren-mode 1)
(setq show-paren-delay 0)
(defadvice show-paren-function
    (after show-matching-paren-offscreen activate)
  "If the matching paren is offscreen, show the matching line in the
   echo area. Has no effect if the character before point is not of
   the syntax class ')'."
  (interactive)
  (let* ((cb (char-before (point)))
         (matching-text (and cb
                             (char-equal (char-syntax cb) ?\) )
                             (blink-matching-open))))
    (when matching-text (message matching-text))))

;; Since We want want show symbol highlight everywhere, make it a global mode
(define-globalized-minor-mode my-highlight-symbol-mode highlight-symbol-mode
  (lambda () (highlight-symbol-mode 1)))

(use-package highlight-symbol
  :defer t
  :diminish highlight-symbol-mode
  :init (my-highlight-symbol-mode 1)
  :config (progn
            (setq highlight-symbol-idle-delay 100))
  :bind (("<f5>" . highlight-symbol-next)))

;; https://github.com/Malabarba/beacon
;; http://endlessparentheses.com/beacon-never-lose-your-cursor-again.html
(use-package beacon
  :init (beacon-mode 1)
  :config (progn
            (setq beacon-color "#666600")))


;; Apropos can sort results by relevancy.
(setq apropos-sort-by-scores t)

;; It joins the following line onto this one.
(global-set-key (kbd "M-j")
                (lambda ()
                  (interactive)
                  (join-line -1)))

;; Move more quickly
(global-set-key (kbd "C-S-n")
                (lambda ()
                  (interactive)
                  (ignore-errors (next-line 5))))

(global-set-key (kbd "C-S-p")
                (lambda ()
                  (interactive)
                  (ignore-errors (previous-line 5))))

(global-set-key (kbd "C-S-f")
                (lambda ()
                  (interactive)
                  (ignore-errors (forward-char 5))))

(global-set-key (kbd "C-S-b")
                (lambda ()
                  (interactive)
                  (ignore-errors (backward-char 5))))

;; This snippet flips a two-window frame, so that left is right, or up is down.
(defun rotate-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))

                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))

                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; Press C-X C-r to rename the current buffer file
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)


(defun delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

;; C-x k to kill the buffer and
;; C-x C-k to kill the file.
(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)

;; Save point position between sessions in a file
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))


;; https://www.masteringemacs.org/article/fixing-mark-commands-transient-mark-mode
(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(global-set-key (kbd "C-`") 'push-mark-no-activate)

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
  This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))

(global-set-key (kbd "M-`") 'jump-to-mark)

(defun exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))

(define-key global-map [remap exchange-point-and-mark] 'exchange-point-and-mark-no-activate)

;; https://github.com/clojure-emacs/cider/issues/1479
;; Fix for "{" in clojure repl
(add-hook 'cider-repl-mode-hook
          '(lambda ()
             (define-key cider-repl-mode-map "{" #'paredit-open-curly)
             (define-key cider-repl-mode-map "}" #'paredit-close-curly)))


;; full screen magit-status
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

;; (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)
(eval-after-load 'magit '(define-key magit-status-mode-map (kbd "q") 'magit-quit-session))

