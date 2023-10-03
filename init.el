(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))

;;;; ibuffer


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
(define-key minibuffer-local-map (kbd "C-<return>") #'embark-act)

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
   '(((:application tramp :protocol "flatpak")
      tramp-container-connection-local-default-flatpak-profile)
     ((:application tramp :machine "localhost")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "Jonathans-MBP-3.askey.com")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)
     ((:application eshell)
      eshell-connection-default-profile)))
 '(connection-local-profile-alist
   '((tramp-container-connection-local-default-flatpak-profile
      (tramp-remote-path "/app/bin" tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin"))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))
     (eshell-connection-default-profile
      (eshell-path-env-list))))
 '(custom-safe-themes
   '("6ca663019600e8e5233bf501c014aa0ec96f94da44124ca7b06d3cf32d6c5e06" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
