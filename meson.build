# project name and programming language
project('com.github.tvale.xkcdesktop', 'vala', 'c')

vapi_dir = join_paths(meson.current_source_dir(), 'vapi')

libxkcd_project = subproject('libxkcd')
libxkcd_dep = libxkcd_project.get_variable('libxkcd_dep')
libxkcd_vapi = meson.get_compiler('vala').find_library('libxkcd', dirs: vapi_dir)

executable(
    meson.project_name(),
    sources: [
        'src/Backend.vala',
        'src/NavigationButtons.vala',
        'src/SearchEntry.vala',
        'src/ZoomMode.vala',
        'src/Image.vala',
        'src/Overlay.vala',
        'src/MainWindow.vala',
        'src/Application.vala'
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
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

install_data (
    join_paths('data', meson.project_name() + '.gschema.xml'),
    install_dir: join_paths (get_option ('datadir'), 'glib-2.0', 'schemas'),
)
