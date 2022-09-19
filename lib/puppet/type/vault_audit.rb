# vault_audit { '/file-audit':
#   ensure      => present,,
#   type        => 'file',
#   description => 'File audit',
#   options     => {
#     'file_path' => '/path/on/disk',
#   },
# }
Puppet::Type.newtype(:vault_audit) do
  @doc = <<-PUPPET
          @summary
          Manages Hashicorp Vault audit.
          PUPPET

  ensurable

  newproperty(:path) do
    desc 'path'

    isnamevar
  end

  newproperty(:type) do
    desc 'type'

    newvalue('file')
    newvalue('syslog')
    newvalue('socket')
  end

  newproperty(:description) do
    desc 'description'
  end

  newproperty(:options) do
    desc 'options'
    validate do |value|
      raise Puppet::Error, _('must be a Hash') unless value.is_a?(Hash)
      super(value) # TODO revisit this
    end
  end
end