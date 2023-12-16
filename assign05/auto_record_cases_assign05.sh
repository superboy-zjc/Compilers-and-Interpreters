DIR="$HOME/fall2023-tests/assign05/cases/LVN_CONSTANT_PROPAGATION_1"
mkdir $DIR

for i in {01..31}; do
  ./nearly_cc -h -o ~/fall2023-tests/assign04/input/example$i.c > $DIR/example$i.out
done
