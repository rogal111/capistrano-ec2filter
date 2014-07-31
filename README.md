# Introduction

capistrano-ec2filter is a Capistrano plugin designed to simplify the task of deploying to infrastructure hosted on Amazon EC2.
It allows to declare capistrano deploy servers filtered with `ec2-describe-instances` criteria ([read more](#supported-filters)).

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-ec2filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-ec2filter

## Usage

Add this to the top of your `deploy.rb`:

```ruby
require 'capistrano/ec2filter'
```

Then supply your AWS credentials with the environment variables (default):

```zsh
# aws
export AWS_ACCESS_KEY_ID='...'
export AWS_SECRET_ACCESS_KEY='...'
# export AWS_EC2_ENDPOINT='...'

```

Or in your `deploy.rb` with capistrano variables:

```ruby
set :aws_access_key_id, "..."
set :aws_secret_access_key, "..."
# set :aws_ec2_endpoint, "ec2.eu-west-1.amazonaws.com"

```

Define your servers:

```ruby
ec2_group("tag:application"=>"SuperApp", "tag:layer"=>"application") do |address|
  server address, :web, :app
end

ec2_group("tag:application"=>"SuperApp", "tag:layer"=>"workers") do |address, instance|
  server address, :app, :jobs, :min_job_priority: 10
end

ec2_group("placement-group-name"=>"matrix") do |address, instance|
  server address, :matrix, platform: instance.platform
end
```

`instance` - [AWS::EC2::Instance](http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/EC2/Instance.html) from AWS SDK for Ruby

`address` - dns/ip address of instance = `instance.dns_name || instance.ip_address || instance.private_ip_address`

By default ec2_group apply `"instance-state-name" => "running"` filter. You can overwrite this:

```ruby
  ec2_group("instance-state-name" => ["stopped", "stopping"], "tag:layer"=>"application") do |address|
    server address, :app, stopped: true
  end
```


### Supported filters

  Full list of supported EC2 filters: [click here](http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-DescribeInstances.html#cmd-DescribeInstances-filters)


## Contributing

1. Fork it ( http://github.com/rogal111/capistrano-ec2filter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
