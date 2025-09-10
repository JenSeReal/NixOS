{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.firefox";

  home.ifEnabled = {
    cfg,
    myconfig,
    ...
  }: {
    programs.firefox.profiles.default = {
      inherit (cfg) extraConfig;
      # inherit (myconfig.constants) username;
      extensions.packages = with pkgs.firefoxAddons; [
        ublock-origin
        privacy-badger
        bitwarden
        clearurls
        decentraleyes
        duckduckgo-privacy-essentials
        ghostery
        privacy-badger
        # languagetool
        disconnect
      ];
      userChrome = ''
        ${cfg.userChrome}
        .tabbrowser-tab .tab-close-button {
          visibility: collapse !important;
        }
        #tabs-newtab-button, #new-tab-button{
          display: none !important
        }
        .titlebar-buttonbox-container {
          display:none;
        }
      '';
      search = {
        force = true;
        default = "google";
        order = ["google"];
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nw"];
          };
          "bing".metaData.hidden = true;
          "Amazon".metaData.hidden = true;
          "Wikipedia".metaData.hidden = true;
          "google".metaData.alias = "@g";
        };
      };

      settings = lib.mkMerge [
        cfg.settings
        {
          "accessibility.typeaheadfind.enablesound" = false;
          "accessibility.typeaheadfind.flashBar" = 0;

          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;
          "browser.bookmarks.autoExportHTML" = true;
          "browser.bookmarks.showMobileBookmarks" = true;
          "browser.meta_refresh_when_inactive.disabled" = true;
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.search.hiddenOneOffs" = "Google,Amazon.com,Bing,DuckDuckGo,eBay,Wikipedia (en)";
          "browser.search.suggest.enabled" = false;
          "browser.sessionstore.warnOnQuit" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.ssb.enabled" = true;
          "browser.startup.homepage.abouthome_cache.enabled" = true;
          "browser.startup.page" = 3;
          "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.translations.enable" = false;

          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;
          "dom.forms.autocomplete.formautofill" = true;
          "dom.storage.next_gen" = true;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          "font.name.monospace.x-western" =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Monaspace Krypton"
            else "MonaspaceKrypton";
          "font.name.sans-serif.x-western" =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Monaspace Neon"
            else "MonaspaceNeon";
          "font.name.serif.x-western" =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Monaspace Neon"
            else "MonaspaceNeon";

          "general.autoScroll" = false;
          "general.smoothScroll.msdPhysics.enabled" = true;
          "geo.enabled" = false;
          "geo.provider.use_corelocation" = false;
          "geo.provider.use_geoclue" = false;
          "geo.provider.use_gpsd" = false;

          "gfx.font_rendering.cleartype_params.enhanced_contrast" = 25;
          "gfx.font_rendering.cleartype_params.force_gdi_classic_for_families" = "";
          "gfx.font_rendering.directwrite.bold_simulation" = 2;

          "intl.accept_languages" = "en-US,en";
          "media.eme.enabled" = true;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

          "signon.autofillForms" = false;
          "signon.firefoxRelay.feature" = "disabled";
          "signon.generation.enabled" = false;
          "signon.management.page.breach-alerts.enabled" = false;
          "signon.rememberSignons" = false;

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "xpinstall.signatures.required" = false;

          "browser.startup.homepage" = "about:blank";
          "browser.newtab.url" = "about:blank";
          "browser.ctrlTab.sortByRecentlyUsed" = false;
          "browser.tabs.closeWindowWithLastTab" = true;
          "browser.tabs.tabmanager.enabled" = true;

          "browser.download.start_downloads_in_tmp_dir" = true;
          # "browser.download.folderList" = 2; # use the last dir
          "browser.download.useDownloadDir" = true;
          "browser.download.dir" = "~/Downloads";

          "media.block-autoplay-until-in-foreground" = true;
          "media.block-play-until-document-interaction" = true;
          "media.block-play-until-visible" = true;

          "privacy.clearOnShutdown.history" = false;
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "device.sensors.enabled" = false;
          # Bluetooth location tracking
          "beacon.enabled" = false;

          "browser.send_pings" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;
          "extensions.webcompat-reporter.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.eventTelemetry.enabled" = false;
          "browser.tabs.crashReporting.sendReport" = false;

          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;

          "extensions.pocket.enabled" = false;
          "browser.vpn_promo.enabled" = false;
          "extensions.abuseReport.enabled" = false;

          # Firefox login
          # "identity.fxaccounts.enabled" = false;
          # "identity.fxaccounts.toolbar.enabled" = false;
          # "identity.fxaccounts.pairing.enabled" = false;
          # "identity.fxaccounts.commands.enabled" = false;

          # Firefox password manager
          "browser.contentblocking.report.lockwise.enabled" = false;
          "browser.uitour.enabled" = false;

          "dom.push.enabled" = false;
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.private-attribution.submission.enabled" = false;

          # Sidebar
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "expand-on-hover";
        }
        (lib.optionalAttrs cfg.gpuAcceleration {
          "dom.webgpu.enabled" = true;
          "gfx.webrender.all" = true;
          "layers.gpu-process.enabled" = true;
          "layers.mlgpu.enabled" = true;
        })
        (lib.optionalAttrs cfg.hardwareDecoding {
          "media.ffmpeg.vaapi.enabled" = true;
          "media.gpu-process-decoder" = true;
          "media.hardware-video-decoding.enabled" = true;
        })
      ];
    };
  };
}
