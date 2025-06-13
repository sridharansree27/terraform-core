output "sub_region" {
  value = [module.resource.sub_region]
}

output "expression" {
  value = {
    Heredocs                = module.expression.Heredocs
    Indented_Heredocs       = module.expression.Indented_Heredocs
    create_tuple_list       = module.expression.create_tuple_list
    create_tuple_map        = module.expression.create_tuple_map
    create_map_list         = module.expression.create_map_list
    create_admin_object     = module.expression.create_admin_object
    create_non_admin_object = module.expression.create_non_admin_object
    create_tuple_order      = module.expression.create_tuple_order
    grouped_users           = module.expression.grouped_users
    splat_list_1            = module.expression.splat_list_1
    splat_list_2            = module.expression.splat_list_2
    splat_list_3            = module.expression.splat_list_3
    nested_dynamic          = module.expression.nested_dynamic
  }
}