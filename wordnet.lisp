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
(in-package :wordnet)

;;;; Disable caching, mostly for debugging at this point ;;;;
(setf clsql:*cache-table-queries-default* nil)

;;;;;; ENABLE SYNTAX READER ;;;;;;;
; Note, ran into some issues with this at times, run:
; (clsql:locally-disable-sql-reader-syntax) to disable syntax, then again to reenable
;
(clsql:locally-disable-sql-reader-syntax)
(clsql:locally-enable-sql-reader-syntax)

(defmacro with-generic-wordnet-mssql-connection ((var) &body body)
  `(let ((,var (connect-db (make-instance 'db-connection-mssql :user "wordnet" :host "wordnet" :pass "wordnet"))))
     ,@body
     (disconnect-db ,var)))

; Do I need this method?
(defgeneric query-wordnet (wordnet)
  (:documentation "Our generic function that'll query wordnet"))

(define-condition query-error (error)
  ((text :initarg :text :reader text)))

(defun query-db (&key (word nil) (tbl nil) (srcword 'lemma) (db nil)
		 (order-by nil))
  (if (or (null word) (null tbl) (null db))
      (error 'query-error :text "Must supply a word and table minimum")
      (if (not order-by)
	  (clsql:select tbl
			:where [= srcword word]
			:order-by order-by
			:database db
			:flatp t)
	  (clsql:select tbl
			:where [= srcword word]
			:database db
			:flatp t))))






