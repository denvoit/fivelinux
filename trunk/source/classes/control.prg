#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TControl FROM TWindow

   DATA   bSetGet   // A bSetGet codeblock to manage a related variable value
   DATA   bWhen     // A codeblock to evaluate to activate or not the control
   DATA   lUpdate   // Update the control contents if its container is updated
   DATA   bChange   // A codeblock to evaluate when the control changes its main value
   DATA   lDrag  INIT .F.  // moveable with the mouse
   DATA   nStartRow, nStartCol // initial coors when design drag starts

   METHOD LostFocus()

   METHOD End() INLINE WndDestroy( ::hWnd )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD LButtonDown( nRow, nCol )

   METHOD Show() INLINE ShowControl( ::hWnd )

   METHOD SetFont( oFont ) INLINE If( ::oFont != nil, ::oFont:End(),),;
                           ::oFont := oFont, SetFont( ::hWnd, oFont:hFont )

   METHOD SetPos( nTop, nLeft ) INLINE CtrlSetPos( ::hWnd, nTop, nLeft )

   METHOD MouseMove( nRow, nCol )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TControl

   if ::lDrag
      ::nStartRow = nRow
      ::nStartCol = nCol
   endif

   Super:LButtonDown( nRow, nCol )

return If( ::lDrag, 1, nil )  // no default behavior for lDrag 

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TControl

   if ::bValid != nil
      if ! Eval( ::bValid, Self )
         ::SetFocus()
      endif
   endif

   ::oWnd:AEvalWhen()

   if ::bLostFocus != nil
      Eval( ::bLostFocus, Self )
   endif   

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TControl

   do case
      case nMsg == WM_LBUTTONDOWN
           return ::LButtonDown( nWParam, nLParam )

      case nMsg == WM_MOUSEMOVE
           return ::MouseMove( nWParam, nLParam )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol ) CLASS TControl

   if ::lDrag
      if IsLBtnPressed( ::hWnd ) .and. ::nStartRow != nil
         ::SetPos( nRow - ::nStartRow, nCol - ::nStartCol )
      endif
   endif

return nil

//----------------------------------------------------------------------------//
