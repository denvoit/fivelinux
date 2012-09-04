#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TComboBox FROM TControl

   DATA   aItems   // The items displayed at the dropdown list

   METHOD New( nRow, nCol, oWnd, bSetGet, aItems, nWidth, nHeight,;
               bWhen, bValid, lUpdate, bChange, lDesign, lPixel, cVarName )

   METHOD Change() INLINE Eval( ::bSetGet, ::GetText() )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD LostFocus() INLINE Eval( ::bSetGet, ::GetText() ), Super:LostFocus()

   METHOD SetItems( aItems ) INLINE ::aItems := aItems,;
                                    CbxSetItems( ::hWnd, aItems )

   METHOD SetText( cText ) INLINE CbxSetText( ::hWnd, cText )

   METHOD GetText() INLINE CbxGetText( ::hWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, bSetGet, aItems, nWidth, nHeight, bWhen,;
            bValid, lUpdate, bChange, lDesign, lPixel, cVarName ) CLASS TComboBox

   DEFAULT oWnd := GetWndDefault(), lUpdate := lUpdate, nWidth := 175,;
           nHeight := 22, aItems := { "one", "two", "three" }, lDesign := .F.,;
           lPixel := .F.

   ::bSetGet  = bSetGet
   ::hWnd     = CreateComboBox()
   ::bWhen    = bWhen
   ::bValid   = bValid
   ::lUpdate  = lUpdate
   ::bChange  = bChange
   ::lDrag    = lDesign
   ::cVarName = cVarName

   if Eval( bSetGet ) == nil
      Eval( bSetGet, aItems[ 1 ] )
   endif

   ::SetText( Eval( bSetGet ) )
   ::SetItems( aItems )

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )
   ::SetSize( nWidth, nHeight )

   ::Link()
   ::Show()

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TComboBox

   do case
        case nMsg == WM_CHANGE
             return ::Change()

	case nMsg == WM_LOSTFOCUS
             return ::LostFocus()
   endcase

return nil

//----------------------------------------------------------------------------//
