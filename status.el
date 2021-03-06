;;; status.el --- Package to display information when unused

;; Copyright (C) 2014 Jérémy Compostella

;; Author: Jérémy Compostella <jeremy.compostella@gmail.com>
;; Keywords: emacs status

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;(require 'status-activity)
(require 'status-misc)
(require 'status-workgroups)
(require 'status-project-manager)
(require 'status-purple)
(require 'status-gnus)
(require 'status-battery)
(require 'status-date)

(defgroup status nil
  "Status management group."
  :group 'convenience)

(defcustom status-minibuffer-format " *status-minbuf*"
  "Format of name for minibuffer to be used to display status lines."
  :group 'status)

(defcustom status-format '((status-workgroups status-project-manager status-misc)
			   (status-purple status-gnus status-battery status-date))
  "Status format list"
  :group 'status)

(defcustom status-separator " "
  "Status separator string to use between two consecutive items."
  :group 'status)

(defcustom status-refresh-timer-delay 1
  "When different from 0, start a timer to automatically refresh
the status information."
  :group 'status)

(defvar status-refresh-timer nil
  "Store the status timer object.")

(defvar status-activated nil
  "t if status is in used, nil otherwise.")

(defun status-build-item (item)
  (ignore-errors
    (cond ((stringp item) item)
	  ((functionp item) (funcall item))
	  ((symbolp item) (symbol-value item))
	  ((not (stringp item)) ""))))

(defun status-build-items (items)
  (mapconcat 'identity (delq nil (mapcar 'status-build-item items))
	     status-separator))

(defun status-window-width ()
  (let ((edges (window-inside-pixel-edges (minibuffer-window))))
    (- (nth 2 edges) (nth 0 edges))))

(defun status-insert-item (item)
  (insert item)
  (point-marker))

(defun status-current-position ()
  (caaddr (posn-at-point (point) (minibuffer-window))))

(defun status-build ()
  (let* ((items (mapcar 'status-build-items status-format))
	 (width (status-window-width)))
    (erase-buffer)
    (let* ((markers (mapcar 'status-insert-item items)))
      (when (>= (length items) 2)
	(let ((space (/ (- (- width 1) (status-current-position))
			(1- (length items)))))
	  (dolist (marker markers)
	    (goto-char (marker-position marker))
	    (insert (propertize " " 'display `((space :width (,space)))))))))))

(defmacro for-each-minibuf (&rest body)
  (declare (indent defun))
  `(dolist (f (frame-list))
     (with-selected-frame f
       (with-current-buffer (window-buffer (minibuffer-window f))
	 ,@body))))

(defun status-update ()
  "Update the status informations."
  (interactive)
  (when (and status-activated (= (minibuffer-depth) 0))
    (for-each-minibuf
      (let ((saved-status (buffer-string)))
	(condition-case nil
	    (status-build)
	  (error (with-current-buffer status-module-buffer
		   (erase-buffer) (insert saved-status))))))))

(defun toggle-status ()
  (interactive)
  (if status-activated
      (progn (when status-refresh-timer
	       (cancel-timer status-refresh-timer)
	       (setq status-refresh-timer nil))
	     (for-each-minibuf
	       (set-window-buffer (minibuffer-window) (get-buffer-create " *Minibuf-0*") t)
	       (kill-buffer (current-buffer)))
	     (message (propertize "Status disabled."
				  'face 'error)))
    (for-each-minibuf
      (set-window-buffer (minibuffer-window) (generate-new-buffer status-minibuffer-format) t))
    (status-update)
    (unless (= 0 status-refresh-timer-delay)
      (setq status-refresh-timer
	    (run-at-time 1 status-refresh-timer-delay 'status-update)))
    (message (propertize "Status enabled."
			 'face 'success)))
  (setq status-activated (not status-activated)))

(provide 'status)
;;; status.el ends here
