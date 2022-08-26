require 'vault'
require 'erb'
require 'puppet'

Puppet::Type.type(:vault_policy).provide(:vault) do
  desc 'This provider manages vault policies.'

  defaultfor kernel: :Linux
  confine    kernel: :Linux

  def rules_to_string(rules)
    Puppet.debug("Entering rules_to_string with rules: #{rules}")
    template = %q{
# comment
<% rules.each do |rule| %>
path "<%= rule %>" {
    capabilities = <%= rule %>
}
<% end %>
    }.gsub(/^  /, '')
    message = ERB.new(template).result(binding)
    Puppet.debug("message is: #{message}")
    message
  end

  def exists?
    Puppet.debug('entering exists?')
    Vault.sys.policies.include? resource[:name]
  end

  def rules
    Puppet.debug('entering rules')
    Vault.sys.policy(resource[:name]).rules
  end

  def rules=(value)
    Puppet.debug("entering rules=value with name: #{resource[:name]} and rules #{resource[:rules]}")
    rules = rules_to_string(resource[:rules])
    Puppet.debug("rules is: #{rules}")
    rules_str = rules.to_str
    Puppet.debug("rules_str is: #{rules_str}")
    Vault.sys.put_policy(resource[:name], rules_str)
  end

  def create
    Puppet.debug("entering create with name: #{resource[:name]} and rules #{resource[:rules]}")
    Vault.sys.put_policy(resource[:name], rules_to_string(resource[:rules]))
  end

  def destroy
    Puppet.debug("entering destroy with name: #{resource[:name]} and rules #{resource[:rules]}")
    Vault.sys.delete_policy(resource[:name])
  end
end
