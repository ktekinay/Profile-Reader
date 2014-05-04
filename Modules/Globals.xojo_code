#tag Module
Protected Module Globals
	#tag Method, Flags = &h1
		Protected Function ContentsOfTextFile(doc As FolderItem) As String
		  if doc is nil or not doc.Exists or doc.Directory then
		    return ""
		  end if
		  
		  dim text as String
		  dim tis as TextInputStream = TextInputStream.Open( doc )
		  if tis <> nil then
		    tis.Encoding = Encodings.UTF8
		    text = tis.ReadAll
		    tis = nil
		  end if
		  
		  return ReplaceLineEndings( text, EndOfLine )
		  
		End Function
	#tag EndMethod


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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
