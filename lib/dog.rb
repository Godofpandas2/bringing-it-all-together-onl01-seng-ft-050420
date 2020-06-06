require 'pry'
class Dog

  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id:nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs;
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
        SQL
        #binding.pry
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.create(hash)
    dog = self.new(name: hash[:name], breed: hash[:breed])
    dog.save
    dog
  end

  def self.new_from_db(row)
    dog = self.new(id:row[0], name:row[1], breed:row[2])
    dog
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM songs WHERE id = ?"
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db
  end.first

  def self.find_or_create_by

  end

  def self.find_by_name

  end

  def update

  end
end
