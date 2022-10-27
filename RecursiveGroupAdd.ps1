#This script recursively adds a permission group to every directory/file

#Created by Yaen Torres Rosales

#--------------------------------------------------------------------#

write-host " "

#Grabs path from User 
$path = read-host "Enter full path"

#Grabs every directory within patch
#Progress Variable Created
$x = 0

#Stores the permission group
$permGroup = read-host "Enter Workgroup\Permissiongroup: "

#Starts recursive Get-ChildItem
$subPaths = Get-childitem -recurse -force -path $path

#Gets the total count of directories for progress bar
$total = $subPaths.count

#Loops through the whole
foreach ($child in $subPaths) {

#Displays child name
write-host ""
write-host ""
write-host "+--------------------------------- " $child.name "--------------------------------+"
write-host ""
write-host ""
write-host ""
write-host "Directory:" $child.FullName

#Grabs ACL for each child
$ACL = Get-Acl -Path $child.FullName

#Displays ACL for child
write-host ""
(Get-Acl -Path $child.FullName).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#New rule is created
$newRule = new-object System.Security.Accesscontrol.FileSystemAccessRule ("$permGroup","Read","Allow")

#New rule is added to ACL variable
$ACL.AddAccessRule($newRule)

#New ACL is set to the actual path
set-acl -path $child.FullName -aclobject $ACL

#Displays new ACL for child
(Get-Acl -Path $child.FullName).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

#Math for Progress Bar
$count += 1
$x = ($count / $total) * 100

$status = "Adding to " + $child.FullName

#Displays Progress Bar
Write-Progress -Activity "Adding group $permGroup ..." -status $status -PercentComplete $x

}

#Completes Progress Bar
write-progress -activity "$permGroup added to all sub directories" -Completed
