project('lineclip', 'fortran',
  version: '1.0.0',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=3'])

fc = meson.get_compiler('fortran')

std18 = fc.first_supported_argument(['-std=f2018', '-stand f18', '/stand:f18'])
add_project_arguments(std18, language : 'fortran')

assert_lib = library('assert',
  sources: ['assert.f90'])

lineclip_lib = library('lineclip', 'lineclipping.f90',
  link_with: [assert_lib])

lineclip_exe = executable('RunLineclip', 'DemoLineclip.f90',
  link_with: [lineclip_lib, assert_lib])

test('clip', lineclip_exe, timeout: 10)

# -- coarray

coarrays = dependency('coarray', required: false, disabler: true)

CoarrayLineclip_exe = executable('CoarrayLineclip', 'DemoCoarrayLineclip.f90',
  link_with: [assert_lib, lineclip_lib],
  dependencies: coarrays)
cafrun = find_program('cafrun', required: false)
test('CoarrayClip', cafrun,
  args: CoarrayLineclip_exe,
  timeout: 10)
