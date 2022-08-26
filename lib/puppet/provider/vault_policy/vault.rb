require 'vault'
require 'erb'

Puppet::Type.type(:vault_policy).provide(:vault) do
  desc 'This provider manages vault policies.'

  defaultfor kernel: :Linux
  confine    kernel: :Linux

  def rules_to_string(rules)
    template = %q{
        % r.each do |k, v|
            path "<%= v['path'] %>" {
              capabilities = <%= v['capabilities'] %>
            }
  
        % end
    }.gsub(/^  /, '')
    message = ERB.new(template).result(binding)
    message
  end

  def exists?
    Vault.sys.policies.include? resource[:name]
  end

  def rules
    Vault.sys.policy(resource[:name]).rules
  end

  def rules=(value)
    Vault.sys.put_policy(resource[:name], rules_to_string(resource[:rules]))
  end

  def create
    Vault.sys.put_policy(resource[:name], rules_to_string(resource[:rules]))
  end

  def destroy
    Vault.sys.delete_policy(resource[:name])
  end
end
