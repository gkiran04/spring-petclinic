resource "aws_eks_node_group" "myapp-eks-node-group" {
  cluster_name    = aws_eks_cluster.myapp-eks.name
  node_group_name = "myapp-eks-node-group"
  node_role_arn   = aws_iam_role.eks-workernodes.arn
  subnet_ids      = [aws_subnet.myapp-public-1.id, aws_subnet.myapp-public-2.id, aws_subnet.myapp-public-3.id]
  
  capacity_type = "ON_DEMAND"
  disk_size = "20"
  instance_types = ["t3.medium"]
  remote_access {
    ec2_ssh_key = "EKSKEYPAIR"
    source_security_group_ids = [aws_security_group.myapp-sg.id]
  }
  labels = {
    Name = "eks-node"
  }
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-node-EC2InstanceProfileForImageBuilderECRContainerBuilds,
    aws_iam_role_policy_attachment.eks-node-AmazonSSMManagedInstanceCore,
    aws_iam_role_policy_attachment.eks-node-s3,
    aws_iam_role_policy_attachment.eks-node-autoscaler,
  ]
}