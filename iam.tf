# resource "aws_iam_policy" "ssm_parameter_read" {
#   name        = "AllowSSMParameterGet"
#   description = "Allows read access to public and custom SSM Parameters"
#   policy      = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "ssm:GetParameter"
#         Resource = [
#           "arn:aws:ssm:ap-southeast-1::parameter/aws/service/ami-amazon-linux-latest/*",
#           "arn:aws:ssm:ap-southeast-1::parameter/*"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_user_policy_attachment" "ssm_read_attachment" {
#   user       = aws_iam_user.rger.name
#   policy_arn = aws_iam_policy.ssm_parameter_read.arn
# }
# resource "aws_iam_user" "rger" {
#   name = "rger"
#   tags = {
#     Name = "rger"
#   }
# }