;;; expand-snippets.el --- Generate many snippets from a raw directory. 
;;

;; This file is not part of Emacs

;; Author: Phillip Lord <phillip.lord@newcastle.ac.uk>
;; Maintainer: Phillip Lord <phillip.lord@newcastle.ac.uk>

;; COPYRIGHT NOTICE
;;
;; The contents of this file are subject to the GPL License, Version 3.0.
;;
;; Copyright (C) 2013, Phillip Lord, Newcastle University
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.



(require 'yasnippet)

;; these need to be run from this directory, so they are not interactive.
;; (expand-snippet)
;; (expand-snippet-reload)


(defvar expand-snippet-modes
  '(

    ("clojure-mode"
     ((:all ";; ")))
    ("emacs-lisp-mode"
     ((:all ";; ")))
    ("java-mode"
     ((:all " * ")
      (:before "/*")
      (:after " */"))
     )
    ("php-mode"
     ((:before "/*")
      (:after "*/")
      (:all " * "))
     )
    ("text-mode")
    ("fundamental-mode")
    ))


(defun expand-snippet ()
  (let ((raw-templates
         (directory-files "raw" nil "^[^.]")))
    
    ;; for each mode 
    (mapcar 
     (lambda (config)
       (let* ((directory (car config))
              (comments (cadr config))
              (all (assoc :all comments))
              (before (assoc :before comments))
              (after (assoc :after comments)))
         (message "Expanding for %s" directory)
         ;; ensure the directory is there
         (when (not (file-exists-p directory))
           (make-directory directory))
         
         ;; for each file in license, write out with comments
         (mapcar 
          (lambda (file)
            (with-temp-buffer
              (insert-file-contents (concat "raw/" file))
              ;; TODO this needs to cope with moving over the comment line in yasnippet
              (let ((firstline 
                     ;; there is a comment line
                     (progn
                       (goto-char (point-min))
                       (save-excursion
                         ;; insert the name
                         (insert (format "# name: %s-%s\n" file directory))
                         (if (not (re-search-forward "# --\n" nil t))
                             (insert "# --\n")))
                       (re-search-forward "# --\n" nil t))))

                (when all
                  (string-rectangle 
                   firstline 
                   (progn 
                     (goto-char (point-max))
                     (beginning-of-line)
                     (point))
                   (cadr all)))
                
                (when after
                  (goto-char (point-max))
                  (insert "\n")
                  (insert (cadr after)))
                
                (when before
                  (goto-char firstline)
                  (insert (cadr before))
                  (insert "\n"))
                
                (goto-char (point-max))
                (insert "\n$0")
                (delete-trailing-whitespace)
                (write-file (concat directory "/" file)))
              
              ))
          raw-templates)))
     expand-snippet-modes)))


(defun expand-snippet-reload ()
  "Expand all the snippets, reload everything"
  (expand-snippet)
  (yas-reload-all))


(provide 'expand-snippet)
