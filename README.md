# Raw2ometiff Conda Fork

This project is a fork of the original [raw2ometiff](https://github.com/glencoesoftware/raw2ometiff) repository, created to facilitate building and using the software within a Conda environment. The primary goal of this fork is to make the setup process easier and more accessible for users who prefer to work with Conda environments. Please note that this fork and its modifications are not affiliated with or endorsed by the original authors of the raw2ometiff project.

Please note that this fork is not the main project repository, and any issues or contributions related to the original codebase should be directed to the [original authors' project](https://github.com/glencoesoftware/raw2ometiff).

## About raw2ometiff

Raw2ometiff is a tool for converting raw images broken down by bioformats2raw into OME-tiff format for visualization.

For more information, please refer to the original [README.md](https://github.com/glencoesoftware/raw2ometiff/blob/master/README.md) file in the original repository.

## Usage and Installation

Please follow the instructions provided in this repository for installing and using the bioformats2raw tool in a Conda environment. If you have any questions or issues related to the Conda-specific setup or usage, feel free to open an issue in this forked repository.

### 1. Create your conda enviornment

`$ conda env create -f environment.yml -n bioformats2raw`

### 2. Build the Jar and create the script to executing using Gradle

`$ ./gradlew clean shadowJar createRaw2ometiffScript`

### 3. Run raw2ometiff

```
$ ./build/scripts/raw2ometiff 
Missing required parameters: <inputDirectory>, <outputFilePath>
Usage: <main class> [-p] [--legacy] [--rgb] [--version] [--debug[=<logLevel>]]
                    [--compression=<compression>] [--max_workers=<maxWorkers>]
                    [--quality=<compressionQuality>] <inputDirectory>
                    <outputFilePath>
      <inputDirectory>   Directory containing pixel data to convert
      <outputFilePath>   Relative path to the output OME-TIFF file
      --compression=<compression>
                         Compression type for output OME-TIFF file
                           (Uncompressed, LZW, JPEG-2000, JPEG-2000 Lossy,
                           JPEG, zlib; default: LZW)
      --debug, --log-level[=<logLevel>]
                         Change logging level; valid values are OFF, ERROR,
                           WARN, INFO, DEBUG, TRACE and ALL. (default: WARN)
      --legacy           Write a Bio-Formats 5.9.x pyramid instead of OME-TIFF
      --max_workers=<maxWorkers>
                         Maximum number of workers (default: 72)
      --quality=<compressionQuality>
                         Compression quality
      --rgb              Attempt to write channels as RGB; channel count must
                           be a multiple of 3
  -p, --progress         Print progress bars during conversion
      --version          Print version information and exit
```


raw2ometiff converter
=====================

Java application to convert a directory of tiles to an OME-TIFF pyramid.
This is the second half of iSyntax/.mrxs => OME-TIFF conversion.

Requirements
============

Java 8 or later is required.

libblosc (https://github.com/Blosc/c-blosc) version 1.9.0 or later must be installed separately.
The native libraries are not packaged with any relevant jars.  See also note in jzarr readme (https://github.com/bcdev/jzarr/blob/master/README.md)

 * Mac OSX: `brew install c-blosc`
 * Ubuntu 18.04+: `apt-get install libblosc1`

Installation
============

1. Download and unpack a release artifact:

    https://github.com/glencoesoftware/raw2ometiff/releases

Development Installation
========================

1. Clone the repository:

    git clone git@github.com:glencoesoftware/raw2ometiff.git

2. Run the Gradle build as required, a list of available tasks can be found by running:

    ./gradlew tasks

Configuring Logging
===================

Logging is provided using the logback library. The `logback.xml` file in `src/dist/lib/config/` provides a default configuration for the command line tool.
In release and snapshot artifacts, `logback.xml` is in `lib/config/`.
You can configure logging by editing the provided `logback.xml` or by specifying the path to a different file:

    JAVA_OPTS="-Dlogback.configurationFile=/path/to/external/logback.xml" \
    raw2ometiff ...

Alternatively you can use the `--debug` flag, optionally writing the stdout to a file:

    raw2ometiff /path/to/zarr-pyramid /path/to/file.ome.tiff --debug > raw2ometiff.log

The `--log-level` option takes an [slf4j logging level](https://www.slf4j.org/faq.html#fatal) for additional simple logging configuration.
`--log-level DEBUG` is equivalent to `--debug`. For even more verbose logging:

    raw2ometiff /path/to/zarr-pyramid /path/to/file.ome.tiff --log-level TRACE

Eclipse Configuration
=====================

1. Run the Gradle Eclipse task:

    ./gradlew eclipse

2. Add the logback configuration in `src/dist/lib/config/` to your CLASSPATH.

Usage
=====

Run the conversion (Bio-Formats 6.x):

    raw2ometiff tile_directory pyramid.ome.tiff

or generate a 5.9.x-compatible pyramid:

    raw2ometiff tile_directory pyramid.tiff --legacy

The input tile directory must contain a full pyramid in a Zarr container.

The compression can be changed using the `--compression` option.
Valid compression types are `Uncompressed`, `LZW`, `JPEG-2000`, `JPEG-2000 Lossy`, `JPEG`, and `zlib`.
By default, `LZW` compression will be used in the OME-TIFF file.

If the `--compression` option is set to `JPEG-2000 Lossy`, then
the `--quality` option can be used to control encoded bitrate in bits per pixel.
The quality is a floating point number and must be greater than 0. A larger number implies less data loss but also larger file size.
By default, the quality is set to the largest positive finite value of type double (64 bit floating point).
This is equivalent to lossless compression, i.e. setting `--compression` to `JPEG-2000`.
To see truly lossy compression, the quality should be set to less than the bit depth of the input image (e.g. less than 8 for uint8 data).
We recommend experimenting with different quality values between 0.25 and the bit depth of the input image to find an acceptable tradeoff
between file size and visual appeal of the converted images.

Tile compression is performed in parallel.  The number of workers can be changed using the `--max_workers` option.

`axes` and `transformations` metadata in the input Zarr will be ignored. This metadata is assumed to be consistent
with the corresponding `PhysicalSize*`, `TimeIncrement`, and `DimensionOrder` values in the input `METADATA.ome.xml`.

License
=======

The converter is distributed under the terms of the GPL license.
Please see `LICENSE.txt` for further details.
