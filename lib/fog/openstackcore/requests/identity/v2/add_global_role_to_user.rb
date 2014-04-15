# module Fog
#   module Identity
#     class OpenStackCommon
#       class Real
#
#         def add_global_role_to_user(user_id, role_id)
#           request(
#             :method   => 'PUT',
#             :expects  => [200,201],
#             :path     => "/users/#{user_id}/roles/OS-KSADM/#{role_id}"
#           )
#         end
#
#       end # Real
#
#       class Mock
#       end
#     end # OpenStackCommon
#   end # Identity
# end # Fog
