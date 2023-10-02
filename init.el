(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))

;; Org
;;; Packages
(straight-use-package 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;; add org tempo as it includes (among other things), the '<s' expansion feature
(require 'org-tempo)
(setq org-hide-emphasis-markers t)
;;; better list bullets
(font-lock-add-keywords 'org-mode
			'(("^ +\\([-*]\\) "
			   (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "·"))))))

(setq org-directory "~/Dropbox")
(setq org-default-notes-file (concat org-directory "/index.org"))
(add-to-list 'org-agenda-files org-default-notes-file)

;;; Generate table of contents
(straight-use-package 'toc-org)
(add-hook 'org-mode-hook 'toc-org-mode)

;;; Org specific global bindings
(evil-define-key 'normal 'global
  (kbd "<leader> o c") #'org-capture)

;;; Org Capture
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/Work/index.org" "Tasks")
	 "* %?\n %i\n %a")))


(evil-define-key 'normal org-mode-map
  (kbd "<tab>") 'org-cycle
  (kbd "s-j") 'org-metadown
  (kbd "s-k") 'org-metaup
  (kbd "> >") 'org-shiftmetaright
  (kbd "< <") 'org-shiftmetaleft)


;; Tabs
(setq tab-bar-show 1)
(evil-define-key '(normal motion) 'global
  (kbd "<leader> t t") #'tab-switch
  (kbd "<leader> t n") #'tab-new
  (kbd "<leader> t c") #'tab-close
  (kbd "<leader> t j") #'tab-next
  (kbd "<leader> t k") #'tab-previous
  (kbd "<leader> t f") #'find-file-other-tab
  (kbd "<leader> t b") #'switch-to-buffer-other-tab
  (kbd "<leader> t r") #'tab-rename
  (kbd "<leader> t d") #'dired-other-tab)

;; better help display
(straight-use-package 'helpful)
;;; bind to helpful commands
(evil-define-key '(normal motion) 'global
  (kbd "<leader> h i") #'info
  (kbd "<leader> h v") #'helpful-variable
  (kbd "<leader> h f") #'helpful-function
  (kbd "<leader> h k") #'helpful-key
  (kbd "<leader> h m") #'describe-mode
  (kbd "<leader> h r") #'info-display-manual
  (kbd "<leader> h M") #'info-emacs-manual)
  
(evil-define-key '(normal motion) helpful-mode-map
  (kbd "q") #'quit-window)

(evil-define-key '(normal motion) help-mode-map
  (kbd "q") #'quit-window)
  
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

(defun dired-first-file ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 3))

(defun dired-last-file ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

;; launching dired
(evil-define-key '(normal motion) 'global
  (kbd "<leader> d d") 'dired
  (kbd "<leader> d j") 'dired-jump)

(evil-define-key '(normal motion) dired-mode-map
  (kbd "j") 'dired-next-line
  (kbd "k") 'dired-previous-line
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file
  (kbd "s") 'eshell
  (kbd "g g") 'dired-first-file
  (kbd "G") 'dired-last-file
  (kbd "<left>") 'dired-up-directory
  (kbd "<right>") 'dired-find-file
  (kbd "<up>") 'dired-previous-line
  (kbd "<down>") 'dired-next-line)

;;;; ibuffer
(evil-set-initial-state 'ibuffer-mode 'normal)
(evil-define-key '(normal motion) ibuffer-mode-map
  (kbd "<leader> x") 'execute-extended-command
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
  (kbd "D") 'ibuffer-do-delete
  (kbd "K") 'ibuffer-do-kill-lines)


;; unbind space from running `dired-next-line' in order to free it up for space-prefixed bindings.
(define-key dired-mode-map (kbd "SPC") nil)

;; Completion
;;; Project aware commands ('p' prefix)
(evil-define-key 'normal 'global
  (kbd "<leader> p f") 'project-find-file
  (kbd "<leader> p e") 'project-eshell)


;;; minibuffer
(setq enable-recursive-minibuffers t)
;; TODO: consider aliasing `yes-or-no-p' to `y-or-n-p'.
;; (defalias 'yes-or-no-p 'y-or-n-p)

;;;; minibuffer completion framework
(straight-use-package 'vertico)
(vertico-mode 1)
(define-key vertico-map (kbd "<escape>") #'keyboard-escape-quit)
(require 'vertico-directory)
(define-key vertico-map
  (kbd "DEL") #'vertico-directory-delete-char)
(define-key vertico-map
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
(evil-define-key '(normal motion visual insert emacs) 'global
  (kbd "s-<return>") 'embark-dwim
  (kbd "C-<return>") 'embark-act)

;; Git
(straight-use-package 'magit)
(evil-set-initial-state 'magit-status-mode 'normal)
(evil-define-key '(normal motion) magit-status-mode-map
  (kbd "q") 'magit-mode-bury-buffer
  (kbd "c") 'magit-commit
  (kbd "j") 'magit-next-line
  (kbd "k") 'magit-previous-line
  (kbd "}") 'magit-section-forward
  (kbd "{") 'magit-section-backward
  (kbd "TAB") 'magit-section-toggle
  (kbd "RET") 'magit-visit-thing
  (kbd "i") 'magit-gitignore
  (kbd "l") 'magit-log
  ;; delete
  (kbd "d d") 'magit-discard)

(evil-define-key '(normal visual) magit-status-mode-map
  (kbd "s") 'magit-stage
  (kbd "u") 'magit-unstage)

(evil-set-initial-state 'magit-log-mode 'normal)
(evil-define-key '(normal motion) magit-log-mode-map
  (kbd "q") 'magit-log-bury-buffer
  (kbd "j") 'magit-next-line
  (kbd "k") 'magit-previous-line
  (kbd "}") 'magit-section-forward
  (kbd "{") 'magit-section-backward
  (kbd "RET") 'magit-show-commit)

(evil-set-initial-state 'magit-revision-mode 'normal)
(evil-define-key '(normal motion) magit-revision-mode-map
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
(evil-define-key '(normal motion) 'global
  (kbd "<leader> f f") 'find-file
  (kbd "<leader> f c") #'find-config)

(evil-define-key '(normal motion) 'global
  (kbd "<leader> g") #'magit)

(evil-define-key '(normal motion) 'global  
  (kbd "<leader> e e") 'eval-last-sexp
  (kbd "<leader> e d") 'eval-defun)

;; TODO: this doesn't currently work.
(evil-define-key '(visual motion) 'global
  (kbd "<leader> e e") 'eval-region)

;; Seems like this is already defined in `simple.el'
;; (defun kill-current-buffer ()
  ;; "Kill the current buffer using `kill-buffer'."
  ;; (interactive)
  ;; (kill-buffer t))

;;;; Buffer wrangling
 (evil-define-key '(normal motion) 'global
  (kbd "<leader> b b") 'switch-to-buffer
  (kbd "<leader> b n") 'next-buffer
  (kbd "<leader> b p") 'previous-buffer
  (kbd "<leader> b s") 'save-buffer
  (kbd "<leader> b i") 'ibuffer
  (kbd "<leader> b d") 'evil-delete-buffer
  (kbd "<leader> b k") 'kill-current-buffer)

;;;; Shells
(setq explicit-shell-file-name "/bin/zsh"
      shell-file-name "/bin/zsh")
(evil-define-key 'normal 'global
  (kbd "<leader>s e") 'eshell)

;;;; window navigation
(evil-define-key '(normal motion) 'global
  ;; short command for most common operation. might need
  ;; to give it up if I deem the 'o' prefix handy for a
  ;; group of commands
  (kbd "<leader> .") 'evil-window-split
  (kbd "<leader> /") 'evil-window-vsplit
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

(add-to-list 'display-buffer-alist
	     '("Calendar"
	       (display-buffer-below-selected)
	       (window-height . 15)))

;; "App" Launcher
(evil-define-key 'normal 'global
  (kbd "<leader> a c") #'calendar
  (kbd "<leader> a a") #'org-agenda)

;; Toggles
(evil-define-key 'normal 'global
  (kbd "<leader> T t") #'modus-themes-toggle
  (kbd "<leader> T n") #'display-line-numbers-mode)

;; Eshell
(straight-use-package 'eshell-syntax-highlighting)
(eshell-syntax-highlighting-global-mode +1)
(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)


;; Http
(straight-use-package 'restclient)
(add-to-list 'auto-mode-alist '("\\.http\\'" . restclient-mode))


;; Calendar
;;; enable appointment reminders
(appt-activate 1)
(evil-set-initial-state 'calendar-mode 'normal)
(evil-define-key 'normal calendar-mode-map
  (kbd "l") 'calendar-forward-day
  (kbd "h") 'calendar-backward-day
  (kbd "k") 'calendar-backward-week
  (kbd "j") 'calendar-forward-week
  (kbd "q") 'calendar-exit
  (kbd ".") 'calendar-goto-today
  (kbd "d d") 'diary-view-entries
  (kbd "d i") 'diary-insert-entry)

;; Diary
(evil-define-key 'normal diary-fancy-display-mode-map
  (kbd "q") 'quit-window)


;; Programming modes
;;; General settings applicable to all programming modes.
(straight-use-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;; LSP setup
;; Emacs 29 packages `eglot', so no need to install it.
(add-hook 'eglot-managed-mode-hook
	  (lambda ()
	    (setq eldoc-documentation-strategy #'eldoc-documentation-compose)
	    (setq eldoc-documentation-functions
		  '(flymake-eldoc-function
		    eglot-signature-eldoc-function
		    eglot-hover-eldoc-function))))
		  

;;; Lisps

;;; Yaml
(straight-use-package 'yaml-mode)

;;; Docker
(straight-use-package 'dockerfile-mode)

;;; Terraform
(straight-use-package 'terraform-mode)

;;; Rust
(straight-use-package 'rust-mode)

;;; PHP
(straight-use-package 'php-mode)

;; Reading
;;; Epub support
(straight-use-package 'nov)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; Icons
(straight-use-package 'all-the-icons)
;;; If icons aren't showing up, you may need to install the font.
;;; If so, uncomment and execute the following line.
;; (all-the-icons-install-fonts t)

(straight-use-package 'all-the-icons-completion)
(all-the-icons-completion-mode)
(if (require 'marginalia nil nil)
    (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup))

;; miscellanious functions
(defun masteringemacs ()
  "Open the masteringemacs epub manual."
  (interactive)
  ;; ensure the nov package is installed
  (require 'nov)
  (find-file "~/Dropbox/Emacs/mastering-emacs-v4.epub"))

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
