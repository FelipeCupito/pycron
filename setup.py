from setuptools import setup, find_packages

setup(
    name='cron_dummy',
    version='0.1.0',
    packages=find_packages(),
    install_requires=[
        'PyYAML',
    ],
    entry_points={
        'console_scripts': [
            'cron-dummy = cron_dummy.scheduler:main',
        ],
    },
)
