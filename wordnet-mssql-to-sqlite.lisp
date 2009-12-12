; wordnet-mssql-to-sqlite.lisp
; The purpose of this is to give at least a minor set
; of the data from wordnet to a sqlite database located in the
; directory db.  This is used in tests.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (progn (require :wordnet)))

(defpackage :wordnet-mssql2sqlite
  (:use :cl :wordnet))

(in-package :wordnet-mssql2sqlite)

(defmacro with-generic-wordnet-sqlite-connection ((var) &body body)
  `(let ((,var (connect-db (make-instance 'db-connection-sqlite :path "db/wordnet.sqlite3"))))
     ,@body
     (disconnect-db ,var)))

(defun build-sqlite-db ()
  (with-generic-wordnet-mssql-connection (dbms)
    (with-generic-wordnet-sqlite-connection (sqlitedb)
;      (clsql:create-view-from-class 'worddef :database sqlitedb)
      (dolist (obj (query-db :word "cat" :tbl 'worddef :db dbms))
	(clsql:update-records-from-instance obj :database sqlitedb)))))