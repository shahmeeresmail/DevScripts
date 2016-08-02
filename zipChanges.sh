#!/bin/bash
# Copyright(c) 2016 Shahmeer Esmail. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is 
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
# THE SOFTWARE.

#=====================================================================================
# Functions
#=====================================================================================
function displayUsage ()
{
    echo "Usage:"
    echo "=========================================================================="
    echo "Command                   Gets file changes between"
    echo "--------------------------------------------------------------------------"
    echo "zipChanges.sh             Active local branch and remote active branch"
    echo "zipChanges.sh <brA>       Active local branch and remote branch A*"
    echo "zipChanges.sh <brA> <brB> Branch A** and Branch B**"
    echo ""
    echo "*  If A is the active branch, will get diff between local & remote copies"
    echo "** Will use remote copy unless branch is the active branch"
}

#=====================================================================================
# Main Body
#=====================================================================================
echo ""
echo ""

if [ $# -gt 2 ]; then
   displayUsage
   exit
fi

#Initialization
gitBranches[0]=''
gitBranches[1]=''
branchLocation[0]=''
branchLocation[1]=''
count=0

#Get Current Branch
currentBranch=$(git rev-parse --abbrev-ref HEAD)

#Process parameters
while [[ $# > 0 ]]
do
    key="$1"
    while [[ ${key+x} ]]
    do
        case $key in
            *?)
                displayUsage
                exit
                ;;
            -h)
                displayUsage
                exit
                ;;
            -help)
                displayUsage
                exit
                ;;
            --h)
                displayUsage
                exit
                ;;
            --help)
                displayUsage
                exit
                ;;
            local)
                gitBranches[count]="$currentBranch"
                branchLocation[count]="Local"
                count=$(( $count + 1 ))
                ;;
            *)
                gitBranches[count]="$1"
                
                if [ "$1" == "$currentBranch" ]; then
                    branchLocation[count]="Local"
                else
                    branchLocation[count]="Remote"
                fi

                count=$(( $count + 1 ))
                ;;
        esac

        unset key
    done
    shift # option(s) fully processed, proceed to next input argument
done

#Fill in implicit values if explicit parameters not provided
if [ $count -eq 0 ]; then
   #This is a comparison between local and remote branches of the current branch
   gitBranches[0]="$currentBranch"
   branchLocation[0]="Local"
   branchLocation[1]="Remote"
   count=$(( $count + 1 ))
elif [ $count -eq 1 ]; then
    if [ "${gitBranches[0]}" == "$currentBranch" ]; then
        #This is a comparison between local and remote copies of the active branch
        branchLocation[count]="Remote"
    else
        #Comparison between active local branch and a different remote branch
        #Prepend active local branch to list
        gitBranches[1]="${gitBranches[0]}"
        branchLocation[1]="${branchLocation[0]}"
        gitBranches[0]="$currentBranch"
        branchLocation[0]="Local"
        count=$(( $count + 1 ))
    fi
fi

#Set output file names
outFileBase="changes_${gitBranches[0]}_${branchLocation[0]}_vs_${gitBranches[$(( $count - 1))]}_${branchLocation[1]}"
txtFileName="${outFileBase}.txt"
zipFileName="${outFileBase}.zip"

#Cleanup existing output files that may conflict
rm -f ${txtFileName} ${zipFileName}

#Generate diff file list
git diff ${gitBranches[0]} ${gitBranches[1]} --name-only > ${txtFileName}

#CreateZip
7z a -tzip ${zipFileName} @${txtFileName}

echo "Zip File     : $zipFileName"
echo "FileList File: $txtFileName"