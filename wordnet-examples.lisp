; wordnet-example
; Examples of how to use the library

(in-package :wordnet-examples)

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
