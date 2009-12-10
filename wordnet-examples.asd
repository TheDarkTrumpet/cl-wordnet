(in-package #:cl-user)

(defpackage #:wordnet-examples-asd
  (:use :cl))

(in-package :wordnet-examples-asd)

(asdf:defsystem :wordnet-examples
  :name "wordnet-examples"
  :description "Very simple examples of how to use this library"
  :components ((:file "wordnet-examples"))
  :serial t
  :depends-on (:wordnet))
