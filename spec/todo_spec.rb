# frozen_string_literal: true

require 'tada'

include TADA

RSpec.describe TODO do
  let(:complex) do
    TODO.new(
      :doing, 'root',
      info: { 'note' => 'root node of todo lists' },
      sublist: [
        TODO.new(
          :done, 'authentication system',
          info: { 'note' => 'use JWT' },
          sublist: [
            TODO.new(:todo, 'something')
          ]
        ),
        TODO.new(
          :doing, 'middlewares',
          sublist: [
            TODO.new(:todo, 'permission check'),
            TODO.new(
              :doing, 'flash messages appender',
              sublist: [
                TODO.new(:todo, 'x'),
                TODO.new(:todo, 'y')
              ]
            ),
            TODO.new(
              :todo, 'advanced route',
              sublist: [
                TODO.new(:todo, 'u'),
                TODO.new(:todo, 'v')
              ]
            )
          ]
        )
      ]
    )
  end

  describe '#initialize' do
    it 'raises TypeError when given wrong types' do
      # wrong type parameters
      expect { TODO.new({}, '') }.to raise_error TypeError
      expect { TODO.new(1, {}) }.to raise_error TypeError
      expect { TODO.new(1, '', info: []) }.to raise_error TypeError
      expect { TODO.new(1, '', sublist: {}) }.to raise_error TypeError
      # correct type parameters
      expect { TODO.new(1, '') }.not_to raise_error
    end

    it 'accepts other forms of status as Status class accepts' do
      expect(TODO.new('-', 'title').status.to_i).to eql 0
      expect(TODO.new(0, 'title').status.to_i).to eql 0
      expect(TODO.new(:todo, 'title').status.to_i).to eql 0
      expect(TODO.new(Status.new(0), '').status.to_i).to eql 0
    end

    it "checks info's keys and values types" do
      expect do
        TODO.new(1, '', info: { x: 1 }).info
      end.to raise_error TypeError

      expect do
        TODO.new(1, '', info: { 'x' => 'y' }).info
      end.not_to raise_error
    end

    it "checks sublist's cells types" do
      expect do
        TODO.new(1, '', sublist: [1, 'str']).sublist
      end.to raise_error TypeError

      expect do
        TODO.new(1, '', sublist: [TODO.new(0, '')]).sublist
      end.not_to raise_error
    end
  end

  describe '#match?' do
    let(:todo) { TODO.new(:doing, 'my fancy title') }
    let(:info_todo) do
      TODO.new(
        :todo,
        'project 1',
        info: {
          'note 1' => 'description 1',
          'note 2' => 'description 2',
          'warning' => 'some warning'
        }
      )
    end

    it "checks given ref's type" do
      expect { todo.match?([]) }.to raise_error TypeError

      expect { todo.match?(1) }.not_to raise_error
      expect { todo.match?(1..2) }.not_to raise_error
      expect { todo.match?({}) }.not_to raise_error
      expect { todo.match?(Ref.new(1)) }.not_to raise_error
    end

    it 'matches by given numeric ref and index' do
      expect(todo.match?(1, 1)).to be true
      expect(todo.match?(1, 2)).to be false
      expect(todo.match?(-1, 1)).to be false
    end

    it 'matches by given range and index' do
      expect(todo.match?(0..42)).to be true
      expect(todo.match?(1..42)).to be false

      expect(todo.match?(0..2, 1)).to be true
      expect(todo.match?(0..2, -1)).to be false
      expect(todo.match?(0..2, 3)).to be false
    end

    it 'behaves recursively when given ref as TADA::Ref' do
      expect(todo.match?(Ref.new(0..12))).to be true
      expect(todo.match?(Ref.new(12))).to be false
    end

    it 'matches by given ref if all key/value pairs exist in info too' do
      expect(info_todo.match?({ 'note 1' => /1/ })).to be true
      expect(info_todo.match?({ 'warning' => /some/ })).to be true

      mismatch_regex = { 'note 1' => /1/, 'note 2' => /123/ }
      expect(info_todo.match?(mismatch_regex)).to be false

      mismatch_key = { 'note 1' => /1/, 'note 3' => /1/ }
      expect(info_todo.match?(mismatch_key)).to be false
    end

    it 'matches by title when given String or Regexp' do
      expect(todo.match?('fancy')).to be true
      expect(todo.match?(/^my/)).to be true

      expect(todo.match?('yohoo')).to be false
      expect(todo.match?(/fancy$/)).to be false
    end

    it 'matches by status when given Status or Symbol' do
      expect(todo.match?(:doing)).to be true
      expect(todo.match?(Status.new(:doing))).to be true

      expect(todo.match?(:todo)).to be false
      expect(todo.match?(:done)).to be false
      expect(todo.match?(Status.new(:todo))).to be false
      expect(todo.match?(Status.new(:done))).to be false
    end
  end

  describe 'crud and #move' do
    describe '#create' do
      it 'inserts given todo at all places given reference points' do
        test1 = TODO.new(:todo, 'test1')
        complex.create(Ref.new({ 'note' => // }), test1)

        expect(complex.sublist[0].sublist).to include test1
        expect(complex.sublist[1].sublist).not_to include test1

        test2 = TODO.new(:todo, 'test2')
        complex.create(Ref.new({ 'note' => /asdasd/ }), test2)

        expect(complex.sublist[0].sublist).not_to include test2
        expect(complex.sublist[1].sublist).not_to include test2

        expect(complex.create(Ref.new(3), test1)).to be complex
      end

      it 'inserts in its own sublist if given reference is empty' do
        test = TODO.new(:todo, 'test')
        complex.create(Ref.new, test)

        expect(complex.sublist).to include test
        expect(complex.sublist[0].sublist).not_to include test
      end
    end

    describe '#retrieve' do
      it 'selects and returns referenced todos by given reference' do
        ret = complex.retrieve(
          Ref.new(1..2, '', Status.new(:todo), Status.new(:todo))
        )

        ret.each do |todo|
          expect(todo.status).to eql Status.new(:todo)
          expect(%w[x y u v]).to include todo.title
        end
      end

      it 'returns itself when empty reference' do
        todo = TODO.new(:todo, 'test')
        expect(todo.retrieve(Ref.new)).to be todo
      end
    end

    describe '#update' do
      it 'replaces todos at given reference by given todo' do
        test = TODO.new(:doing, 'lol')

        complex.create(Ref.new(//, //), test)
        created_lols = complex.retrieve(Ref.new(//, //, /^lol$/))

        test.status = Status.new(:done)
        complex.update(Ref.new(//, //, /^lol$/), test)
        updated_lols = complex.retrieve(Ref.new(//, //, /^lol$/))

        expect(updated_lols.size).to eql created_lols.size
      end
    end

    describe '#delete' do
      it 'removes todos pointed by given reference from hierarchy' do
        ref = Ref.new(//, //, Status.new(:todo))
        a_todo = TODO.new(:doing, 'a')

        complex.create(Ref.new(//, //), a_todo)
        complex.delete(ref)

        expect(complex.retrieve(ref)).to be_empty

        doings = complex.retrieve([//, //, Status.new(:doing)])
        expect(doings).to include a_todo
      end

      it 'returns nil when given reference is empty deletes itself' do
        expect(complex.delete(Ref.new)).to be nil
      end
    end

    describe '#move' do
      it 'is same as delete and create' do
        src_ref = [0, 0]

        src_todo = complex.retrieve(src_ref)[0]
        dst_ref = [1, src_todo.title]

        complex.move(src_ref, [1])
        dst_todo = complex.retrieve(dst_ref)[0]

        expect(complex.retrieve(src_ref)).to be_empty
        expect(src_todo).not_to be nil
        expect(dst_todo).not_to be nil
        expect(src_todo == dst_todo).to be true
      end
    end
  end

  describe '#at' do
    it 'returns one retrieve per given argument' do
      expect(complex.at([//], [//, ''], 1).size).to be 3
    end
  end

  describe '#set' do
    it 'sets given todo at given reference' do
      todo = TODO.new(:todo, 'test')
      complex.set(//, todo)
      ret = complex.retrieve('test')

      expect(ret.all? { |t| t == todo }).to be true
    end
  end

  describe '#[]' do
    it 'is same as retrieve' do
      expect(complex[//] == complex.retrieve(//)).to be true
    end
  end

  describe '#[]=' do
    it 'creates given todo at' do
      todo = TODO.new(:doing, 'unique title')
      complex[//] = todo
      expect(complex.retrieve([//])).to include todo
    end
  end

  it '#==' do
    a = TODO.new(:todo, 'something', info: { 'x' => 'y' })
    b = TODO.new(:todo, 'something', info: { 'x' => 'y' })
    c = TODO.new(:todo, 'something', info: { 'x' => 'y', 'u' => 'v' })

    u = TODO.new(
      :todo, 'something',
      info: { 'x' => 'y', 'u' => 'v' },
      sublist: [a, b]
    )
    v = TODO.new(
      :todo, 'something',
      info: { 'x' => 'y', 'u' => 'v' },
      sublist: [a, b, c]
    )

    x = TODO.new(:todo, 'root', sublist: [u, u])
    y = TODO.new(:todo, 'root', sublist: [u, u])
    z = TODO.new(:todo, 'root', sublist: [u, v])

    expect(a == b).to be true
    expect(a == c).to be false

    expect(u == v).to be false

    expect(x == y).to be true
    expect(y == z).to be false
  end
end
