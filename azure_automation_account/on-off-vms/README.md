# VM Power Management

This solution automates the management of virtual machines' power states in Azure based on a specific tag. It targets virtual machines within a specified resource group where the 'Scheduler ON-OFF' tag is set to 'true'. Proper Role-Based Access Control (RBAC) permissions must be configured for the system identity to perform start/stop operations.

## Prerequisites
- System-assigned managed identity enabled on the Automation Account.
- RBAC permissions assigned to the identity for starting and stopping targeted VMs.

## Setup Instructions

1. **Azure Portal Setup**:
   - Sign in to the Azure Portal.
   - Navigate to 'Automation Accounts'.

2. **Identity and Permissions**:
   - Confirm the system-assigned managed identity is enabled under 'Identity'.
   - Verify the identity has the required RBAC permissions to manage the VM power states.

3. **Runbook Creation**:
   - Click on 'Runbooks', then '+ Add a runbook'.
   - Select 'Create a new runbook'.
   - Name your runbook and select PowerShell as the runbook type with runtime version 7.
   - Enter script code (main.ps1), save, and then publish the runbook.

4. **Scheduling (Optional)**:
   - Go to 'Schedules' and link your runbook to a schedule if desired.
   - Set the 'SUBSCRIPTION_ID' parameter to your subscription ID containing the target VM.
   - Use the 'RESOURCE_GROUP_NAME' parameter for the resource group containing the target VM.
   - Set the 'ACTION' parameter to 'on' to power on the VM or 'off' to power it off.

5. **Configure VM Tags**:
   - Navigate to the virtual machine.
   - Add the 'Scheduler ON-OFF' tag and set it to 'true' to include the VM in the automation.

Its recomending to monitor the runbook execution and scheduled tasks to validate that virtual machines are being managed as expected.
