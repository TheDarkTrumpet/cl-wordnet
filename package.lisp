(in-package :cl-user)

(defpackage :wordnet
  (:use :cl :clsql-odbc :clsql-sqlite3)
  (:export :connect-wordnet-mssql
	   :with-generic-wordnet-mssql-connection
	   :db-connection-mssql
	   :query-db
	   :query-error
	   :worddef
	   :wordparse
	   :hypernyms
	   :hyponyms
	   :synonyms
	   :db-connection
	   :db-connection-sqlite
	   :db-connection-dbms
	   :db-connection-mssql
	   :connect-db
	   :disconnect-db))
