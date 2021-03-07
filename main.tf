/*
module "toh" {
  source = "./toh"
}
*/

module "toh-azure" {
  source           = "./toh-azure"
  application_name = "toh"
}
