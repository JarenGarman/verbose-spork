# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Election do
  subject(:election) { described_class.new('2024') }

  let(:first_candidate) { instance_double(Candidate, name: 'Diana D', votes: 3) }
  let(:second_candidate) { instance_double(Candidate, name: 'Roberto R', votes: 2) }
  let(:third_candidate) { instance_double(Candidate, name: 'Joe S', votes: 4) }
  let(:first_race) { instance_double(Race, candidates: [first_candidate, second_candidate], open?: false) }
  let(:second_race) { instance_double(Race, candidates: [third_candidate], open?: false) }

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }

    it 'has a year' do
      expect(election.year).to eq('2024')
    end

    it 'has no races' do
      expect(election.races).to eq([])
    end

    it 'has no candidates' do
      expect(election.candidates).to eq([])
    end
  end

  describe '#add_race' do
    it 'can add races' do
      election.add_race first_race
      election.add_race second_race

      expect(election.races).to eq([first_race, second_race])
    end
  end

  describe '#candidates' do
    it 'can get all candidates' do
      election.add_race first_race
      election.add_race second_race

      expect(election.candidates).to eq([first_candidate, second_candidate, third_candidate])
    end
  end

  describe '#vote_counts' do
    it 'can get vote counts' do
      election.add_race first_race
      election.add_race second_race

      expect(election.vote_counts).to eq({ 'Diana D' => 3, 'Roberto R' => 2, 'Joe S' => 4 })
    end
  end

  describe '#winners' do
    subject(:winners) { election.winners }

    context 'when no races are tied' do
      it 'gets all winners' do
        election.add_race first_race
        election.add_race second_race

        expect(winners).to eq([first_candidate, third_candidate])
      end
    end

    context 'when races are tied' do
      it 'gets only winning candidates' do
        allow(second_candidate).to receive(:votes).and_return(3)

        expect(winners).to eq([third_candidate])
      end
    end
  end
end
