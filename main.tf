terraform {
  required_providers {

    minio = {
      source = "aminueza/minio"
    }

    tls = {
      source = "hashicorp/tls"
    }

    null = {
      source = "hashicorp/null"
    }

    bigip = {
      source = "F5Networks/bigip"
    }

    gitlab = {
      source = "gitlabhq/gitlab"
    }

    nutanix = {
      source = "nutanix/nutanix"
    }
 
    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    kubectl = {
      source = "schizofreny/kubectl"
    }

    splunk = {
      source = "splunk/splunk"
    }

    ad = {
      source = "hashicorp/ad"
    }
  }
}

