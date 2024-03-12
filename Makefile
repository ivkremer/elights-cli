.PHONY: build

target_elights = ./build/elights.sh
path_helpers = ./src/helpers
path_core = ./src/elights
echo_ok = echo "OK.\n"

build:
	@echo "Building ./build/elights.sh"
	@mkdir -p ./build
	@echo "#!/usr/bin/env bash\n" > ${target_elights}
	@cat ${path_helpers}/print_stacktrace.sh >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_helpers}/current_func_name.sh >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_core}/no_vars_warning.sh >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_core}/set_scene.sh >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_core}/change_lamp.sh >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_core}/elights.sh >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_core}/print_help.sh >> ${target_elights}
	@${echo_ok}
	@echo "Copying ./build/scene.sh"
	@cp ./src/scene.sh ./build/
	@${echo_ok}
	@echo "Build finished:\n"
	ls -lAGht ./build
