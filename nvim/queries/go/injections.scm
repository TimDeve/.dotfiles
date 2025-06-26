; extends

; SQL
((raw_string_literal) @sql (#lua-match? @sql "^`%s*SELECT") (#offset! @sql 0 1 0 -1))
((raw_string_literal) @sql (#lua-match? @sql "^`%s*INSERT") (#offset! @sql 0 1 0 -1))
((raw_string_literal) @sql (#lua-match? @sql "^`%s*UPDATE") (#offset! @sql 0 1 0 -1))
((raw_string_literal) @sql (#lua-match? @sql "^`%s*WITH") (#offset! @sql 0 1 0 -1))

((interpreted_string_literal) @sql (#lua-match? @sql "^\"%s*SELECT") (#offset! @sql 0 1 0 -1))
((interpreted_string_literal) @sql (#lua-match? @sql "^\"%s*INSERT") (#offset! @sql 0 1 0 -1))
((interpreted_string_literal) @sql (#lua-match? @sql "^\"%s*UPDATE") (#offset! @sql 0 1 0 -1))
((interpreted_string_literal) @sql (#lua-match? @sql "^\"%s*WITH") (#offset! @sql 0 1 0 -1))

(
  (raw_string_literal) @python
  (#match? @python "api\\s*\\=\\s*(\"\\d\\.\\d\\.\\d\"|'\\d\\.\\d\\.\\d')\n")
  (#offset! @python 0 1 0 -1)
)

; JSON
((const_spec
  name: (identifier) @_const
  value: (expression_list (raw_string_literal) @json))
 (#lua-match? @_const ".*[J|j]son.*"))


((short_var_declaration
    left: (expression_list
            (identifier) @_var)
    right: (expression_list
             (raw_string_literal) @json))
  (#lua-match? @_var ".*[J|j]son.*")
  (#offset! @json 0 1 0 -1))
