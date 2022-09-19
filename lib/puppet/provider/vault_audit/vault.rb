require 'vault'
require 'erb'
require 'puppet'

Puppet::Type.type(:vault_audit).provide(:vault) do
  desc 'This provider manages vault audit.'

  defaultfor kernel: :Linux
  confine    kernel: :Linux

  def exists?
    Puppet.debug("entering exists? with #{resource[:path]}")
    Puppet.debug("Get audits: #{Vault.sys.audits}")
    Vault.sys.audits.include? resource[:path]
  end

  def description
    Puppet.debug('entering description getter')
    description = nil
    Vault.sys.audits.each do | key, values |
      if key == resource[:path]
        description = values['description']
      end
    end
    description
  end

  def description=(value)
    Puppet.debug("entering rules=value with name: #{resource[:name]} and rules #{resource[:rules]}")
    #Vault.sys.disable_audit(resource[:path])
    Vault.sys.enable_audit(resource[:path], resource[:type], resource[:description], resource[:options])
  end

  def create
    Puppet.debug("entering create with name: #{resource[:path]} and type #{resource[:type]} and description #{resource[:description]} and options #{resource[:options]}")
    Vault.sys.enable_audit(resource[:path], resource[:type], resource[:description], resource[:options])
  end

  def destroy
    Puppet.debug("entering destroy with name: #{resource[:path]}")
    Vault.sys.disable_audit(resource[:path])
  end
end
