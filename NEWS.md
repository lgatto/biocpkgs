# biocpkgs 0.1

## biocpkgs 0.1.3

- Update contact email address
- Replace BioInstaller by BiocManager

## biocpkgs 0.1.2

- Make sure `biocpkgversion` doesn't stop with an error if the URL
  isn't available, such as it the Bioconducor package fails (after a
  release) and doesn't generate it's landing page.
- New functions to access package contributors. See `?contribs` for
  details.

## biocpkgs 0.1.1

- New biocpkgversion and githubpkgversion functions <2017-08-25 Fri>
- biocVersions function for Bioconducor release and devel versions
  (moved over from cputols) <2017-09-07 Thu>
- Add a type (software, experiment, annotation) to biocpkgversion
  <2017-09-08 Fri>
- New cranpkgversion function <2017-09-08 Fri>

## biocpkgs 0.1.0

- First release: `pkg_download_data` function <2017-06-27 Tue>
- Add function for package dependencies <2017-06-30 Fri>
