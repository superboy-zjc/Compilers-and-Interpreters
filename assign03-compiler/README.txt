By traversing the AST tree, which has already been completed using lex/bison, I briefly did things below:
- Wrap different type objects for variable keywords, and values. And mark every expression node with a type object representing the result of expression which would be helpful for semantic checking.

- Create symbol table entry for every variable definition as well as structure and function definitions.

- Develop semantic analysis aligning with the computation rules
