(use-modules (srfi srfi-1)
	     (srfi srfi-43)
             (ice-9 format)
	     (ice-9 iconv))
	    	 

;; m homopolymer length  3
;; b coding potential; entropy of each nucleotide in a valid sequence 1.98
;; i index overhead 0.05 - 0.1 (fraction devoted to index sequences)
;; l oligo length 100-200 nt
;; L 256 bits (32 bytes) length of non-overlapping segments
;; d number of segments to package in a droplet


(define d  (list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)) ;; d number of segments to package in a droplet
(define K 100)                                         ;; K number of segments needed for decoding
(define c 0.1)
(define delta_v 0.05)                                  ;; delta_v dropout rate  0 - 0.005
(define Z 1.033)                                       ;; Z normalization parameter
(define s (* (* c (sqrt K)) (log (/ K delta_v)) ))
(define (calc-rho-d x) (if (= x 1) (/ 1 K) (/ 1 (* x (- x 1))  ) ))  ;; rho(d)  probability distribution
(define (calc-tau-d x) (cond ((and (>= 1) (<= x (- (/ K s) 1)  ))
			     (/ s (* K x)))
			     ((and (> x (- (/ K s) 1))(<= x (/ K s)))
			     (/ (* s (log (/ s delta_v))) K))
			     ((> x (/ K s)) 0))) 
(define tau (map calc-tau-d d))
(define rho (map calc-rho-d d))


(define  (make-rho-tau rho tau)
  (letrec ((r rho)
	 (t tau)
	 (end (length r))
	(counter 0)
	(rt '()))
    (while (<  counter end )     
     
	  (append! rt (+ (list-ref r counter)(list-ref t counter)))
	 (set! counter (+  counter 1)))
    rt))

(make-rho-tau  rho tau)

(define rt '())
(append! rt '(0.13))



(length rho)
(+(list-ref rho 3)(list-ref tau 3))
(plot* #f 0 15 0 10 #f  #f #f #f #f "My Title" d #f )


(define (myfunc x) (* 2 x))

(format #f "~a" (plot* #:xmin 0 :xmax 15 :ymin 0 :ymax 20 :func myfunc :brush "points" ))

(gen-data (list 1 2 3 4))

(myfunc 4)

(run gnuplot)
(calc-tau-d d)


(< 1 0)
