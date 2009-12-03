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



