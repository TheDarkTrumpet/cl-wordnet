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
  ((type :initform "sqlite" :reader db-type)))

(defclass db-connection-dbms (db-connection)
  ((host :initarg :host :accessor host-name)
   (user :initarg :user :accessor user-name)
   (pass :initarg :user :accessor password)
   (port :initarg :port :accessor port-number))
  (:documentation "The foundation for databases one connects to through the network"))

(defclass db-connection-mssql (db-connection-dbms)
  ((type :initform "odbc" :reader db-type))
  (:documentation "The specific MSSQL database")

