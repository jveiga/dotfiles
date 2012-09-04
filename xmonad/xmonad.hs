import Control.Monad (liftM2)
import Data.List
import Data.Ratio ((%))
import Graphics.X11.ExtraTypes.XF86
import System.IO
import XMonad
import XMonad.Actions.CycleWindows
import XMonad.Actions.FloatKeys
import XMonad.Actions.NoBorders
import XMonad.Actions.WindowGo
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.Magnifier
import XMonad.Layout.Mosaic
import XMonad.Layout.MosaicAlt
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WorkspaceDir
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import qualified Data.Map as M
import qualified System.IO.UTF8
import qualified XMonad.StackSet as W


myManageHook = composeAll
	[ className =? "Gimp" --> doFloat
	, className =? "Firefox-bin" --> doShift "1:Web"
	, className =? "File Operation Progress"   --> doFloat
	, className =? "Skype" --> viewShift "3:Chat"
	, className =? "Pidgin" --> viewShift "3:Chat"
	, className =? "Nitrogen" --> doFloat
	]
    where viewShift = doF . liftM2 (.) W.greedyView W.shift

myWorkspaces = ["1:Web", "2:Dev", "3:Chat", "4:Latex", "5:Remote", "6:Term"]


startup :: X ()
startup = do
          spawn "xmodmap ~/.xmodmaprc"
          spawn "nitrogen --restore"
          spawn "xscreensaver -no-splash&"

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
	xmonad $ defaultConfig
		{ --manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
		-- <+> manageHook defaultConfig
          workspaces         = myWorkspaces
        , manageHook = myManageHook
		, terminal = "urxvt"
		, focusFollowsMouse  = False
   		, layoutHook=avoidStruts $ layoutHook defaultConfig
		, logHook = dynamicLogWithPP xmobarPP
				{ ppOutput = hPutStrLn xmproc
				, ppTitle = xmobarColor "green" "" . shorten 50
		}
		,startupHook = startup
		, modMask = mod4Mask     -- Rebind Mod to the Windows key
		} `additionalKeys`
		[ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock") 
		, ((mod4Mask,             xK_Down), spawn "amixer set Master 1-")
		, ((mod4Mask,             xK_Up  ), spawn "amixer set Master 1+")
		]
