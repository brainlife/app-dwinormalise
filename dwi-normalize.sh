#!/bin/bash

set -e
set -x

# bl configs
dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`
bvecs=`jq -r '.bvecs' config.json`
NORM=`jq -r '.nval' config.json` # default: 1000
PRCT=`jq -r '.prct' config.json` # currently null in mrtrix3 preprocess. leaving that the same here just wanted to make sure normalization command works

#some mrtrix3 commands don't honor -nthreads option (https://github.com/MRtrix3/mrtrix3/issues/1479
echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"
[ -z "$OMP_NUM_THREADS" ] && export OMP_NUM_THREADS=8

# set common flags for mrtrix3 commands
common="-nthreads $OMP_NUM_THREADS -quiet -force"

# make output directory
[ ! -d output ] && mkdir output

# convert to mif
[ ! -f dwi.mif ] && mrconvert -fslgrad $bvecs $bvals $dwi dwi.mif --export_grad_mrtrix dwi.b $common

# create brainmask
[ ! -f mask.mif ] && dwi2mask dwi.mif mask.mif $common

echo "Performing intensity normalization (dwinormalise)..."

## create fa wm mask of input subject
[ ! -f wm.mif ] && dwi2tensor -mask mask.mif dwi.mif - $common | tensor2metric - -fa - $common | mrthreshold -abs 0.5 - wm.mif $common

## normalize the 50th percentile intensity of generous FA white matter mask to 1000
[ ! -f dwi_norm.mif ] && dwinormalise individual dwi.mif wm.mif dwi_norm.mif -intensity $NORM -percentile $PRCT $common

# convert to nifti and save to output
[ ! -f ./output/dwi.nii.gz ] && mrconvert dwi.mif ./output/dwi.nii.gz -export_grad_fsl ./output/dwi.bvecs ./output/dwi.bvals -export_grad_mrtrix dwi.b -json_export dwi.json $common


if [ ! -f ./output/dwi.nii.gz ]; then
    echo "something went wrong. check logs"
    exit 1
else
    echo "dwi normalization complete"
    exit 0
fi
