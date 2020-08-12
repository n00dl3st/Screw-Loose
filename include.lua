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

__Moose.Include( 'E:/Code/Screw Loose/Player.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Airports.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Sets.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Zones.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Supplychain.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Logistics.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Detection.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Dispatcher.lua' )
--__Moose.Include( 'E:/Code/Screw Loose/Spawner.lua' )
--__Moose.Include( 'E:/Code/Screw Loose/Squadron.lua' )
__Moose.Include( 'E:/Code/Screw Loose/Command.lua' )

BASE:TraceOnOff( true )
env.info( '*** DynaMis INCLUDE END *** ' )