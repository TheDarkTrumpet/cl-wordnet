(in-package :cl-user)

(defpackage :wordnet
  (:use :cl :clsql-odbc :clsql-sqlite3)
  (:export :connect-wordnet-mssql))
