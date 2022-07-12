# Recurso aws_iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

resource "aws_iam_role" "eks-iam-role1" {
 name = "AWSServiceRoleForAmazonEKS"

 assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:DescribeInstances",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:CreateNetworkInterfacePermission",
                "iam:ListAttachedRolePolicies",
                "ec2:CreateSecurityGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteSecurityGroup",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupIngress"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Condition": {
                "ForAnyValue:StringLike": {
                    "ec2:ResourceTag/Name": "eks-cluster-sg*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:vpc/*",
                "arn:aws:ec2:*:*:subnet/*"
            ],
            "Condition": {
                "ForAnyValue:StringLike": {
                    "aws:TagKeys": [
                        "kubernetes.io/cluster/*"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:security-group/*"
            ],
            "Condition": {
                "ForAnyValue:StringLike": {
                    "aws:TagKeys": [
                        "kubernetes.io/cluster/*"
                    ],
                    "aws:RequestTag/Name": "eks-cluster-sg*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "route53:AssociateVPCWithHostedZone",
            "Resource": "arn:aws:route53:::hostedzone/*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/eks/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/eks/*:*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/eks/*:*:*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "eks-iam-role2" {
 name = "AWSServiceRoleForAmazonEKSNodegroup"

 assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SharedSecurityGroupRelatedPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:RevokeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeInstances",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:DeleteSecurityGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/eks": "*"
                }
            }
        },
        {
            "Sid": "EKSCreatedSecurityGroupRelatedPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:RevokeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeInstances",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:DeleteSecurityGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/eks:nodegroup-name": "*"
                }
            }
        },
        {
            "Sid": "LaunchTemplateRelatedPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateLaunchTemplateVersion"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/eks:nodegroup-name": "*"
                }
            }
        },
        {
            "Sid": "AutoscalingRelatedPermissions",
            "Effect": "Allow",
            "Action": [
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "autoscaling:CompleteLifecycleAction",
                "autoscaling:PutLifecycleHook",
                "autoscaling:PutNotificationConfiguration",
                "autoscaling:EnableMetricsCollection"
            ],
            "Resource": "arn:aws:autoscaling:*:*:*:autoScalingGroupName/eks-*"
        },
        {
            "Sid": "AllowAutoscalingToCreateSLR",
            "Effect": "Allow",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "autoscaling.amazonaws.com"
                }
            },
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*"
        },
        {
            "Sid": "AllowASGCreationByEKS",
            "Effect": "Allow",
            "Action": [
                "autoscaling:CreateOrUpdateTags",
                "autoscaling:CreateAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "ForAnyValue:StringEquals": {
                    "aws:TagKeys": [
                        "eks",
                        "eks:cluster-name",
                        "eks:nodegroup-name"
                    ]
                }
            }
        },
        {
            "Sid": "AllowPassRoleToAutoscaling",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "autoscaling.amazonaws.com"
                }
            }
        },
        {
            "Sid": "AllowPassRoleToEC2",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "ec2.amazonaws.com",
                        "ec2.amazonaws.com.cn"
                    ]
                }
            }
        },
        {
            "Sid": "PermissionsToManageResourcesForNodegroups",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "ec2:CreateLaunchTemplate",
                "ec2:DescribeInstances",
                "iam:GetInstanceProfile",
                "ec2:DescribeLaunchTemplates",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:RunInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:GetConsoleOutput",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSubnets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "PermissionsToCreateAndManageInstanceProfiles",
            "Effect": "Allow",
            "Action": [
                "iam:CreateInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:AddRoleToInstanceProfile"
            ],
            "Resource": "arn:aws:iam::*:instance-profile/eks-*"
        },
        {
            "Sid": "PermissionsToManageEKSAndKubernetesTags",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": "*",
            "Condition": {
                "ForAnyValue:StringLike": {
                    "aws:TagKeys": [
                        "eks",
                        "eks:cluster-name",
                        "eks:nodegroup-name",
                        "kubernetes.io/cluster/*"
                    ]
                }
            }
        }
    ]
}
EOF
}