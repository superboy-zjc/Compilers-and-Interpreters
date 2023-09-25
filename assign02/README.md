# Conclusion

The process of completing Assigment01 is exciting. A lot of details in the interpreters are unable to be learned, if I don't write it on my own. To conclude, I learned that:

- the entire architecture of interpreters (assign 01)
  - Scanning tokens(checking for undefined tokens)
  - Defining context-free grammar(Essential specification for a sound programming language. Among this process the precedences should be considered, as well as avoiding infinitely recursive error due to endlessly expanding non-terminal symbols)
  - Parsing the pre-defined grammar, expanding non-terminal symbols with the scanned tokens(checking grammar errors), finally generating a parse tree or AST tree
  - If a parse tree is produced in the previous step, converting it into an AST tree
  - Interpreting the AST tree to evaluate results(checking the rest of grammar errors, like a variable been referenced before its definition)

- focus more on the operations
  - add control flow to the programming language
    - the while's environment should be cleared after per cycle 
  - add functions
    - **function call** should be settled in a new environment, the **function body** either
    - while **function**'s parent environment should be the environment when it was initiated
  - add intrisic functions
    - intrisic functions are loaded and implemented by the interpreter