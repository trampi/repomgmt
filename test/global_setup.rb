require 'rubygems/package'

class GlobalTestSetup

  def initialize fixture_path
    extract_gitolite_fixture fixture_path
  end

  private
  def extract_gitolite_fixture fixture_path
    tmpdir = Dir.mktmpdir
    Rails.configuration.repomgmt.gitolite_repository = tmpdir + '/gitolite-admin-clone'
    Rails.configuration.repomgmt.repository_root_path = tmpdir + '/gitolite-repositories'
    Rails.configuration.repomgmt.repository_url_prefix = 'ssh://gitolite@127.0.0.1/'
    repomgmt_fixture_archive_path = File.join(fixture_path, 'files', 'repomgmt_gitolite_fixture.tar')

    File.open(repomgmt_fixture_archive_path) do |repomgmt_fixture_archive_handle|
      tar_reader = Gem::Package::TarReader.new(repomgmt_fixture_archive_handle)
      tar_reader.each do |archive_file_entry|
        extract_archive(tmpdir, archive_file_entry)
      end
    end

    # clean up
    ObjectSpace.define_finalizer(self, proc { |id| FileUtils.rm_rf(tmpdir) })
  end

  def extract_archive target_root, entry
    entry_path = File.join(target_root, entry.full_name)
    if entry.directory? then
      Dir.mkdir(entry_path)
    elsif entry.file? then
      File.open(entry_path, 'wb') do |out_file_handle|
        out_file_handle.write(entry.read)
      end
    end
  end
end
