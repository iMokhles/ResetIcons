GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 192.168.1.92
export SDKVERSION=8.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 6.0
# ADDITIONAL_CFLAGS = -fobjc-arc

include theos/makefiles/common.mk

BUNDLE_NAME = ResetIcons
ResetIcons_FILES = Switch.xm
ResetIcons_FRAMEWORKS = UIKit
ResetIcons_PRIVATE_FRAMEWORKS = GraphicsServices
ResetIcons_LIBRARIES = flipswitch
ResetIcons_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk

# internal-stage::
#     #PreferenceLoader plist
#     $(ECHO_NOTHING)if [ -f Preferences.plist ]; then mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ResetIcons; cp Preferences.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ResetIcons/; fi$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
