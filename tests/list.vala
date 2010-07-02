void test_list_int_empty () {
	List<int> list = [];
	assert (list.length == 0);
}

void test_list_int_one () {
	List<int> list = [42];
	assert (list.length == 1);
	assert (list[0] == 42);
}

void test_list_int_two () {
	List<int> list = [42, 23];
	assert (list.length == 2);
	assert (list[0] == 42);
	assert (list[1] == 23);
}

void test_list_int_concat () {
	List<int> list1 = [42];
	List<int> list2 = [23];
	List<int> list = list1 + list2;
	assert (list.length == 2);
	assert (list[0] == 42);
	assert (list[1] == 23);
}

void test_list () {
	test_list_int_empty ();
	test_list_int_one ();
	test_list_int_two ();
	test_list_int_concat ();
}
