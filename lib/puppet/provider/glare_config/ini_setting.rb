Puppet::Type.type(:glare_config).provide(
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
    '/etc/glare/glare.conf'
  end
end
