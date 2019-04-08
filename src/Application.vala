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
public class Xkcd.Application : Granite.Application {
    public Xkcd.Backend xkcd_backend = new Xkcd.Backend ();
    public Settings settings = new Settings ("com.github.tvale.xkcdesktop");

    public Application () {
        Object (
            application_id: "com.github.tvale.xkcdesktop",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var main_window = new MainWindow (this);

        main_window.show_all ();

        main_window.begin_work ();

        string comic_id = settings.get_string ("current-comic-id");
        xkcd_backend.jump_to (comic_id);
   }

    public static int main (string[] args) {
        Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;

        var app = new Xkcd.Application ();
        return app.run (args);
    }
}
