require 'spec_helper'

describe PostgresqlStorage do

  def env
    {
      :storage => 'postgresql',
      :host => 'localhost',
      :port => '5432',
      :database => 'test'
    }
  end

  def error_env
    {
      :storage => 'unknown'
    }
  end

  it 'should raise exception with incorrect property' do
    expect do
      pg = PostgresqlStorage.new(error_env)
    end.to raise_error(Exception)
  end
end
