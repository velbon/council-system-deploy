from setuptools import setup, find_packages

setup(
    name="council-system-dashboard",
    version="1.0.0",
    description="Sierra Leone Council Dashboard System",
    packages=find_packages(),
    install_requires=[
        "flask==3.0.0",
        "gunicorn==21.2.0",
    ],
    python_requires=">=3.11",
)
