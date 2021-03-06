{------------------------------------------------------------------------------}
{                 Central definition of conditional defines                    }
{------------------------------------------------------------------------------}

{ In Unix systems, the unit clocale is automatically added to the uses clause
  of fpspreadsheet.pas. This unit sets up localization settings needed for
  locale-dependent number and date/time formats. However, this adds a dependence
  on the C library to the package.
  If this is not wanted, define FPS_DONT_USE_CLOCALE. }
{.$DEFINE FPS_DONT_USE_CLOCALE}

{ In older versions of fpspreadsheet, the formatting fields had belonged to the
  cell record. This has been given up to reduce memory consumption.
  For fpc >2.6, however, record helpers allow to get this feature back. In case
  of older compilers activate the define FPS_NO_RECORD_HELPERS. Note that worksheet
  methods can only be used to change cell formatting then. }
{.$DEFINE FPS_NO_RECORD_HELPERS}

{------------------------------------------------------------------------------}

{ The next defines activate code duplicated from new compiler versions in case
  an old compiler is used. }

{ fpspreadsheet requires the function VarIsBool which was introduced by
  fpc 2.6.4. If an older FPC versions is used define FPS_VARISBOOL. Keep
  undefined for the current FPC version. }
{.$DEFINE FPS_VARISBOOL}

{ fpspreadsheet requires some functions from LazUTF8 which were
  introduced by Lazarus 1.2. If an older Lazarus version is used define
  FPS_LAZUTF8. Keep undefined for the current Lazarus version. }
{.$DEFINE FPS_LAZUTF8}

{ In order to allow selection of multiple ranges in the WorksheetGrid a
  sufficiently new version of the basic TCustomGrid is required. The required
  property "RangeSelect" was introduced in Lazarus 1.4. In order to compile
  the package with older versions activate the define FPS_NO_GRID_MULTISELECT }
{.$DEFINE FPS_NO_GRID_MULTISELECT}

{ In order to provide safe casting of integers to pointers new version of FPC
  provide the types PtrInt and IntPtr.
  This is not yet available in fpc 2.6.0 }
{.$DEFINE FPS_PTRINT}

