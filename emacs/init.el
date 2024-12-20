(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)


(column-number-mode 1)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "ZedMono Nerd Font" :height 140 :weight 'medium)

(load-theme 'wombat)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


;; Initialize package resources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package command-log-mode)
(use-package swiper)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
   	 :map ivy-switch-buffer-map
   	 :map ivy-reverse-i-search-map)
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key]      . helpful-key))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 0)
  (doom-modeline-icon nil))

(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-visual-bell-config))
  

(use-package which-key
  :init
  (which-key-mode)
  :diminish
  :custom
  (which-key-idle-delay 0.3))

(use-package evil
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-want-C-i-jump t)

  :config
  (evil-mode 1)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :after evil
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emas)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (rune/leader-keys
    "w"  '(:ignore w :which-key "window")
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package hydra
  :after general
  :config
  (defhydra hydra-window-zoom (:timeout 4)
    "scale text"
    ("=" text-scale-increase "in")
    ("-" text-scale-decrease "out"))
  (rune/leader-keys
    "wz" '(hydra-window-zoom/body :which-key "zoom")))

(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode)
  (rune/leader-keys
    "p" '(projectile-command-map :which-key "project"))
  :init
  (setq projectile-project-search-path 
    (pcase system-type
      (gnu/linux '("~/src/" "~/work/nesim/rotatalk"))
      (darwin    '("~/dev"))
      (_         nil)))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-traditional)
  :config
  (rune/leader-keys
    "g" '(:ignore g :which-key "magit")
    "gs" '(magit-status :which-key "git status")
    "gp" '(magit-pull-from-upstream :which-key "git pull origin")))

(use-package forge)

(use-package zig-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(zig-mode forge evil-magit magit counsel-projectile helpful projectile hydra doom-themes general evil-collection evil counsel ivy-rich which-key rainbow-delimiters rainbow-delimiter doom-modeline evil-mode swiper ivy command-log-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

