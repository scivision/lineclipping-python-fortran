#!/usr/bin/env python
install_requires = ['numpy']
tests_require=['pytest','nose','coveralls']
# %%
from setuptools import setup,find_packages

setup(name='pylineclip',
      packages=find_packages(),
      description='Line clipping: Cohen-Sutherland',
      long_description=open('README.rst').read(),
      version='0.9.0',
      author='Michael Hirsch, Ph.D.',
      url='https://github.com/scivision/lineclipping-python-fortran',
      classifiers=[
      'Development Status :: 4 - Beta',
      'Environment :: Console',
      'Intended Audience :: Science/Research',
      'License :: OSI Approved :: MIT License',
      'Operating System :: OS Independent',
      'Programming Language :: Python :: 2.7',
      'Programming Language :: Python :: 3.4',
      'Programming Language :: Python :: 3.5',
      'Programming Language :: Python :: 3.6',
      'Programming Language :: Python :: 3.7',
      'Topic :: Scientific/Engineering :: Visualization',
      ],
      install_requires=install_requires,
      tests_require=tests_require,
      extras_require={'tests':tests_require},
      python_requires='>=2.7',
      scripts=['DemoLineclip.py'],
      include_package_data=True,
	  )

