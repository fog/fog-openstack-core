# module Fog
#   module Identity
#     class OpenStackCore
#       class Real
#
#         def add_credential_to_user(user_id)
#           request(
#             :method  => 'POST',
#             :expects => [200, 202],
#             :path    => "/users/#{user_id}/OS-KSADM/credentials"
#           )
#         end
#
#       end # Real
#
#       class Mock
#       end
#     end # OpenStackCore
#   end # Identity
# end # Fog
