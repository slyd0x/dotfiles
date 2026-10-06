;; personal configuration file

;;---------------------------------------------------------------
;; PACKAGE MANAGER
;;---------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives
	     '(("gnu" . "http://elpa.gnu.org/packages/")
	       ("nongnu" . "http://elpa.nongnu.org/nongnu/")
	       ("melpa" . "http://melpa.org/packages/")))
(setq url-connection-timeout 5)
(setq gnutls-trustfiles '("/etc/ssl/certs/ca-certificates.crt"))
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq read-process-output-max (* 1024 1024))
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

;;--------------------------------------------------------------
;; APPEARANCE
;;--------------------------------------------------------------
(global-display-line-numbers-mode)

;;--------------------------------------------------------------
;; WHICH KEY
;;--------------------------------------------------------------
(use-package which-key
  :ensure nil
  :config
  (which-key-mode 1))

(use-package compat
  :ensure t)

;;---------------------------------------------------------------
;; AUTOCOMPLETION
;;---------------------------------------------------------------
(use-package corfu
  :ensure t
  :after compat
  :custom
  (corfu-auto t)
  (corfu-auto-deley 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator) ;; keep corfu open for advanced orderless search
  ;;(corfu-preselect 'prompt)
   :init
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  (corfu-history-mode 1)
  :bind
  (:map corfu-map
	("TAB" . corfu-next)
	([tab] . corfu-next)
	("S-TAB" . corfu-previous)
	([backtab] . corfu-previous)
	("M-m" . corfu-move-to-minibuffer)))

(use-package cape
  :ensure t
  :after corfu
  :bind (("C-c p p" . completion-at-point)
	 ("C-c p d" . cape-dabbrev)
	 ("C-c p f" . cape-file)
	 ("C-c p k" . cape-keyword)
	 ("C-c p s" . cape-elisp-symbol))
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-nonexclusive))

(use-package emacs
  :ensure nil
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p))

(defun my/setup-programming-capfs ()
  (setq-local completion-at-point-functions
	      (list (cape-capf-super
		     #'eglot-completion-at-point
		     #'cape-dabbrev
		     #'cape-keyword))))
(add-hook 'prog-mode-hook #'my/setup-programming-capfs)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
	      ("C-c r r" . eglot-rename)
	      ("C-c r a" . eglot-code-actions)
	      ("C-c r f" . eglot-format-buffer))
  :custom
  (eglot-workspace-configuration
   '((:rust-analyzer . (:check (:command "clippy")))))
  :config
  (add-hook 'rust-ts-mode-hook
	    (lambda ()
	      (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
  (setq completion-category-defaults nil))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package treesit
  :ensure nil
  :config
  (setq treesit-language-source-alist
	'((rust "https://github.com/tree-sitter/tree-sitter-rust")))
  (unless (treesit-language-available-p 'rust)
    (treesit-language-grammar 'rust)))

(use-package rust-ts-mode
  :ensure nil
  :mode "\\.rs\\"
  :hook (rust-ts-mode . eglot-ensure))

(use-package cargo
  :ensure t
  :hook (rust-ts-mode . cargo-minor-mode))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-buffer-file-name-style 'relative-to-project))

(use-package whitespace
  :hook (prog-mode . whitespace-mode)
  :config
  (setq whitespace-style '(trailing empty indentation)) ; What to highlight
  (setq whitespace-global-modes '(prog-mode))) ; Enable in code

(add-hook 'before-save-hook 'delete-trailing-whitespace)
