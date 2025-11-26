;;; -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load in.

(doom! :input

       :completion
       (corfu +orderless)  ; complete with cap(f), cape and a flying feather!
       vertico           ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       ;;(emoji +unicode)  ; 🙂
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       modeline          ; snazzy, Atom-inspired modeline, plus API
       ophints           ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       (vc-gutter +pretty) ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       workspaces        ; tab emulation, persistence & separate workspaces
       zen               ; distraction-free coding or writing

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       fold              ; (nigh) universal code folding
       ;;(format +onsave)  ; automated prettiness
       parinfer          ; turn lisp into python, sort of
       snippets          ; my elves. They type so I don't have to
       (whitespace +guess +trim)  ; a butler for your whitespace

       :emacs
       dired             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       tramp             ; remote files at your arthritic fingertips
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       vterm             ; the best terminal emulation in Emacs

       :checkers
       syntax            ; tasing you for every semicolon you forget
       (spell +flyspell) ; tasing you for misspelling mispelling
       grammar           ; tasing grammar mistake every you make

       :tools
       (eval +overlay)     ; run code, run (also, repls)
       lookup              ; navigate your code and its documentation
       magit               ; a git porcelain for Emacs

       :os
       (:if (featurep :system 'macos) macos)  ; improve compatibility with macOS
       tty               ; improve the terminal Emacs experience

       :lang
       emacs-lisp        ; drown in parentheses
       markdown          ; writing docs for people to ignore
       nix               ; I hereby declare "nix geht mehr!"
       org               ; organize your plain life in plain text
       sh                ; she sells {ba,z,fi}sh shells on the C xor

       :app
       calendar

       :config
       (default +bindings +smartparens))

