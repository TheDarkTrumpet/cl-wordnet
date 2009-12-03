; wordnet.lisp - integration with wordnet
;
; Relies upon an SQL implementation of Wordnet - I've used
; http://opensource.ebswift.com/WordNetSQLServer/
; as my source
;
; Much of the calls require views to be created.
; There is a migrations directory included that includes the SQL to run
; to join up the tables as needed.
;
;
(eval-when (:compile-toplevel :load-toplevel :execute)
  (progn (require :clsql-odbc)
	 (require :clsql-sqlite3)))

(defpackage :wordnet
  (:use :cl :cl-odbc :cl-sqlite3))

(in-package :wordnet)

