export ASSIGN05_DIR=~/Compilers-and-Interpreters
TEST_DIR=~/fall2023-tests/assign05
cd $TEST_DIR && ./run_test.rb -o example$1
#$TEST_DIR/build.rb $TEST_DIR/example$1
#cat  ~/fall2023-tests/assign04/my_output/example$1.out
#cat  ~/fall2023-tests/assign04/my_output_low/example$1.out
cat  ~/fall2023-tests/assign05/out/example$1.S
cat ~/fall2023-tests/assign05/input/example$1.c
