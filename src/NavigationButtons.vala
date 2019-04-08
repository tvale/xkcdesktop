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
public class Xkcd.NavigationButtons : Gtk.Grid {
    public signal void previous ();
    public signal void next ();
    public signal void last ();

    private Gtk.Button button_previous;
    private Gtk.Button button_next;
    private Gtk.Button button_last;

    public NavigationButtons () {
        orientation = Gtk.Orientation.HORIZONTAL;
        valign = Gtk.Align.CENTER;

        var grid = new Gtk.Grid ();
        grid.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        add (grid);

        button_previous = new Gtk.Button.from_icon_name ("go-previous-symbolic", Gtk.IconSize.BUTTON);
        button_previous.get_style_context ().remove_class ("image-button");
        set_previous_sensitive (false);
        grid.add (button_previous);

        button_next = new Gtk.Button.from_icon_name ("go-next-symbolic", Gtk.IconSize.BUTTON);
        button_next.get_style_context ().remove_class ("image-button");
        set_next_sensitive (false);
        grid.add (button_next);

        button_last = new Gtk.Button.from_icon_name ("go-last-symbolic", Gtk.IconSize.BUTTON);
        add (button_last);

        button_previous.clicked.connect (() => {
            previous ();
        });
        button_next.clicked.connect (() => {
            next ();
        });
        button_last.clicked.connect (() => {
            last ();
        });
    }

    public void set_previous_sensitive (bool sensitive) {
        button_previous.sensitive = sensitive;
    }

    public void set_next_sensitive (bool sensitive) {
        button_next.sensitive = sensitive;
    }

    public void set_last_sensitive (bool sensitive) {
        button_last.sensitive = sensitive;
    }
}
