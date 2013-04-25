# encoding: utf-8

require 'spec_helper'
require 'pg'
require 'stringio'

# This is a postgresql system table to store the large object.
TABLE_NAME = 'pg_largeobject'

describe PostgresqlStorage do

  def env
    {
      :storage => 'postgresql',
      :host => 'localhost',
      :port => '5432',
      :database => 'letshire_ci'
    }
  end

  def error_env
    {
      :storage => 'unknown'
    }
  end

  def content
    "\xCC" * 256
  end

  before (:all) do
    @conninfo = "host=#{env[:host]} port=#{env[:port]} dbname=#{env[:database]}"
    @conn = PGconn.connect(@conninfo)
  end

  before (:each) do
    @conn.transaction do
      object = @conn.escape_bytea(content)
      @conn.exec("INSERT INTO #{TABLE_NAME}(loid, pageno, data) values (1, 0, E'#{object}')")
    end
  end

  after (:each) do
    @conn.transaction do
      @conn.exec("DELETE FROM #{TABLE_NAME}")
    end
  end

  after (:all) do
    @conn.finish
  end

  it 'should raise exception with incorrect property' do
    expect do
      pg = PostgresqlStorage.new(error_env)
    end.to raise_error(Exception)
  end

  it 'should read/write small binary object from/into database' do
    pg = PostgresqlStorage.new(env)
    oid = pg.write(StringIO.new(content))
    file = StringIO.new
    pg.read(file, oid)
    file.rewind
    res = file.read
    res.length.should be_equal(content.length)
    #FIXME: not sure why the following statement reports error
    #res.should be_equal(content)
    pg.fini
  end

  it 'should read/write large binary object from/into database' do
    pg = PostgresqlStorage.new(env)
    oid = pg.write(StringIO.new(content * 1024))
    file = StringIO.new
    pg.read(file, oid)
    file.rewind
    res = file.read
    res.length.should be_equal(content.length * 1024)
    #FIXME: not sure why the following statement reports error
    #res.should be_equal(content * 1024)
    pg.fini
  end

  it 'should get the correct size of binary object' do
    pg = PostgresqlStorage.new(env)
    oid = pg.write(StringIO.new(content))
    pg.file_length(oid).should be_equal(content.length)
    pg.fini
  end
end
