# FiveLinux makefile

all : ./lib/libfive.a ./lib/libfivex.a ./lib/libfivec.a

PRG_OBJS = ./obj/bar.o        \
           ./obj/button.o     \
           ./obj/checkbox.o   \
	   ./obj/combobox.o   \
	   ./obj/control.o    \
	   ./obj/database.o   \
	   ./obj/dbtools.o    \
	   ./obj/dialog.o     \
	   ./obj/errsys.o     \
	   ./obj/file.o       \
	   ./obj/filename.o   \
	   ./obj/folder.o     \
	   ./obj/font.o       \
	   ./obj/form.o       \
	   ./obj/get.o        \
	   ./obj/group.o      \
	   ./obj/harbour.o    \
	   ./obj/image.o      \
	   ./obj/ini.o        \
	   ./obj/listbox.o    \
           ./obj/memoedit.o   \
	   ./obj/menu.o       \
	   ./obj/menuitem.o   \
	   ./obj/mget.o       \
	   ./obj/msgbar.o     \
	   ./obj/pdmenu.o     \
	   ./obj/printer.o    \
	   ./obj/progres.o    \
	   ./obj/radio.o      \
	   ./obj/radmenu.o    \
	   ./obj/say.o        \
	   ./obj/scrollbar.o  \
	   ./obj/timer.o      \
	   ./obj/valblank.o   \
	   ./obj/wbrowse.o    \
	   ./obj/wbcolumn.o   \
           ./obj/window.o

PRGX_OBJS = ./objx/bar.o        \
           ./objx/button.o     \
           ./objx/checkbox.o   \
	   ./objx/combobox.o   \
	   ./objx/control.o    \
	   ./objx/dialog.o     \
	   ./objx/errsys.o     \
	   ./objx/file.o       \
	   ./objx/folder.o     \
	   ./objx/font.o       \
	   ./objx/form.o       \
	   ./objx/get.o        \
	   ./objx/group.o      \
	   ./objx/harbour.o    \
	   ./objx/image.o      \
	   ./objx/listbox.o    \
	   ./objx/menu.o       \
	   ./objx/menuitem.o   \
	   ./objx/mget.o       \
	   ./objx/msgbar.o     \
	   ./objx/pdmenu.o     \
	   ./objx/printer.o    \
	   ./objx/progres.o    \
	   ./objx/radio.o      \
	   ./objx/radmenu.o    \
	   ./objx/say.o        \
	   ./objx/scrollbar.o  \
	   ./objx/timer.o      \
	   ./objx/valblank.o   \
	   ./objx/wbrowse.o    \
	   ./objx/wbcolumn.o   \
           ./objx/window.o

C_OBJS = ./objc/bars.o        \
         ./objc/buttons.o     \
         ./objc/checkboxes.o  \
	 ./objc/comboboxes.o  \
	 ./objc/dialogs.o     \
	 ./objc/files.o       \
	 ./objc/folders.o     \
	 ./objc/fonts.o       \
	 ./objc/getcolor.o    \
	 ./objc/getfile.o     \
	 ./objc/getfont.o     \
	 ./objc/gets.o        \
	 ./objc/groups.o      \
	 ./objc/images.o      \
	 ./objc/listboxes.o   \
         ./objc/lnx.o         \
         ./objc/menus.o       \
	 ./objc/mgets.o       \
	 ./objc/mouse.o       \
	 ./objc/msgbars.o     \
         ./objc/msgbox.o      \
	 ./objc/printers.o    \
	 ./objc/progress.o    \
	 ./objc/radios.o      \
	 ./objc/says.o        \
	 ./objc/scrollbars.o  \
	 ./objc/spawn.o       \
         ./objc/strtoken.o    \
         ./objc/wbrowses.o    \
	 ./objc/windows.o


./lib/libfive.a  : $(PRG_OBJS)
./lib/libfivex.a : $(PRGX_OBJS)
./lib/libfivec.a : $(C_OBJS)

./obj/%.c : ./source/classes/%.prg
	./../harbour/bin/harbour $< -o./$@ -n -I./../harbour/include -I./include

./obj/%.c : ./source/function/%.prg
	./../harbour/bin/harbour $< -o./$@ -n -I./../harbour/include -I./include

./obj/%.o : ./obj/%.c
	gcc -c -D_HARBOUR_ -o $@ -I./../harbour/include -I./include $<
	ar rc ./lib/libfive.a $@

./objx/%.c : ./source/classes/%.prg
	./../xharbour/bin/harbour $< -o./$@ -n -I./../xharbour/include -I./include

./objx/%.c : ./source/function/%.prg
	./../xharbour/bin/harbour $< -o./$@ -n -I./../xharbour/include -I./include

./objx/%.o : ./objx/%.c
	gcc -c -o $@ -I./../xharbour/include $<
	ar rc ./lib/libfivex.a $@

./objc/%.o : ./source/function/%.c
	gcc  -D_HARBOUR_ `pkg-config --cflags gtk+-2.0` `pkg-config --cflags libgnomeprintui-2.2` -I./../harbour/include -I./include -Wall -c -o $@ $<
	ar rc ./lib/libfivec.a $@

./objc/%.o : ./source/winapi/%.c
	gcc -D_HARBOUR_ `pkg-config --cflags gtk+-2.0` `pkg-config --cflags libgnomeprintui-2.2` -I./../harbour/include -I./include -Wall -c -o $@ $<
	ar rc ./lib/libfivec.a $@

./objc/%.o : ./source/internal/%.c
	gcc -D_HARBOUR_ `pkg-config --cflags gtk+-2.0` `pkg-config --cflags libglade-2.0` -I./../harbour/include -I./include -Wall -c -o $@ $<
	ar rc ./lib/libfivec.a $@