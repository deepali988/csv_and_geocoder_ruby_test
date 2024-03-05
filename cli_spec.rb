# cli_spec.rb
require './cli'  # Assuming your main script is named cli.rb

describe 'CLI Script' do
  let(:input_file) { 'sample_input.csv' }
  let(:output_file) { 'output.csv' }

  it 'outputs valid CSV with Latitude and Longitude' do
    expect { system("ruby cli.rb #{input_file}") }.to output(/Output written to #{output_file}/).to_stdout
    # You can add more expectations based on your specific requirements
  end

  # Add more test cases as needed

  context 'when the input file does not exist' do
    let(:input_file) { 'nonexistent_file.csv' }

    it 'outputs an error message' do
      expect { system("ruby cli.rb #{input_file}") }.to output(/Error: File #{input_file} not found/).to_stdout
    end
  end
end
