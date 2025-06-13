output "Heredocs" {
  value = <<EOT
    hello
      ${var.name}
        $${var.name}
          Hello, %{if var.name != ""}${var.name}%{else}unnamed%{endif}!
EOT
}

output "Indented_Heredocs" {
  value = <<-EOT
    hello
      ${var.name}
        $${var.name}
          %{for n in [1, 2, 3]~}
          ${n > 0 ? "${n} is poitive" : "${n} is negative"}
          %{endfor}
EOT
}

output "create_tuple_list" {                                   # creates list/tuple using list
  value = [for i, s in var.list_name : "index of ${s} = ${i}"] #i or idx can be used for list
}

output "create_tuple_map" { # creates list/tuple using map
  value = [for key, value in var.map : length(key) + length(value)]
}

output "create_map_list" { # create map using list
  value = { for v in var.list_name : v => upper(v) }
}

output "create_admin_object" {
  value = { for name, user in var.users : name => user if user.is_admin }
}

output "create_non_admin_object" {
  value = { for name, user in var.users : name => user if !user.is_admin }
}

output "create_tuple_order" {                                         # creates set or ordered list (lexico order)
  value = toset([for i, s in var.list_name : "index of ${s} = ${i}"]) #i or idx can be used for list
}

output "grouped_users" {
  value = {
    for user in var.grouping : user.role => user.name...
  }
}

output "splat_list_1" {
  value = var.grouping[*].role
}

output "splat_list_2" {
  value = var.splat_null_test_1[*].args1.null_test # inside [] index number can be used, * means all indexes
}

output "splat_list_3" {
  value = var.splat_null_test_2[*]
}

output "nested_dynamic" {
  value = {
    for origin_group_key, origin_group_value in var.dynamic_nested :
    origin_group_key => [
      for origin in origin_group_value.origins :
      {
        hostname = origin.hostname
      }
    ]
  }
}