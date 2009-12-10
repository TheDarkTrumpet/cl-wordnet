(in-package :wordnet)

;;;;;;;;;;;;;;;;;;;
; Treat the database connections as objects - so we can set the user/pass stuff and keep
; it encapsulated.  The connect-db will be a defgeneric which will accept a database object
; but more on that later.
;;;;;;;;;;;;;;;;;;;

(defclass db-connection ()
  ((type :initarg :type :accessor db-type))
  (:documentation "The foundation datbase connection class, that the others will inherit"))

(defclass db-connection-sqlite (db-connection)
  ((type :initform "sqlite3" :reader db-type)
   (path :initarg :path :accessor path))
  (:documentation "The specific connection object for SQLite"))

(defclass db-connection-dbms (db-connection)
  ((host :initarg :host :accessor host-name)
   (user :initarg :user :accessor user-name)
   (pass :initarg :pass :accessor password)
   (port :initarg :port :accessor port-number))
  (:documentation "The foundation for databases one connects to through the network (ODBC, Postgresql, etc)"))

(defclass db-connection-mssql (db-connection-dbms)
  ((type :initform "odbc" :reader db-type)
   (port :initform NIL :reader port-number))
  (:documentation "The specific connection object for an MSSQL database"))


;;;; Helper connection methods

(defgeneric connect-db (db-connection &optional make-default)
  (:documentation "Generic method for which the various database types will be supported"))

;; Connection method for MSSQL
(defmethod connect-db ((db db-connection-mssql) &optional make-default)
  (connect (list 
	    (host-name db)
	    (user-name db)
	    (password db))
	   :database-type :odbc
	   :make-default make-default))

(defmethod connect-db ((db db-connection-sqlite) &optional make-default)
  (connect (list 
	    (path db))
	   :database-type :sqlite3
	   :make-default make-default))

; If you close a database multiple times with clsql, you get an error
; The purpose of this is, really do I care if the person closes the database more than
; once? I think not...
; database-state from the clsql-sys package

(defun disconnect-db (db)
  (when (eql (database-state db) :open)
    (disconnect :database db))
  T)