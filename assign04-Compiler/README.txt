# All the changed files
- Bash shell scripts for test
    - autotest_first.sh
    - test_assign03_bad.sh
    - test_assign03_exam.sh
    - test_assign03_good.sh
    - test_assign03_struct.sh
    - test_auto_high_level.sh
    - test_auto_low_level.sh
    - test_high_evel.sh
    - test_low_level.sh
    - test_semantics.sh

- symtab.h
    - Add storage type and location property, as well as two bool properties for marking if the symbol entry stored in virtual register and if the address of the symbol entry was taken
- symtab.cpp
    - Add `get` and `set` functions to modify and get the storage type and storage location of a symbol entry

- type.h
    - Add storage offset property for Member class to store every storage location of a field of struct type.
- type.cpp
    - Add `set` function for annotating the member object with the storage offset of a field 

- semantic_analysis.cpp
    - Annotate AST_XXX_DECLATOR node, AST_FUNCTION_PARAMETER, AST_STRUCT_TYPE_DEFINITION with the variable's symbol for storage allocation.
    - Finish the explicitly implicit conversion for binary expression, unary expression and function call expression.
    - Annotate each AST_LITERAL_VALUE node with a LiterValue object.
    - Optimize code to make it more concise, reasonable and readable.
- semantic_analysis.h
    - Add several helper function for explicitly implicit conversion.

- local_storage_allocation.cpp
    - Allocate storage location, either a virtual register or a memory locartion, for every variable definition and function parameter, and store those information into the corresponding symbol table entry. 
    - Allocate storage offset for each field of a struct type, and store storage information into the Member object.
    - Calculate all the virtual registers and memory storage assigned for each function, and store those storage information into the AST_FUNCTION_DEFINITION Node
- local_storage_allocation.h
    - Add several helper function and private propreties for allocating storage location.


- context.cpp
    - Support string constants by converting LiterValue into a label name, as well as loading string constants into the .rodata section.
- context.h
    - Add helper function `encodeString` for escaping special characters.

- highlevel_codegen.cpp
    - Add helper function `TOK_TAG_TO_HH_CODE` for converting AST_TAG into a highlevel opcode.
    - Emit high level instructions for binary and unary expression, and annotate a Operand object for each expression node. 
    - Emit high level instructions for every conditional jump and comparsion.
    - Emit high level instructions for function call expression.
    - Emit high level instructions for direct and indirect field reference expression
    - Emit high level instructions when necessary and assign operand objects for each variable reference.
    - Explicitly implement implicit conversion and emit appropriate high level instructions.
- highlevel_codegen.h
    - Add several helper functions for emit high level instructions.


- lowlevel_codegen.cpp
    - Calculate memory storage for virtual registers and variables, and emit low level code for allocation.
    - Translate high level instructions to low level instructions by emitting corresponding low level code.
    - Assign temporary registers r10 and r11 in turn.
- lowlevel_codegen.h
    - Add helper functions and helper properties for implementing low level code generation.

- literal_value.cpp
    - Add a helper function `set_str_value` for replacing the string value with the label name assigned in the .rodata section.
- literal_value.h
    - Add a helper function `set_str_value` for replacing the string value with the label name assigned in the .rodata section.

- node_base.cpp
    - Add functionality for modify lable name on its LiteralValue property.
- node_base.h
    - Add properties for storing allocation status of virtual registers, which would be useful on nodes such as AST_FUNCTION_DEFINITION>
    - Add property for stroing the total memory storage size, which would be useful on nodes such as AST_FUNCTION_DEFINITION.
    - Add LiteralValue object property for storing the literval value.
    - Add Operand object property.
    - Add several `set` and `get` helper functions to modify and get storage information from the properties.

- operand.cpp
    - Add `memref_to` function.



