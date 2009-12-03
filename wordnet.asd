(in-package #:cl-user)

(asdf:defsystem :wordnet
  :components ((:file "wordnet"))
  :depends-on (:clsql-odbc :clsql-sqlite3))