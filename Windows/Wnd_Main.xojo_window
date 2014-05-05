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
   Begin PRListBox lbProfiles
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
      Width           =   160
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin PRListBox lbMethods
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
      InitialValue    =   " 	Called	Total (ms)	Average (ms)	Percent of Total"
      Italic          =   False
      Left            =   192
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
      Width           =   754
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin Timer tmrCheckForParentChange
      Height          =   32
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockedInPosition=   False
      Mode            =   2
      Period          =   1000
      Scope           =   2
      TabPanelIndex   =   0
      Top             =   0
      Width           =   32
   End
   Begin Label lblParentPath
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      Text            =   "/path/to/folder"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   926
   End
   Begin Timer tmrFixMethodSelection
      Height          =   32
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockedInPosition=   False
      Mode            =   0
      Period          =   20
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   0
      Width           =   32
   End
   Begin Timer tmrUpdateMouseOverHighlighting
      Height          =   32
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockedInPosition=   False
      Mode            =   0
      Period          =   100
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   0
      Width           =   32
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h1
		Protected Sub pPopulateMethodsListBox()
		  lbMethods.DeleteAllRows()
		  if lbProfiles.ListIndex = -1 then return
		  
		  dim profile As ProfileDocument = lbProfiles.RowTag( lbProfiles.ListIndex )
		  dim lastCol as Integer = lbMethods.ColumnCount - 1
		  
		  // Just add the threads here, then expand them as needed
		  dim thds() As ProfileThread = profile.Threads
		  
		  // Need to be sorted?
		  dim sortColumnIndex as Integer = lbMethods.SortedColumn
		  if sortColumnIndex = kColumnTimeSpent then
		    dim sortDirection as Integer = lbMethods.ColumnSortDirection( sortColumnIndex )
		    dim sorter() as Double
		    redim sorter( thds.Ubound )
		    for i as Integer = 0 to sorter.Ubound
		      sorter( i ) = thds( i ).TimeSpent
		    next i
		    
		    sorter.SortWith thds
		    
		    if sortDirection = -1 then
		      dim firstElement as Integer = 0
		      dim lastElement as Integer = thds.Ubound
		      while firstElement < lastElement
		        dim temp as ProfileThread = thds( firstElement )
		        thds( firstElement ) = thds( lastElement )
		        thds( lastElement ) = temp
		        
		        firstElement = firstElement + 1
		        lastElement = lastElement - 1
		      wend
		    end if
		  end if
		  
		  for i as Integer = 0 to thds.Ubound
		    dim thisThread as ProfileThread = thds( i )
		    lbMethods.AddFolder( thisThread.Name )
		    lbMethods.Cell( i, kColumnTimeSpent ) = Format( thisThread.TimeSpentTotal, "-#,0.00" )
		    
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
	#tag EndMethod

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
		    profileName = profile.StartDate.SQLDateTime
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
		  
		  zParentLastModDate = pFolder.ModificationDate
		  
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
		      
		      // Rename the FolderItem if needed.
		      if f.Name = "Profile.txt" then // Default name, so rename it
		        dim sqlTime as String = profile.StartDate.SQLDateTime
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
		        profile.Document = f
		      end if
		      
		      if profile <> nil then
		        if not zProfileDocsDict.HasKey( profile.ID ) then
		          updateListBox = True
		        end if
		        newDict.Value( profile.ID ) = profile
		      end if
		    end if
		  next
		  
		  // Is there anything there?
		  if newDict.Count = 0 then
		    
		    pShowMessageDialog( "All profiles have been deleted.", "Close" )
		    
		  else
		    
		    // Was something deleted?
		    if zProfileDocsDict.Count <> newDict.Count then
		      updateListBox = True
		    end if
		    
		    zProfileDocsDict = newDict
		    if updateListBox then
		      pPopulateProfilesListBox()
		    end if
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub pShowMessageDialog(msg As String, caption As String)
		  dim dlg as new MessageDialog
		  dlg.Message = msg
		  dlg.ActionButton.Caption = caption
		  call dlg.ShowModalWithin( self )
		  self.Close
		  
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
			  if value <> nil then
			    lblParentPath.Text = value.NativePath
			  else
			    lblParentPath.Text = ""
			  end if
			  
			End Set
		#tag EndSetter
		ParentFolder As FolderItem
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected zLastSelectedMethodProfile As ProfileBase
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zMouseOverPrevious As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zMouseOverRow As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zParentFolder As FolderItemAlias
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zParentLastModDate As Date
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

	#tag Constant, Name = kExpandedColor, Type = Color, Dynamic = False, Default = \"&cD2CBFD", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kMouseOverColor, Type = Color, Dynamic = False, Default = \"&cFFA7AA", Scope = Protected
	#tag EndConstant


#tag EndWindowCode

#tag Events lbProfiles
	#tag Event
		Sub Change()
		  pPopulateMethodsListBox()
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function ConstructContextualMenu(base as MenuItem, x as Integer, y as Integer) As Boolean
		  while base.Count <> 0
		    base.Remove 0
		  wend
		  
		  dim m as MenuItem
		  
		  m = new MenuItem( "Reveal" )
		  m.Enabled = me.ListIndex <> -1
		  base.Append m
		  
		  m = new MenuItem( "Delete..." )
		  m.Enabled = me.ListIndex <> -1
		  base.Append m
		  
		  return True
		  
		  #pragma unused x
		  #pragma unused y
		  
		End Function
	#tag EndEvent
	#tag Event
		Function ContextualMenuAction(hitItem as MenuItem) As Boolean
		  dim row as Integer = me.ListIndex
		  dim profile as ProfileDocument
		  if row <> -1 and me.RowTag( row ) IsA ProfileDocument then
		    profile = me.RowTag( row )
		  end if
		  
		  dim f as FolderItem
		  if profile <> nil then
		    f = profile.Document
		  end if
		  
		  if f is nil then // Nothing to do
		    return False
		  end if
		  
		  if hitItem.Text = "Delete..." then
		    dim dlg as new MessageDialog
		    dlg.Message = "Really delete """ + f.Name + """?"
		    dlg.ActionButton.Caption = "Delete"
		    dlg.CancelButton.Visible = True
		    dim btn as MessageDialogButton = dlg.ShowModalWithin( self )
		    if btn.Caption = "Delete" then
		      f.Delete
		      pScanParentFolder()
		    end if
		    return True
		    
		  elseif hitItem.Text = "Reveal" then
		    #if TargetMacOS
		      FinderReveal( f.NativePath )
		    #else
		      f.Parent.Launch
		    #endif
		    
		  end if
		  
		  return True
		  
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events lbMethods
	#tag Event
		Sub Open()
		  me.ColumnAlignment( kColumnCalled ) = ListBox.AlignRight
		  
		  me.ColumnAlignment( kColumnTimeSpent ) = ListBox.AlignRight
		  
		  me.ColumnAlignment( kColumnAverageTime ) = ListBox.AlignRight
		  
		  me.ColumnAlignment( kColumnPercent ) = ListBox.AlignRight
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub ExpandRow(row As Integer)
		  dim profile as ProfileBase = me.RowTag( row )
		  dim cnt as Integer = profile.ChildCount
		  dim methods() as ProfileMethod = if( profile IsA ProfileThread, ProfileThread( profile ).Methods, ProfileMethod( profile ).Methods )
		  
		  // Need to be sorted?
		  dim sortColumnIndex as Integer = lbMethods.SortedColumn
		  if sortColumnIndex <> -1 then
		    dim sortDirection as Integer = lbMethods.ColumnSortDirection( sortColumnIndex )
		    dim sorter() as Double
		    redim sorter( methods.Ubound )
		    for i as Integer = 0 to sorter.Ubound
		      select case sortColumnIndex
		      case kColumnCalled
		        sorter( i ) = methods( i ).TimesCalled
		      case kColumnTimeSpent
		        sorter( i ) = methods( i ).TimeSpentTotal
		      case kColumnAverageTime
		        sorter( i ) = methods( i ).TimeSpentTotal / methods( i ).TimesCalled
		      case kColumnPercent
		        sorter( i ) = methods( i ).PercentOfTotal
		      end select
		    next i
		    
		    sorter.SortWith methods
		    
		    if sortDirection = -1 then
		      dim firstElement as Integer = 0
		      dim lastElement as Integer = methods.Ubound
		      while firstElement < lastElement
		        dim temp as ProfileMethod = methods( firstElement )
		        methods( firstElement ) = methods( lastElement )
		        methods( lastElement ) = temp
		        
		        firstElement = firstElement + 1
		        lastElement = lastElement - 1
		      wend
		    end if
		  end if
		  
		  dim expandAll as Boolean = Keyboard.OptionKey
		  
		  for i as Integer = 1 to cnt
		    dim thisMethod as ProfileMethod = methods( i - 1 )
		    dim newRow as Integer = row + i
		    if thisMethod.ChildCount <> 0 then
		      me.AddFolder( thisMethod.Name )
		    else
		      me.AddRow( thisMethod.Name )
		    end if
		    me.Cell( newRow, kColumnCalled ) = Format( thisMethod.TimesCalled, "-#,0" )
		    me.Cell( newRow, kColumnTimeSpent ) = Format( thisMethod.TimeSpentTotal, "-#,0.00" )
		    me.Cell( newRow, kColumnAverageTime ) = Format( thisMethod.TimeSpentTotal / thisMethod.TimesCalled, "-#,0.00" )
		    me.Cell( newRow, kColumnPercent ) = Format( thisMethod.PercentOfTotal, "-##0.00%" )
		    
		    me.RowTag( newRow ) = thisMethod
		  next
		  
		  dim lastRow as Integer = row + cnt
		  dim firstRow as Integer = row + 1
		  for i as Integer = lastRow DownTo firstRow
		    dim thisMethod as ProfileMethod = me.RowTag( i )
		    if expandAll and thisMethod.ChildCount <> 0 then
		      thisMethod.Expanded = True
		    end if
		    
		    if thisMethod.Expanded then
		      me.Expanded( i ) = True
		    end if
		  next i
		  
		  if not profile IsA ProfileThread then
		    me.Cell( row, kColumnTimeSpent ) = format( profile.TimeSpent, "-#,0.00" )
		    me.Cell( row, kColumnAverageTime ) = format( profile.TimeSpent / profile.TimesCalled, "-#,0.00" )
		    me.Cell( row, kColumnPercent ) = format( profile.PercentOfTotal - profile.PercentChildren, "-##0.00%" )
		  end if
		  
		  profile.Expanded = True
		End Sub
	#tag EndEvent
	#tag Event
		Sub CollapseRow(row As Integer)
		  dim profile as ProfileBase = me.RowTag( row )
		  
		  dim collapseAll as Boolean = Keyboard.OptionKey
		  if collapseAll then
		    dim cnt as Integer = profile.ChildCount
		    for i as Integer = 1 to cnt
		      dim newRow as Integer =  row + i
		      dim rowProfile as ProfileBase = me.RowTag( newRow )
		      me.Expanded( newRow ) = False
		    next i
		  end if
		  
		  if not profile IsA ProfileThread then
		    me.Cell( row, kColumnTimeSpent ) = format( profile.TimeSpentTotal, "#,0.00" )
		    me.Cell( row, kColumnAverageTime ) = format( profile.TimeSpentTotal / profile.TimesCalled, "#,0.00" )
		  end if
		  
		  profile.Expanded = False
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function SortColumn(column As Integer) As Boolean
		  if column < kColumnCalled then
		    me.SortedColumn = -1
		    me.HeadingIndex = -1
		  end if
		  
		  dim savedProfile as ProfileBase = zLastSelectedMethodProfile
		  pPopulateMethodsListBox()
		  zLastSelectedMethodProfile = savedProfile
		  tmrFixMethodSelection.Mode = Timer.ModeSingle
		  
		  return True
		  
		End Function
	#tag EndEvent
	#tag Event
		Function CellBackgroundPaint(g As Graphics, row As Integer, column As Integer) As Boolean
		  if me.Selected( row ) then
		    return False
		  end if
		  
		  dim changeIt as Boolean = True
		  
		  dim profile as ProfileBase
		  if row < me.ListCount then
		    profile = me.RowTag( row )
		  end if
		  
		  if row = zMouseOverRow then
		    g.ForeColor = kMouseOverColor
		    g.FillRect( 0, 0, g.Width, g.Height )
		    zMouseOverPrevious = zMouseOverRow
		  elseif row < me.ListCount and profile <> nil and profile.Expanded then
		    g.ForeColor = kExpandedColor
		    g.FillRect( 0, 0, g.Width, g.Height )
		  else
		    changeIt = False
		  end if
		  
		  return changeIt
		  
		  #pragma unused column
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  dim row as Integer = me.RowFromXY( X, Y )
		  if row < 0 or row >= me.ListCount then
		    row = -1
		  end if
		  
		  if row <> zMouseOverRow then
		    zMouseOverRow = row
		    tmrUpdateMouseOverHighlighting.Mode = Timer.ModeSingle
		    tmrUpdateMouseOverHighlighting.Reset
		  end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  if zMouseOverRow <> -1 then
		    zMouseOverRow = -1
		    tmrUpdateMouseOverHighlighting.Mode = Timer.ModeSingle
		    tmrUpdateMouseOverHighlighting.Reset
		  end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  dim tag As Variant
		  if me.ListIndex <> -1 then
		    tag = me.RowTag( me.ListIndex )
		  end if
		  
		  zLastSelectedMethodProfile = tag
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function CellTextPaint(g As Graphics, row As Integer, column As Integer, x as Integer, y as Integer) As Boolean
		  if me.RowTag( row ) IsA ProfileThread then
		    g.TextFont = "System"
		    'g.TextSize = 10
		  end if
		  
		  #pragma unused column
		  #pragma unused x
		  #pragma unused y
		End Function
	#tag EndEvent
	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  dim row as Integer = me.RowFromXY( X - me.Left, Y - me.Top )
		  if row < 0 or row >= me.ListCount then
		    row = -1
		  end if
		  
		  if row <> zMouseOverRow then
		    zMouseOverRow = row
		    tmrUpdateMouseOverHighlighting.Mode = Timer.ModeSingle
		    tmrUpdateMouseOverHighlighting.Reset
		  end if
		  
		  #pragma unused deltaX
		  #pragma unused deltaY
		  
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events tmrCheckForParentChange
	#tag Event
		Sub Action()
		  dim pFolder as FolderItem = ParentFolder
		  if pFolder is nil or not pFolder.Exists then
		    pShowMessageDialog( "The parent folder no longer exists.", "Close" )
		    return
		  end if
		  
		  if zParentLastModDate is nil then
		    zParentLastModDate = pFolder.ModificationDate
		  elseif zParentLastModDate.TotalSeconds <> pFolder.ModificationDate.TotalSeconds then
		    pScanParentFolder
		  end if
		  
		  lblParentPath.Text = pFolder.NativePath
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events tmrFixMethodSelection
	#tag Event
		Sub Action()
		  dim savedProfile as ProfileBase = zLastSelectedMethodProfile
		  
		  if savedProfile <> nil then
		    dim lastRow as Integer = lbMethods.ListCount - 1
		    for row as Integer = lastRow DownTo 0
		      if lbMethods.RowTag( row ) is savedProfile then
		        lbMethods.ListIndex = row
		        'lbMethods.Selected( row ) = True
		        exit
		      end if
		    next
		  end if
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events tmrUpdateMouseOverHighlighting
	#tag Event
		Sub Action()
		  dim oldRow as Integer = zMouseOverPrevious
		  dim row as Integer = zMouseOverRow
		  
		  if oldRow <> -1 then
		    lbMethods.InvalidateCell( oldRow, -1 )
		  end if
		  if row <> -1 then
		    lbMethods.InvalidateCell( row, -1 )
		  end if
		  
		  zMouseOverPrevious = row
		  
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
