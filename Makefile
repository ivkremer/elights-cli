.PHONY: build

target_elights = ./build/elights.sh
path_helpers = ./src/helpers
path_core = ./src/core
echo_ok = echo "OK.\n"

build:
	@echo "Building ./build/elights.sh"
	@mkdir -p ./build
	@echo "#!/usr/bin/env bash\n" > ${target_elights}
	@cat ${path_core}/no_vars_warning.sh >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_core}/elights.sh >> ${target_elights}
	@sed -i "" -e '/\s*## function helpers\/print_stacktrace.sh/r ${path_helpers}/print_stacktrace.sh' -e '/\s*## function helpers\/print_stacktrace.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function helpers\/print_func_name.sh/r ${path_helpers}/print_func_name.sh' -e '/\s*## function helpers\/print_func_name.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function core\/set_scene.sh/r ${path_core}/set_scene.sh' -e '/\s*## function core\/set_scene.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function core\/change_lamp.sh/r ${path_core}/change_lamp.sh' -e '/\s*## function core\/change_lamp.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function core\/print_help.sh/r ${path_core}/print_help.sh' -e '/\s*## function core\/print_help.sh/d' ${target_elights}
	@${echo_ok}
	@echo "Copying ./build/scene.sh"
	@cp ./src/scene.sh ./build/
	@${echo_ok}
	@echo "Build finished:\n"
	ls -lAGht ./build
