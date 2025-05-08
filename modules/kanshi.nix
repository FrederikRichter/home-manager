# {
#     lib,
#     config,
#     ...
# }:
# {
#     services.kanshi = {
#         enable = true;
#         settings = [
#         {
#             profile.name = "Xiaomi";
#             profile.outputs = [
#             {
#                 criteria = "eDP-1";
#                 status = "disable";
#             }
#             {
#                 criteria = "Xiaomi Corporation Mi Monitor 5744900021637";
#                 status = "enable";
#                 mode = "2560x1440@59.951Hz";
#                 position = "0,0";
#             }
#             ];
#         }
#         {
#             profile.name = "Default HDMI";
#             profile.outputs = [
#             {
#                 criteria = "eDP-1";
#                 status = "enable";
#                 mode = "1920x1080@60Hz";
#             }
#             {
#                 criteria = "HDMI-A-1";
#                 status = "enable";
#                 position = "0,0";
#                 mode = "1920x1080@60Hz";
#             }
#             ];
#             }
#         ];
#     };
# }
