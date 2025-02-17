RSpec.describe PluginSingleSource::SingleSourcePage do
  describe '#initialize' do
    let(:plugin) do
      PluginSingleSource::Plugin::Base.make_for(dir: 'acme/jwt-signer', site:)
    end

    subject { described_class.new(site:, version:, plugin:, is_latest:, source:) }

    context 'when the `source` does not start with `_`' do
      let(:source) { 'index' }
      let(:version) { '3.0.x' }
      let(:is_latest) { true }

      it 'raises an expection' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'when it is the latest version of the plugin' do
      let(:source) { '_index' }
      let(:version) { '3.0.x' }
      let(:is_latest) { true }

      it 'sets the corresponding attributes' do
        expect(subject.instance_variable_get(:@dir)).to eq('hub/acme/jwt-signer')
        expect(subject.instance_variable_get(:@relative_path)).to eq('_hub/acme/jwt-signer/_index.md')

        expect(subject.data['version']).to eq('3.0.x')
        expect(subject.data['is_latest']).to eq(true)
        expect(subject.data['canonical_url']).to be_nil
        expect(subject.data['seo_noindex']).to be_nil
        expect(subject.data['permalink']).to eq('hub/acme/jwt-signer/')
        expect(subject.data['layout']).to eq('extension')

        expect(subject.data['source_file']).to eq('_hub/acme/jwt-signer/_index.md')
        expect(subject.data['extn_slug']).to eq('jwt-signer')
        expect(subject.data['extn_publisher']).to eq('acme')
        expect(subject.data['extn_icon']).to eq('/assets/images/icons/hub/acme_jwt-signer.png')
        expect(subject.data['extn_release']).to eq('3.0.x')
      end
    end

    context 'when it is not' do
      let(:source) { '_index' }
      let(:version) { '2.8.x' }
      let(:is_latest) { false }

      it 'sets the corresponding attributes' do
        expect(subject.instance_variable_get(:@dir)).to eq('hub/acme/jwt-signer')
        expect(subject.instance_variable_get(:@relative_path)).to eq('_hub/acme/jwt-signer/_index.md')

        expect(subject.data['version']).to eq('2.8.x')
        expect(subject.data['is_latest']).to eq(false)
        expect(subject.data['canonical_url']).to eq('/hub/acme/jwt-signer/')
        expect(subject.data['seo_noindex']).to eq(true)
        expect(subject.data['permalink']).to eq('hub/acme/jwt-signer/2.8.x.html')
        expect(subject.data['layout']).to eq('extension')

        expect(subject.data['source_file']).to eq('_hub/acme/jwt-signer/_index.md')
        expect(subject.data['extn_slug']).to eq('jwt-signer')
        expect(subject.data['extn_publisher']).to eq('acme')
        expect(subject.data['extn_icon']).to eq('/assets/images/icons/hub/acme_jwt-signer.png')
        expect(subject.data['extn_release']).to eq('2.8.x')
      end

      context 'when there is a specific file for a particular version' do
        let(:source) { '_2.2.x' }
        let(:version) { '2.2.x' }
        let(:is_latest) { false }

        it 'sets the corresponding attributes' do
          expect(subject.instance_variable_get(:@dir)).to eq('hub/acme/jwt-signer')
          expect(subject.instance_variable_get(:@relative_path)).to eq('_hub/acme/jwt-signer/_2.2.x.md')

          expect(subject.data['version']).to eq('2.2.x')
          expect(subject.data['is_latest']).to eq(false)
          expect(subject.data['canonical_url']).to eq('/hub/acme/jwt-signer/')
          expect(subject.data['seo_noindex']).to eq(true)
          expect(subject.data['permalink']).to eq('hub/acme/jwt-signer/2.2.x.html')
          expect(subject.data['layout']).to eq('extension')

          expect(subject.data['source_file']).to eq('_hub/acme/jwt-signer/_2.2.x.md')
          expect(subject.data['extn_slug']).to eq('jwt-signer')
          expect(subject.data['extn_publisher']).to eq('acme')
          expect(subject.data['extn_icon']).to eq('/assets/images/icons/hub/acme_jwt-signer.png')
          expect(subject.data['extn_release']).to eq('2.2.x')
        end
      end

      context 'does not override versions missing from "frontmatter"' do
        let(:plugin) do
          PluginSingleSource::Plugin::Base.make_for(dir: 'acme/unbundled-plugin', site:)
        end
        let(:source) { '_index' }
        let(:version) { '2.8.x' }

        it 'sets the corresponding attributes' do
          expect(subject.instance_variable_get(:@dir)).to eq('hub/acme/unbundled-plugin')

          expect(subject.data['version']).to eq('2.8.x')
          expect(subject.data['bundled']).to eq(nil)
        end
      end

      context 'uses the "frontmatter" overrides where applicable' do
        let(:plugin) do
          PluginSingleSource::Plugin::Base.make_for(dir: 'acme/unbundled-plugin', site:)
        end
        let(:source) { '_index' }
        let(:version) { '3.0.x' }

        it 'sets the corresponding attributes' do
          expect(subject.instance_variable_get(:@dir)).to eq('hub/acme/unbundled-plugin')

          expect(subject.data['version']).to eq('3.0.x')
          expect(subject.data['bundled']).to eq(false)
        end
      end
    end
  end
end
