#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TGet FROM TControl

   DATA   oGet       // A Harbour GET object
   DATA   lPassword  // password style

   METHOD New( nRow, nCol, oWnd, bSetGet, cPicture, nWidth, nHeight,;
               bWhen, bValid, lUpdate, lPassword )

   METHOD GetPos() INLINE GetGetCurPos( ::hWnd )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD KeyDown( nKey )

   METHOD LostFocus()

   METHOD GotFocus()

   METHOD Refresh() INLINE ::SetText( ::oGet:buffer )

   METHOD SetCurPos( nPos ) INLINE GetSetCurPos( ::hWnd, nPos )

   METHOD SetText( cText ) INLINE GetSetText( ::hWnd, cText )

   METHOD GetText() INLINE GetGetText( ::hWnd )

   METHOD SetSel( nStart, nEnd ) INLINE GetSetSel( ::hWnd, nStart, nEnd )

   METHOD VarPut( uVal ) INLINE  ::oGet:SetFocus(),;
                                 ::oGet:buffer := cValToChar( uVal ),;
                                 If( ValType( ::bSetGet ) == "B",;
                                     Eval( ::bSetGet, uVal ),)
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, bSetGet, cPicture, nWidth, nHeight, bWhen,;
            bValid, lUpdate, lPassword ) CLASS TGet

   DEFAULT oWnd := GetWndDefault(), nWidth := 60, nHeight := 25,;
           lUpdate := .f., lPassword := .F.

   ::hWnd    = CreateGet()
   ::bSetGet = bSetGet
   ::oGet    = GetNew( -1, -1, bSetGet, "", cPicture )
   ::bWhen   = bWhen
   ::bValid  = bValid
   ::lUpdate = lUpdate
   ::lPassword = lPassword

   ::oGet:SetFocus()
   ::SetText( If( ! ::lPassword, ::oGet:buffer, Replicate( "*", Len( AllTrim( ::oGet:buffer ) ) ) ) )

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   ::Link()

return Self

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TGet

   if ::oGet:buffer != ::GetText() .and. ! ::lPassword
      ::oGet:buffer = ::GetText()
   endif

   ::oGet:Assign()

   if ::bValid != nil
      if Len( ::GetText() ) == 0
         ::SetText( If( ! ::lPassword, ::oGet:buffer, Replicate( "*", Len( AllTrim( ::oGet:buffer ) ) ) ) )
      endif
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

METHOD GotFocus() CLASS TGet

   ::SetCurPos( 0 )
   ::SetSel( 0, 0 )

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TGet

   do case
        case nMsg == WM_KEYDOWN
	     return ::KeyDown( nWParam )

        case nMsg == WM_LOSTFOCUS
             return ::LostFocus()

        case nMsg == WM_GOTFOCUS
             return ::GotFocus()

        // case nMsg == WM_LBUTTONDOWN
        //      ::oGet:pos = ::GetPos()
        //      return .T. 
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey ) CLASS TGet

   local lRet

   if ::bKeyDown != nil
      if ( lRet := Eval( ::bKeyDown, nKey, Self ) ) != nil .and. lRet
         return nil
      endif
   endif

   if ::oGet:pos != ::GetPos()
      ::oGet:pos = ::GetPos() + 1
   endif

   if nKey >= K_KEYPAD0 .and. nKey <= K_KEYPAD0 + 9
      nKey = Asc( "0" ) + nKey - K_KEYPAD0
   endif     

   do case
      case nKey == K_BS
           ::oGet:BackSpace()
           ::SetText( If( ! ::lPassword, ::oGet:buffer, Replicate( "*", Len( AllTrim( ::oGet:buffer ) ) ) ) )
	   ::SetCurPos( ::oGet:pos - 1 )

      case nKey == K_DEL
           ::oGet:Delete()
           ::SetText( If( ! ::lPassword, ::oGet:buffer, Replicate( "*", Len( AllTrim( ::oGet:buffer ) ) ) ) )
	   ::SetCurPos( ::oGet:pos - 1 )

      case nKey == K_TAB .or. nKey == K_UPPER .or. nKey == K_SHIFT .or. ;
           nKey == K_CTRL .or. nKey == K_UP .or. nKey == K_DOWN .or. ;
	   nKey == K_PAGEUP .or. nKey == K_PAGEDOWN .or. nKey == K_RSHIFT
	   // Ignore these keystrokes

      case nKey == K_ESC
           ::oWnd:End()

      case nKey == K_HOME
           ::oGet:Home()
	   ::SetCurPos( ::oGet:pos - 1 )

      case nKey == K_END
           ::oGet:End()
	   ::SetCurPos( ::oGet:pos - 1 )

      case nKey == K_LEFT
           ::oGet:Left()
	   ::SetCurPos( ::oGet:pos - 1 )

      case nKey == K_RIGHT
           ::oGet:Right()
	   ::SetCurPos( ::oGet:pos - 1 )

      otherwise
           ::oGet:Insert( Chr( nKey ) )
           ::SetText( If( ! ::lPassword, ::oGet:buffer, Replicate( "*", Len( AllTrim( ::oGet:buffer ) ) ) ) )
           ::SetCurPos( ::oGet:pos - 1 )
   endcase

return nil

//----------------------------------------------------------------------------//
