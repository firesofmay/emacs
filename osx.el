;;; osx.el --- OSX related configuration -*- lexical-binding: t; -*-
(setq ns-use-srgb-colorspace t)

;; Switch the Cmd and Meta keys
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; Menu bar is not annoying in OSX
(menu-bar-mode 1)

;; Make the browser the OS X default
(setq browse-url-browser-function 'browse-url-default-macosx-browser)

;; In dired, move deletions to trash
(setq delete-by-moving-to-trash t)

;; Set font etc
(set-face-font 'default "fontset-standard")
(set-frame-font "-*-Source Code Pro-light-normal-normal-*-15-*-*-*-m-0-iso10646-1")

;; Emoji :-P
(set-fontset-font "fontset-standard"
                  (cons (decode-char 'ucs #x1F600)
                        (decode-char 'ucs #x1F64F))
                  "Symbola")

;; Greek
(set-fontset-font "fontset-standard"
                  (cons (decode-char 'ucs #x1F00)
                        (decode-char 'ucs #x1FFF))
                  "Gentium Plus")

(defun finder ()
  "Opens file directory in Finder."
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (shell-command
         (format "%s %s" (executable-find "open") (file-name-directory file)))
      (error "Buffer is not attached to any file."))))


;; Make cut and paste work with the OS X clipboard

(defun live-copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun live-paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'live-paste-to-osx)
(setq interprogram-paste-function 'live-copy-from-osx)


;; Work around a bug on OS X where system-name is a fully qualified
;; domain name
(setq system-name (car (split-string system-name "\\.")))

;;; frames
(add-hook 'after-init-hook 'toggle-frame-maximized)
(setq frame-title-format "%b")
(setq icon-title-format  "%b")

(global-unset-key (kbd "s-p")) ;; stupid binding
(global-unset-key (kbd "M-TAB"))

(use-package exec-path-from-shell
  :init (progn (exec-path-from-shell-initialize)
               (exec-path-from-shell-copy-env "GOPATH")))

;; Set alt as meta as well
(setq mac-option-modifier 'meta)

(provide 'osx)
;;; osx.el ends here

