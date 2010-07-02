void test_string_join () {
	assert (",".join ([]) == "");
	assert (",".join (["1"]) == "1");
	assert (",".join (["1", "2", "3"]) == "1,2,3");
}

void test_string () {
	test_string_join ();
}
