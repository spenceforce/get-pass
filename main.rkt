#lang racket/base

(module+ test
  (require rackunit))

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/port)

(provide get-pass)

(define-ffi-definer define-libc (ffi-lib #f))

;; C Structs
(define-cstruct _TERMIOS ([c_iflag _uint]
                          [c_oflag _uint]
                          [c_cflag _uint]
                          [c_lflag _uint]
                          [c_cc (_array _uint 32)]
                          [c_ispeed _uint]
                          [c_ospeed _uint]))

;; C Functions
(define-libc tcgetattr (_fun _int (t : (_ptr o _TERMIOS)) -> (i : _int) -> (values i t)))
(define-libc tcsetattr (_fun _int _int (t : (_ptr i _TERMIOS)) -> (i : _int) -> (values i t)))

;; C Defines
(define ECHO 8)
(define TCSANOW 0)
(define TCSADRAIN 1)

(define (get-pass [prompt "password: "]
                  #:in [in (current-input-port)]
                  #:out [out (current-output-port)])
  ;; Utility to get passwords from the command line without echoing input.
  (define fd (unsafe-port->file-descriptor in))
  (unless fd
    (error "Could not get file descriptor for #:in" 'in))

  (define-values (ret-val termios) (tcgetattr fd))

  (display prompt out)
  ;; Flush output to ensure prompt is displayed.
  (flush-output)

  ;; Set ECHO flag to 0 in TERMIOS struct.
  (set-TERMIOS-c_lflag! termios (bitwise-and (TERMIOS-c_lflag termios)
                                             (bitwise-not ECHO)))
  ;; Use TCSADRAIN to ensure all output to the output port has been transmitted
  ;; before turning off ECHO.
  (tcsetattr fd TCSADRAIN termios)

  (define pass (read-line))

  ;; Set ECHO flag to 1 in TERMIOS struct.
  (set-TERMIOS-c_lflag! termios (bitwise-ior (TERMIOS-c_lflag termios) ECHO))
  ;; Use TCSANOW to ensure ECHO is turned on immediately.
  (tcsetattr fd TCSANOW termios)

  pass)

(module+ test
  ;; Tests to be run with raco test
  )
