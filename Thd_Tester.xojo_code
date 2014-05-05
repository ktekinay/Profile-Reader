#tag Class
Protected Class Thd_Tester
Inherits Thread
	#tag Event
		Sub Run()
		  // A do-nothing thread meant to generate an additional thread entry when Profile Code is turned on for this project.
		  
		  for i as integer = 0 to 1000000
		    dim s as string = Str( i )
		    #pragma unused s
		  next i
		  
		  me.Sleep( 950 )
		End Sub
	#tag EndEvent


End Class
#tag EndClass
