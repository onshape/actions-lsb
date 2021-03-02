# **WARNING - This is a public repo used to host a custom action for GitHub workflows. Do not include proprietary or sensitive data.**

# actions-lsb
Get or put the Last Successful Build SHA for a workflow/branch

## Inputs

### `operation`

**Required** The operation - get or put

### `ownerRepo`

**Required** The owner and repository (owner/repository)

### `workflowBranch`

**Required** The workflow and branch (workflow/branch)

### `putLsb`

**Put operation - Required** The lsb SHA

### `expiryMons`

**Put operation - Optional** The item expiry in months (TTL)

## Outputs

### `getLsb`

Get operation - the lsb SHA

## Example usage

### Get
```yaml
- name: call actions-lsb
  uses: onshape/actions-lsb@v1
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.ONSHAPE_CI_AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.ONSHAPE_CI_AWS_SECRET_ACCESS_KEY }}
  with:
    operation: "get"
    ownerRepo: "${{ github.event.organization.login }}/ios"
    workflowBranch: "ios-test-demo-c/rel-1.126"
```

### Put
```yaml
- name: call actions-lsb
  uses: onshape/actions-lsb@v1
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.ONSHAPE_CI_AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.ONSHAPE_CI_AWS_SECRET_ACCESS_KEY }}
  with:
    operation: "put"
    ownerRepo: "${{ github.event.organization.login }}/ios"
    workflowBranch: "ios-test-demo-c/rel-1.126"
    putLsb: "7831e4ec2f1a215c64d43cb4188f092dca04ce8b"
```
