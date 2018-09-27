sbcl --userinit sbclrc-docker \
    --eval "(asdf:load-system :restagraph)" \
    --eval "(sb-ext:save-lisp-and-die \"mytaxsys\" :executable t :toplevel #'(lambda () (restagraph::dockerstart :schemapath \"/schemas\")))"
