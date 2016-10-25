#lang racket


(define english-1
  '((Initial (1))
    (Final (9))
    (From 1 to 3 by NP)
    (From 1 to 2 by DET)
    (From 2 to 3 by N)
    (From 3 to 4 by BV)
    (From 4 to 5 by ADV)
    (From 4 to 5 by |#|)
    (From 5 to 6 by DET)
    (From 5 to 7 by DET)
    (From 5 to 8 by |#|)
    (From 6 to 7 by ADJ)    
    (From 6 to 6 by MOD)
    (From 7 to 9 by N)
    (From 8 to 8 by MOD)
    (From 8 to 9 by ADJ)
    (From 9 to 4 by CNJ)
    (From 9 to 1 by CNJ)))

(define (getf x y)
  (if (eq? (car x) y)
      (cadr x)
      (getf (cdr x) y)))

(define (initial-nodes network)
  (list-ref (assoc 'Initial network) 1))

(define (final-nodes network)
  (list-ref  (assoc 'Final network) 1))

(define (transitions network)
  (filter (lambda (x) (eq? (car x) 'From)) network))

(define (trans-node transition)
  (getf transition 'From))

(define(trans-newnode transition)
  (getf transition 'to))

(define (trans-label transition)
  (getf transition 'by))

(define abbreviations
  '((NP kim sandy lee)
    (DET a the her)
    (N consumer man woman)
    (BV is was)
    (CNJ and or)
    (ADJ happy stupid)
    (MOD very)
  (ADV often always sometimes)))

(getf '(From 1 to 3 by NP) 'From)

(define (recognize network tape)
  ;; returns t if sucessfully recognizes tape - nil otherwise
  (call/cc (lambda (return)
             (define (recognize_next node tape network)
               (if (and (null? tape) (member node (final-nodes network)))
                   (return #t) ; success
                   (for ([transition (transitions network)])
                           ;; try each transition of the network
                           (if (equal? node (trans_node transition)) ; if it starts at the right node
                               (for ([newtape (recognize_move (transJabel transition) tape)])
                                       ;; try each possible new value of tape
                                 (recognize_next (trans_newnode transition) newtape network))))))
             (for ([initialnode (initial-nodes network)])
               (recognize_next initialnode tape network))
             nil))) ; failed to recognize


;(define (generate network)
 ; (for ((initialnode (initial-nodes network)))
  ;  (generate-next initialnode null network)))
