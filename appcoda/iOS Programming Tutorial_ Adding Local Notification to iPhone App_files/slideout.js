// Global instance of our plugin api
var EjSocialSlideoutJsApi = {};

(function ($, api)
{

    // ----------------------------------------------------------------------------------------------------
    //                                           Global Settings
    // ----------------------------------------------------------------------------------------------------
    var DefaultSettings = {

        // Slider should slide-out at this Percentage or Fixed Height (whichever is smaller)
        startDistanceFixed: 2000,
        startDistancePercent: 0.25,
        startDistance: function ()
        {
            return Math.min($("body").height() * api.Settings.startDistancePercent, api.Settings.startDistanceFixed);
        },

        // The TIME delay at which the slider should slide-out if we can't scroll on this page
        noScrollStartTime: 30,


        profileTimeoutDays: 0, // The number of days that a single social profile (Facebook,Twitter,..) stays active before changing
        hideForDaysAfterProfileClick: 1, // The number of days to hide the popup for after the profile is clicked
        hideForDaysAfterDontShowClick: 30, // The number of days to hide the popup for after the "X Dont Show" link is clicked

        cookieName: "ej-ss-settings-e40b2fc5"
    };

    // ----------------------------------------------------------------------------------------------------
    //                                                API
    // ----------------------------------------------------------------------------------------------------
    api._isDomLoading = true; // We're still waiting for the DOM to load
    api.SettingsLoaded = function(settings) // Called when the settings have loaded
    {
        api.Settings = $.extend({}, DefaultSettings, settings);
        CheckInit();
    }

    // ----------------------------------------------------------------------------------------------------
    //                                                Setup
    // ----------------------------------------------------------------------------------------------------

    // Listen to whether the DOM has loaded
    $(document).ready(function()
    {
        delete api._isDomLoading;

        // Check whether the settings have loaded BEFORE we got a chance to load the plugin proper
        if (typeof (EjSocialSlideoutJsApi_Settings) !== "undefined" )
            api.SettingsLoaded(EjSocialSlideoutJsApi_Settings);

        CheckInit();
    });

    // ------------------------------
    // Check whether we need to init the plugin
    function CheckInit()
    {
        if (!api._isDomLoading && api.Settings && !api._isAlreadyInit)
        {
            Init();
        }
    }

    // ------------------------------
    // Initialize the plugin. This can only be done once BOTH the DOM are loaded and the Settings are loaded
    function Init()
    {
        // ** Mark as Initialized
        // (preemptively in case we exit init early)
        api._isAlreadyInit = true;

        // ** Load user settings and select a profile

        // Load user settings
        LoadUserSettings();

        // Retrieve all the available social profiles
        var availableSocialProfiles = Object.keys(api.Settings.SocialProfiles).map(function (key) { return key; }); // http://stackoverflow.com/questions/7306669/how-to-get-all-properties-values-of-a-javascript-object-without-knowing-the-key

        // Select a profile
        api.Settings.UserSettings.UpdateShownProfile(availableSocialProfiles);

        // Save this profile - in case the user hasn't been saved before
        SaveUserSettings(); 

        // ** Check if we have anything to show?
        if (!api.Settings.UserSettings.ShowProfile)
            return;

        // ** Load the slider

        // Select the social network
        var socialNetwork = api.Settings.UserSettings.ShowProfileName; // Facebook,Twitter,GooglePlus,YouTube,iTunes,LinkedIn,Instagram,Pinterest

        // Append the slideout html to the page
        appendSlideoutDom(socialNetwork); // TODO: We should add the DOM through the plugin as part of the page load so that we don't miss out on any page scans from the loaded social scripts (if they're loaded on the page already before we get executed)

        // Append social media scripts
        loadSocialNetworkApi(socialNetwork);

        // ** Hook up the functionality 

        // Hook up the scroll handler
        $(window).scroll(onScroll);

        // Hook up the slide out time if we can't scroll
        if( api.Settings.startDistance() > ($("body").height() - $(window).height()) )
            setTimeout(SlidePopupIn, api.Settings.noScrollStartTime * 1000);

        // Show the slideout DOM (currently slid away)
        $('#ej-plugin-socialslideout').show();

        // Add the event that closes the popup and sets the cookie that tells us to
        // not show it again until one day has passed.
        $('#ej-plugin-socialslideout-close').click(onClosePopupClick);

        // Enable click tracking
        EnableTracking();

        // Preview Mode
        // Note: Preview flag stops the user preferences getting Read or Written + tracking events don't hit the server
        if (api.Settings.Preview)
            SlidePopupIn();

    }

    // ------------------------------
    // 
    function EnableTracking()
    {
        // Intercept mouse events to track social likes
        // Hardcore solution:
        // . Overlay div
        // . When mouse event occurs, hide div, re-create the event, fire the event directly via dispatchEvent or fireEvent
        // . http://stackoverflow.com/questions/1009753/pass-mouse-events-through-absolutely-positioned-element
        // . http://www.vinylfox.com/forwarding-mouse-events-through-layers/
        // . css pointer-events:none doesn't seem to help since we can't actually track the mouse events ourselves there
        // Easier / Less problematic solution (implemented below)
        // . Register a click handler on anything inside the social box
        // . If an iframe happens to be inside the social box then register mouseOver and mouseOut, at the same time register a $(window).blur(..) event and if this is fired while the cursor is inside the iframe then the iframe was clicked
        //   (http://www.bennadel.com/blog/1752-tracking-google-adsense-clicks-with-jquery-and-coldfusion.htm)
        {
            // Setup
            var clickLogged = false; // Only log once
            var inIFrame = false; // Whether the mouse is currently within hte iFrame

            // Straight click on static elements
            $(".ejp-ss-btn-container").on("click", function ()
            {
                if(!clickLogged)
                    onTracking();
                clickLogged = true;
            });

            // iFrame, we'll need to track whether the iFrame becomes active and assume the user clicked
            $(".ejp-ss-btn-container").on("mouseover", "iframe", function ()
            {
                inIFrame = true;
            });
            $(".ejp-ss-btn-container").on("mouseout", "iframe", function ()
            {
                inIFrame = false;
            });
            $(window).blur(function ()
            {
                if (inIFrame)
                {
                    if (!clickLogged)
                        onTracking();
                    clickLogged = true;
                }
            });
        }
    }

    // ------------------------------
    // 
    function LoadUserSettings()
    {
        // * Create a default user setting
        var userSettings = {
            HideUntil:null, // DateTime - hide he popup until the specified time
            ShowProfile: false, // bool - whether we should show this profile (i.e. if the user clicks through we want to hide the profile, but not select another one until a certain timeout from ShowProfileFrom)
            ShowProfileName: null, // string - the profile we're displaying
            ShowProfileFrom: null, // DateTime - when we decided to display ShowProfileName. This way we can consistently show this profile for a period of time

            UserProfileTracking: {},

            // ------------------------------
            // Returns the tracking information for profileName in UserProfileTracking or a default one if not set
            GetTrackingForProfile: function (profileName)
            {
                if (!userSettings.UserProfileTracking[profileName])
                {
                    userSettings.UserProfileTracking[profileName] = {
                        Clicked: false
                    };
                }

                return userSettings.UserProfileTracking[profileName];
            },

            // ------------------------------
            // Returns the tracking for userSettings.ShowProfile
            GetTrackingForCurrentProfile: function (profileName)
            {
                return userSettings.GetTrackingForProfile(userSettings.ShowProfileName);
            },

            // ------------------------------
            // Record a tracking event for the current social profile
            RecordTrackingEvent: function()
            {
                userSettings.GetTrackingForCurrentProfile().Clicked = true;
                userSettings.HideUntil = new Date();
                userSettings.HideUntil.setDate(userSettings.HideUntil.getDate() + api.Settings.hideForDaysAfterProfileClick);
                userSettings.ShowProfile = false;
            },

            // ------------------------------
            // Close the social slider temporarily
            ClosePopup: function ()
            {
                userSettings.HideUntil = new Date();
                userSettings.HideUntil.setDate(userSettings.HideUntil.getDate() + api.Settings.hideForDaysAfterDontShowClick);
                userSettings.ShowProfile = false;
            },


            // ------------------------------
            // Select a new profile to display to this user
            SelectRandomUnclickedProfile: function (availableSocialProfiles)
            {
                // Filter the available profiles by the ones the user hasn't clicked
                var $available = $(availableSocialProfiles).filter(function (i, e)
                {
                    return (!userSettings.UserProfileTracking[e] || !userSettings.UserProfileTracking[e].Clicked);
                });

                // Filter the available profiles by the ones not currently shown
                if($available.length > 1)
                {
                    $available = $($available).filter(function (i, e)
                    {
                        return e != userSettings.ShowProfileName;
                    });
                }

                // Select this profile
                if ($available.length == 0)
                {
                    userSettings.ShowProfile = false;
                    userSettings.ShowProfileName = null;
                    userSettings.ShowProfileFrom = null; // This ensures we re-check, in case more available profiles get added to api.Settings
                    return null;
                }
                else
                {
                    var randomProfileIdx = Math.max(Math.ceil(Math.random() * $available.length) - 1, 0);
                    var selectedProfile = $available[randomProfileIdx];

                    userSettings.ShowProfile = true;
                    userSettings.ShowProfileName = selectedProfile;
                    userSettings.ShowProfileFrom = new Date();
                }
            },

            // ------------------------------
            // Update ShowProfile if enough time has passed for the current profile
            UpdateShownProfile: function (availableSocialProfiles)
            {
                // Actively hiding
                if (userSettings.HideUntil)
                {
                    // We should continue hiding
                    if (userSettings.HideUntil > new Date())
                        return;

                    // We should hide no longer
                    userSettings.HideUntil = null;
                }

                // Currently not showing a profile
                if (!userSettings.ShowProfileFrom)
                {
                    userSettings.SelectRandomUnclickedProfile(availableSocialProfiles);
                }
                // Timeout?
                else
                {
                    var timeoutOfCurrentProfile = new Date();
                    timeoutOfCurrentProfile.setDate(timeoutOfCurrentProfile.getDate() - api.Settings.profileTimeoutDays);

                    if (userSettings.ShowProfileFrom < timeoutOfCurrentProfile)
                        userSettings.SelectRandomUnclickedProfile(availableSocialProfiles);

                    // else - we're still showing the current profile
                }
            }
        };



        // * Read the user's profile from the cookie
        var cookieSettingStr = readCookie(api.Settings.cookieName);
        if (cookieSettingStr && !api.Settings.Preview)
        {
            // Load the cookie settings (and convert types from string where appropriate)
            var cookieSettings = JSON.parse(cookieSettingStr);
            if (cookieSettings.ShowProfileFrom)
                cookieSettings.ShowProfileFrom = new Date(Date.parse(cookieSettings.ShowProfileFrom));
            if (cookieSettings.HideUntil)
                cookieSettings.HideUntil = new Date(Date.parse(cookieSettings.HideUntil));

            // Update User Settings
            $.extend(userSettings, cookieSettings);
        }

        // * Done
        api.Settings.UserSettings = userSettings;
        return userSettings;
    }

    // ------------------------------
    //
    function SaveUserSettings()
    {
        if(!api.Settings.Preview)
            createCookie(api.Settings.cookieName, JSON.stringify(api.Settings.UserSettings), 365);
    }

    // ----------------------------------------------------------------------------------------------------
    //                                             Event Methods
    // ----------------------------------------------------------------------------------------------------

    // ------------------------------
    //
    function onScroll()
    {
        var scrollTop = $(document).scrollTop();

        if (scrollTop > api.Settings.startDistance())
            SlidePopupIn();
        else
            SlidePopupOut();
    }

    // ------------------------------
    //
    function onClosePopupClick()
    {
        // Save this in the user's settings
        api.Settings.UserSettings.ClosePopup();
        SaveUserSettings();
        SlidePopupClosed();
        return false;
    }

    // ------------------------------
    // A tracking event for the currently displayed social network has occurred
    function onTracking()
    {
        // console.log("tracking");

        // Save this in the user's settings
        api.Settings.UserSettings.RecordTrackingEvent();
        SaveUserSettings();

        // Slide the popup in (after a little while, in case they got a Google+ popup or similar and are still interacting with it)
        setTimeout(SlidePopupClosed, 800);

        // Inform the plugin of this event
        var data = {
            'action': 'ej_ss_click_track',
            'network': api.Settings.UserSettings.ShowProfileName
        };

        if (!api.Settings.Preview)
        {
            $.post('/wp-admin/admin-ajax.php', data, function (response)
            {
                //console.log("tracking + response = " + response);
            });
        }
    }

    // ----------------------------------------------------------------------------------------------------
    //                                            Helper Methods
    // ----------------------------------------------------------------------------------------------------

    // --------------------------------------------------
    // Dom
    // --------------------------------------------------

    // ------------------------------
    // Slide and remove the popup dom
    function SlidePopupClosed()
    {
        var $slider = $('#ej-plugin-socialslideout');
        if ($slider.is(".ej-ss-animate-close"))
            return;

        $slider.removeClass("ej-ss-animate-in");
        $slider.removeClass("ej-ss-animate-out");
        $slider.addClass("ej-ss-animate-close");
        $slider.stop(true).animate({ 'left': '-330px', 'opacity': '0.2' }, 800, function ()
        {
            $slider.removeClass("ej-ss-animate-close");
            $slider.remove();
        });
    }

    // ------------------------------
    // Slide in the Popup dom
    function SlidePopupIn()
    {
        var $slider = $('#ej-plugin-socialslideout');
        if ($slider.is(".ej-ss-animate-in"))
            return;

        $slider.removeClass("ej-ss-animate-close");
        $slider.removeClass("ej-ss-animate-out");
        $slider.addClass("ej-ss-animate-in");
        $slider.animate({ 'left': '0px', 'opacity': '1' }, 800, function ()
        {
            $slider.removeClass("ej-ss-animate-in");
        });
    }

    // ------------------------------
    // Slide in the Popup out
    function SlidePopupOut()
    {
        var $slider = $('#ej-plugin-socialslideout');
        if ($slider.is(".ej-ss-animate-out"))
            return;

        $slider.removeClass("ej-ss-animate-in");
        $slider.removeClass("ej-ss-animate-close");
        $slider.addClass("ej-ss-animate-out");
        $slider.stop(true).animate({ 'left': '-330px', 'opacity': '0.2' }, 800, function ()
        {
            $slider.removeClass("ej-ss-animate-out");
        });
    }

    // ------------------------------
    // The list of Dom generation functions per social network
    // Attention: This is output directly by the plugin now! This is so that the Network DOM exists in case another plugin inserts the network script before we have a chance to add the network DOM
    var NetworkDomFunctions =
    {
        Facebook: function(profile)
        {
            return "<div class='fb-follow' data-href='https://www.facebook.com/" + profile.Id + "' data-width='210' data-colorscheme='light' data-layout='standard' data-show-faces='true'></div>";
        },

        Twitter: function (profile)
        {
            return "<a href='https://twitter.com/" + profile.Id + "' class='twitter-follow-button' data-show-count='true' data-size='medium'>Follow @" + profile.Id + "</a>";
        },

        GooglePlus: function (profile)
        {
            return "<div class='g-follow' data-annotation='bubble' data-height='24' data-href='https://plus.google.com/" + profile.Id + "' data-rel='author'></div>";
        },

        YouTube: function (profile)
        {
            return "<div class='g-ytsubscribe' data-channel" + (profile.Id.length == 24 ? "id" : "") + "='" + profile.Id + "' data-layout='default' data-count='default'></div>";
        },

        iTunes: function (profile)
        {
            return "<a href='https://itunes.apple.com/us/podcast/subscribe/" + profile.Id + "' target='itunes_store' style='display:inline-block;overflow:hidden;background:url(https://linkmaker.itunes.apple.com/htmlResources/assets/en_us//images/web/linkmaker/badge_subscribe-lrg.png) no-repeat;width:135px;height:40px;@media only screen{background-image:url(https://linkmaker.itunes.apple.com/htmlResources/assets/en_us//images/web/linkmaker/badge_subscribe-lrg.svg);}'></a>";
        },

        LinkedIn: function (profile)
        {
            var id = profile.Id.trim();
            var url = "https://linkedin.com/in/" + id;
            if (id.match(/^\d+$/ig))
            {
                url = "https://linkedin.com/profile/view?id=" + id;
            }

            return "<a href='" + url + "' target='_blank'><img src='http://www.linkedin.com/img/webpromo/btn_myprofile_160x33.png' width='160' height='27' border='0' alt='View my profile on LinkedIn'></a>";
        },

        Instagram: function (profile)
        {
            //return "<span class='ig-follow' data-id='5479dee' data-handle='igfbdotcom' data-count='true' data-size='large' data-username='true'></span>";
            return "<a href='//instagram.com/" + profile.Id + "' target='_blank'><img src='" + profile.Image + "' width='160' height='27' alt='Follow us on Instagram'></a>";
        },

        Pinterest: function (profile)
        {
            return "<a data-pin-do='buttonFollow' href='http://www.pinterest.com/" + profile.Id + "/' target='_blank'>Follow " + profile.Id + "<b></b><i></i></a>";
        }

    };

    

    // ------------------------------
    //
    function appendSlideoutDom(socialNetwork)
    {
        var domTemplates = $("#ej-ss-slideout-dom-templates"); // Has the plugin pre-inserted all the network DOM templates (i.e. to be more compatible with other social plugins that might insert the network script before we have a chance to insert the DOM)
        var socialNetworkProfile = api.Settings.SocialProfiles[socialNetwork];
        var rawDom = "<div id='ej-plugin-socialslideout'><div class='ejp-ss-top-box ejp-ss-" + socialNetwork.toLowerCase() + "'> <p><a href='JavaScript:void(0)' id='ej-plugin-socialslideout-close'>Don't show again | <strong>X</strong></a></p><h3>{!mainDescription}</h3><p class='ej-ss-description'>{!subDescription}</p></div><div class='ej-ss-slider-photo'>{!sliderImage}</div><div class='ejp-ss-btn-container ejp-ss-" + socialNetwork.toLowerCase() + "'>" + (domTemplates.length ? "" : NetworkDomFunctions[socialNetwork](socialNetworkProfile)) + "</div></div>";
        rawDom = rawDom.replace(/{!sliderImage}/g, api.Settings.SliderImage);
        rawDom = rawDom.replace(/{!mainDescription}/g, socialNetworkProfile.Title != null && socialNetworkProfile.Title != undefined && socialNetworkProfile.Title.length > 0 ? socialNetworkProfile.Title.replace(/\s/ig, "&nbsp;") : "&nbsp;");
        rawDom = rawDom.replace(/{!subDescription}/g, socialNetworkProfile.Description != null && socialNetworkProfile.Description != undefined && socialNetworkProfile.Description.length > 0 ? socialNetworkProfile.Description.replace(/\s/ig, "&nbsp;") : "&nbsp;");

        $("body").append(rawDom);

        // Copy the DOM into the slider
        if(domTemplates.length)
        {
            var dom = $("#ej-ss-slideout-dom-template-" + socialNetwork.toLowerCase());
            dom.remove();
            dom.children().each(function (i, e)
            {
                $(".ejp-ss-btn-container.ejp-ss-" + socialNetwork.toLowerCase()).append(e);
            });
        }
    }

    
    

    // --------------------------------------------------
    // Social Media
    // --------------------------------------------------

    // ------------------------------
    // The list of scripts to load each social network's API
    var NetworkLoadApiFunctions =
    {
        Facebook: function()
        {
            var d = document;
            var s = 'script';
            var id = 'facebook-jssdk';

            var h = d.getElementsByTagName("head")[0];
            var js, fjs = h.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.0";
            js.async = true;
            if (fjs)
                fjs.parentNode.insertBefore(js, fjs);
            else
                h.insertBefore(js, h.children[0]);

        },

        Twitter:function ()
        {
            var d = document;
            var s = 'script';
            var id = 'twitter-wjs';

            var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
            if(!d.getElementById(id))
            {
                js=d.createElement(s);
                js.id=id;
                js.src=p+'://platform.twitter.com/widgets.js';
                fjs.parentNode.insertBefore(js,fjs);
            }
        },

        GooglePlus: NetworkLoadApiFunctions_GoogleCommon,
        YouTube: NetworkLoadApiFunctions_GoogleCommon,
        iTunes: function () { }, // Nothing to do, just a passive link
        LinkedIn: function () { }, // Nothing to do, just a passive link

        Instagram: function () { }, // We're just using a standard image for now
        //Instagram: function ()
        //{
        //    var d = document
        //    var t = "script";

        //    // Additional handling to check that we're not adding the script tag twice, since the standard Instagram code does NOT include an id check
        //    var target = 'x.instagramfollowbutton.com/follow.js';
        //    var scripts = d.getElementsByTagName('script');

        //    for (var i = 0; i < scripts.length; i++)
        //    {
        //        var iScript = scripts[i];
        //        if (iScript.src && iScript.src.toLowerCase().indexOf(target) >= 0)
        //            return;
        //    }

        //    var g = d.createElement(t), s = d.getElementsByTagName(t)[0];
        //    g.src = "//" + target;
        //    s.parentNode.insertBefore(g, s);
        //},

        Pinterest: function ()
        {
            // Custom script since Pinterest only provides a static script link to insert: <script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
            // Also included is additional handling to check that we're not adding the script tag twice
            var d = document
            var t = "script";

            
            var target = 'assets.pinterest.com/js/pinit.js';
            var targetAlt = 'assets.pinterest.com/js/pinit_main.js';
            var scripts = d.getElementsByTagName('script');

            for (var i = 0; i < scripts.length; i++)
            {
                var iScript = scripts[i];
                if (   iScript.src
                    && (iScript.src.toLowerCase().indexOf(target) >= 0 || iScript.src.toLowerCase().indexOf(targetAlt) >= 0))
                {
                    return;
                }
            }

            var g = d.createElement(t), s = d.getElementsByTagName(t)[0];
            g.src = "//" + target;
            g.async = true;
            g.defer = true;

            s.parentNode.insertBefore(g, s);
        }
    };

    // ------------------------------
    // Google API loading functions across multiple Google networks
    function NetworkLoadApiFunctions_GoogleCommon()
    {
        // Additional handling to check that we're not adding GooglePlus twice, since the standard GooglePlus code does NOT include an id check
        var d = document;
        var t = 'apis.google.com/js/platform.js';
        var scripts = d.getElementsByTagName('script');

        for (var i = 0; i < scripts.length; i++)
        {
            var iScript = scripts[i];
            if (iScript.src && iScript.src.toLowerCase().indexOf(t) >= 0)
                return;
        }

        // Standard GooglePlus code
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://' + t;
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    }

    // ------------------------------
    // The list of scripts to load each social network's API
    function loadSocialNetworkApi(socialNetwork)
    {
        NetworkLoadApiFunctions[socialNetwork]();
    }

    // --------------------------------------------------
    // Cookie
    // --------------------------------------------------

    // ------------------------------
    //
    function readCookie(name)
    {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++)
        {
            var c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }

    // ------------------------------
    //
    function createCookie(name, value, days)
    {
        if (days)
        {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            var expires = "; expires=" + date.toGMTString();
        }
        else var expires = "";
        document.cookie = name + "=" + value + expires + "; path=/";
    }

    // ------------------------------
    //
    function eraseCookie(name)
    {
        createCookie(name, "", -1);
    }


})(jQuery, EjSocialSlideoutJsApi);