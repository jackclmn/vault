Puppet::Type.newtype(:vault_policy) do
  @doc = <<-PUPPET
        @summary
        Manages Hashicorp Vault policies.
        PUPPET

  ensurable

  def rules_to_string(rules)
    Puppet.debug("Entering rules_to_string with rules: #{rules}")
    template = %q{
# comment
<% rules.each do |rule| %>
path "<%= rule['path'] %>" {
    capabilities = <%= rule['capabilities'] %>
}
<% end %>
    }.gsub(/^  /, '')
    message = ERB.new(template).result(binding)
    Puppet.debug("message is: #{message}")
    message
  end

  newparam(:name) do
    desc 'The name assigned to the vault policy.'

    isnamevar
  end

  newproperty(:rules, array_matching: :all) do
    desc 'The content of the vault policy'
    munge do |value|
        rules_to_string(value)
    end
  end
end
