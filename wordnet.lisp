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
  (:use :cl :clsql-odbc :clsql-sqlite3)
  (:export :connect-wordnet-mssql
	   ))

(in-package :wordnet)

(defun connect-wordnet-mssql ()
  (setf *mssql* (clsql:connect '("wordnet" "wordnet" "wordnet") 
			       :database-type :odbc
			       :make-default t)))

(defun connect-wordnet-sqlite ()
  (setf *sqlite* (clsql:connect '("/tmp/test.sqlite3") 
				:database-type :sqlite3
				:make-default nil)))


