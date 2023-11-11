export ASSIGN04_DIR=~/Compilers-and-Interpreters
TEST_DIR=~/fall2023-tests/assign04
cd $TEST_DIR && ./build.rb example$1
#$TEST_DIR/build.rb $TEST_DIR/example$1
#cat  ~/fall2023-tests/assign04/my_output/example$1.out
cat  ~/fall2023-tests/assign04/example_lowlevel_code/example$1.S
cat  ~/fall2023-tests/assign04/out/example$1.S
cat ~/fall2023-tests/assign04/input/example$1.c
