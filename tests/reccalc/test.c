muscle_insert("file_name",
              (
                  __extension__({
                      struct obstack *__o = (&muscle_obstack);
                      if (__extension__({
                              struct obstack const *__o1 = (__o);
                              (size_t)(__o1->chunk_limit - __o1->next_free);
                          }) < 1)
                          _obstack_newchunk(__o, 1);
                      ((void)(*((__o)->next_free)++ = ('\0')));
                  }),
                  (char *)__extension__({
                      struct obstack *__o1 = (&muscle_obstack);
                      void *__value = (void *)__o1->object_base;
                      if (__o1->next_free == __value)
                          __o1->maybe_empty_object = 1;
                      __o1->next_free = ((sizeof(ptrdiff_t) < sizeof(void *)
                                              ? (__o1->object_base)
                                              : (char *)0) +
                                         (((__o1->next_free) - (sizeof(ptrdiff_t) < sizeof(void *) ? (__o1->object_base) : (char *)0) + (__o1->alignment_mask)) & ~(__o1->alignment_mask)));
                      if ((size_t)(__o1->next_free - (char *)__o1->chunk) > (size_t)(__o1->chunk_limit - (char *)__o1->chunk))
                          __o1->next_free = __o1->chunk_limit;
                      __o1->object_base = __o1->next_free;
                      __value;
                  })

                      ));
