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

(defgeneric query-wordnet (wordnet)
  (:documentation "Our generic function that'll query wordnet"))

(define-condition query-error (error)
  ((text :initarg :text :reader text)))

(defun query-db (&key (word nil) (tbl nil) (srcword 'lemma) (db *mssql*)
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

(defun list-word-defs (word)
  (with-generic-wordnet-mssql-connection (dbms)
    (dolist (obj (query-db :word word :tbl 'worddef :db dbms))
      (format t "Definition: ~a~%" (definition obj)))))

(defun list-word-parse (word)
  (with-generic-wordnet-mssql-connection (dbms)
    (dolist (obj (query-db :word word :tbl 'wordparse :db dbms))
      (format t "parse output: ~a~%" (parse obj)))))

(defun list-word-hypernyms (word)
  (with-generic-wordnet-mssql-connection (dbms)
    (dolist (obj (query-db :word word :tbl 'hypernyms :srcword 'hyponym :order-by 'hypernym :db dbms))
      (format t "Hypernym: ~a~%" (hypernym obj)))))

(defun list-word-hyponyms (word)
  (with-generic-wordnet-mssql-connection (dbms)
    (dolist (obj (query-db :word word :tbl 'hyponyms :srcword 'hypernym :order-by 'hyponym :db dbms))
      (format t "Hyponym: ~a~%" (hyponym obj)))))

(defun list-word-synonyms (word)
  (with-generic-wordnet-mssql-connection (dbms)
    (dolist (obj (query-db :word word :tbl 'synonyms :srcword 'orig_word :db dbms))
      (format t "Synonym: ~a, grammar position: ~a~%" (synonym obj) (grammarpos obj)))))





