; wordnet-mssql-to-sqlite.lisp
; The purpose of this is to give at least a minor set
; of the data from wordnet to a sqlite database located in the
; directory db.  This is used in tests.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (progn (require :wordnet)))

(defpackage :wordnet-mssql2sqlite
  (:use :cl :wordnet))

(in-package :wordnet-mssql2sqlite)

(defun build-sqlite-db ()
  (with-generic-wordnet-mssql-connection (dbms)
    (with-generic-wordnet-sqlite-connection (sqlitedb)
      (clsql:create-view-from-class 'worddef :database sqlitedb)
      (dolist (obj (query-db :word "cat" :tbl 'worddef :db dbms))
	(setf (slot-value obj (intern "VIEW-DATABASE" 'clsql-sys)) nil)
	(clsql:update-records-from-instance obj :database sqlitedb)))))