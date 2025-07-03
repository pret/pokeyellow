IF !DEF(__RGBDS_MAJOR__) || !DEF(__RGBDS_MINOR__) || !DEF(__RGBDS_PATCH__)
	fail "pokeyellow requires rgbds v0.9.3 or newer."
ENDC
IF __RGBDS_MAJOR__ == 0 && (__RGBDS_MINOR__ < 9 || (__RGBDS_MINOR__ == 9 && __RGBDS_PATCH__ < 3))
	fail "pokeyellow requires rgbds v0.9.3 or newer."
ENDC
