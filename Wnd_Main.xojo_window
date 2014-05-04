#tag Window
Begin Window Wnd_Main
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   1856602461
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Profile Reader"
   Visible         =   True
   Width           =   966
   Begin Listbox lbProfiles
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   1
      ColumnsResizable=   False
      ColumnWidths    =   ""
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   False
      HeadingIndex    =   -1
      Height          =   316
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "SmallSystem"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   64
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   180
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin Listbox lbMethods
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   5
      ColumnsResizable=   True
      ColumnWidths    =   ",70,100,100,130"
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   316
      HelpTag         =   ""
      Hierarchical    =   True
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   " 	Called	Total (ms)	Average (ms)	Percent Of Total"
      Italic          =   False
      Left            =   212
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "SmallSystem"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   64
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   734
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h1
		Protected Sub pPopulateProfilesListBox()
		  if zProfileDocsDict is nil then return
		  
		  dim selectedProfile as ProfileDocument
		  if lbProfiles.ListIndex <> -1 and lbProfiles.ListIndex < lbProfiles.ListCount then
		    selectedProfile = lbProfiles.RowTag( lbProfiles.ListIndex )
		  end if
		  
		  #if not TargetMacOS
		    lbProfiles.Visible = False
		  #endif
		  lbProfiles.DeleteAllRows
		  
		  dim profileName as String
		  dim dictValues() as Variant = zProfileDocsDict.Values
		  for each profile as ProfileDocument in dictValues
		    profileName = profile.Document.Name
		    lbProfiles.AddRow( profileName )
		    lbProfiles.RowTag( lbProfiles.LastIndex ) = profile
		  next profile
		  
		  #if not TargetMacOS
		    lbProfiles.Visible = True
		  #endif
		  
		  lbProfiles.SortedColumn = 0
		  lbProfiles.Sort
		  
		  if selectedProfile <> nil then
		    pShowProfile( selectedProfile.ID )
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub pScanParentFolder()
		  // Scans the parent folder and pulls out all the profiles
		  
		  if zProfileDocsDict is nil then
		    zProfileDocsDict = new Dictionary
		  end if
		  
		  dim pFolder as FolderItem = self.ParentFolder
		  if pFolder is nil then return // Really shouldn't happen
		  
		  dim updateListBox as Boolean
		  dim fileList() as FolderItem
		  dim cnt as Integer = pFolder.Count
		  for i as Integer = 1 to cnt
		    fileList.Append( pFolder.Item( i ) )
		  next
		  
		  dim newDict as new Dictionary
		  for each f as FolderItem in fileList
		    dim fName as string = f.Name
		    if fName.Left( 7 ) = "Profile" and fName.Right( 4 ) = ".txt" then
		      dim profile as ProfileDocument = ProfileDocument.CreateFromDocument( f )
		      if profile <> nil then
		        if not zProfileDocsDict.HasKey( profile.ID ) then
		          updateListBox = True
		        end if
		        newDict.Value( profile.ID ) = profile
		      end if
		    end if
		  next
		  
		  // Was something deleted?
		  if zProfileDocsDict.Count <> newDict.Count then
		    updateListBox = True
		  end if
		  
		  zProfileDocsDict = newDict
		  if updateListBox then
		    pPopulateProfilesListBox()
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub pShowProfile(profileID As String)
		  if profileID = "" then
		    lbProfiles.ListIndex = -1
		    return
		  end if
		  
		  dim lastRow as Integer = lbProfiles.ListCount - 1
		  for row as Integer = 0 to lastRow
		    dim profile as ProfileDocument = lbProfiles.RowTag( row )
		    if profile.ID = profileID then
		      lbProfiles.ListIndex = row
		      exit
		    end if
		  next row
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Show(profileDoc as ProfileDocument)
		  // By the time the doc gets here, it will have been validated
		  
		  self.Show()
		  
		  if zProfileDocsDict is nil then
		    zProfileDocsDict = new Dictionary
		  end if
		  
		  if self.ParentFolder is nil or self.ParentFolder.NativePath <> profileDoc.Document.NativePath then
		    self.ParentFolder = profileDoc.Document.Parent
		  end if
		  dim pFolder as FolderItem = self.ParentFolder
		  
		  // Rename the FolderItem if needed.
		  dim f as FolderItem = profileDoc.Document
		  if f.Name = "Profile.txt" then // Default name, so rename it
		    dim sqlTime as String = profileDoc.StartDate.SQLDateTime
		    dim newNamePrefix as String = "Profile " + sqlTime.ReplaceAll( ":", "-" )
		    dim newNameSuffix as String = ".txt"
		    dim newName as String = newNamePrefix + newNameSuffix
		    dim moveTo as FolderItem = pFolder.Child( newName )
		    dim index as Integer
		    while moveTo.Exists
		      index = index + 1
		      newName = newNamePrefix + " (" + Str( index ) + ")" + newNameSuffix
		      moveTo = pFolder.Child( newName )
		    wend
		    f.Name = newName
		    profileDoc.Document = f
		  end if
		  
		  pScanParentFolder()
		  pShowProfile( profileDoc )
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if zParentFolder = nil then
			    return nil
			  else
			    return zParentFolder
			  end if
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  zParentFolder = value
			  
			End Set
		#tag EndSetter
		ParentFolder As FolderItem
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected zParentFolder As FolderItemAlias
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			Key is the ProfileDocument.ID
			
		#tag EndNote
		Protected zProfileDocsDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zValid As Boolean
	#tag EndProperty


	#tag Constant, Name = kColumnAverageTime, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kColumnCalled, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kColumnPercent, Type = Double, Dynamic = False, Default = \"4", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kColumnTimeSpent, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant


#tag EndWindowCode

#tag Events lbProfiles
	#tag Event
		Sub Change()
		  lbMethods.DeleteAllRows()
		  if me.ListIndex = -1 then return
		  
		  dim profile As ProfileDocument = me.RowTag( me.ListIndex )
		  dim lastCol as Integer = lbMethods.ColumnCount - 1
		  
		  // Just add the threads here, then expand them as needed
		  dim thds() As ProfileThread = profile.Threads
		  for i as Integer = 0 to thds.Ubound
		    dim thisThread as ProfileThread = thds( i )
		    lbMethods.AddFolder( thisThread.Name )
		    lbMethods.Cell( i, kColumnCalled ) = Format( thisThread.TimesCalled, "#,0" )
		    lbMethods.Cell( i, kColumnTimeSpent ) = Format( thisThread.TimeSpentTotal, "#,0.00" )
		    lbMethods.Cell( i, kColumnAverageTime ) = Format( thisThread.TimeSpentTotal / thisThread.TimesCalled, "#,0.00" )
		    lbMethods.Cell( i, kColumnPercent ) = Format( thisThread.PercentOfTotal, "##0.00%" )
		    
		    lbMethods.RowTag( i ) = thisThread
		    for col as Integer = 0 to lastCol
		      lbMethods.CellBold( i, col ) = True
		    next
		  next i
		  
		  // Expand as needed
		  for i as Integer = thds.Ubound DownTo 0
		    if thds( i ).Expanded then
		      lbMethods.Expanded( i ) = True
		    end if
		  next i
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events lbMethods
	#tag Event
		Sub Open()
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub ExpandRow(row As Integer)
		  dim profile as ProfileBase = me.RowTag( row )
		  dim cnt as Integer = profile.ChildCount
		  dim methods() as ProfileMethod = if( profile IsA ProfileThread, ProfileThread( profile ).Methods, ProfileMethod( profile ).Methods )
		  
		  dim offset as Integer = me.CellAlignmentOffset( row, 0 ) + 5
		  for i as Integer = 1 to cnt
		    dim thisMethod as ProfileMethod = methods( i - 1 )
		    dim newRow as Integer = row + i
		    if thisMethod.ChildCount <> 0 then
		      me.InsertFolder( newRow, thisMethod.Name )
		    else
		      me.InsertRow( newRow, thisMethod.Name )
		    end if
		    me.Cell( newRow, kColumnCalled ) = Format( thisMethod.TimesCalled, "#,0" )
		    me.Cell( newRow, kColumnTimeSpent ) = Format( thisMethod.TimeSpentTotal, "#,0.00" )
		    me.Cell( newRow, kColumnAverageTime ) = Format( thisMethod.TimeSpentTotal / thisMethod.TimesCalled, "#,0.00" )
		    me.Cell( newRow, kColumnPercent ) = Format( thisMethod.PercentOfTotal, "##0.00%" )
		    
		    me.CellAlignmentOffset( newRow, 0 ) = offset
		    me.RowTag( newRow ) = thisMethod
		  next
		  
		  
		  dim lastRow as Integer = row + cnt
		  dim firstRow as Integer = row + 1
		  for i as Integer = lastRow DownTo firstRow
		    dim thisMethod as ProfileMethod = me.RowTag( i )
		    if thisMethod.Expanded then
		      me.Expanded( i ) = True
		    end if
		  next i
		  
		  if not profile IsA ProfileThread then
		    me.Cell( row, kColumnTimeSpent ) = format( profile.TimeSpent, "#,0.00" )
		    me.Cell( row, kColumnAverageTime ) = format( profile.TimeSpent / profile.TimesCalled, "#,0.00" )
		  end if
		  
		  profile.Expanded = True
		End Sub
	#tag EndEvent
	#tag Event
		Sub CollapseRow(row As Integer)
		  dim profile as ProfileBase = me.RowTag( row )
		  dim cnt as Integer = profile.ChildCount
		  for i as Integer = cnt DownTo 1
		    dim newRow as Integer =  row + i
		    dim rowProfile as ProfileBase = me.RowTag( newRow )
		    if rowProfile.Expanded then
		      me.Expanded( newRow ) = False
		    end if
		    me.RemoveRow( newRow )
		  next i
		  
		  if not profile IsA ProfileThread then
		    me.Cell( row, kColumnTimeSpent ) = format( profile.TimeSpentTotal, "#,0.00" )
		    me.Cell( row, kColumnAverageTime ) = format( profile.TimeSpentTotal / profile.TimesCalled, "#,0.00" )
		  end if
		  
		  profile.Expanded = False
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"10 - Drawer Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
