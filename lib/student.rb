require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :grade, :name

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if @id == nil
      sql = <<-SQL
      INSERT INTO students(name, grade) VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      sql = <<-SQL
      SELECT students.id FROM students ORDER BY students.id DESC LIMIT 1
      SQL

      @id = DB[:conn].execute(sql)[0][0]
    else
      self.update
    end 
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
  end

  def self.new_from_db(params)
    Student.new(params[1],params[2],params[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
     SELECT * FROM students WHERE students.name = ?
    SQL

    student_params = DB[:conn].execute(sql, name)[0]
    self.new_from_db(student_params)
  end

  def update
    sql = <<-SQL
     UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
