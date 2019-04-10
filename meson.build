# project name and programming language
project('com.github.tvale.xkcdesktop', 'vala', 'c')

vapi_dir = join_paths(meson.current_source_dir(), 'vapi')

libxkcd_project = subproject('libxkcd')
libxkcd_dep = libxkcd_project.get_variable('libxkcd_dep')
libxkcd_vapi = meson.get_compiler('vala').find_library('libxkcd', dirs: vapi_dir)

executable(
    meson.project_name(),
    sources: [
        join_paths('src', 'Backend.vala'),
        join_paths('src', 'NavigationButtons.vala'),
        join_paths('src', 'SearchEntry.vala'),
        join_paths('src', 'ZoomMode.vala'),
        join_paths('src', 'Image.vala'),
        join_paths('src', 'Overlay.vala'),
        join_paths('src', 'MainWindow.vala'),
        join_paths('src', 'Application.vala')
    ],
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
        libxkcd_dep,
        libxkcd_vapi
    ],
    install: true
)

install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data(
    join_paths('data', meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)

install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

install_data (
    join_paths('data', meson.project_name() + '.gschema.xml'),
    install_dir: join_paths (get_option ('datadir'), 'glib-2.0', 'schemas'),
)

meson.add_install_script(join_paths('meson', 'post_install.py'))
