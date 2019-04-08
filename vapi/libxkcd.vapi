[CCode(cheader_filename="xkcd.h")]
namespace Xkcd {
    [CCode (cname = "enum xkcd_error_code", cprefix = "XKCD_", has_type_id = false)]
    public enum ErrorCode {
        OK = 0,
        ERROR
    }

    [CCode(cname="struct xkcd", free_function="xkcd_free")]
    [Compact]
    public class Handle {
        [CCode(cname="xkcd_new")]
        public Handle ();

        [CCode(cname="xkcd_latest")]
        public ErrorCode latest ();

        [CCode(cname="xkcd_jump_to")]
        public ErrorCode jump_to (string comic_id);

        [CCode(cname="xkcd_has_previous")]
        public bool has_previous ();

        [CCode(cname="xkcd_previous")]
        public ErrorCode previous ();

        [CCode(cname="xkcd_has_next")]
        public bool has_next ();

        [CCode(cname="xkcd_next")]
        public ErrorCode next ();

        [CCode(cname="xkcd_get_id")]
        public ErrorCode get_id (out string comic_id);

        [CCode(cname="xkcd_get_text")]
        public ErrorCode get_text (out string text);

        [CCode(cname="xkcd_get_comic")]
        public ErrorCode get_comic ([CCode(array_length_type="size_t")] out uint8[] image);
    }
}
