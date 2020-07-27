SHELL = /bin/bash

PRESS_COLOR_MODE := $(shell gawk 'BEGIN{mode="RGB"}/^[ \t]*\\PassOptionsToPackage{gray}{xcolor}/{mode="BW"}END{print mode}' ../../src/template/phdthesis.cls)

blender := $(shell { which blender /Applications/blender.app/Contents/MacOS/blender; echo blender; } | head -n 1 )

# $(call getpage,input.pdf,output.png,pagenr)
getpage = gs -q -dSAFER -dBATCH -dNOPAUSE -dDOINTERPOLATE -sDEVICE=png16m -r300 -dTextAlphaBits=4 -dFirstPage=$(3) -dLastPage=$(3) -sOutputFile=$(2) $(1)

PAGES = $(addsuffix .png,page1 page2 page3 page4 page5 page6 page7)
COVER = ../../src/cover/cover-front.png 

.PHONY: all render conver ignore-no-blender clean dist-clean
all: render

render: art_digital.png art_press.png

placeholder: clean | $(COVER)
	@if which $(blender) >/dev/null 2>&1; then					\
		cp $| art_digital.png;									\
		cp $| art_press.png;									\
	fi

test-blender:
	@which $(blender) >/dev/null 2>&1

ignore-no-blender:
	@if which $(blender) >/dev/null 2>&1; then					\
		$(MAKE) render;											\
	else														\
		echo 'Safely ignoring art work, blender is missing...';	\
	fi

page1.png: kernel.pdf Makefile
	$(call getpage,$<,$@,5)

page2.png: Makefile.pdf Makefile
	$(call getpage,$<,$@,3)

page3.png: plb2bus.pdf Makefile
	$(call getpage,$<,$@,1)

page4.png: ptr.pdf Makefile
	$(call getpage,$<,$@,2)

page5.png: temp.pdf Makefile
	$(call getpage,$<,$@,1)

page6.png: thesis_outline.pdf Makefile
	$(call getpage,$<,$@,1)

page7.png: kernel.pdf Makefile
	$(call getpage,$<,$@,2)

cover: $(COVER)

$(COVER):
	$(MAKE) -C $(@D) $(@F)

art_digital.py: Makefile
	@{																									\
		echo 'import bpy';																				\
		echo 'bpy.data.scenes["Scene"].render.image_settings.file_format = '\''PNG'\';					\
		echo 'bpy.data.scenes["Scene"].render.image_settings.color_mode = '\''RGB'\';					\
		echo 'bpy.data.scenes["Scene"].render.filepath = '\''//art_digital'\';							\
		echo 'bpy.data.scenes["Scene"].render.resolution_percentage = 33';								\
		echo 'bpy.ops.render.render( write_still=True )';												\
	} > $@

art_press.py: Makefile
	@{																									\
		echo 'import bpy';																				\
		echo 'bpy.data.scenes["Scene"].render.image_settings.file_format = '\''PNG'\';					\
		echo 'bpy.data.scenes["Scene"].render.image_settings.color_mode = '\''$(PRESS_COLOR_MODE)'\';	\
		echo 'bpy.data.scenes["Scene"].render.filepath = '\''//art_press'\';							\
		echo 'bpy.data.scenes["Scene"].render.resolution_percentage = 100';								\
		echo 'bpy.ops.render.render( write_still=True )';												\
	} > $@

art_%.png: thesis.blend art_%.py $(PAGES) $(COVER) 
	$(blender) -b $< -P art_$*.py

clean:
	-rm $(addsuffix .png,$(PAGES)) art_{digital,press}.py

dist-clean: clean
	-rm art_{digital,press}.png

