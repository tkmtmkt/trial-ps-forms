<#
start powershell -ArgumentList "-NoLogo","-NoProfile","-WindowStyle Hidden","-File",".\main.ps1"
#>
# アセンブリの読み込み
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#ストップウォッチ
$Watch = New-Object System.Diagnostics.Stopwatch

#タイマー
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 10
$Time = {
    $Now = $Watch.Elapsed
    $Label.Text = "$Now".substring(0,11)
}
$Timer.Add_Tick($Time)

# フォームの作成
$MainForm = New-Object System.Windows.Forms.Form
$MainForm.Size = "190,170"
$MainForm.font = New-Object System.Drawing.Font("メイリオ",9)
$MainForm.StartPosition = "CenterScreen"
$MainForm.MinimizeBox = $False
$MainForm.MaximizeBox = $False
$MainForm.TopLevel = $True
$MainForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
#FixedSingle、Fixed3D、FixedDialog、FixedToolWindow
$MainForm.Modal = $True
$MainForm.Text = "ストップウォッチ"

# 時間表示ラベル
$Label = New-Object System.Windows.Forms.Label
$Label.Location = "10,10"
$Label.Size = "150,50"
$Label.text = "00:00:00.00"
$Label.Font = New-Object System.Drawing.Font("メイリオ",16)
$Label.textAlign = "MiddleCenter"

# 開始・停止兼用ボタン
$Button = New-Object System.Windows.Forms.Button
$Button.Location = "10,70"
$Button.Size = "70,50"
$Button.Text = "開 始"
$Click = {
    IF ( $Watch.IsRunning -eq $False ) #ストップウォッチが起動していない時 = 計測を開始
    {
        $Timer.Start()
        $Watch.Start()
        $Button.Text = "停 止"
    }else{ #ストップウォッチが起動している時 = 計測を停止
        $Timer.Stop()
        $Watch.Stop()
        $ResetButton.Enabled = $true
        $Button.Text = "再 開"
    }
}
$Button.Add_Click($Click)

# リセットボタン
$ResetButton = New-Object System.Windows.Forms.Button
$ResetButton.Location = "90,70"
$ResetButton.Size = "70,50"
$ResetButton.Text = "リセット"
$ResetButton.Enabled = $False
$Reset = {
    $Label.text = "00:00:00.00"
    $Watch.Reset()
    $Button.Text = "開 始"
    $ResetButton.Enabled = $False
}
$ResetButton.Add_Click($Reset)

# フォームに各アイテムを設置 
$MainForm.Controls.AddRange(@($Label,$Button,$ResetButton))

# フォームを表示 
$MainForm.ShowDialog()
