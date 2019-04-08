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
public class Xkcd.Image : Gtk.Grid {
    private Gtk.ScrolledWindow scrolled_window;
    private Gtk.Image image;
    private Gdk.Pixbuf pixbuf_original;
    private Gdk.Pixbuf pixbuf;

    public Image () {
        scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.vexpand = true;
        scrolled_window.hexpand = true;
        add (scrolled_window);

        image = new Gtk.Image ();
        scrolled_window.add (image);

        pixbuf_original = new Gdk.Pixbuf (Gdk.Colorspace.RGB, false, 8, 1, 1);
        pixbuf = pixbuf_original;
    }

    public void new_comic (uint8[] image_data, string tooltip, Xkcd.ZoomMode.Type zoom) throws Error {
        var pixbuf_loader = new Gdk.PixbufLoader ();
        try {
            pixbuf_loader.write (image_data);
            pixbuf_loader.close ();
            pixbuf_original = pixbuf_loader.get_pixbuf ();
            pixbuf = pixbuf_original;

            resize_comic (zoom);

            image.tooltip_text = tooltip;
        } catch (Error e) {
            throw e;
        }
    }

    public void resize_comic (Xkcd.ZoomMode.Type zoom) {
        Gtk.Allocation allocation;
        scrolled_window.get_allocation (out allocation);

        var pixbuf_too_big = (pixbuf_original.width > allocation.width || pixbuf_original.height > allocation.height);
        var zoom_fit = (zoom == Xkcd.ZoomMode.Type.FIT);
        var pixbuf_needs_scaling = (pixbuf_too_big && zoom_fit);
        if (pixbuf_needs_scaling) {
            var new_width = 0.0;
            var new_height = 0.0;
            var original_ratio = pixbuf_original.width * 1.0 / pixbuf_original.height;
            var target_ratio = allocation.width * 1.0 / allocation.height;
            if (original_ratio > target_ratio) {
                new_width = allocation.width;
                new_height = allocation.width / original_ratio;
            } else {
                new_width = allocation.height * original_ratio;
                new_height = allocation.height;
            }
            pixbuf = pixbuf_original.scale_simple ((int)new_width, (int)new_height, Gdk.InterpType.BILINEAR);
        } else {
            pixbuf = pixbuf_original;
        }

        image.set_from_pixbuf (pixbuf);
    }
}
