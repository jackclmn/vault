require 'vault'

Puppet::Type.type(:vault_policy).provide(:vault) do
  desc 'This provider manages vault policies.'

  defaultfor kernel: :Linux
  confine    kernel: :Linux

  def exists?
    Vault.sys.policies.include? resource[:name]
  end

  def content
    Vault.sys.policy(resource[:name]).rules
  end

  def content=(_value)
    Vault.sys.put_policy(resource[:name], resource[:content])
  end

  def create
    Vault.sys.put_policy(resource[:name], resource[:content])
  end

  def destroy
    Vault.sys.delete_policy(resource[:name])
  end
end
