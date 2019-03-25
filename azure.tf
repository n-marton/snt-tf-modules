resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}"
  location = "${var.region}"

  tags = "${var.rg_tags}"
}

resource "azurerm_storage_account" "sa" {
  name                = "${var.is_sa_prefixed ? "${var.sa_prefix}${var.sa_name}" : "${var.sa_name}"}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "${var.sa_acc_tier}"
  account_replication_type = "${var.sa_acc_rep_type}"
  enable_file_encryption = "${var.file_encryption}"
  enable_blob_encryption = "${var.blob_encryption}"
}

resource "azurerm_virtual_network" "vn" {
  name                = "${var.vn_name}"
  address_space       = "${var.vn_addr_space}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "vss" {
  count = "${length(var.vn_subnets)}"
  name                 = "subnet-${replace(replace(element(var.vn_subnets, count.index), ".", "-"), "/", "-")}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vn.name}"
  address_prefix       = "${element(var.vn_subnets, count.index)}"
}

resource "azurerm_policy_definition" "pd" {
  name         = "samplepd"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "sentia-resource-type-restriction"

  policy_rule = "${jsonencode(local.enabled_resource_types_map)}"
}

resource "azurerm_policy_assignment" "pa" {
  name                 = "samplepa"
  scope                = "${azurerm_resource_group.rg.id}"
  policy_definition_id = "${azurerm_policy_definition.pd.id}"
  description          = "Policy Assignment for resource restriction"
  display_name         = "senita-resource-type-assignment"
}
