<h1 align="center">Normalize DWI data</h1>

<p align="center">
  An intensity-normalised diffusion-weighted image, scaled so that the white matter b0 signal equals a set value, with MRtrix3 dwinormalise.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.806"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.806-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Normalises DWI intensities so the white matter b0 signal equals a set value, with MRtrix3 dwinormalise individual using an FA > 0.5 white matter mask.**

Builds a brain mask (dwi2mask) and a white matter mask (FA > 0.5 from dwi2tensor), then runs dwinormalise individual with the chosen intensity and percentile, and exports the DWI with its gradients. Use it before comparing DWI intensities across subjects or sessions.

| | |
|---|---|
| 📥 **Inputs** | `neuro/dwi` |
| 📤 **Outputs** | `neuro/dwi` |
| 🐳 **Container** | `brainlife/mrtrix3:3.0.2` |
| ⚙️ **Resources** | 8 CPUs · 1 h walltime |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.806](https://doi.org/10.25663/brainlife.app.806) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | DWI image with bvecs and bvals (sbref files are passed along but not used). |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/dwi` | Intensity-normalised DWI with bvecs and bvals exported by MRtrix3. |

<details>
<summary><b>⚙️ Parameters</b> (2)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `nval` | number | `1000` | The value to which the mode value intensity normalization will normalize the white matter intensity. |
| `prct` | number | `50` | Percentile of the white matter b0 intensities matched to nval (dwinormalise -percentile). |

</details>

<!-- brainlife-app:end -->

## 🚀 Running the App

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.806](https://doi.org/10.25663/brainlife.app.806), choose a `neuro/dwi` dataset, set the target intensity (`nval`, default 1000) and percentile (`prct`, default 50), and press **Execute**. The App writes a `neuro/dwi` dataset tagged `normalized` to your project. Use it before comparing DWI intensities across subjects or sessions.

### 🔬 How it works

1. The DWI is converted to MRtrix format with its gradients and a brain mask is computed with `dwi2mask`.
2. A white matter mask is built by fitting a tensor (`dwi2tensor`), computing FA (`tensor2metric`) and keeping voxels with FA > 0.5 (`mrthreshold`).
3. `dwinormalise individual` scales the image so that the `prct` percentile of the white matter b0 intensities equals `nval`.
4. The normalised DWI is exported to NIfTI with FSL-format bvecs and bvals.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The App runs in the `brainlife/mrtrix3:3.0.2` container.

1. Clone this repository and check out the released version (`git checkout mrtrix33.0.2-v1.0`). Run the released branch: it is the one registered on brainlife.io.
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "dwi": "/input/dwi/dwi.nii.gz",
       "bvecs": "/input/dwi/dwi.bvecs",
       "bvals": "/input/dwi/dwi.bvals",
       "nval": 1000,
       "prct": 50
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

The number of threads is taken from `OMP_NUM_THREADS` (8 if unset).

## 📦 Outputs

```text
output/
├── dwi.nii.gz   intensity-normalised DWI
├── dwi.bvecs    gradient directions (FSL format)
└── dwi.bvals    b-values (FSL format)
```

## 🩺 Troubleshooting

- **`something went wrong. check logs`**: `output/dwi.nii.gz` was not produced. Check that the bvecs and bvals match the DWI (one entry per volume).

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Normalize DWI data. brainlife.io App. [doi:10.25663/brainlife.app.806](https://doi.org/10.25663/brainlife.app.806)
- Tournier et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019). [doi:10.1016/j.neuroimage.2019.116137](https://doi.org/10.1016/j.neuroimage.2019.116137)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Brad Caron
- Franco Pestilli (project director)

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

MIT. MRtrix3 is distributed under the [Mozilla Public License 2.0](https://www.mrtrix.org/).
