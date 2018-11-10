sbcl --userinit sbclrc-docker \
    --eval "(asdf:load-system :restagraph)" \
    --eval "(sb-ext:save-lisp-and-die \"sebcat\" :executable t :toplevel #'(lambda () (restagraph::dockerstart :schemapath \"/schemas\")))"
