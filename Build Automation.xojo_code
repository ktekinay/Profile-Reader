#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin ExternalIDEScriptStep MacPostBuild
					AppliesTo = 0
					FolderItem = Li4AWG9qb1NjcmlwdHMAUHJvZmlsZSBSZWFkZXIgQnVpbGQueG9qb19zY3JpcHQ=
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
