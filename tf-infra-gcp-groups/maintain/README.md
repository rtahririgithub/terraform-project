# GCP Groups Maintenance

The script `maintainGroup.sh` can be used to remove entries from the state file that are no longer present in the group, and must be removed by state surgery.

## Procedure

- Download the cloud build log
- Search the logs for entries that cannot be managed via terraform
```bash
grep  "Error when reading" error.txt  | cut -d '"' -f4 > entries.txt
```
- Download the state file from GCP
```bash
gsutil cp gs://tf-state-gcp-groups-pr-c6c009/terraform/pr/default.tfstate .
```
- Invoke the shell script
```bash 
./removeElementsById.sh default.tfstate entries.txt
```
- Upload the state file to GCP
```bash
gsutil cp default.tfstate gs://tf-state-gcp-groups-pr-c6c009/terraform/pr/default.tfstate 
```
