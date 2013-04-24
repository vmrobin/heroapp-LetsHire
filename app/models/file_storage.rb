require 'pg'

class FileStorageImpl
  @@storages = %w(postgresql mongodb)

  attr_accessor :buffer_size, :host, :port, :database

  def initialize(opts)
    if opts.has_key?(:storage)
      unless @@storages.include?(opts[:storage])
        raise Exception.new("unknown storage")
      end
    end

    @host = opts[:host] if opts.has_key?(:host)
    @port = opts[:port] if opts.has_key?(:port)
    @database = opts[:database] if opts.has_key?(:database)
    @buffer_size = 256
  end

  # NOTE: It's better to mark the following functions to be 'abstract'.
  def read(file, oid)
  end

  def write(file)
  end

private
  def parse_args(opts)
  end
end

class PostgresqlStorage < FileStorageImpl
  def initialize(opts)
    super(opts)
  end

  def read(file, oid)
    file.rewind
    transaction(connection) do
      fd = connection.lo_open(oid, PG::INV_READ)
      total_size = connection.lo_lseek(fd, 0, PG::SEEK_END)
      connection.lo_lseek(fd, 0, PG::SEEK_SET)
      offset = 0
      while offset < total_size
        buffer = connection.lo_read(fd, @buffer_size)
        file.write(buffer)
        offset += buffer.length
      end
      connection.lo_close(fd)
    end
  end

  def write(file)
    file.rewind
    oid = nil
    transaction(connection) do
      oid = connection.lo_create
      fd = connection.lo_open(fd, 0, PG::INV_WRITE)
      total_size = file.length
      offset = 0
      while offset < total_size
        buffer = file.read(@buffer_size)
        offset += buffer.length
        until buffer.empty?
          bytes = connection.lo_write(fd, buffer)
          buffer.slice!(0, bytes)
        end
      end
      connection.lo_close(fd)
    end
    return oid
  end

  def file_length(oid)
    fd = connection.lo_open(oid, PG::INV_READ)
    length = connection.lo_lseek(fd, 0, PG::SEEK_END)
    connection.lo_close(fd)
    return length
  end

private
  # NOTE: Shall we need a connection pool? Currently let's make it simple.
  def connection
    @conn ||= PG.connect( :dbname => @database, :host => @host, :port => @port )
    @conn
  end

  def disconnect
  end

  def transaction(conn, &blk)
    begin
      conn.exec('BEGIN')
      yield
      conn.exec('COMMIT')
    rescue => exception
      conn.exec('ROLLBACK')
    end
  end
end
