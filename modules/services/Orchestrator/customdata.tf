data "template_file" "orchestrator_install_script" {
  template = <<EOF
    if(![System.IO.File]::Exists("C:\Program Files\metadata_scripts\createorchestratorUser")){

    $setLocalAdminPassword = "${var.set_local_adminpass}"
    if($setLocalAdminPassword -eq "yes") {
    $admin = [ADSI]("WinNT://./administrator, user")
    $admin.SetPassword("${var.admin_password}")
    }

    # create orchestrator local user
    $orchestratorRole = "${var.orchestrator_local_account_role}"
    if($orchestratorRole -eq "localuser") {
     $localorchestratorRole = "Remote Desktop Users"
    } else { $localorchestratorRole = "Administrators" }

    $UserName="${var.vm_username}"
    $Password="${var.vm_password}"
    $Computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"
    $User = $Computer.Create("User", $UserName)
    $User.SetPassword("$Password")
    $User.SetInfo()
    $User.FullName = "${var.vm_username}"
    $User.SetInfo()
    $User.Put("Description", "UiPath orchestrator Admin Account")
    $User.SetInfo()
    $User.UserFlags = 65536
    $User.SetInfo()
    $Group = [ADSI]("WinNT://$Env:COMPUTERNAME/$localorchestratorRole,Group")
    $Group.add("WinNT://$Env:COMPUTERNAME/$UserName")
    $admin = [ADSI]("WinNT://./administrator, user")
    $admin.SetPassword("${var.vm_password}")
    New-Item "C:\Program Files\metadata_scripts\createorchestratorUser" -type file
    }

    if(![System.IO.File]::Exists("C:\Program Files\metadata_scripts\orchinstall")){
    Set-ExecutionPolicy Unrestricted -force
    Invoke-WebRequest https://raw.githubusercontent.com/UiPath/Infrastructure/master/Setup/Install-UiPathOrchestrator.ps1 -OutFile "C:\Program Files\metadata_scripts\Install-UiPathOrchestrator.ps1"
    powershell.exe -ExecutionPolicy Bypass -File "C:\Program Files\metadata_scripts\Install-UiPathOrchestrator.ps1" -orchestratorversion "${var.orchestrator_version}" -passphrase "${var.orchestrator_passphrase}" -databaseservername "${var.orchestrator_databaseservername}" -databasename "${var.orchestrator_databasename}" -databaseusername "${var.orchestrator_databaseusername}" -databaseuserpassword "${var.orchestrator_databaseuserpassword}" -orchestratoradminpassword "${var.orchestrator_orchestratoradminpassword}" -redisServerHost "${var.haa_master_network_ip}:10000,${var.haa_master_network_ip}:10000,${var.haa_master_network_ip}:10000,password=${var.haa-password}"
    New-Item "C:\Program Files\metadata_scripts\orchinstall" -type file
    #Start-Sleep -Seconds 10 ; Restart-Computer -Force
    }
EOF
}

data "template_file" "init" {
  template  = <<EOF
  <script>
    winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"} & winrm/config @{MaxEnvelopeSizekb="8000kb"}
  </script>
  <powershell>
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  if("${var.admin_password}"){
    $admin = [ADSI]("WinNT://./administrator, user")
    $admin.SetPassword("${var.admin_password}")
  }
  $temp = "C:\AzureData"
  $link = "https://raw.githubusercontent.com/UiPath/Infrastructure/master/Setup/Install-UiPathOrchestrator.ps1"
  $file = "Install-UiPathOrchestrator.ps1"
  New-Item $temp -ItemType directory
  Set-Location -Path $temp
  Set-ExecutionPolicy Unrestricted -force
  Invoke-WebRequest -Uri $link -OutFile $file
  powershell.exe -ExecutionPolicy Bypass -File "C:\AzureData\Install-UiPathOrchestrator.ps1" -OrchestratorVersion "${var.orchestrator_version}" -passphrase "${var.orchestrator_passphrase}" -databaseServerName "${var.orchestrator_databaseservername}" -databaseName "${var.orchestrator_databasename}"  -databaseUserName "${var.orchestrator_databaseusername}" -databaseUserPassword "${var.orchestrator_databaseuserpassword}" -orchestratorAdminPassword "${var.orchestrator_orchestratoradminpassword}" -redisServerHost "${var.haa_master_network_ip}:10000,${var.haa_master_network_ip}:10000,${var.haa_master_network_ip}:10000,password=${var.haa-password}"
  </powershell>
EOF
}