plantuml-pdf
===

A plantuml distro capable of building PDFs.

```bash
docker run --rm -u $(id -u) \
  -v /your-folder:/data \
  ghcr.io/schnatterer/plantuml-pdf \
  -tpdf your.puml
```
Creates file `/your-folder/your.pdf`

See https://plantuml.com/pdf


## Releasing

For now manually, in future a Cron would be nice:

* Update versions in pom.xml
* Commit and push
* Create release on GitHub using the plantuml version
* GitHub Action will build an release image