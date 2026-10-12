;;; init.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(tool-bar-mode -1)
(menu-bar-mode 1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)

(cua-mode 1)

(defvar my/preferred-font "Inter"
  "Primary coding font family.")

(defvar my/preferred-font-size 140
  "Font size in 1/10pt (150 = 15pt). Change to 160 for 16pt, 140 for 14pt.")

(defvar my/preferred-variable-font "Inter"
  "Proportional font for prose and documentation.")

(defun my/apply-font-configuration ()
  "Apply global font settings across graphical frames."
  (when (display-graphic-p)
    (set-face-attribute 'default nil
		       :family my/preferred-font
		       :height my/preferred-font-size
		       :weight 'regular)
    (set-face-attribute 'fixed-pitch nil
			:family my/preferred-font
			:height 1.0)))

(my/apply-font-configuration)
(add-hook 'server-after-make-frame-hook #'my/apply-font-configuration)

(use-package nerd-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-lsp t)
  (doom-modeline-buffer-file-name-style 'truncate-with-project))

(use-package doom-themes
  :ensure t
  :init
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  :config
  (load-theme 'doom-nord :no-confirm)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))


(defun my/setup-fonts ()
  (interactive)
  (set-face-attribute 'default nil
		      :font "Inter"
		      :height 130
		      :weight 'regular)
  (set-face-attribute 'fixed-pitch nil
		      :font "Inter"
		      :height 1.0
		      :weight 'regular)
  (set-face-attribute 'variable-pitch nil
		      :font "Inter"
		      :height 1.0
		      :weight 'regular))
  (my/setup-fonts)
  (add-hook 'after-make-frame-functions
	    (lambda (frame)
	      (with-selected-frame frame
		(my/setup-fonts))))


(use-package modus-themes
  :ensure t
  :config
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs t
	modus-themes-mixed-fonts t)

  (setq modus-themes-common-palette-overrides nil)
  (setq modus-themes-to-toggle '(modus-operandi modus-vivendi)))

(defun my/load-clean-theme (theme)
  "Disable current themes and load THEME cleanly."
  (interactive
   (list
    (intern (completing-read "Theme: " (mapcar #'symbol-name (custom-available-themes))))))
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme :no-confirm)
  (my/apply-font-configuration))

(keymap-global-set "<f5>" #'my/load-clean-theme)

;;(use-package company
;;  :hook (prog-mode . company-mode)
;;  :config
;;  (setq company-idle-delay 0.0
;;	company-minimum-prefix-length 1
;;	company-tooltip-align-annotations t))

;;(use-package flycheck
;;  :init (global-flycheck-mode))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.0)
  (corfu-auto-prefix 1)
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  :bind
  (:map corfu-map
	("TAB" . corfu-next)
	([tab] . corfu-next)
	("S-TAB" . corfu-previous)
	([backtab] . corfu-previous)
	("RET" . corfu-insert)))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(use-package rust-mode
  :mode "\\.rs\\'"
  :init
  (setq rust-format-on-save t))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package eglot
  :hook (rust-mode . eglot-ensure)
  :config
  (add-hook 'before-save-hook 'eglot-format-buffer nil t))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
