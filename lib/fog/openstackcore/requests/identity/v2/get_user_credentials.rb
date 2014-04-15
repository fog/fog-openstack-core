# module Fog
#   module Identity
#     class OpenStackCommon
#       class Real
#
#         # def get_user_credentials(user_id, credential_type)
#         def get_user_credentials(user_id)
#           request(
#             :method   => 'GET',
#             :expects  => [200, 203],
#             # :path     => "/users/​#{user_id}​/OS-KSADM/credentials"
#             :path     => "/users/​#{user_id}​/OS-KSADM/credentials/OS-KSEC2:ec2Credentials"
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
