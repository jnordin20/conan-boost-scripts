#!/usr/bin/env bash
# ----------------------------------------------------------------------------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2018-2020 Ralph-Gordon Paul. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ----------------------------------------------------------------------------------------------------------------------

set -e

#=======================================================================================================================
# settings

declare LIBRARY_VERSION=1.70.0

#=======================================================================================================================
# globals

declare ABSOLUTE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare IOS_SDK_VERSION=sdk$(xcodebuild -showsdks | grep iphoneos | awk '{print $4}' | sed 's/[^0-9,\.]*//g')

#=======================================================================================================================

function build()
{
    cd "${ABSOLUTE_DIR}/Apple"

    ./boost.sh -ios --min-ios-version "11.0" \
               --boost-version ${LIBRARY_VERSION} \
               --hidden-visibility \
               --universal \
               --boost-libs "chrono filesystem program_options system thread timer"

    rm -rf "${ABSOLUTE_DIR}/Apple/build/boost/${LIBRARY_VERSION}/ios/release/prefix/lib"
    mv "${ABSOLUTE_DIR}/Apple/build/boost/${LIBRARY_VERSION}/ios/release/build/universal" "${ABSOLUTE_DIR}/Apple/build/boost/${LIBRARY_VERSION}/ios/release/prefix/lib"

    cd "${ABSOLUTE_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${ABSOLUTE_DIR}/Apple/build" "${ABSOLUTE_DIR}/Apple/src"
}

#=======================================================================================================================

function archive()
{
    cd "${ABSOLUTE_DIR}/Apple/build/boost/${LIBRARY_VERSION}/ios/release/prefix"

    mkdir -p "${ABSOLUTE_DIR}/builds/${LIBRARY_VERSION}" || true

    zip -r "${ABSOLUTE_DIR}/builds/${LIBRARY_VERSION}/boost-ios-${IOS_SDK_VERSION}-${LIBRARY_VERSION}.zip" include lib

    cd "${ABSOLUTE_DIR}"
}

#=======================================================================================================================

echo "################################################################################"
echo "###                                  Boost                                   ###"
echo "################################################################################"


build
archive
# cleanup
