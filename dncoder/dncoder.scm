#! /gnu/store/6l9rix46ydxyldf74dvpgr60rf5ily0c-guile-3.0.7/bin/guile \
-e main -s
!#

(add-to-load-path "/home/mbc/temp")

(use-modules (srfi srfi-19)
	     (srfi srfi-1)
	     (srfi srfi-9)
	     (ice-9 pretty-print)
	     (json)
	     )


(define-record-type <person>
  (make-person first last maiden)
  person?
  (first    person-first)
  (last person-last)
  (maiden   person-maiden ))



(define-json-type <person> (first)(last)(maiden))

(define results  (make-person "Julie" "Smith" "Jones"))


(define-record-type <contact>
  (make-contact first index qname wholen firstn lastn affil email)
  contact?
  (first    contact-first set-contact-first!)
  (index contact-index set-contact-index!)
  (qname contact-qname set-contact-qname!)
  (wholen contact-wholen)
  (firstn contact-firstn)
  (lastn contact-lastn)
  (affil contact-affil set-contact-affil!)
  (email contact-email set-contact-email!))


(define (main args)

(pretty-print (person->json results))
  )
