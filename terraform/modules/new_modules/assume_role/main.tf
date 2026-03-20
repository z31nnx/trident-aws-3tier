data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = toset(var.trusted_services)
    }
  }
}

resource "aws_iam_role" "role" {
  name                 = var.role_name
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.trust.json

  tags = {
    Name = "${var.prefix}-${var.role_name}-role"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.role.name
  policy_arn = each.value
}