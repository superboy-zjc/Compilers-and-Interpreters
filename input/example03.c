int main(void) {
  const unsigned int x, y[10], *z, *p[10], **e, f[5][5];
  return 0;
}
struct Point {
int x, y;
};
void move_horiz(struct Point *p, int dx) {
	int u;
	u = p->x + dx;
	p->x = u;
}
