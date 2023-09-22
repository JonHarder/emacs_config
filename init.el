;; Set up straight.el
(defun load-user-file (file)
  "Loads the FILE relative to `user-emacs-directory'."
  (load (expand-file-name file user-emacs-directory)))

(load-user-file "bootstrap-straight.el")

;; Theme and appearance
(straight-use-package 'catppuccin-theme)
(load-theme 'catppuccin t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(let ((font "FiraCode Nerd Font")
      (size 160))
  (set-face-attribute 'default nil :font font :height size)
  (set-frame-font font nil t)
  (add-to-list 'default-frame-alist
	       `(font . ,font)))


;; Evil (vim)
(straight-use-package 'evil)
(evil-mode 1)

;;; Set up the leader key
(evil-set-leader 'normal (kbd "<SPC>"))

(evil-define-key 'normal 'global
  (kbd "<leader> x") 'execute-extended-command)

(evil-define-key '(insert emacs) 'global
  (kbd "s-x") #'execute-extended-command)

;;; Evil-ify modes
;;;; Info mode
(evil-set-initial-state 'Info-mode 'normal)
(evil-define-key '(normal motion) Info-mode-map
  (kbd "<tab>") 'Info-next-reference
  (kbd "S-<tab>") 'Info-prev-reference
  (kbd "RET") 'Info-follow-nearest-node
  "d" 'Info-directory
  "u" 'Info-up
  "s" 'Info-search
  "i" 'Info-index
  "a" 'info-apropos
  "q" 'quit-window

  [mouse-1] 'Info-mouse-follow-nearest-node
  [follow-link] 'mouse-face

  ;; goto
  "gm" 'Info-menu
  "gt" 'Info-top-node
  "gT" 'Info-toc
  "gj" 'Info-next
  "gk" 'Info-prev)

;;;; dired
;; dired starts in normal mode even without explicitly stating so using `evil-set-initial-state'.
(setq dired-kill-when-opening-new-dired-buffer t) 
(require 'dired)
(evil-define-key 'normal dired-mode-map
  "j" 'dired-next-line
  "k" 'dired-previous-line
  "h" 'dired-up-directory
  "l" 'dired-find-file
  (kbd "<left>") 'dired-up-directory
  (kbd "<right>") 'dired-find-file
  (kbd "<up>") 'dired-previous-line
  (kbd "<down>") 'dired-next-line)

;;;; ibuffer
(evil-set-initial-state 'ibuffer-mode 'normal)
(evil-define-key 'normal ibuffer-mode-map
  ;; navigation
  (kbd "{") 'ibuffer-backwards-next-marked
  (kbd "}") 'ibuffer-forward-next-marked

  ;; mark commands
  (kbd "J") 'ibuffer-jump-to-buffer
  (kbd "m") 'ibuffer-mark-forward
  (kbd "~") 'ibuffer-toggle-marks
  (kbd "u") 'ibuffer-unmark-forward
  (kbd "DEL") 'ibuffer-unmark-backward
  (kbd "* *") 'ibuffer-mark-special-buffers
  (kbd "U") 'ibuffer-unmark-all-marks
  (kbd "* m") 'ibuffer-mark-by-mode
  (kbd "* M") 'ibuffer-mark-modified-buffers
  (kbd "* r") 'ibuffer-mark-read-only-buffers
  (kbd "* /") 'ibuffer-mark-dired-buffers
  (kbd "* h") 'ibuffer-mark-help-buffers
  (kbd "d") 'ibuffer-mark-for-delete

  ;; actions
  (kbd "x") 'ibuffer-do-kill-on-deletion-marks
  (kbd "gr") 'ibuffer-update

  ;; immediate actions
  (kbd "A") 'ibuffer-do-view
  (kbd "D") 'ibuffer-do-delete)


;; unbind space from running `dired-next-line' in order to free it up for space-prefixed bindings.
(define-key dired-mode-map (kbd "SPC") nil)

;; Completion
;;; minibuffer
(setq enable-recursive-minibuffers t)
;; TODO: consider aliasing `yes-or-no-p' to `y-or-n-p'.
;; (defalias 'yes-or-no-p 'y-or-n-p)

;;;; minibuffer completion framework
(straight-use-package 'vertico)
(vertico-mode 1)
(define-key vertico-map (kbd "<escape>") #'keyboard-escape-quit)
(evil-define-key '(normal emacs) vertico-map
  (kbd "DEL") #'vertico-directory-delete-char
  (kbd "RET") #'vertico-directory-enter)

;;;; save history of minibuffer commands used in order to promote them next time.
(straight-use-package 'savehist)
(savehist-mode)

;;;; add helpfull info to any completion candidate based on category (files, commands, buffers, etc.)
(straight-use-package 'marginalia)
(marginalia-mode 1)

;;;; better sorting using space-separrated search fragments
(straight-use-package 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;;; In buffer completion
(straight-use-package 'corfu)
(setq corfu-auto t
      corfu-separator ?\s

      tab-always-indent 'complete)
(global-corfu-mode 1)

;;; act on completions using user defined actions
(straight-use-package 'embark)
(setq prefix-help-command #'embark-prefix-help-command)
(add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
(evil-define-key '(normal visual insert emacs) 'global
  (kbd "s-<return>") 'embark-dwim
  (kbd "C-<return>") 'embark-act)

;; Git
(straight-use-package 'magit)
;;;; TODO add vim bindings to this
(evil-set-initial-state 'magit-status-mode 'normal)
(evil-define-key 'normal magit-status-mode-map
  (kbd "q") 'magit-mode-bury-buffer
  (kbd "c") 'magit-commit
  (kbd "j") 'magit-next-line
  (kbd "k") 'magit-previous-line
  (kbd "}") 'magit-section-forward
  (kbd "{") 'magit-section-backward
  (kbd "TAB") 'magit-section-toggle
  (kbd "RET") 'magit-visit-thing
  (kbd "i") 'magit-gitignore
  (kbd "l") 'magit-log)

(evil-define-key '(normal visual) magit-status-mode-map
  (kbd "s") 'magit-stage
  (kbd "u") 'magit-unstage)

(evil-set-initial-state 'magit-log-mode 'normal)
(evil-define-key 'normal magit-log-mode-map
  (kbd "q") 'magit-log-bury-buffer
  (kbd "j") 'magit-next-line
  (kbd "k") 'magit-previous-line
  (kbd "}") 'magit-section-forward
  (kbd "{") 'magit-section-backward
  (kbd "RET") 'magit-show-commit)

(evil-set-initial-state 'magit-revision-mode 'normal)
(evil-define-key 'normal magit-revision-mode-map
  (kbd "j") 'magit-next-line
  (kbd "k") 'magit-previous-line
  (kbd "}") 'magit-section-forward
  (kbd "{") 'magit-section-backward
  (kbd "TAB") 'magit-section-toggle
  (kbd "RET") 'magit-visit-thing
  (kbd "q") 'magit-mode-bury-buffer)

;; Bindings
(defun find-config ()
  "Open the user's config file."
  (interactive)
  (find-file (concat user-emacs-directory "init.el")))

;;;; file commands
(evil-define-key 'normal 'global
  (kbd "<leader> .") 'find-file
  (kbd "<leader> f c") #'find-config)

(evil-define-key 'normal 'global
  (kbd "<leader> g") #'magit)

(evil-define-key 'normal 'global  
  (kbd "<leader> e e") 'eval-last-sexp
  (kbd "<leader> e d") 'eval-defun)

;; TODO: this doesn't currently work.
(evil-define-key 'visual 'global
  (kbd "<leader> e e") 'eval-region)


;;;; Buffer wrangling
 (evil-define-key 'normal 'global
  (kbd "<leader> b b") 'switch-to-buffer
  (kbd "<leader> b n") 'next-buffer
  (kbd "<leader> b p") 'previous-buffer
  (kbd "<leader> b s") 'save-buffer
  (kbd "<leader> b i") 'ibuffer
  (kbd "<leader> b d") 'evil-delete-buffer)

;;;; Help (prefix 'h')
(evil-define-key 'normal 'global
  (kbd "<leader>h f") 'describe-function
  (kbd "<leader>h v") 'describe-variable
  (kbd "<leader>h m") 'describe-mode
  (kbd "<leader>h i") 'info
  (kbd "<leader>h k") 'describe-key)

;;;; Shells
(setq explicit-shell-file-name "/bin/zsh"
      shell-file-name "/bin/zsh")
(evil-define-key 'normal 'global
  (kbd "<leader>s e") 'eshell)

;;;; window navigation
(evil-define-key 'normal 'global
  (kbd "<leader> w w") 'other-window
  (kbd "<leader> w c") 'evil-window-delete
  (kbd "<leader> w v") 'evil-window-vsplit
  (kbd "<leader> w s") 'evil-window-split
  (kbd "<leader> w o") 'delete-other-windows)

;;; Why doesn't this work?
;; (define-key minibuffer-local-map (kbd "ESC") 'keyboard-escape-quit)


;; Window Management
(setq switch-to-buffer-obey-display-actions t)

(add-to-list 'display-buffer-alist
	     '("\\*eshell\\*"
	       (display-buffer-in-side-window)
	       (side . bottom)
	       (slot . 0)
	       (window-height . 15)))

;; Eshell
(straight-use-package 'eshell-syntax-highlighting)
(eshell-syntax-highlighting-global-mode +1)


;; Programming modes
;;; General settings applicable to all programming modes.
(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;; LSP setup

;;; Lisps


;;; Terraform

;;; PHP
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(connection-local-criteria-alist
   '(((:application eshell)
      eshell-connection-default-profile)))
 '(connection-local-profile-alist
   '((eshell-connection-default-profile
      (eshell-path-env-list))))
 '(custom-safe-themes
   '("6ca663019600e8e5233bf501c014aa0ec96f94da44124ca7b06d3cf32d6c5e06" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
