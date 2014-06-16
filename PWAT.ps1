﻿#----------------------------------------------
#region Application Functions
#----------------------------------------------

function OnApplicationLoad {
	$XMLFile = "PWAT.Options.xml"
	$Script:ParentFolder = Split-Path (Get-Variable MyInvocation -scope 1 -ValueOnly).MyCommand.Definition
	$XMLFile = Join-Path $ParentFolder $XMLFile
	[XML]$Script:XML = Get-Content $XMLFile

	if($XML.Options.Elevate.Enabled -eq $true){Start-Process -FilePath PowerShell.exe -ArgumentList $MyInvocation.MyCommand.Definition -Verb RunAs}
	
	return $true #return true for success or false for failure
}

function OnApplicationExit {
	
	$script:ExitCode = 0 #Set the exit code for the Packager
}

#endregion Application Functions

#----------------------------------------------
# Generated Form Function
#----------------------------------------------
function Call-AWSA_pff {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load("System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formMain = New-Object System.Windows.Forms.Form
	$groupTools = New-Object System.Windows.Forms.GroupBox
	$btnRestart = New-Object System.Windows.Forms.Button
	$btnMsg = New-Object System.Windows.Forms.Button
	$btnCDrive = New-Object System.Windows.Forms.Button
	$btnRA = New-Object System.Windows.Forms.Button
	$btnRDP = New-Object System.Windows.Forms.Button
	$groupInfo = New-Object System.Windows.Forms.GroupBox
	$btnServices = New-Object System.Windows.Forms.Button
	$btnProcesses = New-Object System.Windows.Forms.Button
	$btnStartupItems = New-Object System.Windows.Forms.Button
	$btnApplications = New-Object System.Windows.Forms.Button
	$btnLocalAdmins = New-Object System.Windows.Forms.Button
	$btnSystemInfo = New-Object System.Windows.Forms.Button
	$lvMain = New-Object System.Windows.Forms.ListView
	$btnSearch = New-Object System.Windows.Forms.Button
	$txtComputer = New-Object System.Windows.Forms.TextBox
	$SB = New-Object System.Windows.Forms.StatusBar
	$menu = New-Object System.Windows.Forms.MenuStrip
	$menuFile = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuFileConnect = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuFileExit = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuView = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuViewEventVwr = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuViewServices = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuViewUser = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuViewWSUS = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuViewWSUSReport = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuViewWSUSUpdate = New-Object System.Windows.Forms.ToolStripMenuItem
	$contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$cmsProcEnd = New-Object System.Windows.Forms.ToolStripMenuItem
	$cmsStartupRemove = New-Object System.Windows.Forms.ToolStripMenuItem
	$cmsAdminAdd = New-Object System.Windows.Forms.ToolStripMenuItem
	$cmsAdminRemove = New-Object System.Windows.Forms.ToolStripMenuItem
	$cmsAppUninstall = New-Object System.Windows.Forms.ToolStripMenuItem
	$cmsSelect = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuHelp = New-Object System.Windows.Forms.ToolStripMenuItem
	$menuHelpAbout = New-Object System.Windows.Forms.ToolStripMenuItem
	$SBPStatus = New-Object System.Windows.Forms.StatusBarPanel
	$SBPBlog = New-Object System.Windows.Forms.StatusBarPanel
	$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	
	
	
	
	
	$formMain_Load={
		[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
		$VBMsg = New-Object -COMObject WScript.Shell
        
		if($XML.Options.Domain.Enabled -eq $true){$Domain = $XML.Options.Domain.Default}
		elseif("\\$env:computername" -eq $env:logonserver){$Domain = "Local"}
        else{$Domain = ([DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name}
		Set-FormTitle
	}
	
	
	$menuFileConnect_Click={
		$Domain = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a NetBIOS domain name to connect to... `n(e.g. Contoso instead of Contoso.com)", "Connect to domain...", "")
		if ($Domain){
			$objTrans = New-Object -comObject "NameTranslate"
			$objNT = $objTrans.GetType()
	
			$objNT.InvokeMember("Init", "InvokeMethod", $Null, $objTrans, (3, $Null))
			$objNT.InvokeMember("Set", "InvokeMethod", $Null, $objTrans, (3, "$Domain\"))
			$DNSDomain = $objNT.InvokeMember("Get", "InvokeMethod", $Null, $objTrans, 1)
	
			$script:Searchroot = "LDAP://$DNSDomain"
	
			Set-FormTitle
		}
	}
	
	
	$menuFileExit_Click={
		$formMain.Close()
	}
	
	
	$btnSearch_Click={
		Get-ComputerName
		Initialize-Listview
		$SBPStatus.Text = "Retrieving Computers..."
		Update-ContextMenu (Get-Variable cmsSelect*)
		$Properties = $XML.Options.Search.Property 
		$Properties | %{Add-Column $_}
		Resize-Columns
		$Col0 = $lvMain.Columns[0].Text
		$Info = Get-RPADComputer
		$Info | %{
			$Item = New-Object System.Windows.Forms.ListViewItem($_.Properties.(($Col0).ToLower()))
			ForEach ($Col in ($lvMain.Columns | ?{$_.Index -ne 0})){
				$Field = $Col.Text
				[String]$SubItem = $_.Properties.(($Field).ToLower())
				if($SubItem -ne $null){$Item.SubItems.Add($SubItem)}
				else{$Item.SubItems.Add("")}
			}
			$lvMain.Items.Add($Item)
		}
		$SBPStatus.Text = "Ready"
	}
	
	$cmsSelect_Click={
		if ($lvMain.SelectedItems.Count -gt 1){$vbError = $vbmsg.popup("You may only select one computer at a time.",0,"Error",0)}
		else{$txtComputer.Text = $lvMain.SelectedItems[0].Text}
	}
	
	
	$btnSystemInfo_Click={
		Get-ComputerName
		Initialize-Listview
		$SBPStatus.Text = "Retrieving System Information..."
		Update-ContextMenu (Get-Variable cmsSystem*)
		
		$SysError = $null
		$sysComp = Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName -ErrorVariable SysError
		Start-Sleep -m 250
		if($SysError){$SBPStatus.Text = "[$ComputerName] $SysError"}
		else{
			$sysComp2 = Get-WmiObject Win32_ComputerSystemProduct -ComputerName $ComputerName
			$sysOS = Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName
			$sysBIOS = Get-WmiObject Win32_BIOS -ComputerName $ComputerName
			$sysCPU = Get-WmiObject Win32_Processor -ComputerName $ComputerName
			$sysRAM = Get-WmiObject Win32_PhysicalMemory -ComputerName $ComputerName
			$sysNAC = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $ComputerName -Filter "IPEnabled='True'"
			$sysMon = Get-WmiObject Win32_DesktopMonitor -ComputerName $ComputerName
			$sysVid = Get-WmiObject Win32_VideoController -ComputerName $ComputerName
			$sysOD = Get-WmiObject Win32_CDROMDrive -ComputerName $ComputerName
			$sysHD = Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName
			$sysProc = Get-WmiObject Win32_Process -ComputerName $ComputerName
		
			if ($XML.Options.SystemInfo.AntiVirus.Enabled -eq $true){
				$sysAV = Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct -ComputerName $ComputerName
				switch ($sysAV.ProductState) {
					"262144" {$DefStatus = "Up to date"  ;$RTStatus = "Disabled"}
				    "262160" {$DefStatus = "Out of date" ;$RTStatus = "Disabled"}
				    "266240" {$DefStatus = "Up to date"  ;$RTStatus = "Enabled"}
				    "266256" {$DefStatus = "Out of date" ;$RTStatus = "Enabled"}
				    "393216" {$DefStatus = "Up to date"  ;$RTStatus = "Disabled"}
				    "393232" {$DefStatus = "Out of date" ;$RTStatus = "Disabled"}
				    "393488" {$DefStatus = "Out of date" ;$RTStatus = "Disabled"}
				    "397312" {$DefStatus = "Up to date"  ;$RTStatus = "Enabled"}
				    "397328" {$DefStatus = "Out of date" ;$RTStatus = "Enabled"}
				    "397584" {$DefStatus = "Out of date" ;$RTStatus = "Enabled"}
					default  {$DefStatus = "Unknown" ;$RTStatus = "Unknown"}
				} 
			}
	
			if ($XML.Options.SystemInfo.General.DomainLocation.Enabled -eq $true -AND $Domain -ne 'Local'){
				$Script:ComputerName = $ComputerName.Split('.')[0]
				$sysOU = Get-RPADComputer
			}
	
			"Property","Value" | %{Add-Column $_}
			
			if ($XML.Options.SystemInfo.General.Enabled -eq $true){
				$Item = New-Object System.Windows.Forms.ListViewItem("General")
				$Item.BackColor = "Black"
				$Item.ForeColor = "White"
				$lvMain.Items.Add($Item)
				if($XML.Options.SystemInfo.General.ComputerName.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("Computer Name")
					$Item.SubItems.Add($sysComp.Name)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.General.DomainLocation.Enabled -eq $true -AND $Domain -ne 'Local'){
					$OU = $sysOU.Path.Substring($sysOU.Path.IndexOf(',')+1)
					$Item = New-Object System.Windows.Forms.ListViewItem("Computer OU")
					$Item.SubItems.Add($OU)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.General.CurrentUser.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("User")
					if($SysComp.UserName -ne $null){$Item.SubItems.Add($sysComp.UserName)}
					else{$Item.SubItems.Add("")}					
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.General.LogonTime.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("User Logon")
					if($sysProc | ?{$_.Name -eq "explorer.exe"}){
						$UserLogonDT = ($sysProc | ?{$_.Name -eq "explorer.exe"} | Sort CreationDate | Select-Object -First 1).CreationDate
						$UserLogon = [System.Management.ManagementDateTimeconverter]::ToDateTime($UserLogonDT).ToString()
						$Item.SubItems.Add($UserLogon)
					}else{
						$Item.SubItems.Add("N/A")
					}
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.General.ScreenSaverTime.Enabled -eq $true){
					
					$Item = New-Object System.Windows.Forms.ListViewItem("Screensaver Time")
					if($sysProc | ?{$_.Name -match ".scr"}){
						$ScreensaverTime = ($sysProc | ?{$_.Name -match ".scr"} | Sort CreationDate | Select-Object -First 1).CreationDate
						$Screensaver = [System.Management.ManagementDateTimeconverter]::ToDateTime($ScreensaverTime).ToString()
						$Item.SubItems.Add($Screensaver)
					}else{
						$Item.SubItems.Add("N/A")
					}
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.General.LastRestart.Enabled -eq $true){
					$LastBootUpTime = [System.Management.ManagementDateTimeconverter]::ToDateTime($sysOS.LastBootUpTime).ToString()
					$Item = New-Object System.Windows.Forms.ListViewItem("Last Restart")
					$Item.SubItems.Add($LastBootUpTime)
					$lvMain.Items.Add($Item)
				}
			}
			
			if ($XML.Options.SystemInfo.Build.Enabled -eq $true){
				$Item = New-Object System.Windows.Forms.ListViewItem("Build")
				$Item.BackColor = "Black"
				$Item.ForeColor = "White"
				$lvMain.Items.Add($Item)
				if($XML.Options.SystemInfo.Build.Manufacturer.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("Manufacturer")
					$Item.SubItems.Add($sysComp.Manufacturer)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.Build.Model.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("Model")
					$Item.SubItems.Add($sysComp.Model)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.Build.Chassis.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("Chassis")
					$Item.SubItems.Add($sysComp2.Version)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.Build.Serial.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("Serial")
					$Item.SubItems.Add($sysBIOS.SerialNumber)
					$lvMain.Items.Add($Item)
				}
			}
			
			if ($XML.Options.SystemInfo.Hardware.Enabled -eq $true){
				$Item = New-Object System.Windows.Forms.ListViewItem("Hardware")
				$Item.BackColor = "Black"
				$Item.ForeColor = "White"
				$lvMain.Items.Add($Item)
				if($XML.Options.SystemInfo.Hardware.CPU.Enabled -eq $true){
					$sysCPU | %{
					$Item = New-Object System.Windows.Forms.ListViewItem("CPU")
					$Item.SubItems.Add($sysCPU.Name.Trim())
					$lvMain.Items.Add($Item)
					}
				}
				if($XML.Options.SystemInfo.Hardware.RAM.Enabled -eq $true){
					$tRAM = "{0:N2} GB Usable - " -f $($sysComp.TotalPhysicalMemory / 1GB)
					$sysRAM | %{$tRAM += "[$($_.Capacity / 1GB)] "}
					$Item = New-Object System.Windows.Forms.ListViewItem("RAM")
					$Item.SubItems.Add($tRAM)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.Hardware.HD.Enabled -eq $true){
					$sysHD | ?{$_.DriveType -eq 3} | %{
						$HDInfo = "{0:N1} GB Free / {1:N1} GB Total" -f ($_.FreeSpace / 1GB), ($_.Size / 1GB)
						$Item = New-Object System.Windows.Forms.ListViewItem("HD")
						$Item.SubItems.Add($HDinfo)
						$lvMain.Items.Add($Item)
					}
				}
				if($XML.Options.SystemInfo.Hardware.OpticalDrive.Enabled -eq $true){
					$sysOD | %{
					$Item = New-Object System.Windows.Forms.ListViewItem("Optical Drive")
					$Item.SubItems.Add("[$($sysOD.Drive)] $($sysOD.Caption)")
					$lvMain.Items.Add($Item)
					}
				}
				if($XML.Options.SystemInfo.Hardware.GPU.Enabled -eq $true){
					$sysVid | ?{$_.AdapterRAM -gt 0} | %{
					$Item = New-Object System.Windows.Forms.ListViewItem("GPU")
					$Item.SubItems.Add($_.Name)
					$lvMain.Items.Add($Item)
					}
				}
				if($XML.Options.SystemInfo.Hardware.Monitor.Enabled -eq $true){
					$Monitors = $null
					$sysMON | %{$Monitors += "[{0} x {1}] " -f $_.ScreenWidth,$_.ScreenHeight}
					$Item = New-Object System.Windows.Forms.ListViewItem("Monitor(s)")
					$Item.SubItems.Add($Monitors)
					$lvMain.Items.Add($Item)
				}
			}
			
			if ($XML.Options.SystemInfo.OS.Enabled -eq $true){
				$Item = New-Object System.Windows.Forms.ListViewItem("Operating System")
				$Item.BackColor = "Black"
				$Item.ForeColor = "White"
				$lvMain.Items.Add($Item)
				if($XML.Options.SystemInfo.OS.OS.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("OS Name")
					$Item.SubItems.Add($sysOS.Caption)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.OS.ServicePack.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("Service Pack")
					$Item.SubItems.Add($sysOS.CSDVersion)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.OS.Architecture.Enabled -eq $true){
					$Item = New-Object System.Windows.Forms.ListViewItem("OS Architecture")
					$Item.SubItems.Add($sysComp.SystemType)
					$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.OS.ImageDate.Enabled -eq $true){
					$InstallDate = [System.Management.ManagementDateTimeconverter]::ToDateTime($sysOS.InstallDate).ToString()
					$Item = New-Object System.Windows.Forms.ListViewItem("Install Date")
					$Item.SubItems.Add($InstallDate)
					$lvMain.Items.Add($Item)
				}
			}
			
			if ($XML.Options.SystemInfo.IPConfig.Enabled -eq $true){
				$Item = New-Object System.Windows.Forms.ListViewItem("Network Adapters")
				$Item.BackColor = "Black"
				$Item.ForeColor = "White"
				$lvMain.Items.Add($Item)
				$sysNAC | %{
					if($XML.Options.SystemInfo.IPConfig.Description.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("Description")
						$Item.SubItems.Add($_.Description)
						$lvMain.Items.Add($Item)
					}
					if($XML.Options.SystemInfo.IPConfig.IPAddress.Enabled -eq $true){
						$IPinfo = $null
						ForEach ($IP in $_.IPAddress){$IPinfo += "$IP "}
						$Item = New-Object System.Windows.Forms.ListViewItem("IP Address")
						$Item.SubItems.Add($IPinfo)
						$lvMain.Items.Add($Item)
					}
					if($XML.Options.SystemInfo.IPConfig.MACAddress.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("MAC Address")
						$Item.SubItems.Add($_.MACAddress)
						$lvMain.Items.Add($Item)
					}
					if($XML.Options.SystemInfo.IPConfig.DHCPEnabled.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("DHCP Enabled")
						$Item.SubItems.Add($_.DHCPEnabled.ToString())
						$lvMain.Items.Add($Item)
					}
					if($XML.Options.SystemInfo.IPConfig.DHCPServer.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("DHCP Server")
						$Item.SubItems.Add($_.DHCPServer)
						$lvMain.Items.Add($Item)
					}
					if($XML.Options.SystemInfo.IPConfig.DNSDomain.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("DNS Domain")
						$Item.SubItems.Add($_.DNSDomain)
						$lvMain.Items.Add($Item)
					}
				}
			}
			if ($XML.Options.SystemInfo.Antivirus.Enabled -eq $true){
				$Item = New-Object System.Windows.Forms.ListViewItem("AntiVirus")
				$Item.BackColor = "Black"
				$Item.ForeColor = "White"
				$lvMain.Items.Add($Item)
				if($XML.Options.SystemInfo.Antivirus.Name.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("AV Name")
						$Item.SubItems.Add($sysAV.DisplayName)
						$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.Antivirus.DefinitionStatus.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("Definition Status")
						$Item.SubItems.Add($DefStatus)
						$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.Antivirus.RealTimeProtection.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("Real-Time Protection")
						$Item.SubItems.Add($RTStatus)
						$lvMain.Items.Add($Item)
				}
				if($XML.Options.SystemInfo.Antivirus.Executable.Enabled -eq $true){
						$Item = New-Object System.Windows.Forms.ListViewItem("Executable")
						$Item.SubItems.Add($sysAV.PathToSignedProductExe)
						$lvMain.Items.Add($Item)
				}
			}
			
			$lvMain.Columns[0].Width = "120"
			$lvMain.Columns[1].Width = ($lvMain.Width - ($lvMain.Columns[0].Width + 22))
			$SBPStatus.Text = "Ready"
		}
	}
	
	
	$btnProcesses_Click={
		Get-ComputerName
		Initialize-Listview
		$SBPStatus.Text = "Retrieving Processes..."
		Update-ContextMenu (Get-Variable cmsProc*)
		$XML.Options.Processes.Property | %{Add-Column $_}
		Resize-Columns
		$Col0 = $lvMain.Columns[0].Text
		$Info = Get-WmiObject win32_process -ComputerName $ComputerName -ErrorVariable SysError | Sort Name
		Start-Sleep -m 250
		if($SysError){$SBPStatus.Text = "[$ComputerName] $SysError"}
		else{
		$Info | %{
			$Item = New-Object System.Windows.Forms.ListViewItem($_.$Col0)
			ForEach ($Col in ($lvMain.Columns | ?{$_.Index -ne 0})){
				$Field = $Col.Text
				$SubItem = $_.$Field
				if($SubItem -ne $null){$Item.SubItems.Add($SubItem)}
				else{$Item.SubItems.Add("")}
			}
			$lvMain.Items.Add($Item)
		}
		$SBPStatus.Text = "Ready"
		}
	}
	
	$cmsProcEnd_Click={
		foreach ($Sel in $lvMain.SelectedItems){($Info | ?{$_.ProcessID -eq $Sel.Text}).Terminate()}
		Remove-SelectedItems
	}
	
	$btnStartupItems_Click={
		Get-ComputerName
		Initialize-Listview
		$SBPStatus.Text = "Retrieving Startup Items..."
		if((Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName).Version -eq "5.1.2600"){
			Write-Verbose "Windows XP does not report Win32_StartupCommand correctly."
			$vbError = $vbmsg.popup("This feature is not supported on Windows XP.",0,"Information",0)
			$SBPStatus.Text = "Ready"
			}
		else{
			Update-ContextMenu (Get-Variable cmsStart*)
			$XML.Options.StartupItems.Property | %{Add-Column $_}
			Resize-Columns
			$Col0 = $lvMain.Columns[0].Text
			$Info = Get-WmiObject win32_StartupCommand -ComputerName $ComputerName -ErrorVariable SysError | Sort Name
			Start-Sleep -m 250
			if($SysError){$SBPStatus.Text = "[$ComputerName] $SysError"}
			else{
			$Info | %{
				$Item = New-Object System.Windows.Forms.ListViewItem($_.$Col0)
				ForEach ($Col in ($lvMain.Columns | ?{$_.Index -ne 0})){$Field = $Col.Text;$Item.SubItems.Add($_.$Field)}
				$lvMain.Items.Add($Item)
				}
			$SBPStatus.Text = "Ready"
			}
		}
	}
	
	$cmsStartupRemove_Click={
		Get-ColumnIndex 'Caption'
		ForEach ($Sel in $lvMain.SelectedItems){
			if($Sel.Text -match 'HKU'){
				Remove-ItemProperty $Sel.SubItems[$ColumnIndex].Text -LiteralPath $Sel.Text.Replace('HKU','REGISTRY::HKEY_USERS')
			}else{
				Remove-ItemProperty $Sel.SubItems[$ColumnIndex].Text -LiteralPath $Sel.Text.Replace('HKLM','REGISTRY::HKEY_LOCAL_MACHINE')
			}
		}
		Remove-SelectedItems
	}
	
	$btnApplications_Click={
		Get-ComputerName
		Initialize-Listview
		$SBPStatus.Text = "Retrieving Applications..."
		Update-ContextMenu (Get-Variable cmsApp*)
		$XML.Options.Applications.Property | %{Add-Column $_}
		Resize-Columns
		$Col0 = $lvMain.Columns[0].Text
		$Info = Get-WmiObject win32_Product -ComputerName $ComputerName -ErrorVariable SysError | Sort Name,Vendor
		Start-Sleep -m 250
		if($SysError){$SBPStatus.Text = "[$ComputerName] $SysError"}
		else{
		$Info | %{
			$Item = New-Object System.Windows.Forms.ListViewItem($_.$Col0)
			ForEach ($Col in ($lvMain.Columns | ?{$_.Index -ne 0})){$Field = $Col.Text;$Item.SubItems.Add($_.$Field)}
			$lvMain.Items.Add($Item)
			}
		$SBPStatus.Text = "Ready"
		}
	}
	
	$cmsAppUninstall_Click={
		ForEach ($Sel in $lvMain.SelectedItems){($Info | ?{$_.Name -eq $Sel.Text}).Uninstall()}
		Remove-SelectedItems
	}
	
	$btnLocalAdmins_Click={
		Get-ComputerName
		Initialize-Listview
		$SBPStatus.Text = "Retrieving Local Admins..."
		Update-ContextMenu (Get-Variable cmsAdmin*)
		$XML.Options.LocalAdmins.Property | %{Add-Column $_}
		Resize-Columns
		$Col0 = $lvMain.Columns[0].Text
		Try{
			$Group = [ADSI]("WinNT://$ComputerName/Administrators,group")
			$Info = @()
			$Group.Members() | %{ 
			    $AdsPath = $_.GetType().InvokeMember("Adspath", 'GetProperty', $null, $_, $null)
			    $Prop = $AdsPath.split('/',[StringSplitOptions]::RemoveEmptyEntries)
			    $Name = $Prop[-1]
			    $Domain = $Prop[-2]
			    $Class = $_.GetType().InvokeMember("Class", 'GetProperty', $null, $_, $null)
	
			    $Member = New-Object PSObject -Property @{
			        Name = $Name
			        Domain = $Domain
			        Class = $Class
			        }
			    $Info += $Member
			}
			
			$Info | %{
				$Item = New-Object System.Windows.Forms.ListViewItem($_.$Col0)
				ForEach ($Col in ($lvMain.Columns | ?{$_.Index -ne 0})){$Field = $Col.Text;$Item.SubItems.Add($_.$Field)}
				$lvMain.Items.Add($Item)
			}
			
			$SBPStatus.Text = "Ready"
			}
		Catch{$SBPStatus.Text = "[$ComputerName] Error: Could not retrieve local administrators."}
		#
	}
	
	$cmsAdminRemove_Click={
		Get-ColumnIndex 'Domain'
		ForEach ($Sel in $lvMain.SelectedItems){
			$Computer = [ADSI]("WinNT://" + $ComputerName + ",computer")
			$Group = $Computer.psbase.children.find("Administrators")
			Try{$Group.Remove("WinNT://" + $Sel.SubItems[$ColumnIndex].Text + "/" + $Sel.Text)}
			Catch{$SBPStatus.Text = "Error removing selected administrator(s)."}
		}
		Remove-SelectedItems
	}
	
	$cmsAdminAdd_Click={
		$Input = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a username to add (Domain\Username)", "Add Local Admin", "")
		$Username = ($Input.Split('\'))[1]
		$Domain = ($Input.Split('\'))[0]
		$Group = [ADSI]("WinNT://" + $ComputerName + "/Administrators, group")
		$Group.Add("WinNT://" + $Domain + "/" + $Username)
	}
	
	$btnServices_Click={
		Get-ComputerName
		Initialize-Listview
		$SBPStatus.Text = "Retrieving Services..."
		Update-ContextMenu (Get-Variable cmsSvc*)
		$XML.Options.Services.Property | %{Add-Column $_}
		Resize-Columns
		$Col0 = $lvMain.Columns[0].Text
		$Info = Get-WmiObject Win32_Service -ComputerName $ComputerName -ErrorVariable SysError | Sort Name
		Start-Sleep -m 250
		if($SysError){$SBPStatus.Text = "[$ComputerName] $SysError"}
		else{
		$Info | %{
			$Item = New-Object System.Windows.Forms.ListViewItem($_.$Col0)
			ForEach ($Col in ($lvMain.Columns | ?{$_.Index -ne 0})){$Field = $Col.Text;$Item.SubItems.Add($_.$Field)}
			$lvMain.Items.Add($Item)
		}
		$SBPStatus.Text = "Ready"
		}
	}
	
	$btnRDP_Click={
		Get-ComputerName
		MSTSC.exe /v:$ComputerName
	}
	
	$btnRA_Click={
		Get-ComputerName
		MSRA.exe /OfferRA $ComputerName
	}
	
	$btnCDrive_Click={
		Get-ComputerName
		$ViewCDrive = "\\$ComputerName\C$"
		Explorer.exe $ViewCDrive
	}
	
	$btnMsg_Click={
		Get-ComputerName
		$Message = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a message to send", "Send Message to $ComputerName", "")
		If($Message -ne ''){
            $Msg = "MSG.exe * /SERVER:$ComputerName $Message"
	        Invoke-Expression $Msg
            }
	}
	
	$btnRestart_Click={
		Get-ComputerName
		$VBRestart = $VBMsg.popup("Are you sure you want to restart " + $ComputerName.ToUpper() + "?",0,"Restart " + $ComputerName.ToUpper() + "?",4)
		Switch ($VBRestart)
		{
			6 {Restart-Computer -Force -Computername $ComputerName}
			7 {}
		}
	}
	
	$menuViewEventVwr_Click={
		Get-ComputerName
		EventVwr $ComputerName
	}
	
	$menuViewServices_Click={
		Get-ComputerName
		Services.msc /Computer:$ComputerName
	}
	
	$menuViewUser_Click={
		Get-ComputerName
		LUsrMgr.msc /Computer:$ComputerName
	}
	
	$menuViewWSUSReport_Click={
		Get-ComputerName
		$sysHD = Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType='3'"
		$sysHD | %{
			$Drive = $_.DeviceID.Chars(0)
			$Path = "\\$ComputerName\$Drive`$\Windows\SoftwareDistribution\ReportingEvents.log"
			if (Test-Path $Path){Invoke-Item $Path}
		}
	}
	
	$menuViewWSUSUpdate_Click={
		Get-ComputerName
		$sysHD = Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType='3'"
		$sysHD | %{
			$Drive = $_.DeviceID.Chars(0)
			$Path = "\\$ComputerName\$Drive`$\Windows\WindowsUpdate.log"
			if (Test-Path $Path){Invoke-Item $Path}
		}
	}
	
	$menuHelpAbout_Click={
		$URL = "http://community.spiceworks.com/profile/show/Crusher%20X-ray"
		Start $URL
	}
	
	function Get-RPADComputer{
		$Properties = $XML.Options.Search.Property
		if($ComputerName -match "."){$ComputerName = $ComputerName.Split('.')[0]}
		$searcher=[adsisearcher]"(&(objectClass=computer)(name=$ComputerName*))"
		$searcher.PropertiesToLoad.AddRange($Properties) 
		$searcher.SearchRoot=$searchRoot 
		$searcher.FindAll()	
	}
	
	function Get-ColumnIndex{
		Param($ColumnName)
		$Script:ColumnIndex = ($lvMain.Columns | ?{$_.Text -eq $ColumnName}).Index
	}
	
	function Update-ContextMenu{
		Param($Vis)
		
		Get-Variable cms* | %{Try{$_.Value.Visible = $False}catch{}}
		$Vis | %{try{$_.Value.Visible = $True}catch{}}
	}
	
	function Initialize-Listview{
		$lvMain.Items.Clear()
		$lvMain.Columns.Clear()
	}
	
	function Get-ComputerName{
		if($txtComputer.Text -eq "." -or $txtComputer.Text -eq "localhost" -or $txtComputer.Text -eq "" -or $txtComputer.Text -eq $null){$txtComputer.Text = hostname}
		$Script:ComputerName = $txtComputer.Text
		Start-Sleep -Milliseconds 200
	}
	
	function Add-Column{
		Param([String]$Column)
		Write-Verbose "Adding $Column from XML file"
		$lvMain.Columns.Add($Column)
	}
	
	function Resize-Columns{
		Write-Verbose "Resizing columns based on column count"
		$ColWidth = (($lvMain.Width / ($lvMain.Columns).Count) - 11)
		$lvMain.Columns | %{$_.Width = $ColWidth}
	}
	
	function Remove-SelectedItems{
		$lvMain.SelectedItems | %{$lvMain.Items.RemoveAt($_.Index)}
	}
	
	function Set-FormTitle{
		$formMain.Text = $XML.Options.Product + " v" + $XML.Options.Version + " - Connected to " + $Domain	
	}
	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formMain.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$btnRestart.remove_Click($btnRestart_Click)
			$btnMsg.remove_Click($btnMsg_Click)
			$btnCDrive.remove_Click($btnCDrive_Click)
			$btnRA.remove_Click($btnRA_Click)
			$btnRDP.remove_Click($btnRDP_Click)
			$btnServices.remove_Click($btnServices_Click)
			$btnProcesses.remove_Click($btnProcesses_Click)
			$btnStartupItems.remove_Click($btnStartupItems_Click)
			$btnApplications.remove_Click($btnApplications_Click)
			$btnLocalAdmins.remove_Click($btnLocalAdmins_Click)
			$btnSystemInfo.remove_Click($btnSystemInfo_Click)
			$btnSearch.remove_Click($btnSearch_Click)
			$formMain.remove_Load($formMain_Load)
			$menuFileConnect.remove_Click($menuFileConnect_Click)
			$menuFileExit.remove_Click($menuFileExit_Click)
			$menuViewEventVwr.remove_Click($menuViewEventVwr_Click)
			$menuViewServices.remove_Click($menuViewServices_Click)
			$menuViewUser.remove_Click($menuViewUser_Click)
			$menuViewWSUSReport.remove_Click($menuViewWSUSReport_Click)
			$menuViewWSUSUpdate.remove_Click($menuViewWSUSUpdate_Click)
			$cmsProcEnd.remove_Click($cmsProcEnd_Click)
			$cmsStartupRemove.remove_Click($cmsStartupRemove_Click)
			$cmsAdminAdd.remove_Click($cmsAdminAdd_Click)
			$cmsAdminRemove.remove_Click($cmsAdminRemove_Click)
			$cmsAppUninstall.remove_Click($cmsAppUninstall_Click)
			$cmsSelect.remove_Click($cmsSelect_Click)
			$menuHelpAbout.remove_Click($menuHelpAbout_Click)
			$formMain.remove_Load($Form_StateCorrection_Load)
			$formMain.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	#
	# formMain
	#
	$formMain.Controls.Add($groupTools)
	$formMain.Controls.Add($groupInfo)
	$formMain.Controls.Add($lvMain)
	$formMain.Controls.Add($btnSearch)
	$formMain.Controls.Add($txtComputer)
	$formMain.Controls.Add($SB)
	$formMain.Controls.Add($menu)
	$formMain.ClientSize = '780, 646'
	$formMain.MainMenuStrip = $menu
	$formMain.Name = "formMain"
	$formMain.StartPosition = 'CenterScreen'
	$formMain.Text = "Arposh System Administration v2.0"
	$formMain.add_Load($formMain_Load)
	#
	# groupTools
	#
	$groupTools.Controls.Add($btnRestart)
	$groupTools.Controls.Add($btnMsg)
	$groupTools.Controls.Add($btnCDrive)
	$groupTools.Controls.Add($btnRA)
	$groupTools.Controls.Add($btnRDP)
	$groupTools.Location = '10, 301'
	$groupTools.Name = "groupTools"
	$groupTools.Size = '126, 177'
	$groupTools.TabIndex = 8
	$groupTools.TabStop = $False
	$groupTools.Text = "Tools"
	#
	# btnRestart
	#
	$btnRestart.Location = '9, 143'
	$btnRestart.Name = "btnRestart"
	$btnRestart.Size = '110, 25'
	$btnRestart.TabIndex = 12
	$btnRestart.Text = "Restart Computer"
	$btnRestart.UseVisualStyleBackColor = $True
	$btnRestart.add_Click($btnRestart_Click)
	#
	# btnMsg
	#
	$btnMsg.Location = '9, 112'
	$btnMsg.Name = "btnMsg"
	$btnMsg.Size = '110, 25'
	$btnMsg.TabIndex = 11
	$btnMsg.Text = "Send Message"
	$btnMsg.UseVisualStyleBackColor = $True
	$btnMsg.add_Click($btnMsg_Click)
	#
	# btnCDrive
	#
	$btnCDrive.Location = '9, 81'
	$btnCDrive.Name = "btnCDrive"
	$btnCDrive.Size = '110, 25'
	$btnCDrive.TabIndex = 10
	$btnCDrive.Text = "View C Drive"
	$btnCDrive.UseVisualStyleBackColor = $True
	$btnCDrive.add_Click($btnCDrive_Click)
	#
	# btnRA
	#
	$btnRA.Location = '9, 50'
	$btnRA.Name = "btnRA"
	$btnRA.Size = '110, 25'
	$btnRA.TabIndex = 9
	$btnRA.Text = "Remote Assistance"
	$btnRA.UseVisualStyleBackColor = $True
	$btnRA.add_Click($btnRA_Click)
	#
	# btnRDP
	#
	$btnRDP.Location = '9, 19'
	$btnRDP.Name = "btnRDP"
	$btnRDP.Size = '110, 25'
	$btnRDP.TabIndex = 8
	$btnRDP.Text = "Remote Desktop"
	$btnRDP.UseVisualStyleBackColor = $True
	$btnRDP.add_Click($btnRDP_Click)
	#
	# groupInfo
	#
	$groupInfo.Controls.Add($btnServices)
	$groupInfo.Controls.Add($btnProcesses)
	$groupInfo.Controls.Add($btnStartupItems)
	$groupInfo.Controls.Add($btnApplications)
	$groupInfo.Controls.Add($btnLocalAdmins)
	$groupInfo.Controls.Add($btnSystemInfo)
	$groupInfo.Location = '10, 83'
	$groupInfo.Name = "groupInfo"
	$groupInfo.Size = '126, 208'
	$groupInfo.TabIndex = 7
	$groupInfo.TabStop = $False
	$groupInfo.Text = "Information"
	#
	# btnServices
	#
	$btnServices.Location = '9, 174'
	$btnServices.Name = "btnServices"
	$btnServices.Size = '110, 25'
	$btnServices.TabIndex = 7
	$btnServices.Text = "Services"
	$btnServices.UseVisualStyleBackColor = $True
	$btnServices.add_Click($btnServices_Click)
	#
	# btnProcesses
	#
	$btnProcesses.Location = '9, 143'
	$btnProcesses.Name = "btnProcesses"
	$btnProcesses.Size = '110, 25'
	$btnProcesses.TabIndex = 6
	$btnProcesses.Text = "Processes"
	$btnProcesses.UseVisualStyleBackColor = $True
	$btnProcesses.add_Click($btnProcesses_Click)
	#
	# btnStartupItems
	#
	$btnStartupItems.Location = '9, 112'
	$btnStartupItems.Name = "btnStartupItems"
	$btnStartupItems.Size = '110, 25'
	$btnStartupItems.TabIndex = 5
	$btnStartupItems.Text = "Startup Items"
	$btnStartupItems.UseVisualStyleBackColor = $True
	$btnStartupItems.add_Click($btnStartupItems_Click)
	#
	# btnApplications
	#
	$btnApplications.Location = '9, 81'
	$btnApplications.Name = "btnApplications"
	$btnApplications.Size = '110, 25'
	$btnApplications.TabIndex = 4
	$btnApplications.Text = "Applications"
	$btnApplications.UseVisualStyleBackColor = $True
	$btnApplications.add_Click($btnApplications_Click)
	#
	# btnLocalAdmins
	#
	$btnLocalAdmins.Location = '9, 50'
	$btnLocalAdmins.Name = "btnLocalAdmins"
	$btnLocalAdmins.Size = '110, 25'
	$btnLocalAdmins.TabIndex = 3
	$btnLocalAdmins.Text = "Local Admins"
	$btnLocalAdmins.UseVisualStyleBackColor = $True
	$btnLocalAdmins.add_Click($btnLocalAdmins_Click)
	#
	# btnSystemInfo
	#
	$btnSystemInfo.Location = '9, 19'
	$btnSystemInfo.Name = "btnSystemInfo"
	$btnSystemInfo.Size = '110, 25'
	$btnSystemInfo.TabIndex = 2
	$btnSystemInfo.Text = "System Info"
	$btnSystemInfo.UseVisualStyleBackColor = $True
	$btnSystemInfo.add_Click($btnSystemInfo_Click)
	#
	# lvMain
	#
	$lvMain.Anchor = 'Top, Bottom, Left, Right'
	$lvMain.ContextMenuStrip = $contextMenu
	$lvMain.FullRowSelect = $True
	$lvMain.GridLines = $True
	$lvMain.Location = '142, 28'
	$lvMain.Name = "lvMain"
	$lvMain.Size = '630, 590'
	$lvMain.TabIndex = 13
	$lvMain.UseCompatibleStateImageBehavior = $False
	$lvMain.View = 'Details'
	#
	# btnSearch
	#
	$btnSearch.Location = '19, 52'
	$btnSearch.Name = "btnSearch"
	$btnSearch.Size = '110, 25'
	$btnSearch.TabIndex = 1
	$btnSearch.Text = "Search for PC"
	$btnSearch.UseVisualStyleBackColor = $True
	$btnSearch.add_Click($btnSearch_Click)
	#
	# txtComputer
	#
	$txtComputer.Location = '10, 28'
	$txtComputer.Name = "txtComputer"
	$txtComputer.Size = '126, 20'
	$txtComputer.TabIndex = 0
	#
	# SB
	#
	$SB.Anchor = 'Bottom, Left, Right'
	$SB.Dock = 'None'
	$SB.Location = '0, 624'
	$SB.Name = "SB"
	[void]$SB.Panels.Add($SBPBlog)
	[void]$SB.Panels.Add($SBPStatus)
	$SB.ShowPanels = $True
	$SB.Size = '780, 22'
	$SB.TabIndex = 1
	$SB.Text = "Ready"
	#
	# menu
	#
	[void]$menu.Items.Add($menuFile)
	[void]$menu.Items.Add($menuView)
	[void]$menu.Items.Add($menuHelp)
	$menu.Location = '0, 0'
	$menu.Name = "menu"
	$menu.Size = '780, 24'
	$menu.TabIndex = 0
	$menu.Text = "menuMain"
	#
	# menuFile
	#
	[void]$menuFile.DropDownItems.Add($menuFileConnect)
	[void]$menuFile.DropDownItems.Add($menuFileExit)
	$menuFile.Name = "menuFile"
	$menuFile.Size = '37, 20'
	$menuFile.Text = "File"
	#
	# menuFileConnect
	#
	$menuFileConnect.Name = "menuFileConnect"
	$menuFileConnect.Size = '186, 22'
	$menuFileConnect.Text = "Connect to domain..."
	$menuFileConnect.add_Click($menuFileConnect_Click)
	#
	# menuFileExit
	#
	$menuFileExit.Name = "menuFileExit"
	$menuFileExit.Size = '186, 22'
	$menuFileExit.Text = "Exit"
	$menuFileExit.add_Click($menuFileExit_Click)
	#
	# menuView
	#
	[void]$menuView.DropDownItems.Add($menuViewEventVwr)
	[void]$menuView.DropDownItems.Add($menuViewServices)
	[void]$menuView.DropDownItems.Add($menuViewUser)
	[void]$menuView.DropDownItems.Add($menuViewWSUS)
	$menuView.Name = "menuView"
	$menuView.Size = '44, 20'
	$menuView.Text = "View"
	#
	# menuViewEventVwr
	#
	$menuViewEventVwr.Name = "menuViewEventVwr"
	$menuViewEventVwr.Size = '166, 22'
	$menuViewEventVwr.Text = "Event Viewer"
	$menuViewEventVwr.add_Click($menuViewEventVwr_Click)
	#
	# menuViewServices
	#
	$menuViewServices.Name = "menuViewServices"
	$menuViewServices.Size = '166, 22'
	$menuViewServices.Text = "Services"
	$menuViewServices.add_Click($menuViewServices_Click)
	#
	# menuViewUser
	#
	$menuViewUser.Name = "menuViewUser"
	$menuViewUser.Size = '166, 22'
	$menuViewUser.Text = "Users and Groups"
	$menuViewUser.add_Click($menuViewUser_Click)
	#
	# menuViewWSUS
	#
	[void]$menuViewWSUS.DropDownItems.Add($menuViewWSUSReport)
	[void]$menuViewWSUS.DropDownItems.Add($menuViewWSUSUpdate)
	$menuViewWSUS.Name = "menuViewWSUS"
	$menuViewWSUS.Size = '166, 22'
	$menuViewWSUS.Text = "WSUS Logs"
	#
	# menuViewWSUSReport
	#
	$menuViewWSUSReport.Name = "menuViewWSUSReport"
	$menuViewWSUSReport.Size = '126, 22'
	$menuViewWSUSReport.Text = "Reporting"
	$menuViewWSUSReport.add_Click($menuViewWSUSReport_Click)
	#
	# menuViewWSUSUpdate
	#
	$menuViewWSUSUpdate.Name = "menuViewWSUSUpdate"
	$menuViewWSUSUpdate.Size = '152, 22'
	$menuViewWSUSUpdate.Text = "Updates"
	$menuViewWSUSUpdate.add_Click($menuViewWSUSUpdate_Click)
	#
	# contextMenu
	#
	[void]$contextMenu.Items.Add($cmsProcEnd)
	[void]$contextMenu.Items.Add($cmsStartupRemove)
	[void]$contextMenu.Items.Add($cmsAdminAdd)
	[void]$contextMenu.Items.Add($cmsAdminRemove)
	[void]$contextMenu.Items.Add($cmsAppUninstall)
	[void]$contextMenu.Items.Add($cmsSelect)
	$contextMenu.Name = "contextMenu"
	$contextMenu.Size = '188, 114'
	#
	# cmsProcEnd
	#
	$cmsProcEnd.Name = "cmsProcEnd"
	$cmsProcEnd.Size = '187, 22'
	$cmsProcEnd.Text = "End Process"
	$cmsProcEnd.Visible = $False
	$cmsProcEnd.add_Click($cmsProcEnd_Click)
	#
	# cmsStartupRemove
	#
	$cmsStartupRemove.Name = "cmsStartupRemove"
	$cmsStartupRemove.Size = '187, 22'
	$cmsStartupRemove.Text = "Remove Startup Item"
	$cmsStartupRemove.Visible = $False
	$cmsStartupRemove.add_Click($cmsStartupRemove_Click)
	#
	# cmsAdminAdd
	#
	$cmsAdminAdd.Name = "cmsAdminAdd"
	$cmsAdminAdd.Size = '187, 22'
	$cmsAdminAdd.Text = "Add Local Admin"
	$cmsAdminAdd.Visible = $False
	$cmsAdminAdd.add_Click($cmsAdminAdd_Click)
	#
	# cmsAdminRemove
	#
	$cmsAdminRemove.Name = "cmsAdminRemove"
	$cmsAdminRemove.Size = '187, 22'
	$cmsAdminRemove.Text = "Remove Local Admin"
	$cmsAdminRemove.Visible = $False
	$cmsAdminRemove.add_Click($cmsAdminRemove_Click)
	#
	# cmsAppUninstall
	#
	$cmsAppUninstall.Name = "cmsAppUninstall"
	$cmsAppUninstall.Size = '187, 22'
	$cmsAppUninstall.Text = "Uninstall"
	$cmsAppUninstall.Visible = $False
	$cmsAppUninstall.add_Click($cmsAppUninstall_Click)
	#
	# cmsSelect
	#
	$cmsSelect.Name = "cmsSelect"
	$cmsSelect.Size = '187, 22'
	$cmsSelect.Text = "Select Computer"
	$cmsSelect.Visible = $False
	$cmsSelect.add_Click($cmsSelect_Click)
	#
	# menuHelp
	#
	[void]$menuHelp.DropDownItems.Add($menuHelpAbout)
	$menuHelp.Name = "menuHelp"
	$menuHelp.Size = '44, 20'
	$menuHelp.Text = "Help"
	#
	# menuHelpAbout
	#
	$menuHelpAbout.Name = "menuHelpAbout"
	$menuHelpAbout.Size = '152, 22'
	$menuHelpAbout.Text = "About"
	$menuHelpAbout.add_Click($menuHelpAbout_Click)
	#
	# SBPStatus
	#
	$SBPStatus.AutoSize = 'Spring'
	$SBPStatus.Name = "SBPStatus"
	$SBPStatus.Text = "Ready"
	$SBPStatus.Width = 620
	#
	# SBPBlog
	#
	$SBPBlog.Alignment = 'Center'
	$SBPBlog.Name = "SBPBlog"
	$SBPBlog.Text = "Crusher X-ray"
	$SBPBlog.Width = 143
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formMain.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formMain.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formMain.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $formMain.ShowDialog()

} #End Function

#Call OnApplicationLoad to initialize
if((OnApplicationLoad) -eq $true)
{
	#Call the form
	Call-AWSA_pff | Out-Null
	#Perform cleanup
	OnApplicationExit
}
