#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# teamviewer
wget -O /tmp/teamviewer.asc https://linux.teamviewer.com/pubkey/currentkey.asc
rpm --import /tmp/teamviewer.asc
rm -f /tmp/teamviewer.asc
dnf5 install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm

# install packages from fedora repos
dnf5 install -y \
    krdc \

# remove pre-installed packages
dnf5 remove -y \
    openrazer-daemon \
    openrgb-udev-rules \
    tailscale

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#systemctl enable podman.socket

# edge policies
mkdir -p /etc/opt/edge/policies/managed
cat <<EOF > /etc/opt/edge/policies/managed/policies.json
{
  "HideFirstRunExperience": true,
  "ShowPDFDefaultRecommendationsEnabled": false,
  "SpotlightExperiencesAndRecommendationsEnabled": false,
  "NewTabPageSearchBox": "redirect",
  "GenAILocalFoundationalModelSettings": true,
  "WebToBrowserSignInEnabled": false,
  "StartupBoostEnabled": false,
  "NewTabPageBingChatEnabled": false,
  "NewTabPageContentEnabled": false,
  "NewTabPageHideDefaultTopSites": true,
  "AIGenThemesEnabled": false,
  "AutoImportAtFirstRun": 4,
  "BuiltInAIAPIsEnabled": false,
  "BuiltInDnsClientEnabled": false,
  "ComposeInlineEnabled": false,
  "CopilotPageContext": false,
  "DefaultBrowserSettingEnabled": false,
  "DefaultBrowserSettingsCampaignEnabled": false,
  "DiagnosticData": false,
  "EdgeShoppingAssistantEnabled": false,
  "Microsoft365CopilotChatIconEnabled": false,
  "ShowAcrobatSubscriptionButton": false,
  "ShowMicrosoftRewards": false,
  "ShowRecommendationsEnabled": false,
  "TabServicesEnabled": false,
  "TextPredictionEnabled": false,
  "VisualSearchEnabled": false,
  "EdgeHistoryAISearchEnabled": false
}
EOF
