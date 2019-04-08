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
public class Xkcd.Overlay : Gtk.Overlay {
    private Granite.Widgets.Toast image_error_toast;
    private Granite.Widgets.Toast download_error_toast;
    private Granite.Widgets.OverlayBar information_bar;

    public Overlay () {
        image_error_toast = new Granite.Widgets.Toast ("Error showing xkcd comic.");
        add_overlay (image_error_toast);

        download_error_toast = new Granite.Widgets.Toast ("Error downloading xkcd comic.");
        add_overlay (download_error_toast);

        information_bar = new Granite.Widgets.OverlayBar (this);
    }

    public void notify_image_error () {
        image_error_toast.send_notification ();
    }

    public void notify_download_error () {
        download_error_toast.send_notification ();
    }

    public void inform_work (string message) {
        information_bar.active = true;
        information_bar.label = message;
        information_bar.visible = true;
    }

    public void work_done () {
        information_bar.active = false;
        information_bar.visible = false;
    }
}
