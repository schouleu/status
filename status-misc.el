;;; status-workgroups.el

;; Copyright (C) 2014 Sylvain Chouleur

;; Author: Sylvain Chouleur <sylvain.chouleur@gmail.com>
;; Keywords: emacs status workgroups

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

(require 'appt)
(defgroup status-misc nil
  "Status misc group."
  :group 'status)

(defface status-misc-face
  '((t (:weight bold :width ultra-expanded
		:inherit variable-pitch :foreground "orange")))
  "face for active misc item"
  :group 'status-misc)

(delq 'appt-mode-string global-mode-string)
(defun status-misc ()
  (concat
    (propertize (if compilation-in-progress "Compiling " "") 'face 'status-misc-face)
    (or appt-mode-string "")))

(provide 'status-misc)
