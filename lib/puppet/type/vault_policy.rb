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

  newproperty(:content) do
    desc 'The content of the vault policy'
  end
end
