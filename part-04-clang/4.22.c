#include <curses.h>
#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { min_field_height = 24, min_field_width = 80 };

enum { max_key_value_len = 32 };

enum { delay_ms = 3000 };

typedef enum { rb_red = 1, rb_black = 2 } rb_color_t;
typedef struct tag_rb_tree_t {
  rb_color_t color;
  char *key;
  const void *value;
  struct tag_rb_tree_t *parent, *left, *right;
} rb_tree_t;

static rb_tree_t *rb_tree_delete(rb_tree_t *root)
{
  if (!root)
    return NULL;
  rb_tree_delete(root->left);
  rb_tree_delete(root->right);
  free(root->key);
  free(root);
  return NULL;
}

static rb_tree_t **rb_tree_search_rec(rb_tree_t **root,
                                      const char *key,
                                      rb_tree_t **parent)
{
  int res;

  if (!*root) {
    return root;
  }

  res = strcmp(key, (*root)->key);
  if (res < 0) {
    *parent = *root;
    return rb_tree_search_rec(&(*root)->left, key, parent);
  }
  else if (res > 0) {
    *parent = *root;
    return rb_tree_search_rec(&(*root)->right, key, parent);
  }
  else {
    *parent = (*root)->parent;
    return root;
  }
}

static rb_tree_t **rb_tree_search(rb_tree_t **root,
                                  const char *key,
                                  rb_tree_t **parent)
{
  *parent = NULL;
  return rb_tree_search_rec(root, key, parent);
}

static rb_tree_t *rb_tree_rotate_left(rb_tree_t *root, rb_tree_t *to_rotate)
{
  rb_tree_t *new_parent = to_rotate->right;
  to_rotate->right = new_parent->left;
  if (to_rotate->right)
    to_rotate->right->parent = to_rotate;
  new_parent->parent = to_rotate->parent;
  if (!to_rotate->parent) {
    root = new_parent;
  }
  else if (to_rotate == to_rotate->parent->left)
    to_rotate->parent->left = new_parent;
  else
    to_rotate->parent->right = new_parent;
  new_parent->left = to_rotate;
  to_rotate->parent = new_parent;
  return root;
}

static rb_tree_t *rb_tree_rotate_right(rb_tree_t *root, rb_tree_t *to_rotate)
{
  rb_tree_t *new_parent = to_rotate->left;
  to_rotate->left = new_parent->right;
  if (to_rotate->left)
    to_rotate->left->parent = to_rotate;
  new_parent->parent = to_rotate->parent;
  if (!to_rotate->parent)
    root = new_parent;
  else if (to_rotate == to_rotate->parent->right)
    to_rotate->parent->right = new_parent;
  else
    to_rotate->parent->left = new_parent;
  new_parent->right = to_rotate;
  to_rotate->parent = new_parent;
  return root;
}

static rb_tree_t *rb_tree_insert_fixup(rb_tree_t *root, rb_tree_t *inserted)
{
  if (!root)
    return NULL;

  while (inserted != root && inserted->parent->color == rb_red) {
    if (inserted->parent == inserted->parent->parent->left) {
      rb_tree_t *uncle = inserted->parent->parent->right;
      if (uncle && uncle->color == rb_red) {
        inserted->parent->color = rb_black;
        uncle->color = rb_black;
        uncle->parent->color = rb_red;
        inserted = uncle->parent;
      }
      else {
        if (inserted == inserted->parent->right) {
          inserted = inserted->parent;
          root = rb_tree_rotate_left(root, inserted);
        }

        inserted->parent->color = rb_black;
        inserted->parent->parent->color = rb_red;
        root = rb_tree_rotate_right(root, inserted->parent->parent);
      }
    }
    else {
      rb_tree_t *uncle = inserted->parent->parent->left;
      if (uncle && uncle->color == rb_red) {
        inserted->parent->color = rb_black;
        uncle->color = rb_black;
        uncle->parent->color = rb_red;
        inserted = uncle->parent;
      }
      else {
        if (inserted == inserted->parent->left) {
          inserted = inserted->parent;
          root = rb_tree_rotate_right(root, inserted);
        }

        inserted->parent->color = rb_black;
        inserted->parent->parent->color = rb_red;
        root = rb_tree_rotate_left(root, inserted->parent->parent);
      }
    }
  }
  root->color = rb_black;

  return root;
}

static rb_tree_t *rb_tree_insert(rb_tree_t *root,
                                 const char *key,
                                 const void *value)
{
  rb_tree_t **current, *parent;
  current = rb_tree_search(&root, key, &parent);
  if (*current)
    return root;
  *current = malloc(sizeof(rb_tree_t));
  (*current)->color = rb_red;
  (*current)->key = malloc(strlen(key) + 1);
  strcpy((*current)->key, key);
  (*current)->value = value;
  (*current)->parent = parent;
  (*current)->left = NULL;
  (*current)->right = NULL;
  return rb_tree_insert_fixup(root, *current);
}

static void print_tree_in_window(rb_tree_t *root, int level, int *row)
{
  if (!root)
    return;

  print_tree_in_window(root->right, level + 1, row);

  attron(COLOR_PAIR(root->color));
  mvprintw(*row, level * 9, "%s", root->key);
  attroff(COLOR_PAIR(root->color));

  (*row)++;

  print_tree_in_window(root->left, level + 1, row);
}

int main()
{
  rb_tree_t *root = NULL;
  char key[max_key_value_len + 1];
  char value[max_key_value_len + 1];
  char *tmp;
  enum {
    choice_insert_key_value_pair = '1',
    choice_search_for_key = '2',
    choice_print_tree = '3',
    choice_exit = '4'
  } choice;

  initscr();

  if (LINES < min_field_height || COLS < min_field_width) {
    endwin();
    fprintf(stderr, "Please resize your terminal to at least %dx%d.\n",
            min_field_width, min_field_height);
    return 1;
  }

  if (has_colors() == FALSE) {
    endwin();
    fputs("Your terminal doesn't support color.", stderr);
    return 2;
  }

  start_color();
  use_default_colors();
  init_pair(rb_red, COLOR_RED, -1);
  init_pair(rb_black, COLOR_GREEN, -1);

  cbreak();
  noecho();
  curs_set(0);

  keypad(stdscr, TRUE);

  do {
    int scanw_res, row;
    rb_tree_t *search_res, *search_res_parent;

    clear();
    mvprintw(0, 0, "Menu:");
    mvprintw(1, 0, "1. Insert key-value pair");
    mvprintw(2, 0, "2. Search for key");
    mvprintw(3, 0, "3. Print tree");
    mvprintw(4, 0, "4. Exit");
    mvprintw(5, 0, "Choose an option: ");

    scanw_res = scanw("%c", &choice);
    if (scanw_res != 1)
      continue;

    switch (choice) {
      case choice_insert_key_value_pair:
        mvprintw(7, 0, "Enter key: ");
        getnstr(key, max_key_value_len);

        mvprintw(8, 0, "Enter value: ");
        getnstr(value, max_key_value_len);

        /* There is no need to free this memory further, as the operating
         * system automatically frees all memory that was allocated by the
         * program */
        tmp = malloc(strlen(value) + 1);
        strcpy(tmp, value);

        root = rb_tree_insert(root, key, tmp);
        mvprintw(10, 0, "Key successfully inserted.");
        break;
      case choice_search_for_key:
        mvprintw(7, 0, "Enter key to search: ");
        getnstr(key, max_key_value_len);

        search_res = *rb_tree_search(&root, key, &search_res_parent);
        if (search_res)
          mvprintw(9, 0, "Found: %s -> %s", key, (char *)search_res->value);
        else
          mvprintw(9, 0, "Key not found.");
        break;
      case choice_print_tree:
        row = 7;
        print_tree_in_window(root, 0, &row);
        break;
      case choice_exit:
        root = rb_tree_delete(root);
        continue;
      default:
        continue;
    }
    refresh();
    napms(delay_ms);
  } while (choice != choice_exit);

  endwin();

  return 0;
}
