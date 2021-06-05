#!/usr/bin/guile \
-e main -s
!#


(use-modules (srfi srfi-1)
	     (srfi srfi-43)  ;;vector library
	   ;;  (rnrs)
	    
	     (rnrs bytevectors)
             (ice-9 binary-ports)
             (ice-9 format)
             (ice-9 getopt-long)
	     (ice-9 iconv))   ;;string->byte->string


(load "./meths-and-vars.scm")

(define my-input   (bytevector->u8-list (get-bytevector-some (open-input-file "/home/mbc/syncd/misc/DNCoder/AnavySupT1.ods") )))

(write my-input)


(process-byte 25)

(define my-output (map process-byte  my-input))

(write my-output)



(length my-input)

(utf8->string (u8-list->bytevector '(99 97 102 120)))

       (utf8->string #vu8(104 101 108 108 111))
(write bv)

(print-options)

(bytevector->string (u8-list->bytevector (make-list 4 255)) )


(bytevector-uint-ref 60)

(string->utf8 "help")


(assoc 2 bytes-to-bits)

(assoc-ref bytes-to-bits 11)

(write bytes-to-bits)

;; x is an element of a-list

(convert-bits-to-nucs '(1 . "00010010"))

(define val (cdr '(1 . "00010101")))
(write val)

(car '( 1 . "00010101"))

(write bytes-to-nucs)


