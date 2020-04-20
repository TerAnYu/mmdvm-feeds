module("luci.controller.mmdvm", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/adbyby") then
		return
	end
	
	entry({"admin", "system", "mmdvm"}, cbi("mmdvm"), _("RADIO_DMR_P25"), 56).dependent = true
end
