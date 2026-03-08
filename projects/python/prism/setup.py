import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="prism_mauro_j_sanchirico_iii",
    version="0.0.1",
    author="Mauro J. Sanchirico III",
    author_email="sanchirico.mauro@gmail.com",
    description="Prism AI experiments and algorithms",
    long_description=long_description,
    long_description_content_type="text/markdown",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    package_dir={"": "src"},
    packages=setuptools.find_packages(where="src"),
    python_requires=">=3.6",
)
