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
(eval-when (:compile-toplevel :load-toplevel :execute)
  (progn (require :clsql-odbc)
	 (require :clsql-sqlite3)))

(defpackage :wordnet
  (:use :cl :clsql-odbc :clsql-sqlite3)
  (:export :connect-wordnet-mssql
	   ))

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

(defun connect-wordnet-sqlite ()
  (setf *sqlite* (clsql:connect '("/tmp/test.sqlite3") 
				:database-type :sqlite3
				:make-default nil)))

;;;;; VIEW CLASS DEFINITIONS ;;;;;
; Each of the below are class definitions that we want to utilize
; when calling our methods
;

(clsql:def-view-class worddef () 
  ((lemma :accessor lemma :type (string 80) :initarg :lemma)
   (pos :accessor pos :type (string 3) :initarg :pos)
   (definition :accessor definition :type (string 9000) :initarg :definition))
  (:base-table word_defs))

(clsql:def-view-class wordparse()
  ((lemma :accessor lemma :type (string 80) :initarg :lemma)
   (synsetid :accessor synsetid :type integer :initarg :synsetid)
   (parse :accessor parse :type (string 9000) :initarg :parse))
  (:base-table word_parse))

(clsql:def-view-class hypernyms()
  ((hyponym :accessor hyponym :type (string 80) :initarg :hyponym)
   (rank :accessor rank :type integer :initarg :rank)
   (hypernym :accessor hypernym :type (string 80) :initarg :hypernym))
  (:base-table hypernyms))

(clsql:def-view-class hyponyms()
  ((hypernym :accessor hypernym :type (string 80) :initarg :hypernym)
   (rank :accessor rank :type integer :initarg :rank)
   (hyponym :accessor hyponym :type (string 80) :initarg :hyponym))
  (:base-table hyponyms))

(clsql:def-view-class synonyms ()
  ((orig_word :accessor orig_word :type (string 80) :initarg :orig_word)
   (synonym :accessor orig_word :type (string 80) :initarg :orig_word)
   (pos :accessor pos :type integer :initarg :pos)
   (grammarpos :accessor grammarpos :type (string 15) :initarg  :grammarpos)
   (definition :accessor definition :type (string 9000) :initarg :definition))
  (:base-table synonyms))

;;;;;; ENABLE SYNTAX READER ;;;;;;;
; Note, ran into some issues with this at times, run:
; (clsql:locally-disable-sql-reader-syntax) to disable syntax, then again to reenable
;
(clsql:locally-disable-sql-reader-syntax)
(clsql:locally-enable-sql-reader-syntax)

;;;;;; Our helper functions ;;;;;;;
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
			:database db)
	  (clsql:select tbl
			:where [= srcword word]
			:database db))))
	  
(defun list-word-defs (word)
  (dolist (obj (query-db :word word :tbl 'worddef)) 
    (format t "Definition: ~a~%" (slot-value (first obj) 'definition))))

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

