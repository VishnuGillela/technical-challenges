[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $Object,

    [Parameter(Mandatory=$true)]
    [string]
    $Key
)
Function Get-KeyValueFromObject([Parameter(Mandatory=$true)]$Object,[Parameter(Mandatory=$true)]$Key) {

    if(!$Key){Write-Error "Supply value for 'Key' parameter"}
    if(!$Object){Write-Error "Supply value for 'Object' parameter"}
    
    #Convert input json object into object
    $ConvertedObject = $Object | ConvertFrom-Json
    
    #Split input key by delimeter '/'
    $SplitKey = $Key.Split('/')

    #Initialize count integer to 0
    $Count = 0

    #Copy ConvertedObject into TempObj variable for further operations
    $TempObj = $ConvertedObject

    #While loop to perform operations with condition $Count less than number of indexes in $SplitKey
    while ($Count -lt $SplitKey.Count) {

        #Retrieve value for key with count index and copy output into $TempObj
        $TempObj = $TempObj.$($SplitKey[$Count])
        
        #Increment $Count by 1
        $Count++
    }

    #Return final output value
    return $TempObj
}

Get-KeyValueFromObject -Object $Object -Key $Key
#Get-KeyValueFromObject -Object '{"a":{"b":{"c":"d"}}}' -Key 'a/b/c'

#Get-KeyValueFromObject -Object '{"x":{"y":{"z":"a"}}}' -Key 'x/y/z'