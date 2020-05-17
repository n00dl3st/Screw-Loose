env.info( '*** DynaMis DYNAMIC INCLUDE START *** ' )

local base = _G

__Moose = {}

__Moose.Include = function( IncludeFile )
  if not __Moose.Includes[ IncludeFile ] then
    __Moose.Includes[IncludeFile] = IncludeFile
    local f = assert( base.loadfile( IncludeFile ) )
    if f == nil then
      error ("DynaMiss: Could not load Moose file " .. IncludeFile )
    else
      env.info( "DynaMis: " .. IncludeFile .. " dynamically loaded." )
      return f()
    end
  end
end

__Moose.Includes = {}

__Moose.Include( 'E:/Code/Screw Loose/Modules.lua' )
BASE:TraceOnOff( true )
env.info( '*** DynaMis INCLUDE END *** ' )