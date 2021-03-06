
{**********************************************************************
 Package pl_AGGPas
 is a modification of
 Anti-Grain Geometry 2D Graphics Library (http://www.aggpas.org/)
 for CodeTyphon Studio (http://www.pilotlogic.com/)
 This unit is part of CodeTyphon Studio
***********************************************************************}

unit agg_platform_support;

{$IFDEF WINDOWS}
  {$IFDEF WINCE}
      {$i wince_agg_platform_support.inc}
  {$ELSE}
      {$i win_agg_platform_support.inc}
  {$ENDIF}
{$ENDIF}

{$IFDEF MAC}
 {$i mac_agg_platform_support.inc}
{$ENDIF}

{$IFDEF UNIX}
 {$i lin_agg_platform_support.inc} 
{$ENDIF}
