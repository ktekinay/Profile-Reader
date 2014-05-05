#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Close()
		  if zDocOpenerTimer <> nil then
		    zDocOpenerTimer.Mode = Timer.ModeOff
		    RemoveHandler zDocOpenerTimer.Action, AddressOf pDocOpenerTimerAction
		    zDocOpenerTimer = nil
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  zPostStartupTimer = new Tmr_PostStartup
		  zPostStartupTimer.Period = 500
		  zPostStartupTimer.Mode = Timer.ModeSingle
		  
		  // This doesn't do anything other than generate a separate thread for profiling
		  dim t as new Thd_Tester
		  t.Run
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub OpenDocument(item As FolderItem)
		  if item <> nil and item.Exists and not item.Directory then
		    zDocsToOpen.Append item
		    pGetDocOpenerTimer.Mode = Timer.ModeSingle
		  end if
		  
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function FileOpen() As Boolean Handles FileOpen.Action
			pDoFileOpen
			return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpAbout() As Boolean Handles HelpAbout.Action
			Wnd_About.Show
			
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h1
		Protected Sub pDocOpenerTimerAction(sender As Timer)
		  dim doc as FolderItem
		  if zDocsToOpen.Ubound <> -1 then
		    doc = zDocsToOpen.Pop
		  end if
		  
		  if doc <> nil then
		    dim profileDoc as ProfileDocument = ProfileDocument.CreateFromDocument( doc )
		    if doc <> nil then
		      dim w as Wnd_Main = pWindowForItem( doc )
		      if w <> nil then
		        w.Show( profileDoc )
		      end if
		    end if
		  end if
		  
		  if zDocsToOpen.Ubound <> -1 then
		    sender.Mode = Timer.ModeSingle
		  else
		    sender.Mode = Timer.ModeOff
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub pDoFileOpen()
		  dim dlg as new OpenDialog
		  dlg.PromptText = "Select a ""Profile.txt"" file:"
		  dlg.Filter = FileTypes1.Text
		  dim f as FolderItem = dlg.ShowModal
		  if f <> nil then
		    OpenDocument( f )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function pGetDocOpenerTimer() As Timer
		  if zDocOpenerTimer = nil then
		    zDocOpenerTimer = new Timer
		    zDocOpenerTimer.Mode = Timer.ModeOff
		    zDocOpenerTimer.Period = 100
		    
		    AddHandler zDocOpenerTimer.Action, AddressOf pDocOpenerTimerAction
		  end if
		  
		  return zDocOpenerTimer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PostStartup()
		  // Tackles tasks after all other startup has finished
		  
		  if WindowCount = 0 then // No documents opened
		    pDoFileOpen()
		  end if
		  
		  zPostStartupTimer.Mode = Timer.ModeOff
		  zPostStartupTimer = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function pWindowForItem(item As FolderItem) As Wnd_Main
		  // Finds the Wnd_Main for the given item.
		  // Otherwise, returns a new Wnd_Main
		  
		  dim r as Wnd_Main
		  
		  if item is nil or not item.Exists then
		    return nil
		  end if
		  
		  if not item.Directory then
		    item = item.Parent
		  end if
		  
		  dim lastIndex as Integer = WindowCount - 1
		  for i as Integer = 0 to lastIndex
		    dim w as Window = Window( i )
		    if w IsA Wnd_Main and Wnd_Main( w ).ParentFolder.NativePath = item.NativePath then
		      r = Wnd_Main( w )
		      exit
		    end if
		  next i
		  
		  if r is nil then
		    r = new Wnd_Main
		  end if
		  
		  return r
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected zDocOpenerTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zDocsToOpen() As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zPostStartupTimer As Timer
	#tag EndProperty


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileOpen, Type = String, Dynamic = False, Default = \"&Open...", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


End Class
#tag EndClass
