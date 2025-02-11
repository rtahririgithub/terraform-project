# tf-infra-gcp-groups

The project `gcp-groups-pr` is responsible for  programmatically managing Google Groups via IaC. In order to manage groups in google, the service account that is executing the IaC must be given [domain wide delegation](https://cloud.google.com/identity/docs/how-to/setup#configure_service_account). To minimize the number of account with domain wide delegation, this respository has been established to support multiple different code approvers.

## Group Structure 

Membership in the various groups is managed via a series of json files. The structure of the file allows team members to be established as OWNERS, MANAGERS or MEMBERS of the Google Group

> OWNERS and MANAGERS are included for completeness, and are not recommended at this time.

For example, the following configuration file would create the group `GKE Super Admin`. Consistent with the naming convention in use at TELUS, the groups email address be it's id appened with `-ggrp@telus.com`. For this example the email address will be `gke-super-admin-ggrp@telus.com`
```
{
    "id": "gke-super-admin",
    "displayName": "GKE Super Admin",
    "owners": [],
    "managers": [],
    "members": [
        "michael.lapish@telus.com",
        "eugene.thai@telus.com",
        "harpreet.paul@telus.com"
    ]
}
```

> Pending TELUS' migration to GMail, these group email addresses **DO NOT** allow mail to be delivered to the groups member.

## Email Format
> ⚠️ All email addresses MUST be lower case. GCP does not accept upper case or mixed case email addresses.

## Directory Structure

The current directory structure is as follows:
```
├── adhoc
├── cloud_coe
│   └── cloud_coe.json
├── cso
├── gke
│   ├── gke_super_admin.json
│   └── gke_users.json
```

| Directory       | Description                               | Approvers         |
| ----------------|-------------------------------------------| ------------------|
| adhoc           | Groups not managed by any approving team. | None              |
| cloud_coe       | Groups established by the Cloud CoE to grant access to project resources, included shared resources like Stackdriver. | Cloud CoE |
| cso             | Groups established by TELUS CSO | CSO |
| gke             | Groups established for [GKE RBAC](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control) purposes. Any groups that are created here will become members of the Group `GKE Security Groups` (e.g. `gke-security-groups@telus.com`) | Cloud CoE |
| gcp / dstq      | Groups established to manage access to GCP projects | @telus/dstq |
| bi_layer        | Groups established for common viewer data access from BI Layer projects | @telus/bilayer-admins |
| gidc | Groups established for access to the GIDC folder and projects | @telus/hybrid-cloud-admins |
| kuleana        | Groups established for admin, contributor and viewer access for Kuleana development | @telus/Kuleana |

> Any new directories created must update their relevant `CODEOWNERS` file, and the variable `fileset` in [`pr.tfvars`](terraform/pr.tfvars).

## Contributing

In order to modify groups, teams must create a [branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-and-deleting-branches-within-your-repository#creating-a-branch) in the repository `tf-infra-gcp-groups`, and create a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) to the `master` branch have their contributions included. 

Monitoring of this repository by the `CODEOWNERS` has been minimized in favour of automated checks for correctness. Please ensure that your pull requests meets the standards described [here](https://github.com/telus/cloud-coe-documentation/blob/master/contributing/contribution.md). If your pull request passes all checks, the label `Merge Ready` will be applied to your pull request and it will be merged and deployed automatically.

If your pull request updates any of the following manual intervention is required:

- `GIDC` groups
- `*admin*` groups


### Validation

A daily validation build will be completed at 00h:00, 06h:00 UTC, 12h:00, 18h:00 UTC. This validation will:
* Sort the groups alphabetically
* Remove any team members that are invalid including incorrect emails and departed team members.



### Builds

Actions exist to perform builds. Please review the relevant actions to trouble shoot issues.

| Environment      | Action                          | Description | 
| ---------------- | ------------------------------- | ----------- |
| NA               | [Plan Groups](https://github.com/telus/tf-infra-gcp-groups/actions/workflows/plan.yaml) | Confirms that the content and format of the pull request is correct. This check and any subchecks must `PASS` for the pull request to be merged.            |
| NA               | [Deploy Groups](https://github.com/telus/tf-infra-gcp-groups/actions/workflows/deploy.yaml) | Updates groups with newly added or deleted members.


Triggers exist for the select resources upon push to `master` for all groups.

| Environment      | Trigger                     | 
| ---------------- | ------------------------------- | 
| NA               | [PUSH `gcp-groups-pr-c6c009..auto.YYYY-MM-DD`](https://console.cloud.google.com/cloud-build/builds;region=global?query=trigger_id%3D%2287720ea3-7280-442e-b912-0d5611037658%22&project=gcp-groups-pr-c6c009&supportedpurview=project)|

## GCP Group Projects

| Project Name                                                   | Project ID                       | Environment   |
| ---------------------------------------------------------------|----------------------------------|---------------|
|[gcp-groups-pr](https://console.cloud.google.com/home/dashboard?folder=&organizationId=&project=gcp-groups-pr-c6c009)|gcp-groups-pr-c6c009 | NA |
