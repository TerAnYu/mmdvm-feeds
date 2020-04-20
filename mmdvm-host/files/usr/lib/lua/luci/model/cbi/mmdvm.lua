local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"

local m,s,o
local Status

if SYS.call("pidof MMDVMHost >/dev/null") == 0 then
	Status = "Host Running Ready QSO"
else
	Status = "Host Not Run, wait 2min or Check /usr/sbin/MMDVMHost if exist or MMDVM.ini Config Modem is /dev/ttyS1"
end

m = Map("mmdvm")
m.title	= translate(string.format([[DMR P25 Setting Here]]))
m.description = translate(string.format("%s", Status))

s = m:section(TypedSection, "mmdvm")
s.anonymous = true

s:tab("svc",  translate("Service"))

o = s:taboption("svc", Button, "restart")
o.title = translate("Restart to Enable New Config")
o.inputtitle = translate("RESTART Service")
o.inputstyle = "reload"
o.write = function()
	SYS.call("/etc/init.d/mmdvmhost restart >/dev/null")
	HTTP.redirect(DISP.build_url("admin", "system", "mmdvm"))
end


s:tab("user", translate("Global"))

local file = "/etc/MMDVM.ini"
o = s:taboption("user", TextValue, "rules")
o.description = translate("Changing  MMDVM.ini")
o.rows = 20
o.wrap = "off"
o.cfgvalue = function(self, section)
	return NXFS.readfile(file) or ""
end
o.write = function(self, section, value)
	NXFS.writefile(file, value:gsub("\r\n", "\n"))
end


s:tab("ysfgw", translate("YSF"))

local file = "/etc/YSFGateway.ini"
o = s:taboption("ysfgw", TextValue, "ysfgw")
o.description = translate("Changing YSFGateway.ini")
o.rows = 20
o.wrap = "off"
o.cfgvalue = function(self, section)
        return NXFS.readfile(file) or ""
end
o.write = function(self, section, value)
        NXFS.writefile(file, value:gsub("\r\n", "\n"))
end

s:tab("ysfhost", translate("YSFHosts"))

local file = "/etc/YSFHosts.txt"
o = s:taboption("ysfhost", TextValue, "ysfhost")
o.description = translate("Changing YSFHosts.txt")
o.rows = 20
o.wrap = "off"
o.cfgvalue = function(self, section)
	return NXFS.readfile(file) or ""
end
o.write = function(self, section, value)
	NXFS.writefile(file, value:gsub("\r\n", "\n"))
end

s:tab("p25", translate("P25"))

local file = "/etc/P25Gateway.ini"
o = s:taboption("p25", TextValue, "p25")
o.description = translate("Changing P25Gateway.ini")
o.rows = 20
o.wrap = "off"
o.cfgvalue = function(self, section)
	return NXFS.readfile(file) or ""
end
o.write = function(self, section, value)
	NXFS.writefile(file, value:gsub("\r\n", "\n"))
end

s:tab("p25host", translate("P25Hosts"))

local file = "/etc/P25Hosts.txt"
o = s:taboption("p25host", TextValue, "p25host")
o.description = translate("Changing P25Hosts.ini")
o.rows = 20
o.wrap = "off"
o.cfgvalue = function(self, section)
	return NXFS.readfile(file) or ""
end
o.write = function(self, section, value)
	NXFS.writefile(file, value:gsub("\r\n", "\n"))
end

s:tab("help",  translate("TECH"))

o = s:taboption("help", Button, "web")
o.title = translate("Web")
o.description = translate("Show MMDVM Live Log Pls Click Status->System Log")
o.inputtitle = translate("visit my blog to see details")
o.inputstyle = "apply"
o.write = function()
	HTTP.redirect("http://jumbospot17.blogspot.com")
end

return m
