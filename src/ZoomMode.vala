/*
  xkcdesktop
  Copyright (C) 2019, Tiago Vale

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
public class Xkcd.ZoomMode : Gtk.Grid {
    public enum Type {
        FIT = 0,
        ORIGINAL = 1
    }

    public signal void change (Type type);

    public Type active_zoom_type { get; private set; default = Type.FIT; }

    private Granite.Widgets.ModeButton zoom_mode;

    public ZoomMode (Settings settings) {
        orientation = Gtk.Orientation.HORIZONTAL;
        valign = Gtk.Align.CENTER;

        zoom_mode = new Granite.Widgets.ModeButton ();
        zoom_mode.append_icon ("zoom-fit-best-symbolic", Gtk.IconSize.BUTTON);
        zoom_mode.append_icon ("zoom-original-symbolic", Gtk.IconSize.BUTTON);
        settings.bind ("zoom-mode", zoom_mode, "selected", SettingsBindFlags.DEFAULT);
        active_zoom_type = (Type)zoom_mode.selected;
        set_mode_sensitive (false);
        add (zoom_mode);

        zoom_mode.mode_changed.connect ((widget) => {
            switch (zoom_mode.selected) {
                case 0:
                    active_zoom_type = Type.FIT;
                    break;
                case 1:
                    active_zoom_type = Type.ORIGINAL;
                    break;
            }
            change (active_zoom_type);
        });
    }

    public void set_mode_sensitive (bool sensitive) {
        zoom_mode.sensitive = sensitive;
    }
}
