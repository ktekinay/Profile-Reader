#tag Class
Protected Class ProfileLineData
	#tag Method, Flags = &h0
		Sub Constructor(text As String)
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = _
		    "(?xmi-Us)                # FREE-SPACING" + EndOfLine + _
		    "^" + EndOfLine + _
		    "(?'thdname'Main\x20Thread|Thread\(\d+\))" + EndOfLine + _
		    "\x20" + EndOfLine + _
		    "(?'methods'[^|\r\n]*)" + EndOfLine + _
		    "\|" + EndOfLine + _
		    "(?'called'\d+)" + EndOfLine + _
		    "\|" + EndOfLine + _
		    "(?'spent'[.,]\d+|\d+(?:[.,]\d+)?)" + EndOfLine + _
		    "\|" + EndOfLine + _
		    "(?'percent'\d{2,3}(?:[.,]\d{2})?)%" + EndOfLine + _
		    "$"
		  end if
		  
		  dim match as RegExMatch = rx.Search( text )
		  if match <> nil then
		    ThreadName = match.SubExpressionString( 1 )
		    MethodNames = Split( match.SubExpressionString( 2 ), "->" )
		    TimesCalled = match.SubExpressionString( 3 ).CDbl
		    TimeSpent = pStringToDouble( match.SubExpressionString( 4 ) )
		    PercentOfTotal = pStringToDouble( match.SubExpressionString( 5 ) )
		    Hash = EncodeHex( Crypto.SHA256( text ) )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pGetDecimalSep(value As String) As String
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = "\d(\D)\d+%?$"
		  end if
		  
		  dim match as RegExMatch = rx.Search( value )
		  if match is nil then
		    return ""
		  else
		    return match.SubExpressionString( 1 )
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pJustNumbers(value As String) As String
		  // Strips anything from the value that's not a number
		  
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = "\D"
		    rx.ReplacementPattern = ""
		    rx.Options.ReplaceAllMatches = True
		  end if
		  
		  return rx.Replace( value )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pStringToDouble(value As String) As Double
		  // Converts a string to a double by trying to figure out which decimal point and separator symbols are being used.
		  // Needed because the user might be opening a file created in another country.
		  
		  if value.Len < 3 then return value.CDbl // Assumes that we need at least three charactrers to make a determination
		  
		  dim r as Double
		  
		  dim decimalSep as String = pGetDecimalSep( value )
		  if decimalSep = "" then
		    return value.CDbl
		  end if
		  
		  dim parts() as string = value.Split( decimalSep )
		  if parts.Ubound <> 1 then
		    r = value.CDbl
		  else
		    
		    parts( 0 ) = pJustNumbers( parts( 0 ) )
		    value = Join( parts, "." )
		    r = value.Val
		    
		  end if
		  
		  return r
		  
		End Function
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
