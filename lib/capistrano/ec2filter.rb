require "capistrano/ec2filter/version"
require "aws-sdk"

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/ec2filter requires Capistrano 2"
end

module Capistrano
  module Ec2filter
    def self.load_into(configuration)
      configuration.load do
        _cset(:aws_access_key_id, ENV["AWS_ACCESS_KEY_ID"])
        _cset(:aws_secret_access_key, ENV["AWS_SECRET_ACCESS_KEY"])
        _cset(:aws_ec2_endpoint, ENV["AWS_EC2_ENDPOINT"])

        def ec2_filter(filters = {})
          filters = { "instance-state-name" => "running" }.merge(filters)
          @aws_ec2 ||= AWS::EC2.new(
                     access_key_id: fetch(:aws_access_key_id),
                     secret_access_key: fetch(:aws_secret_access_key),
                     ec2_endpoint: fetch(:aws_ec2_endpoint)
                   )

          instances = @aws_ec2.instances

          filters.each do |attribute, value|
            instances = instances.filter(attribute, value)
          end

          instances.each do |instance|
            address = instance.dns_name || instance.ip_address || instance.private_ip_address
            yield address, instance
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Ec2filter.load_into(Capistrano::Configuration.instance)
end
