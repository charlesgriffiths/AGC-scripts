
type tPanel
  mode as integer
  offset as float

  sprites as integer[]
endtype


global gPanels as tPanel[]

function createPanel()

p as tPanel

  p.mode = 0
  p.offset = 0

  if gPanels.length = -1
    gPanels.length = 0
    gPanels[0] = p
  else
    gPanels.insert( p )
  endif

endfunction gPanels.length

function panelScrollRight( pid, dx# )

  gPanels[pid].mode = 1
  gPanels[pid].offset = gPanels[pid].offset + dx#

  for i = 0 to gPanels[pid].sprites.length
    SetSpriteX( gPanels[pid].sprites[i], dx# + GetSpriteX( gPanels[pid].sprites[i] ))
  next

endfunction

function panelSplitX( pid, dx# )

  gPanels[pid].mode = 3
  gPanels[pid].offset = gPanels[pid].offset + dx#

  midwidth = GetVirtualWidth() / 2

  for i = 0 to gPanels[pid].sprites.length
    x# = GetSpriteX( gPanels[pid].sprites[i] )

    if x# >= midwidth
      SetSpriteX( gPanels[pid].sprites[i], x# + dx# )
    else
      SetSpriteX( gPanels[pid].sprites[i], x# - dx# )
    endif
  next

endfunction


function addSprite( pid, id, x#, y# )

  if gPanels[pid].sprites.length = -1
    gPanels[pid].sprites.length = 0
    gPanels[pid].sprites[0] = id
  else
    gPanels[pid].sprites.insert( id )
  endif


  select gPanels[pid].mode
  
    case 0:
      SetSpritePosition( id, x#, y# )
    endcase

    case 1:
      SetSpritePosition( id, x# + gPanels[pid].offset, y# )
    endcase

    case 2:
      SetSpritePosition( id, x#, y# + gPanels[pid].offset )
    endcase

    case 3:
      if x# >= GetVirtualWidth()/2
        SetSpritePosition( id, x# + gPanels[pid].offset, y# )
      else
        SetSpritePosition( id, x# - gPanels[pid].offset, y# )
      endif
    endcase

    case 4:
      if y# >= GetVirtualHeight()/2
        SetSpritePosition( id, x#, y# + gPanels[pid].offset )
      else
        SetSpritePosition( id, x#, y# - gPanels[pid].offset )
      endif
    endcase


  endselect

  // 0=off, 1=alpha transparency, 2=additive blending
  SetSpriteTransparency( id, 0 )

endfunction


