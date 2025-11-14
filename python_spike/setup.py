from setuptools import setup, find_packages

setup(
    name="pentest-asset-model",
    version="0.1.0",
    description="Comprehensive asset model for penetration testing activities",
    author="Madness Team",
    packages=find_packages(),
    install_requires=[
        "pydantic>=2.0.0",
        "ipaddress>=1.0.23",
        "python-dateutil>=2.8.2",
        "pyyaml>=6.0",
        "networkx>=3.0",
        "typing-extensions>=4.5.0",
    ],
    python_requires=">=3.9",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
)
