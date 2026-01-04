#include <ruby.h>

void Init_bubbletea(void);
void Init_lipgloss(void);
void Init_glamour(void);

__attribute__((__visibility__("default"))) void Init_charm_native(void) {
  Init_bubbletea();
  Init_lipgloss();
  Init_glamour();
}
