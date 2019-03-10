#lang scribble/manual
@require[@for-label[get-pass
                    racket/base]]

@title{get-pass}
@author{Spencer Mitchell}

This package was inspired by Python's @hyperlink["https://docs.python.org/library/getpass.html" "getpass"] module.

@defmodule[get-pass]

@defproc[(get-pass [prompt string? "password: "]
                   [#:in in input-port? (current-input-port)]
                   [#:out out output-port? (current-output-port)])
         string?]

Displays @racket[prompt] on @racket[out]. Accepts input on @racket[in] without
echoing input.

Using the below code in get-a-password.rkt

@codeblock|{
#lang racket

(require get-pass)

(define pass (get-pass "What's your password? "))
(newline)
(displayln (string-append "Your password is " pass))
}|

will result in the following at the terminal if @code["1234"] is entered at the prompt.

@codeblock[#:keep-lang-line? #f]|{
#lang scribble/manual
$ racket get-a-password.rkt
What's your password?              # "1234" is entered at the prompt, but it is not displayed!
Your password is 1234
$ }|
