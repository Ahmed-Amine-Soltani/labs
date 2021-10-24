module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.gcp_project_name
  name                       = var.gke_cluster_name
  #region                     = "us-central1"
  regional              = var.gke_regional
  zones                      = var.gke_zones
  network                    = "vpc-lab"
  subnetwork                 = "subnet-1"
  ip_range_pods              = ""
  ip_range_services          = ""
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = false

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-small"
      #node_locations            = ""
      min_count                 = 1
      max_count                 = 100
      local_ssd_count           = 0
      disk_size_gb              = 50
      disk_type                 = "pd-standard"
      image_type                = "COS"
      auto_repair               = true
      auto_upgrade              = true
      #service_account           = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      create_service_account    = true
      preemptible               = true
      initial_node_count        = 2
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}