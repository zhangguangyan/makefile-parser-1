gnu_make {
--need parse for 9
--     objects = main.o kbd.o command.o display.o \
--               insert.o search.o files.o utils.o
--
--need parse for 13
--     clean:
--             rm edit $(objects)
--

--need parse for 14
--     .PHONY : clean
--


--need parse for 19
--     foo:
--             frobnicate > foo
--
--     %: force
--             @$(MAKE) -f Makefile $@
--     force: ;
--

--need to look at the rest





  white_space     = '\\' <eol>                                                                                      $({})
                  | ' '                                                                                             $({})
  white_space_eol = <white_space>* <eol>                                                                            $({})
  alphanumeric    = [a-zA-Z0-9]
  file_symbol     = '.' | '-'
  file_symbols    = <alphanumeric> | <file_symbol>
  filename        = <white_space>*:a <file_symbols>+:f <white_space>*:b                                             $(f)
  filenames       = <filename>+
  eol             = '\n'                                                                                            $({})
                  | '\r\n'                                                                                          $({})
  make_tree_start = <filename>:f ':'                                                                                $(f)
  make_tree       = <filename>:f ':' <filenames>:s <eol> <white_space>*:a <filenames>:b  <white_space_eol>+         $({"rule", f, s, b})
                  | <filename>:f ':'               <eol> <white_space>*:a <filenames>:b  <white_space_eol>+         $({"rule", f, {}, b})
  gnu_make_main   = <make_tree>*:m                                                                                  $(m)

  num   = [0-9]+

  exprA = <exprA>:a '-' <num>:b               $({a, "-", b})
        | <num>

  exprB = <num>
        | <exprB>:a '-' <num>:b               $({a, "-", b})

  exprC = <num>:a ('-' <num>)*:b               $({a, "-", b})

  xD    = <exprD>
  exprD = <xD>:a '-' <num>:b               $({a, "-", b})
        | <num>

  exprE = <num>:a '+' <num>:b               $({a, "+", b})
        | <num>:a '-' <num>:b               $({a, "-", b})

  term = <term>:a '+' <fact>:b               $({a, "+", b})
       | <term>:a '-' <fact>:b               $({a, "-", b})
       | <fact>

  fact = <fact>:a '*' <num>:b               $({a, "*", b})
       | <fact>:a '/' <num>:b               $({a, "/", b})
       | <num>

  start = <ones>:a '2':b               $({a, b})
        | '1':a <start>:b               $({a, b})
        | <_>!

  ones = <ones>:a '1':b               $({a, b})
       | '1'

  rr = '1':a <rr>:b               $({a, b})
     | '1'

  lr = <lr>:a '1':b               $({a, b})
     | '1'

  lr1 = <x>:a '1':b               $({a, b})
      | '1'

  x = <lr1>
}