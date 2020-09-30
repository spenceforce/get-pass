#lang info
(define collection "get-pass")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/get-pass.scrbl" ())))
(define pkg-desc "Utility to get passwords from the command line without echoing input.")
(define version "0.0.2")
(define pkg-authors '(Spencer Mitchell))
