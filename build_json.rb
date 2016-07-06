#!/usr/bin/ruby
# this script builds the code and html steps files from their folder into json

require 'json'
require 'cgi'
require 'redcarpet'


class StepsParser
  def initialize(markdown_parser)
    @md_parser = markdown_parser
  end

  def generate_steps(lesson_path)
    File.open("#{lesson_path}/steps.md") do |steps_file|
      steps_data = parse steps_file.read
      steps_data.sort
    end
  end

  private
  StepData = Struct.new :index, :cmds, :text do
    def <=>(other)
      self.index <=> other.index
    end
  end

  def parse(raw_steps)

    steps_data = []
    raw_steps.scan(/# ?({.*?})(.*?)(?=# ?{.*}|\z)/m) do |step_cmds, text|
      cmd_hash = parse_step_cmds step_cmds
      step_id = cmd_hash.delete 'step'
      steps_data << StepData.new(step_id, cmd_hash, @md_parser.render(text))
    end

    steps_data
  end

  def parse_step_cmds(step_cmds)
    JSON.parse convert_cmds_to_valid_json(step_cmds)
  end

  def convert_cmds_to_valid_json(step_cmds)
    fixed = step_cmds
      .gsub(/([A-z\-]+)\s*:/, '"\1":') # surround all keys with quotes
      .gsub(/(?<="step":) *(\w+)/, '"\1"') # surround step value with quotes
      .gsub(/(?<=\[).*?(?=\])/) do |text| # add quotes to frame ids inside [  ]
        text.gsub(/(\w+),?/, '"\1",')[0..-2]
      end
    fixed
  end
end

class CodeParser
  LANG_ESCAPE_SEQS = {
    'java': %r{//~},
    'py': %r{#~}
  }


  def self.decorate_code(lesson_name)
    File.open(Dir.glob("#{lesson_name}/code.*").first) do |f|
      cp = CodeParser.new File.extname(f.path)[1..-1] # remove leading dot from filepath
      cp.decorate_code(f.read).string
    end
  end

  def initialize(file_ext)
    @directive_esc_seq = LANG_ESCAPE_SEQS[file_ext.to_sym]
  end

  def decorate_code(code_str)
    strio = StringIO.new
    code_lines = code_str.split "\n"
    line_lookahead = false

    code_lines.each_with_index do |line, i|
      (line_lookahead = false; next) if line_lookahead
      if line =~ @directive_esc_seq
        line_lookahead = true
        strio << enhance_line(line, code_lines, i)
      else
        strio << CGI.escapeHTML(line)
      end
      strio << ?\n
    end
    strio
  end

  def enhance_line(line, all_lines, index)
    line_builder = StringIO.new
    prev_match_end = 0
    next_line = all_lines[index + 1]

    line.scan(/(?:(\w)|\|\s*(\w+)\s*\|)/) do |s| # match x or | x |
      match = Regexp.last_match
      matched_id = match[1] || match[2]
      line_builder << next_line[prev_match_end...match.begin(0)]
      line_builder << add_frame_tags(
        next_line[match.begin(0)...match.end(0)], matched_id)
      prev_match_end = match.end 0
    end
    line_builder << next_line[prev_match_end..-1]
    line_builder.string
  end

  def add_frame_tags(substring, frame_id)
    %Q{<c-frm f-id="#{frame_id}">#{
    CGI.escapeHTML(substring)}</c-frm>}
  end

  def line_higlight_marker(line_num)
    %Q{<c-hl f-ln-num="#{line_num}"></c-hl>}
  end
end

def build_json(code: nil, steps: nil)
  {
    code: code,
    steps: steps.map do |step_data|
      {
        "index": step_data.index,
        "cmds": step_data.cmds,
        "html": step_data.text
      }
    end
  }.to_json
end

if __FILE__ == $0
  renderer = Redcarpet::Render::HTML.new(
    safe_links_only: true, prettify: true, hard_wrap: true)
  markdown_parser = Redcarpet::Markdown.new(renderer,
                                            autolink: true, fenced_code_blocks: true)
  Dir.foreach('lessons') do |filename|
    next if filename == '.' or filename == '..'
    path = "lessons/#{filename}"
    if File.directory? path
      steps_parser = StepsParser.new markdown_parser
      output_dir = Dir.new ARGV[0]
      File.open("#{output_dir.path}/lesson-#{filename}.json", 'w') do |output|
        output << build_json(code: CodeParser.decorate_code(path),
                             steps: steps_parser.generate_steps(path))
      end
    end
  end
end
