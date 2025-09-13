# xupnpd User Manual
**eXtensible UPnP Agent**
Copyright (C) 2011-2025 Anton Burdinuk
clark15b@gmail.com

## Overview

**xupnpd** is a simple and portable UPnP media server designed for IPTV broadcasting within a home network. It allows DLNA-compatible devices to stream IPTV content even if they lack native support for multicast or Internet-sourced playlists.

### Key Use Cases

*   **Router-based IPTV:** Install xupnpd on your home WiFi router to watch Internet TV on various devices (Smart TVs, game consoles, tablets) without a dedicated computer or ISP set-top box (provided the streams are not encrypted).
*   **Satellite TV Distribution:** Share a single satellite receiver's signal to multiple TVs across your home network.
*   **Media Server:** Share local video files from your router/PC to DLNA players.
*   **Online Video Aggregation:** Stream content from online platforms like YouTube, Vimeo, Vkontakte, and others directly to your TV.

Although not DLNA-certified, xupnpd effectively announces unicast or multicast TV channel lists using UPnP/DLNA mechanisms, compatible with a wide range of devices.

## Features

*   Built-in DLNA/UPnP media server for announcing channel lists or media files.
*   Support for HTTP sources (URL lists of Internet streams).
*   Built-in multicast proxy for ISP IPTV or external `udpxy` support.
*   Traditional media server for sharing video files on the network.
*   Support for YouTube, Vimeo, Vkontakte, IVI, and other online platforms.
*   High Definition (HD) video playback.
*   Internet radio.
*   Lua scripting extension mechanism for adding new video sources.
*   **No transcoding** (only delivery method conversion).
*   M3U playlist support.
*   Scheduled automatic feed/channel list updates.
*   Content grouping and tree-view display.
*   Access control lists (ACL) and parental controls.
*   Web interface and external management API.
*   Open source.

## Requirements

*   **Hardware:**
    *   A router with an Atheros or Broadcom chipset (ar71xx, mipsel, etc.), such as:
        *   D-Link DIR-320
        *   ASUS WL-500gP, N-16, RT-N56U
        *   Zyxel Keenetic
        *   TP-LINK WR841ND
    *   *Alternatively:* A PC or any other device running a Linux or BSD-based OS.
*   **Software:**
    *   A custom firmware like **OpenWrt** or **DD-Wrt** (for routers).
    *   (Optional) `udpxy` for external multicast-to-HTTP conversion.

## Installation & Quick Start

1.  **Download** the xupnpd archive to your router (using `scp`, `sftp`, or `ftp`).
2.  **Extract** the archive (e.g., `tar zxf xupnpd.tar.gz`).
3.  **Run** the appropriate binary for your architecture:
    *   `xupnpd/xupnpd-mipsel`
    *   `xupnpd/xupnpd-ar71xx`
4.  **Open** the web interface in your browser: `http://192.168.1.1:4044` (replace `192.168.1.1` with your router's IP address).
5.  **Upload** your IPTV playlist in M3U format via the web interface.
6.  **Enjoy** IPTV on your DLNA-compatible player. Your server should appear as "UPnP-IPTV".

## Playlist Format (M3U8)

xupnpd uses playlists in M3U8 format to describe the structure of media content.

### EXTM3U Directives (Playlist Headers)

Lines starting with `#EXTM3U` can contain the following attributes:
*   `name` - Playlist name.
*   `type` - Default video type.
*   `dlna_extras` - Default DLNA profile.
*   `plugin` - Default handler (extension) for the entire playlist (e.g., for YouTube, Vimeo).

### EXTINF Directives (Channel Entries)

Lines starting with `#EXTINF` describe individual channels and can contain:
*   `logo` - URL of the channel logo (JPEG image).
*   `group-title` - Group name (items with the same value are grouped in one folder).
*   `type` - Video type.
*   `dlna_extras` - DLNA profile.
*   `plugin` - Handler (extension) name for this specific stream.

### Allowed Values

*   **`type`:** `avi`, `asf`, `wmv`, `mp4`, `mpeg`, `mpeg1`, `mpeg2`, `ts`, `mp2t`, `mp2p`, `mov`, `mkv`, `3gp`, `flv`, `aac`, `ac3`, `mp3`, `ogg`, `wma`
*   **`dlna_extras`:** `none`, `mpeg_ps_pal`, `mpeg_ps_pal_ac3`, `mpeg_ps_ntsc`, `mpeg_ps_ntsc_ac3`, `mpeg1`, `mpeg_ts_sd`, `mpeg_ts_hd`, `avchd`, `wmv_med_base`, `wmv_med_full`, `wmv_med_pro`, `wmv_high_full`, `wmv_high_pro`, `asf_mpeg4_sp`, `asf_mpeg4_asp_l4`, `asf_mpeg4_asp_l5`, `asf_vc1_l1`, `mp4_avc_sd_mp3`, `mp4_avc_sd_ac3`, `mp4_avc_hd_ac3`, `mp4_avc_sd_aac`, `mpeg_ts_hd_mp3`, `mpeg_ts_hd_ac3`, `mpeg_ts_mpeg4_asp_mp3`, `mpeg_ts_mpeg4_asp_ac3`, `avi`, `divx5`, `mp3`, `ac3`, `wma_base`, `wma_full`, `wma_pro`

## Configuration (xupnpd.lua)

The main configuration file is `xupnpd.lua`. Here is an example with common parameters:

```lua
-- Network interface for SSDP announcements (e.g., 'eth0', 'br0', 'br-lan')
cfg.ssdp_interface='br0'

-- Allow host to receive its own multicast announcements (0 or 1)
cfg.ssdp_loop=0

-- HTTP port for incoming connections (web interface)
cfg.http_port=4044

-- Log facility ('syslog', 'local0' - 'local7')
cfg.log_facility='local0'

-- Run as a daemon
cfg.daemon=true

-- Embedded mode (no logs, no pid file)
cfg.embedded=true

-- SSDP trace level (0-off, 1-basic, 2-full; requires cfg.daemon=false)
cfg.debug=1

-- URL for external udpxy proxy (comment out to use built-in proxy!)
--cfg.udpxy_url='http://192.168.1.1:4022'

-- Network interface (usually WAN) for receiving multicast streams for the built-in proxy
cfg.mcast_interface='eth1'

-- HTTP unicast proxy mode: 0-disable, 1-proxy only radio, 2-proxy everything
cfg.proxy=2

-- Network timeout
cfg.http_timeout=15

-- Enable DLNA extras transmission
cfg.dlna_extras=true

-- XBox 360 compatibility mode
cfg.xbox360=false

-- Enable UPnP/DLNA change notifications
cfg.dlna_notify=true

-- Group content by 'group-title'
cfg.group=true

-- Display name for the device
cfg.name='UPnP-IPTV'

-- Device UUID (if nil, generates a new one on each start)
cfg.uuid='60bd2fb3-dabe-cb14-c766-0e319b54c29a'

-- Default IPTV stream type
cfg.default_mime_type='mpeg'

-- Feed update interval in seconds (0 - disable)
cfg.feeds_update_interval=0

-- Playlists and local media folders
-- Format: { 'path', 'Display Name', 'optional;acl;list' }
playlist=
{
    { './playlists/mozhay.m3u', 'Mozhay.tv' },
    { './localmedia', 'Local Media Files', '127.0.0.1;192.168.1.1' } -- ACL restricted
}

-- Feeds from extensions
-- Format: { 'plugin_name', 'feed_identifier', 'Display Name' }
feeds=
{
    { 'vimeo',   'channel/hd',          'Vimeo HD Channel' },
    { 'vimeo',   'channel/hdxs',        'HD Xtreme sports' },
    { 'youtube', 'channel/top_rated',   'YouTube Top Rated' },
}
```

## Example Playlist (M3U8)

```m3u8
#EXTM3U name="My IPTV"
#EXTINF:0 logo=http://example.com/chan1.jpg type=mpeg dlna_extras=mpeg_ps_pal,Channel 1
udp://@234.5.2.8:20000
#EXTINF:0,Channel 2
http://192.168.1.1:4022/udp/234.5.2.2:20000
#EXTINF:0 group-title="Main",Channel 3
http://020.example.tv
#EXTINF:0 logo=http://b.vimeocdn.com/ts/204/056/204056508_200.jpg type=mp4 plugin=vimeo,The Curious Fate of Humankind
http://vimeo.com/30381893
#EXTINF:0 logo=http://i.ytimg.com/vi/kffacxfA7G4/1.jpg type=mp4 plugin=youtube,Justin Bieber - Baby ft. Ludacris
http://www.youtube.com/watch?v=kffacxfA7G4
```

## Tested Compatibility

*   **Routers/Devices:** PC (Ubuntu 10.04), D-Link DIR-320, Asus WL-500gP, Asus N-16, Asus RT-N56U, Zyxel Keenetic, TP-LINK WR841ND, Samsung B/C/D Series TVs, DreamBox DM500HD.
*   **Players:** Sony PlayStation 3, Iconbit HDS4L, WDTV Live, HTC Desire (Android + apps), various Samsung, LG, Sony, Philips Smart TVs, Windows Media Player 11, VideoLAN.
