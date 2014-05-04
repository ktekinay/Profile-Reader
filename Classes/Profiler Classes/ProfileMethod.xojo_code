#tag Class
Protected Class ProfileMethod
Inherits ProfileBase
	#tag Event
		Sub ConstructFromData(data As ProfileLineData)
		  zMethodsDict = new Dictionary
		  zName = data.MethodNames( data.MethodIndex )
		  zID = data.Hash
		  
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
		  data.MethodIndex = data.MethodIndex + 1
		  if data.MethodIndex > data.MethodNames.Ubound then return
		  
		  zTimeSpentChildren = zTimeSpentChildren + data.TimeSpent
		  
		  dim methodName as String = data.MethodNames( data.MethodIndex )
		  dim m as ProfileMethod
		  if zMethodsDict.HasKey( methodName ) then
		    m = zMethodsDict.Value( methodName )
		    m.Add( data )
		  else
		    m = new ProfileMethod( me, data )
		    zMethodsDict.Value( methodName ) = m
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
