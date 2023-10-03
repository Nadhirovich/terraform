terraform {
  cloud {
    organization = "MyOwnDC"

    workspaces {
      name = "MyWorkspace"
    }
  }
}