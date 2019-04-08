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
public class Xkcd.Backend : Object {
    public signal void changed ();
    public signal void failed ();

    private delegate void JobFunction ();
    private class Job {
        private JobFunction function;
        private SourceFunc callback;

        public Job (owned JobFunction function, owned SourceFunc callback) {
            this.function = (owned)function;
            this.callback = (owned)callback;
        }

        public void execute () {
            function ();
            Idle.add ((owned)callback);
        }
    }
    private ThreadPool<Job> worker;
    private Xkcd.Handle xkcd;

    public Backend () {
        xkcd = new Xkcd.Handle ();
        try {
            worker = new ThreadPool<Job>.with_owned_data ((job) => { job.execute (); }, 1, false);
        } catch (ThreadError e) {
            error ("Could not create background worker thread.");
        }
    }

    public void latest () {
        fetch_latest.begin ((obj, res) => {
            var error_code = fetch_latest.end (res);
            fire_signal (error_code);
        });
    }

    private async Xkcd.ErrorCode fetch_latest () {
        var error_code = Xkcd.ErrorCode.ERROR;
        try {
            worker.add (new Job (() => { error_code = xkcd.latest (); }, fetch_latest.callback));
            yield;
        } catch (ThreadError e) {}
        return error_code;
    }

    public void jump_to (string comic_id) {
        fetch_comic.begin (comic_id, (obj, res) => {
            var error_code = fetch_comic.end (res);
            fire_signal (error_code);
        });
    }

    private async Xkcd.ErrorCode fetch_comic (string comic_id) {
        var error_code = Xkcd.ErrorCode.ERROR;
        try {
            worker.add (new Job (() => { error_code = xkcd.jump_to (comic_id); }, fetch_comic.callback));
            yield;
        } catch (ThreadError e) {}
        return error_code;
    }

    public bool has_previous () {
        return xkcd.has_previous ();
    }

    public void previous () {
        fetch_previous.begin ((obj, res) => {
            var error_code = fetch_previous.end (res);
            fire_signal (error_code);
        });
    }

    private async Xkcd.ErrorCode fetch_previous () {
        var error_code = Xkcd.ErrorCode.ERROR;
        try {
            worker.add (new Job (() => { error_code = xkcd.previous (); }, fetch_previous.callback));
            yield;
        } catch (ThreadError e) {}
        return error_code;
    }

    public bool has_next () {
        return xkcd.has_next ();
    }

    public void next () {
        fetch_next.begin ((obj, res) => {
            var error_code = fetch_next.end (res);
            fire_signal (error_code);
        });
    }

    private async Xkcd.ErrorCode fetch_next () {
        var error_code = Xkcd.ErrorCode.ERROR;
        try {
            worker.add (new Job (() => { error_code = xkcd.next (); }, fetch_next.callback));
            yield;
        } catch (ThreadError e) {}
        return error_code;
    }

    public string get_id () {
        string comic_id;
        xkcd.get_id (out comic_id);
        return comic_id;
    }

    public uint8[] get_comic () {
        uint8[] image_data;
        xkcd.get_comic (out image_data);
        return image_data;
    }

    public string get_text () {
        string text;
        xkcd.get_text (out text);
        return text;
    }

    private void fire_signal (Xkcd.ErrorCode error_code) {
        switch (error_code) {
            case Xkcd.ErrorCode.OK:
                changed ();
                break;
            case Xkcd.ErrorCode.ERROR:
                failed ();
                break;
        }
    }
}
