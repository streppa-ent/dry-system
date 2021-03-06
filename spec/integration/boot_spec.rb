require 'ostruct'

RSpec.describe Dry::System::Container, '.boot' do
  subject(:system) { Test::Container }

  context 'with a boot file' do
    before do
      class Test::Container < Dry::System::Container
        configure do |config|
          config.root = SPEC_ROOT.join('fixtures/test').realpath
        end
      end
    end

    it 'auto-boots dependency of a bootable component' do
      system.start(:client)

      expect(system[:client]).to be_a(Client)
      expect(system[:client].logger).to be_a(Logger)
    end
  end

  context 'using predefined settings for configuration' do
    before do
      class Test::Container < Dry::System::Container
      end
    end

    it 'uses defaults' do
      system.boot(:api) do
        settings do
          key :token, Types::String.default('xxx')
        end

        start do
          register(:client, OpenStruct.new(config.to_hash))
        end
      end

      system.start(:api)

      client = system[:client]

      expect(client.token).to eql('xxx')
    end
  end

  context 'inline booting' do
    before do
      class Test::Container < Dry::System::Container
      end
    end

    it 'allows lazy-booting' do
      system.boot(:db) do
        init do
          module Test
            class Db < OpenStruct
            end
          end
        end

        start do
          register('db.conn', Test::Db.new(established?: true))
        end
      end

      conn = system['db.conn']

      expect(conn).to be_established
    end
  end
end
