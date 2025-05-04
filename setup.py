from setuptools import setup, find_packages

setup(
    name='ubuntuwebscanner',
    version='1.0.0',
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        'flask',
        'nmap',
        'manuf',
        'mac-vendor-lookup',
        'aiofiles',
        'python-dotenv'
    ],
    entry_points={
        'console_scripts': [
            'runscanner=app:main',
        ],
    },
)