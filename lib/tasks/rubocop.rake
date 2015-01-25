desc 'Scan the project with rubocop'
task rubocop: :environment do
  def remove_spaces_and_newlines(str)
    str.tr!("\r", '')
    str.tr!("\n", '')
    str.strip!
    str.gsub!(/[ ]+/, ' ')
    str
  end

  def read_report_status_line(relative_path_to_report)
    full_path_to_report = Dir.getwd + '/' + relative_path_to_report
    node = Mechanize.new.get("file:///#{full_path_to_report}").at('.information .infobox')
    remove_spaces_and_newlines(node.text)
  end

  relative_path_to_report = 'tmp/rubocop.html'
  result_code = system("rubocop -R --format html -o #{relative_path_to_report}")
  had_error = result_code.nil? || result_code == false
  puts "Generated report in #{relative_path_to_report}"
  report_status_line = read_report_status_line(relative_path_to_report)

  print "\e[31m" if had_error # red
  print "\e[32m" unless had_error # green
  print report_status_line
  puts "\e[0m" # clear color
  Kernel.exit(1) if had_error
end
