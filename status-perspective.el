;;; status-perspective.el

;; Copyright (C) 2016 Sylvain Chouleur

;; Author: Sylvain Chouleur <sylvain.chouleur@gmail.com>
;; Keywords: emacs status perspective

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

(defgroup status-perspective nil
  "Status perspective group."
  :group 'status)

(defcustom status-perspective-fmt "%s"
  "Status format to display the current perspective in the status area")

(defface status-perspective-face
  '((t (:weight bold :width ultra-expanded
		:inherit variable-pitch :foreground "orange")))
  "face for current perspective"
  :group 'status-perspective)

(eval-after-load "perspective"
  '(progn (defun status-perspective ()
	    (propertize (persp-name persp-curr)
	    		'face 'status-perspective-face))
	  (add-hook 'persp-switch-hook 'status-update)))

(provide 'status-perspective)
