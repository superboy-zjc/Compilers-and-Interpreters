int sq(int *p) {
  int x;
x = *p; }
int main(void) {
  int a;
  a = 3;
  sq(&a);
  return a;
}
