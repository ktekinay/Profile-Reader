#tag Class
Protected Class ProfileLineData
	#tag Method, Flags = &h0
		Sub Constructor(text As String)
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = _
		    "(?i-sUm)(?'thdname'Main Thread|Thread\(\d+\)) (?'methods'.*)\|(?'called'\d+)\|(?'spent'\d+(?:\.\d+)?)\|(?'percent'100|\d" + _
		    "{2}\.\d{2})%"
		  end if
		  
		  dim match as RegExMatch = rx.Search( text )
		  if match <> nil then
		    ThreadName = match.SubExpressionString( 1 )
		    MethodNames = Split( match.SubExpressionString( 2 ), "->" )
		    TimesCalled = match.SubExpressionString( 3 ).Val
		    TimeSpent = match.SubExpressionString( 4 ).Val
		    PercentOfTotal = match.SubExpressionString( 5 ).Val
		    Hash = EncodeHex( Crypto.SHA256( text ) )
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Hash As String
	#tag EndProperty

	#tag Property, Flags = &h0
		MethodIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MethodNames() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PercentOfTotal As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		ThreadName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TimesCalled As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TimeSpent As Double
	#tag EndProperty


End Class
#tag EndClass
