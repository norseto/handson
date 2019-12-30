resource "google_service_account" "agent" {
  account_id   = "handson"
  display_name = "Service Account for Hands-on"
}

# resource "google_project_iam_custom_role" "this" {
#   role_id     = "handsonRole"
#   title       = "Hands-on role"
#   description = "A role for hands-on"
#   permissions = [
#     "iam.serviceAccounts.actAs",
#   ]
# }

# resource "google_project_iam_member" "iam01" {
#   role   = "${google_project_iam_custom_role.this.id}"
#   member = format("serviceAccount:%s", "${google_service_account.agent.email}")
# }

resource "google_project_iam_member" "iam02" {
  role   = "roles/monitoring.viewer"
  member = format("serviceAccount:%s", "${google_service_account.agent.email}")
}

resource "google_project_iam_member" "iam03" {
  role   = "roles/monitoring.metricWriter"
  member = format("serviceAccount:%s", "${google_service_account.agent.email}")
}

resource "google_project_iam_member" "iam04" {
  role   = "roles/logging.logWriter"
  member = format("serviceAccount:%s", "${google_service_account.agent.email}")
}

resource "google_project_iam_member" "iam05" {
  role   = "roles/storage.objectViewer"
  member = format("serviceAccount:%s", "${google_service_account.agent.email}")
}

resource "google_project_iam_member" "iam06" {
  role   = "roles/iam.serviceAccountUser"
  member = format("serviceAccount:%s", "${google_service_account.agent.email}")
}

