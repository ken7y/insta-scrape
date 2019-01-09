#encoding: utf-8


file = File.new("outputfile.txt", "r",:encoding => 'UTF-8')

output = File.open( "followers1.txt","w" )

file.each do |line|
  newLine = line[/title=".{0,30}"/]
  if !newLine.nil?
    splitLine = newLine.split(" ",2)
    output << splitLine[0].split("=")[1] + "\n"
  end
end

output.close
