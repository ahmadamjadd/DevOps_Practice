resource "aws_iam_user" "user" {
  name = "terraform-cs316-devops"
}

data "aws_iam_policy" "policy" {
  name = "AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.user.name
  policy_arn = data.aws_iam_policy.policy.arn
}

resource "aws_iam_user_login_profile" "example" {
  user    = aws_iam_user.user.name
  password_reset_required = true  
}

resource "aws_iam_access_key" "lb" {
  user    = aws_iam_user.user.name
}

output "secret" {
  value = aws_iam_access_key.lb.secret
  sensitive = true
}

output "login_password" {
  value     = aws_iam_user_login_profile.example.password
  sensitive = true
}