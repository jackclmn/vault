Puppet::Type.newtype(:vault_policy) do
  @doc = <<-PUPPET
        @summary
        Manages Hashicorp Vault policies.
        PUPPET

  ensurable

  newparam(:name) do
    desc 'The name assigned to the vault policy.'

    isnamevar
  end

  newproperty(:rules, array_matching: :all) do
    desc 'The content of the vault policy'
    munge do |value|
        Puppet.debug("Entering rules_to_string with rules: #{value}")
        template = %q{
    # comment
    <% value.each do |v| %>
    path "<%= v['path'] %>" {
        capabilities = <%= v['capabilities'] %>
    }
    <% end %>
        }.gsub(/^  /, '')
        message = ERB.new(template).result(binding)
        Puppet.debug("message is: #{message}")
        message
    end
  end
end
