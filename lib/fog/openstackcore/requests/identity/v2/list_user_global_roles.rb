# module Fog
#   module Identity
#     class OpenStackCore
#       class Real
#
#         def list_user_global_roles(user_id)
#           request(
#             :expects  => [200, 203],
#             :method   => 'GET',
#             :path     => "/users/#{user_id}/roles"
#           )
#         end
#
#       end
#
#       class Mock
#       end
#     end # OpenStackCore
#   end # Identity
# end # Fog
