#定义结果输出路径
$OutFile = "D:\CPU_" + (Get-Date).GetDateTimeFormats()[1] + ".csv"
#定义性能收集器对象
$CpuCores = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
$Processes = Get-Counter "\Process(*)\% Processor Time"
$Timestamp = $Processes.Timestamp
$Samples = $Processes.CounterSamples
#对相同进程进行叠加汇总
$Process_Poly=@()
$Process_Group = $Samples | Group-Object -Property InstanceName
Foreach ($Group in $Process_Group)
{
    $TempObj = New-Object psobject
    $Member = $Group.Group
    $MemberName = $Group.Name
    $Sum = ($Member | measure -Property CookedValue -Sum).sum
        if ($sum -ne "0") 
        {
            $Sumformat = "{0:N2}" -f ($sum)
            $TempObj | Add-member -Type NoteProperty -name "Process" -value $MemberName
            $TempObj | Add-member -Type NoteProperty -name "CPU%" -value $Sumformat
            $TempObj | Add-member -Type NoteProperty -name "Timestamp" -value $Timestamp
            $Process_Poly +=$TempObj
        }
}
#输出结果
$Process_Poly | Export-Csv -Path $OutFile -Encoding utf8 -Force -NoTypeInformation -Append