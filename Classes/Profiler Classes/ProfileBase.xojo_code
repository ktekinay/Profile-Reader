#tag Class
Protected Class ProfileBase
	#tag Method, Flags = &h0
		Function ChildCount() As Integer
		  return RaiseEvent GetChildCount()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(myParent As ProfileBase, data As ProfileLineData)
		  zParent = new WeakRef( myParent )
		  zTimesCalled = data.TimesCalled
		  zTimeSpentTotal = data.TimeSpent
		  zPercentOfTotal = data.PercentOfTotal
		  
		  RaiseEvent ConstructFromData( data )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ID() As String
		  return zID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PercentChildren() As Double
		  return zPercentChildren
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PercentOfTotal() As Double
		  return zPercentOfTotal
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TimesCalled() As Integer
		  return zTimesCalled
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TimeSpentChildren() As Double
		  return zTimeSpentChildren
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TimeSpentTotal() As Double
		  return zTimeSpentTotal
		  
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ConstructFromData(data As ProfileLineData)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GetChildCount() As Integer
	#tag EndHook


	#tag Property, Flags = &h0
		#tag Note
			Used to keep track of whether this item is expanded in a ListBox
		#tag EndNote
		Expanded As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim r as ProfileBase
			  
			  if zParent <> nil then
			    dim o as Object = zParent.Value
			    if o <> nil then
			      r = ProfileBase( o )
			    end if
			  end if
			  
			  return r
			  
			End Get
		#tag EndGetter
		Parent As ProfileBase
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			Used to keep track of whether this item is selected in a ListBox
		#tag EndNote
		Selected As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return zTimeSpentTotal - zTimeSpentChildren
			  
			End Get
		#tag EndGetter
		TimeSpent As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected zID As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zParent As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zPercentChildren As Double
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zPercentOfTotal As Double
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zTimesCalled As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zTimeSpentChildren As Double
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zTimeSpentTotal As Double
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
