:: Copyright(c) 2016 Shahmeer Esmail. All rights reserved.
::
:: Permission is hereby granted, free of charge, to any person obtaining a copy 
:: of this software and associated documentation files (the "Software"), to deal 
:: in the Software without restriction, including without limitation the rights 
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is 
:: furnished to do so, subject to the following conditions:

:: The above copyright notice and this permission notice shall be included in 
:: all copies or substantial portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
:: THE SOFTWARE.

@echo off
REM Constants
set THIS_FILE_NAME=%~0

REM Parameter Validation
if [%1]==[] goto SHOWUSAGE

REM Set branches
set branchA=%~1
set branchB=HEAD
if [%2] NEQ [] set branchB=%~2

REM File cleanup
del modifiedFiles_%branchA%_vs_%branchB%.txt
del modifiedFiles_%branchA%_vs_%branchB%.zip

REM Generate file list
git diff %branchA% %branchB% --name-only > modifiedFiles_%branchA%_vs_%branchB%.txt

REM CreateZip
7z a -tzip modifiedFiles_%branchA%_vs_%branchB%.zip @modifiedFiles_%branchA%_vs_%branchB%.txt
goto ENDPOINT

:SHOWUSAGE
echo "Usage: zipChanges.bat <branchToCompareCurrentBranchAgainst>   OR"
echo "       zipChanges.bat <branchA> <branchB>"
:ENDPOINT