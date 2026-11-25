<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Normalises DWI intensities so the white matter b0 signal equals a set value, with MRtrix3 dwinormalise individual using an FA > 0.5 white matter mask.**

Builds a brain mask (dwi2mask) and a white matter mask (FA > 0.5 from dwi2tensor), then runs dwinormalise individual with the chosen intensity and percentile, and exports the DWI with its gradients. Use it before comparing DWI intensities across subjects or sessions.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.806](https://doi.org/10.25663/brainlife.app.806)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | DWI image with bvecs and bvals (sbref files are passed along but not used). |

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/dwi` | Intensity-normalised DWI with bvecs and bvals exported by MRtrix3. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `nval` | number | `1000` | The value to which the mode value intensity normalization will normalize the white matter intensity. |
| `prct` | number | `50` | Percentile of the white matter b0 intensities matched to nval (dwinormalise -percentile). |

Runtime: container `brainlife/mrtrix3:3.0.2`; 8 CPUs; 1 h walltime.

<!-- brainlife-app:end -->

# app-dwinormalise