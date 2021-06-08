#! /gnu/store/6l9rix46ydxyldf74dvpgr60rf5ily0c-guile-3.0.7/bin/guile \
-e main -s
!#

(add-to-load-path "/home/mbc/projects/dncoder")

(use-modules (srfi srfi-19)
	     (srfi srfi-1)
	     (srfi srfi-9)
	     (srfi srfi-43)  ;;vector library
	     (ice-9 pretty-print)
	     (json)
	     (rnrs bytevectors)
             (ice-9 binary-ports)
             (ice-9 format)
             (ice-9 getopt-long)
	     (ice-9 textual-ports)
	     (ice-9 iconv)   ;;string->byte->string
	     )

(load "/home/mbc/projects/dncoder/dncoder/meths-and-vars.scm")

(define-record-type <project>
  (make-project name owner email in algorithm oligos)
  project?
  (name    project-name set-project-name!)
  (owner project-owner set-project-owner!)
  (email project-email set-project-email!)
  (in project-in set-project-in!)
  (algorithm project-algorithm set-project-algorithm!)
  (oligos project-oligos set-project-oligos!)
  )

(define-json-type <project> (name)(owner)(email)(in)(algorithm)(oligos))


(define (cluster-bits str size out)
  ;; str is the bits (0 or 1) as concatenated string
  ;; size is length of fragment desired
  ;; out is an empty list initially
  (if (< (string-length str) size )
      (if (> (string-length str) 0)
	  (reverse (cons str out))
	  (reverse  out))
      (let* ((slen (string-length str))
	     (frag (substring str 0  size))
	     (new-lst (cons frag out))
	     (rest (substring str size slen))
	     )
      (cluster-bits rest size new-lst))	
      ))

(define (prepend-index lst counter out)
  ;; create dotted pairs from a list where the car is an index
  ;; counter should start at 1
  ;; out is the empty list
  (if (null? (cdr lst))
      (let*((old-element (car lst))
	    (new-element (cons counter old-element)))
	     (cons new-element out))	
      (let*((old-element (car lst))
	    (new-element (cons counter old-element))
	    (new-out (cons new-element out)))
	(prepend-index (cdr lst) (+ counter 1) new-out))
      ))



(define-record-type <oligo>
  (make-oligo id bits pad seed seq)
  oligo?
  (id    oligo-id)
  (bits oligo-bits)
  (pad oligo-pad) ;;was it padded - then strip excess; indicates # extra chars
  (seed   oligo-seed )
  (seq oligo-seq))


(define-json-type <oligo> (id)(bits)(pad)(seed)(seq))


(define (make-oligo-records lst size out)
  ;; lst is list of indexed cons cells
  ;; size is length of bits - pad out if needed
  ;; out initially '() will be list of records
  (if (null? (cdr lst))
      (let*((index (caar lst))
	    (bits (cdar lst))
	    (blen (string-length bits))
	    (pad (- size blen))
	    (bits (string-pad-right bits size #\0))
	    (rec (make-oligo index bits pad "" "")))
	 (cons rec out))      
      (let*((index (caar lst))
	    (bits (cdar lst))
	    (blen (string-length bits))
	    (pad (- size blen))
	    (bits (string-pad-right bits size #\0))
	    (rec (make-oligo index bits pad "" "")))
	(make-oligo-records (cdr lst) size (cons rec out)))
      ))


;; (define (oligo-rec->json-array lst out)
;;   ;;out is the string of json elements, initially ""
;;  (if (null? (cdr lst))
;;       (let*((old-record (car lst))
;; 	    (new-json (oligo->json old-record)))
;; 	     (string-concatenate `("[" ,new-json ,out "]")))	
;;       (let*((old-record (car lst))
;; 	    (new-json (oligo->json old-record))
;; 	    (new-out (string-append new-json out)))
;; 	(oligo-rec->json-array (cdr lst)  new-out))
;;       ))


(define (oligo-rec->vector lst out)
  ;;out is the lst of json elements, initially ""
 (if (null? (cdr lst))
      (let*((old-record (car lst))
	    (new-json (oligo->json old-record)))
	     (vector (string-append new-json out)))	
      (let*((old-record (car lst))
	    (new-json (oligo->json old-record))
	    (new-out (string-append new-json out)))
	(oligo-rec->vector (cdr lst)  new-out))
      ))



(define (create-prj-rec params oligos-vector)
  ;; lst is the read in alist of params
  ;; oligos-array is json text [{...}{...}{...}]
  (make-project (assoc-ref params "project")
		(assoc-ref params "owner")
		(assoc-ref params "email")
		(assoc-ref params "file")
		(assoc-ref params "algorithm")
		 oligos-vector))


(define (main args)
  ;; args: '( "script name"
  ;;          "project name"
  ;;          "owner"
  ;;          "email"
  ;;          "oligo size"
  ;;          "file"
  ;;          )

  (let* (
	 (pfile (cadr args))
	 (in (open-input-file pfile))
	 (params (json->scm in))
	 (prjname (assoc-ref params "project"))
	 (owner (assoc-ref params "owner"))
	 (email (assoc-ref params "email"))
	 (size (string->number (assoc-ref params "oligo_size")))
	 (data-file (assoc-ref params "file"))
	 (out-file (assoc-ref params "out-file"))
	 
	  (prj-rec (make-project prjname owner email data-file "" ""))
	 (my-input (bytevector->u8-list (get-bytevector-some (open-input-file data-file))))
	  (all-bits (string-concatenate (map process-byte  my-input)))
	  (clustered-bits (cluster-bits all-bits size '()))
	  (indexed-bits (prepend-index clustered-bits 1 '()))
	  (oligo-recs (make-oligo-records indexed-bits size '()))
	  (oligo-json-vector (oligo-rec->vector oligo-recs ""))
	  (prj (create-prj-rec params oligo-json-vector))
	 )
;;(pretty-print (scm->json  oligo-json-vector))
    (put-string (open-output-file out-file) (project->json prj))
  ))


  
