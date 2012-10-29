require 'net/ssh'

module Lobot
  class Sobo
    attr_reader :ip, :key
    attr_writer :timeout

    def initialize(ip, key)
      @ip = ip
      @key = key
    end

    def timeout
      @timeout || 10000
    end

    def exec(command)
      output = nil
      Net::SSH.start(ip, "ubuntu", :keys => [key], :timeout => timeout) do |ssh|
        output = ssh.exec!(command)
      end
      output
    end

    def upload(from, to, opts = "--exclude .git")
      system("rsync -avz --delete #{from} ubuntu@#{ip}:#{to} #{opts}")
    end
  end
end