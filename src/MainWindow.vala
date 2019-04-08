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
public class Xkcd.MainWindow : Gtk.ApplicationWindow {
    private uint configure_id;
    private Xkcd.NavigationButtons comic_navigation;
    private Xkcd.SearchEntry comic_search;
    private Xkcd.ZoomMode comic_zoom;
    private Xkcd.Overlay information_overlay;

    public MainWindow (Xkcd.Application application) {
        Object (
            application: application
        );

        title = "xkcdesktop";

        var header_bar = new Gtk.HeaderBar ();
        header_bar.show_close_button = true;
        set_titlebar (header_bar);

        comic_navigation = new Xkcd.NavigationButtons ();
        header_bar.pack_start (comic_navigation);

        comic_search = new Xkcd.SearchEntry ();
        header_bar.set_custom_title (comic_search);

        comic_zoom = new Xkcd.ZoomMode (application.settings);
        header_bar.pack_end (comic_zoom);

        information_overlay = new Xkcd.Overlay ();
        add (information_overlay);

        var comic_image = new Xkcd.Image ();
        information_overlay.add (comic_image);

        comic_navigation.previous.connect (() => {
            begin_work ();
            application.xkcd_backend.previous ();
        });
        comic_navigation.next.connect (() => {
            begin_work ();
            application.xkcd_backend.next ();
        });
        comic_navigation.last.connect (() => {
            begin_work ();
            application.xkcd_backend.latest ();
        });
        comic_search.change.connect ((comic_id) => {
            begin_work ();
            application.xkcd_backend.jump_to (comic_id);
        });
        comic_zoom.change.connect ((zoom) => {
            comic_image.resize_comic (zoom);
        });
        comic_image.size_allocate.connect ((allocation) => {
            comic_image.resize_comic (comic_zoom.active_zoom_type);
        });
        application.xkcd_backend.changed.connect (() => {
            uint8[] image_data = application.xkcd_backend.get_comic ();
            string text = application.xkcd_backend.get_text ();
            string comic_id = application.xkcd_backend.get_id ();

            try {
                comic_image.new_comic (image_data, text, comic_zoom.active_zoom_type);
                comic_search.set_text (comic_id);
                application.settings.set_string ("current-comic-id", comic_id);
            } catch (Error e) {
                information_overlay.notify_image_error ();
            } finally {
                work_done ();
                comic_navigation.set_previous_sensitive (application.xkcd_backend.has_previous ());
                comic_navigation.set_next_sensitive (application.xkcd_backend.has_next ());
                comic_search.set_entry_sensitive (true);
                comic_zoom.set_mode_sensitive (true);
            }
        });
        application.xkcd_backend.failed.connect (() => {
            information_overlay.notify_download_error ();
            work_done ();
        });

        int window_x, window_y;
        application.settings.get ("window-position", "(ii)", out window_x, out window_y);
        move (window_x, window_y);

        var rect = Gtk.Allocation ();
        application.settings.get ("window-size", "(ii)", out rect.width, out rect.height);
        set_allocation (rect);

        if (application.settings.get_boolean ("window-maximized")) {
            maximize ();
        }
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        if (configure_id != 0) {
            Source.remove (configure_id);
        }

        configure_id = Timeout.add (100, () => {
            configure_id = 0;

            var application = (Xkcd.Application)get_application ();

            if (is_maximized) {
                application.settings.set_boolean ("window-maximized", true);
            } else {
                application.settings.set_boolean ("window-maximized", false);

                Gdk.Rectangle rect;
                get_allocation (out rect);
                application.settings.set ("window-size", "(ii)", rect.width, rect.height);

                int root_x, root_y;
                get_position (out root_x, out root_y);
                application.settings.set ("window-position", "(ii)", root_x, root_y);
            }

            return Source.REMOVE;
        });

        return base.configure_event (event);
    }

    public void begin_work () {
        comic_navigation.set_previous_sensitive (false);
        comic_navigation.set_next_sensitive (false);
        comic_navigation.set_last_sensitive (false);
        comic_search.set_entry_sensitive (false);
        comic_zoom.set_mode_sensitive (false);
        information_overlay.inform_work ("Downloading comic.");
    }

    private void work_done () {
        comic_navigation.set_previous_sensitive (true);
        comic_navigation.set_next_sensitive (true);
        comic_navigation.set_last_sensitive (true);
        comic_search.set_entry_sensitive (true);
        comic_zoom.set_mode_sensitive (true);
        information_overlay.work_done ();
    }
}
