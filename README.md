- [Terraform Topics Tuesdays](#terraform-topics-tuesdays)
  - [Session 1 - Terraform Cloud](#session-1---terraform-cloud)
  - [Session 2 - Generating Resources](#session-2---generating-resources)
  - [Session 3 - Terraform CLI](#session-3---terraform-cli)

# Terraform Topics Tuesdays

Terraform Topics Tuesdays plans to cover a practitioner's level of terraform while steadily targeting more advanced topics.

Current Session Outline:

1. Setup and configuration of Terraform Cloud
2. Deploying resources with a provider (Azure, AWS, Docker, GCP, GitHub, Terraform Enterprise)
3. Terraform CLI (I know this wasn't highly ranked, but it is pretty important to cover before we go deeper!)
4. Configure resources for multi-environment deployments
5. State manipulation (remove, move, import)
6. How and when to build a module.
7. When to scale wide with your Infrastructure Codebase and Workspaces
8. Terraform Functions
9. Integration with HashiCorp Vault
10. Testing your Terraform

Sessions are currently planned to be covered by Matt Braunwart and special guests! If you'd like to cover a topic listed or have one of your own, please let me know!

<a href="mailto:matt.braunwart@insight.com">Matt Braunwart @ insight.com</a>

## Polyglot Notebooks

Most content in these sessions are produced in [Polyglot Notebooks](https://github.com/dotnet/interactive). [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode)

> With the Polyglot Notebooks extension, you can use multiple languages in the same notebook and share variables between them. No more installing different Jupyter kernels, using wrapper libraries, or different tools to get the best language server support for the language of your choice. Always use the best language for the job and seamlessly transition between different states of your workflow, all within one notebook.

## Session 1 - Terraform Cloud

All content can be found in `./Session 1 - Terraform Cloud`. Content of this session contains a Polyglot Notebook with markdown and commands presenting the session. Infrastructure as code used within this session reside in `./Session 1 - Terraform Cloud/tfc_workspace` and `./Session 1 - Terraform Cloud/tfc_module`.

- General overview of Terraform Cloud
- Creating a workspace in Terraform Cloud
- Running terraform commands remotely.
- Publishing a module in the Private Module Registry.

## Session 2 - Generating Resources

All content can be found in `./Session 2 - Creating Resources`. Content of this session is produced on a Polyglot Notebook. In this particular content it was used primarily for markdown documentation. \
Several pieces of terraform are laid out in folders. A NodeJS app was created for an example generating a Docker image using the Docker provider. \

The terraform produced in the session follows the below diagram.

<img alt="TFE Token Variable" src="./Session 2 - Creating Resources/images/app_service_deploy.png" width="50%" height="50%"/>

- Anatomy of a Resource
- Building Resources for Terraform Enterprise
- Building Base Azure Resources
- Building Docker Image and Publish to Registry
- Building Azure Linux App Service

## Session 3 - Terraform CLI

All content can be found in `./Session 3 - Terraform CLI`. Content of this session is produced on a Polyglot Notebook.

The terraform included in this session is the same as the TFE terrform from [Session 2 - Generating Resources](#session-2---generating-resources).

- Terraform CLI Commands
  - Overview
  - Init
  - Validate
  - Plan
  - Apply
  - Destroy
  - Format
  - Console
  - Show
  - State List and State Show
