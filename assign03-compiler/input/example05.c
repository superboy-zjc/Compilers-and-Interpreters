struct Point {
	int x, y;
};
void move_horiz(struct Point *p, int dx) {
	int u;
	u = p->x + dx;
	p->x = u;
}
