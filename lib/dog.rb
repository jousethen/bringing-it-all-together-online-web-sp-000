class Dog 
  attr_accessor :name, :breed, :id
  
  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end
  
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
  end
  
  def update
    sql = <<-SQL
        UPDATE dogs
        SET name = ?, breed = ? WHERE id = ?
      SQL
      
      DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
    dog
  end
  
  def self.new_from_db(row)
    new_dog = self.new(id: row[1], name: row[2], breed: row[0])
    new_dog  
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end
  
  
end