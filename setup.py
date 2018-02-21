#!/usr/bin/env python
install_requires = ['numpy']
tests_require=['nose','coveralls']
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
      'Intended Audience :: Science/Research',
      'Development Status :: 4 - Beta',
      'License :: OSI Approved :: MIT License',
      'Topic :: Scientific/Engineering :: Visualization',
      'Programming Language :: Python :: 3',
      ],
      install_requires=install_requires,
      tests_require=tests_require,
      extras_require={'tests':tests_require},
      python_requires='>=2.7',
	  )
