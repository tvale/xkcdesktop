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
public class Xkcd.SearchEntry : Gtk.Grid {
    public signal void change (string comic_id);

    private Gtk.Entry entry_id;

    public SearchEntry () {
        orientation = Gtk.Orientation.HORIZONTAL;
        valign = Gtk.Align.CENTER;

        entry_id = new Gtk.Entry ();
        entry_id.placeholder_text = "Latest";
        entry_id.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "edit-find-symbolic");
        set_entry_sensitive (false);
        add (entry_id);

        entry_id.activate.connect (() => {
            change (entry_id.text);
        });
    }

    public void set_text (string text) {
        entry_id.set_text (text);
    }

    public void set_entry_sensitive (bool sensitive) {
        entry_id.sensitive = sensitive;
    }
}
