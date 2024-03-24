all: build clean check
.PHONY: build

build = ./build
target_elights = ${build}/elights.sh
path_helpers = ./src/helpers
path_core = ./src/core
echo_ok = echo "OK.\n"
default_scenes_source = ~/.elights_scenes.ini
fragment_scenes = ${build}/scenes.txt
fragment_scene_cases = ${build}/scene_cases.txt
fragment_warnings = ${build}/warnings.txt
guide = ${build}/guide.txt

build:
	@mkdir -p ./build
	@read -p "Path to your scenes.ini [${default_scenes_source}]: " scenes_source; \
		[ -z "$$scenes_source" ] && scenes_source=${default_scenes_source}; \
		! [ -f "$$scenes_source" ] && echo "No such file found: $$scenes_source. Aborting." && exit 1; \
		sh scenes_builder.sh \
		--source $$scenes_source \
		--scenes ${fragment_scenes} \
		--scene-cases ${fragment_scene_cases} \
		--warnings ${fragment_warnings} \
		--guide ${guide}
	@echo "Building ./build/elights.sh"
	@cp ${path_core}/set_scene.sh ${build}/
	@sed -i "" -e '/\s*## placeholder scenes/r ${fragment_scenes}' -e '/\s*## placeholder scenes/d' ${build}/set_scene.sh
	@echo "#!/usr/bin/env bash\n" > ${target_elights}
	@cat ${fragment_warnings} >> ${target_elights}
	@echo >> ${target_elights}
	@cat ${path_core}/elights.sh >> ${target_elights}
	@sed -i "" -e '/\s*## placeholder scene_cases/r ${fragment_scene_cases}' -e '/\s*## placeholder scene_cases/d' ${target_elights}
	@sed -i "" -e '/\s*## function helpers\/print_stacktrace.sh/r ${path_helpers}/print_stacktrace.sh' -e '/\s*## function helpers\/print_stacktrace.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function helpers\/print_func_name.sh/r ${path_helpers}/print_func_name.sh' -e '/\s*## function helpers\/print_func_name.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function core\/set_scene.sh/r ${build}/set_scene.sh' -e '/\s*## function core\/set_scene.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function core\/change_lamp.sh/r ${path_core}/change_lamp.sh' -e '/\s*## function core\/change_lamp.sh/d' ${target_elights}
	@sed -i "" -e '/\s*## function core\/print_help.sh/r ${path_core}/print_help.sh' -e '/\s*## function core\/print_help.sh/d' ${target_elights}
	@${echo_ok}

	@echo "Copying ${build}/scene.sh"
	@cp ./src/scene.sh ${build}/
	@${echo_ok}
	@cat ${guide}

clean:
#	@rm ${fragment_scenes}
#	@rm ${build}/set_scene.sh
#	@rm ${build}/scene_cases.txt
#	@rm ${build}/warnings.txt
#	@rm ${guide}

check:
	@echo "Build finished:\n"
	ls -lAhtr ${build}
