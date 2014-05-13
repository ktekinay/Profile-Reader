#tag Class
Protected Class ProfileThread
Inherits ProfileBase
	#tag Event
		Sub ConstructFromData(data As ProfileLineData)
		  Expanded = True // Threads default to expanded
		  
		  zMethodsDict = new Dictionary
		  zName = data.ThreadName
		  zID = data.Hash
		  
		  zTimeSpentTotal = 0 // Will be update in Add
		  Add( data )
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function GetChildCount() As Integer
		  return if( zMethodsDict is nil, 0, zMethodsDict.Count )
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Add(data As ProfileLineData)
		  dim methods() as String = data.MethodNames
		  if methods.Ubound = -1 then return
		  
		  dim m as ProfileMethod
		  if zMethodsDict.HasKey( methods( 0 ) ) then
		    m = zMethodsDict.Value( methods( 0 ) )
		    m.Add( data )
		  else
		    m = new ProfileMethod( me, data )
		    zMethodsDict.Value( m.Name ) = m
		  end if
		  
		  if methods.Ubound = 0 then // Only the top level methods get added
		    zTimeSpentTotal = zTimeSpentTotal + data.TimeSpent
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Methods() As ProfileMethod()
		  dim r() as ProfileMethod
		  if zMethodsDict is nil then return r
		  
		  dim values() as Variant = zMethodsDict.Values
		  dim sorter() as String
		  for each item as ProfileMethod in values
		    r.Append item
		    sorter.Append item.Name
		  next item
		  
		  sorter.SortWith r
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name() As String
		  return zName
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected zMethodsDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zName As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Expanded"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Selected"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeSpent"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
