# frozen_string_literal: true

require "spec_helper"
require "dependabot/dependency_file"
require "dependabot/gradle/file_fetcher/settings_file_parser"

RSpec.describe Dependabot::Gradle::FileFetcher::SettingsFileParser do
  let(:finder) { described_class.new(settings_file: settings_file) }

  let(:settings_file) do
    Dependabot::DependencyFile.new(
      name: "settings.gradle",
      content: fixture("settings_files", fixture_name)
    )
  end
  let(:fixture_name) { "simple_settings.gradle" }

  describe "#subproject_paths" do
    subject(:subproject_paths) { finder.subproject_paths }

    context "when there are subproject declarations" do
      let(:fixture_name) { "simple_settings.gradle" }

      it "includes the additional declarations" do
        expect(subproject_paths).to match_array(%w(app))
      end
    end

    context "when there are subproject and included build declarations" do
      let(:fixture_name) { "composite_build_simple_settings.gradle" }

      it "includes the additional declarations" do
        expect(subproject_paths).to match_array(%w(app))
        expect(included_build_paths).to match_array(%w(included))
      end
    end

    context "with various call styles" do
      let(:fixture_name) { "call_style_settings.gradle" }

      it "includes the additional declarations" do
        expect(subproject_paths).to match_array(
          %w(function_without_space function_with_space implicit implicit_with_many_spaces)
        )
      end
    end

    context "when kotlin" do
      let(:settings_file) do
        Dependabot::DependencyFile.new(
          name: "settings.gradle.kts",
          content: fixture("settings_files", fixture_name)
        )
      end
      let(:fixture_name) { "settings.gradle.kts" }

      it "includes the additional declarations" do
        expect(subproject_paths).to match_array(%w(app))
        expect(included_build_paths).to match_array(%w(settings-plugins project-plugins))
      end
    end

    context "with commented out subproject declarations" do
      let(:fixture_name) { "comment_settings.gradle" }

      it "includes the additional declarations" do
        expect(subproject_paths).to match_array(%w(app))
      end
    end

    context "with multiple subprojects" do
      let(:fixture_name) { "multi_subproject_settings.gradle" }

      it "includes the additional declarations" do
        expect(subproject_paths).
          to match_array(%w(../ganttproject ../biz.ganttproject.core))
      end

      context "declared across multiple lines" do
        let(:fixture_name) { "multiline_settings.gradle" }

        it "includes the additional declarations" do
          expect(subproject_paths).
            to match_array(%w(../ganttproject ../biz.ganttproject.core))
        end
      end
    end

    context "with multiple included builds" do
      let(:fixture_name) { "composite_build_settings.gradle" }

      it "includes the additional declarations" do
        expect(included_build_paths).
          to match_array(%w(lint-plugins settings-plugins publishing))
      end
    end

    context "with custom paths specified" do
      let(:fixture_name) { "custom_dir_settings.gradle" }

      it "uses the custom declarations" do
        expect(subproject_paths).
          to match_array(%w(subprojects/chrome-trace examples/java))
      end
    end
  end
end
