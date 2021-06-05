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
	     (ice-9 iconv)   ;;string->byte->string
	     )

(load "./meths-and-vars.scm")

(define-record-type <oligo>
  (make-oligo id  seed seq)
  oligo?
  (id    oligo-id)
  (seed   oligo-seed )
  (seq oligo-seq))


(define-json-type <oligo> (id)(seed)(seq))

(define results  (make-oligo "1"  "gcttcga" "actgatagcagtagactgcagat"))


(define-record-type <project>
  (make-project name owner email algorithm oligos)
  project?
  (name    project-name set-project-name!)
  (owner project-owner set-project-owner!)
  (email project-email set-project-email!)
  (algorithm project-algorithm set-project-algorithm!)
  (oligos project-oligos set-project-oligos!)
  )


(define my-input   (bytevector->u8-list (get-bytevector-some (open-input-file "/home/mbc/projects/dncoder/dncoder/courville.ods") )))

(define my-output (map process-byte  my-input))

(define (cluster-bits lst size out)
  (if (null? (cdddr lst))
      (begin
      (car lst)

      )
      (let* ((a (car lst))
	     (b (cadr lst))
	     (c (caddr lst))
	     (d (string-append a b c))
	     (e )
	     )
      (cluster-bits (cdr lst) size out))	

  )

(cdddr my-output)

(define (main args)

(pretty-print (oligo->json results))
  )
