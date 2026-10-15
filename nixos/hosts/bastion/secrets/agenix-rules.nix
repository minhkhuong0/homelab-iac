let
 desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXL3qwxZvMpfJyt/ojv3fyLsynCkjm4BNu+l907LrT0";
 laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQjagqJws0x7rwOF+LaLLdaFbLS6xvTx5r86u152HdG";

 bastion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBQXz7pcP/A0azEaeILslqjsiMKZofphbSiQ51BQ2pf";
 
 all = [ desktop laptop bastion ];
in
{
  "pangolin-site.age".publicKeys = all;
}
