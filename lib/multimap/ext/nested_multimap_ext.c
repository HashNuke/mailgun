#include "ruby.h"

VALUE cNestedMultimap;

static VALUE rb_nested_multimap_aref(int argc, VALUE *argv, VALUE self)
{
	int i;
	VALUE r, h;

	for (i = 0, r = self; rb_obj_is_kind_of(r, cNestedMultimap) == Qtrue; i++) {
		h = rb_funcall(r, rb_intern("_internal_hash"), 0);
		Check_Type(h, T_HASH);
		r = (i < argc) ? rb_hash_aref(h, argv[i]) : RHASH(h)->ifnone;
	}

	return r;
}

void Init_nested_multimap_ext() {
	cNestedMultimap = rb_const_get(rb_cObject, rb_intern("NestedMultimap"));
	// rb_funcall(cNestedMultimap, rb_intern("remove_method"), 1, rb_intern("[]"));
	rb_eval_string("NestedMultimap.send(:remove_method, :[])");
	rb_define_method(cNestedMultimap, "[]", rb_nested_multimap_aref, -1);
}
