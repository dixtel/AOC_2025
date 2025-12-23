(with-open-file (in "./input2.txt" :direction :input :if-does-not-exist :error)
  (defparameter *in* (read-line in)))

(defun split (s &key (delimeter #\Space))
  (do* ((start_idx 0)
        (del_idx (position delimeter s :start start_idx) (position delimeter s :start start_idx))
        (ret (list)))
    ((null del_idx) (append ret (list (subseq s start_idx (length s)))))
    (let ((part (subseq s start_idx del_idx)))
      (setf ret (append ret (list part)))
      (setf start_idx (+ del_idx 1)))))

(defun process (products_ids)
  (let ((counter 0)
        (sum 0))
    (dolist (id products_ids (list counter sum))
      (let ((id_start (parse-integer (car id)))
            (id_end (parse-integer (first (cdr id)))))
        (do ((i id_start (+ i 1)))
          ((> i id_end))
          (when (check_product_id i)
            (incf counter)
            (incf sum i)))))))
  
; ID's with odd number of digits are always valid.
; Algorithm for a number with even number of digits:
; x = <id>
; l = num_of_digits x
; h = (l / 2)
; X = x / (10^h)
; x1 = floor X
; x2 = floor (X - x1)*10^h
;
; There is a simpler and more performent way to check if given product id is
; valid. Convert number to string and split it by half. Then check for equality.
(defun check_product_id (id)
  (cond ((/= 0 (mod (dnum id) 2)) nil)
        (t (let* ((l (dnum id))
                  (h (/ l 2))
                  (X (/ id (expt 10 h)))
                  (x1 (floor X))
                  (x2 (floor (* (- X x1) (expt 10 h)))))
              (if (= x1 x2) t nil)))))
  

; calculate number of digits in the value x
(defun dnum (x)
  (do ((i x (/ i 10))
       (c 0 (+ c 1)))
      ((equal (floor i) 0) c)))

 (let ((ids (mapcar (lambda (x) (split x :delimeter #\-)) (split *in* :delimeter #\,))))
   (let ((answer (process ids)))
     (format t "answer, count: ~a, sum: ~a~%" (car answer) (cdr answer))))
