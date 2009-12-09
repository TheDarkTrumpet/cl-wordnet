(in-package #:cl-user)

(defpackage #:wordnet-asd
  (:use :cl))

(in-package :wordnet-asd)

(asdf:defsystem :wordnet
  :name "wordnet"
  :version "0.1"
  :maintainer "David Thole"
  :author "David Thole"
  :license "LGPL"
  :description "A simple interface to a SQL-Based wordnet, specifically MSSQL over ODBC"
  :components ((:file "package.lisp")
	       (:file "db-defs.lisp")
	       (:file "wordnet")
  :serial t
  :depends-on (:clsql-odbc :clsql-sqlite3))