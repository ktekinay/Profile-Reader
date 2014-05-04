#tag Class
Protected Class Thd_Tester
Inherits Thread
	#tag Event
		Sub Run()
		  for i as integer = 0 to 1000000
		    dim s as string = Str( i )
		    #pragma unused s
		  next i
		  
		  me.Sleep( 950 )
		End Sub
	#tag EndEvent


End Class
#tag EndClass
