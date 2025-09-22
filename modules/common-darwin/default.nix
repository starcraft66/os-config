{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ../../applications/core.nix
    ../../applications/nix.nix
  ];

  # Sudo touch id
  security.pam.services.sudo_local.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.meslo-lg
      # emacs-all-the-icons-fonts
    ];
  };

  networking.applicationFirewall.enable = true;

  services.openssh.enable = true;

  programs.zsh.enable = true;

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    verbose = true;
  };

  # Homebrew integration
  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;
    autoMigrate = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;
    
    user = config.system.primaryUser;
  };
  
  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    casks = [
      "discretescroll"
      "raycast"
      "vlc"
      "discord"
      "spotify"
      "slack"
      "insomnia"
      "kitty"
      "ghostty"
      "rectangle"
      "jordanbaird-ice"
      "obs"
      "imhex"
      "visual-studio-code"
    ];
  };

  # macOS Prefs

  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleIconAppearanceTheme = "RegularAutomatic";
      AppleInterfaceStyleSwitchesAutomatically = true;
      # https://macos-defaults.com/keyboard/applekeyboarduimode.html
      AppleKeyboardUIMode = 2;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      # https://macos-defaults.com/keyboard/applepressandholdenabled.html
      ApplePressAndHoldEnabled = false;
      AppleShowScrollBars = "Automatic";
      # https://macos-defaults.com/mission-control/applespacesswitchonactivate.html
      AppleSpacesSwitchOnActivate = true;
      AppleTemperatureUnit = "Celsius";

      # Keyboard
      InitialKeyRepeat = null;
      KeyRepeat = null;
      "com.apple.keyboard.fnState" = false;

      # Trackpad
      "com.apple.mouse.tapBehavior" = null; # Tap-to-click disabled
      "com.apple.swipescrolldirection" = false; # "Natural" scrolling disabled
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1; # Enable trackpad right-click
      "com.apple.trackpad.forceClick" = true;
      "com.apple.trackpad.scaling" = null;

      # Sound
      "com.apple.sound.beep.feedback" = 1;
      "com.apple.sound.beep.volume" = null;

      # Composing
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = true;

      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      
      NSScrollAnimationEnabled = true;
      NSStatusItemSelectionPadding = null;
      NSStatusItemSpacing = null;
      NSTableViewDefaultSizeMode = null;

      NSTextShowsControlCharacters = true;
      NSUseAnimatedFocusRing = true;

      NSWindowResizeTime = null;
      NSWindowShouldDragOnGesture = false;

      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;

      _HIHideMenuBar = false;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    WindowManager = {
      AppWindowGroupingBehavior = false;
      AutoHide = true;
      EnableStandardClickToShowDesktop = false;

      # Tiling
      EnableTiledWindowMargins = false; # Disable tiling gaps
      EnableTilingByEdgeDrag = true;
      EnableTilingOptionAccelerator = true;
      EnableTopTilingByEdgeDrag = true;

      GloballyEnabled = false; # Disable stage manager
    };

    controlcenter = {
      AirDrop = false;
      BatteryShowPercentage = false;
      Bluetooth = true;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };

    dock = {
      appswitcher-all-displays = true; # Cmd+Tab on all displays
      autohide = false;
      autohide-delay = null;
      autohide-time-modifier = null;
      dashboard-in-overlay = false;
      expose-animation-duration = null;
      expose-group-apps = false; # Don't group apps in mission control
      largesize = null; # Don't magnify icons
      launchanim = true;
      magnification = false;
      mineffect = "genie";
      minimize-to-application = false;
      mouse-over-hilite-stack = false;
      mru-spaces = false;
      orientation = "left";
      scroll-to-open = false;
      show-process-indicators = true;
      show-recents = false;
      showhidden = false;
      slow-motion-allowed = false;
      static-only = false;
      tilesize = null;

      # Hot corners
      wvous-tl-corner = 2; # Top Left Corner triggers Mission Control
      wvous-tr-corner = 13; # Top Right Corner triggers Lock Screen
    };

    finder = {
      # https://macos-defaults.com/finder/appleshowallextensions.html
      AppleShowAllExtensions = true;
      # https://macos-defaults.com/finder/appleshowallfiles.html
      # You can toggle the value using cmd+shift+.
      AppleShowAllFiles = false;
      # https://macos-defaults.com/desktop/createdesktop.html
      CreateDesktop = true;
      # https://macos-defaults.com/finder/fxdefaultsearchscope.html
      FXDefaultSearchScope = "SCcf"; # Set default search scope to current folder
      # https://macos-defaults.com/finder/fxenableextensionchangewarning.html
      FXEnableExtensionChangeWarning = false;
      # https://macos-defaults.com/finder/fxpreferredviewstyle.html
      FXPreferredViewStyle = "Nlsv"; # Use list view by default
      # https://macos-defaults.com/finder/fxremoveoldtrashitems.html
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Home";
      # https://macos-defaults.com/finder/quitmenuitem.html
      QuitMenuItem = false;
      # https://macos-defaults.com/desktop/showexternalharddrivesondesktop.html
      ShowExternalHardDrivesOnDesktop = false;
      # https://macos-defaults.com/desktop/showharddrivesondesktop.html
      ShowHardDrivesOnDesktop = false;
      # https://macos-defaults.com/desktop/showmountedserversondesktop.html
      ShowMountedServersOnDesktop = false;
      # https://macos-defaults.com/finder/showpathbar.html
      ShowPathbar = true;
      # https://macos-defaults.com/desktop/showremovablemediaondesktop.html
      ShowRemovableMediaOnDesktop = false;
      ShowStatusBar = false;
      _FXShowPosixPathInTitle = true;
      # https://macos-defaults.com/finder/_fxsortfoldersfirst.html
      _FXSortFoldersFirst = true;
      # https://macos-defaults.com/desktop/_fxsortfoldersfirstondesktop.html
      _FXSortFoldersFirstOnDesktop = true;
    };

    hitoolbox = {
      # https://macos-defaults.com/keyboard/applefnusagetype.html
      AppleFnUsageType = "Change Input Source";
    };

    menuExtraClock.Show24Hour = true;

    screencapture = {
      disable-shadow = false;
      include-date = true;
      location = "~/Pictures/screenshots";
      show-thumbnail = true;
      target = "file";
      type = "png";
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 5;
    };

    trackpad = {
      ActuationStrength = 1;
      Clicking = false;
      Dragging = false;
      FirstClickThreshold = null;
      SecondClickThreshold = null;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
      TrackpadThreeFingerTapGesture = 0;
    };
  };

  system.keyboard.remapCapsLockToControl = true;

  # Using Determinate Nix
  nix.enable = false;

  determinate-nix.customSettings = let
    caches = import ../../caches;
  in {
    extra-substituters = caches.nix.settings.substituters;
    extra-trusted-public-keys = caches.nix.settings.trusted-public-keys;
  };

}
