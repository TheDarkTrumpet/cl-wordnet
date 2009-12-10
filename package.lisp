(in-package :cl-user)

(defpackage :wordnet
  (:use :cl :clsql-odbc :clsql-sqlite3)
  (:import-from :clsql-sys :database-state)
  (:import-from :clsql :def-view-class :disconnect :connect)
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
	   :disconnect-db
	   :lemma
	   :pos
	   :definition
	   :synsetid
	   :parse
	   :hyponym
	   :rank
	   :hypernym
	   :orig_word
	   :synonym
	   :grammarpos
	   :definition))
