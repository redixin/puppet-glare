Puppet::Type.type(:glare_paste_ini).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do
  def section
    resource[:name].split('/', 2).first
  end
  def setting
    resource[:name].split('/', 2).last
  end
  def self.file_path
    '/etc/glare/glare-paste.ini'
  end
end
