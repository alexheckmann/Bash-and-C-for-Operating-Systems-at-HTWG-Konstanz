#include <stdio.h>
#include <stdlib.h>

struct list {
	int head;
	struct list *tail;
};

struct list *add(int x, struct list *xs) {
	struct list *p = malloc(sizeof(struct list));

	p->head = x;
	p->tail = xs;

	return p;
}

int main(void) {
	struct list *l = NULL;

	l = add(42, l);
	l = add(23, l);
	l = add(1, add(2, l));

	for (struct list *p = l; p; p = p->tail) {
		printf("%d\n", p->head);
	}
}
