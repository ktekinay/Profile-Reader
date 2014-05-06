If BuildMacMachOx86 then
  
  ////////////////////////////////////////////////////////////////////////////////////////////////
  // Xojo build script by App Wrapper Mini 1.2.2 (152) - ©2013 Ohanaware Co., Ltd.
  // Script Built: May 6, 2014 @ 4:51:40 PM
  // Script Format: 0007
  ////////////////////////////////////////////////////////////////////////////////////////////////
  // Set-up the globally required variables
  ////////////////////////////////////////////////////////////////////////////////////////////////
  
  dim appPath as string = currentBuildLocation + "/" + shellEncode( currentBuildAppName )
  if right( appPath, 4 ) <> ".app" then appPath = appPath + ".app"
  if appPath = "/.app" then// - Validate that the script occurs _after_ the Build stage!
    msgBox( "Critical Script Error: Unable to get the path to the built application.", "Please ensure the App Wrapper Mini script is below the 'Build' action in the 'OS X' build settings." )
    
  else
    dim resourcesFolder as string = appPath + "/Contents/Resources/"
    dim plistFile as string = appPath+"/Contents/Info.plist"
    dim plistEntries( -1 ) as string
    const documentUUID = "9D5FCB652171F8A67D"
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Enabling the Retina Bit, so we need to check for NSPrincipleClass
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    Try
      Dim hasPrincipleClass as string = readValue( plistFile, "NSPrincipleClass" )
      If instr( hasPrincipleClass, "does not exist" ) > 0 then
        plistEntries.append "NSPrincipleClass -string ""NSApplication"""
      End if
    End Try
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Begin Converting Version Numbers to Hybrid format.
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    Try
      Dim versionString as string = readValue( plistFile, "CFBundleVersion" )
      plistEntries.append "CFBundleGetInfoString -string """+nthfield( versionString, ".", 1 )+"."+nthfield( versionString, ".", 2 )+"."+nthfield( versionString, ".", 3 )+""""
      plistEntries.append "CFBundleVersion -string """+nthfield( versionString, ".", 1 )+"."+nthfield( versionString, ".", 2 )+"."+nthfield( versionString, ".", 3 )+""""
    End Try
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Begin Building Property List Entries
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    plistEntries.append "NSHighResolutionCapable -bool YES"
    plistEntries.append "LSMinimumSystemVersion -string ""10.7"""
    // End Building Property List Entries
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Begin Adding Property List Entries
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    Try
      call writeValue( plistFile, "AppWrapperMini -int 1" )
      If readValue( plistFile, "AppWrapperMini" ) <> "1" then
        msgBox( "Failed to write to the plist file successfully" )
      Else
        Dim n,l as integer
        n = ubound( plistEntries )
        for l=0 to n
          If writeValue( plistFile, plistEntries( l ) ) = false then exit
        next
      End If
      call deleteValue( plistFile, "AppWrapperMini" )
    End Try
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Begin cleaning up the permissions
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    call execute( "/bin/chmod -RN "+appPath, "Resetting Permissions" )
    call execute( "/bin/chmod -R 755 "+appPath, "Resetting Permissions" )
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Touching the file....
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    call execute( "/usr/bin/touch -acm "+appPath, "Touching the app" )
    
  End if // End Execution Block - after validating the script is in the correct location.
  
Else
  msgBox( "App Wrapper Mini currently only support Mac builds" )
End If // End Macintosh Specific Block

////////////////////////////////////////////////////////////////////////////////////////////////
// Helper functions for this script
////////////////////////////////////////////////////////////////////////////////////////////////

Function execute( inCommand as string, inMethodName as string ) as boolean
  Dim result as string = DoShellCommand( inCommand )
  if result <> "" then
    msgbox( "An error occurred while "+inMethodName, "Message: "+result )
    return false
  else
    return true
  end if
End Function
Function shellEncode( inValue as string ) as string
  Dim rvalue as string = replaceAll( inValue, " ", "\ " )
  rvalue = replaceAll( rvalue, "&", "\&" )
  rvalue = replaceAll( rvalue, "-", "\-" )
  rvalue = replaceAll( rvalue, "(", "\(" )
  rvalue = replaceAll( rvalue, ")", "\)" )
  return rvalue
End Function
Sub msgBox( inMessage as string, inSecondLine as string = "" )
  call showDialog( inMessage, inSecondLine, "OK", "", "", 0 )
End Sub
Function copyFile( inSource as string, inTarget as string, inMethodName as string ) as boolean
  return execute( "/bin/cp -fR "+inSource+" "+inTarget, inMethodName )
End Function
Function readValue( plistFile as string, key as string ) as string
  return trim( DoShellCommand( "/usr/bin/defaults read "+plistfile+" "+key ) )
End Function
Function writeValue( plistFile as string, value as string ) as boolean
  return execute( "/usr/bin/defaults write "+plistFile+" " + value, "Adding "+value+" to the info.plist file." )
End Function
Function deleteValue( plistFile as string, key as string ) as boolean
  return execute( "/usr/bin/defaults delete "+plistFile+" "+key, "Deleting "+key+" from info.plist file." )
End Function