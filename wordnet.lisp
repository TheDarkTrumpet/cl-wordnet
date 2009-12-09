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

;;;; Setup wordnet database global objects ;;;;
(defvar *mssql* nil)
(defvar *sqlite* nil)

(defun connect-wordnet-mssql ()
  (setf *mssql* (clsql:connect '("wordnet" "wordnet" "wordnet") 
			       :database-type :odbc
			       :make-default t)))

(defun connect-wordnet-sqlite (path)
  (setf *sqlite* (clsql:connect (list path)
				:database-type :sqlite3
				:make-default nil)))



;;;;;; ENABLE SYNTAX READER ;;;;;;;
; Note, ran into some issues with this at times, run:
; (clsql:locally-disable-sql-reader-syntax) to disable syntax, then again to reenable
;
(clsql:locally-disable-sql-reader-syntax)
(clsql:locally-enable-sql-reader-syntax)

;;;;;; Our helper functions ;;;;;;;
(defun flatten-results (rlist)
  (mapcar #'first rlist))

(defgeneric query-wordnet (wordnet)
  (:documentation "Our generic function that'll query wordnet"))

(define-condition query-error (error)
  ((text :initarg :text :reader text)))

(defun query-db (&key (word nil) (tbl nil) (srcword 'lemma) (db *mssql*)
		 (order-by nil))
  (if (or (null word) (null tbl))
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
  (dolist (obj (query-db :word word :tbl 'worddef)) 
    (format t "Definition: ~a~%" (slot-value obj 'definition))))

(defun list-word-parse (word)
  (dolist (obj (query-db :word word :tbl 'wordparse))
    (format t "parse output: ~a~%" (slot-value (first obj) 'parse))))

(defun list-word-hypernyms (word)
  (dolist (obj (query-db :word word :tbl 'hypernyms :srcword 'hyponym :order-by 'hypernym))
    (format t "Hypernym: ~a~%" (slot-value (first obj) 'hypernym))))

(defun list-word-hyponyms (word)
  (dolist (obj (query-db :word word :tbl 'hyponyms :srcword 'hypernym :order-by 'hyponym))
    (format t "Hyponym: ~a~%" (slot-value (first obj) 'hyponym))))

(defun list-word-synonyms (word)
  (dolist (obj (query-db :word word :tbl 'synonyms :srcword 'orig_word))
    (format t "Synonym: ~a, grammar position: ~a~%" (slot-value (first obj) 'synonym)
	    (slot-value (first obj) 'grammarpos))))

