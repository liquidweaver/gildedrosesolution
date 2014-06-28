require_relative 'gilded_rose'

describe 'GildedRose' do
	subject { GildedRose.new }

	it { should respond_to(:update_quality) }
  it { should respond_to(:items) }

  context "update_quality was called" do
      let( :vanilla_item ) { subject.items[0] }
      let( :aged_brie ) { subject.items[1] }
      let( :sulfuras ) { subject.items[3] }
      let( :backstage_passes ) { subject.items[4] }
      let( :conjured ) { subject.items[5] }

      context "base item behavior" do

        it "should decrease sell_in by 1" do
          expect {
            subject.update_quality
          }.to change{ vanilla_item.sell_in }.by(-1)
        end

        it "should decrease quality by 1" do
          expect {
            subject.update_quality
          }.to change{ vanilla_item.quality }.by(-1)
        end

        it "should always have a non-negative quality" do
          expect {
            (vanilla_item.sell_in * 10).times {subject.update_quality}
          }.to change{ vanilla_item.quality }.to(0)
        end

        context "when sell_in expires" do
          before(:each) { 10.times{ subject.update_quality } }

          it "should have a sell_in < 1" do
            expect(vanilla_item.sell_in).to be < 1
          end

          it "should decrease quality by 2 after when sell_in < 1" do
            expect {
              subject.update_quality
            }.to change{ vanilla_item.quality }.by(-2)
          end

        end

      end # context base item

      context "Aged Brie" do
        let!( :initial_quality ) { aged_brie.quality }

        [1,10,100,1000].each do |age|
          context "when age increases by #{age}" do
            let!( :initial_quality ) { aged_brie.quality }
            before(:each) { age.times{ subject.update_quality } }

            it "should increase in quality" do
              expect( aged_brie.quality).to be > initial_quality
            end

            it "should not increase in quality over 50" do
              expect( aged_brie.quality).to be <= 50
            end

          end
        end

      end # context agied brie

      context "Sulfuras" do
        it "should never age (because it is legendary, of course)" do
          [1,10,100].each do |age|
            expect { subject.update_quality }.to_not change{ sulfuras.sell_in }
          end
        end
      end

      context "Backstage passes" do
        context "sell_in > 10" do
          it "should have a sell_in > 10" do
              expect( backstage_passes.sell_in ).to be > 10
          end

          it "should increase quality by 1 on update_quality" do
            expect{ subject.update_quality }.to change{backstage_passes.quality}.by(1)
          end
        end
        context "sell_in <= 10" do
          before(:each) { 5.times{ subject.update_quality } }
          it "should have a sell_in <= 10" do
              expect( backstage_passes.sell_in ).to be <= 10
          end

          it "should increase quality by 2 on update_quality" do
            expect{ subject.update_quality }.to change{backstage_passes.quality}.by(2)
          end
        end
        context "sell_in <= 5" do
          before(:each) { 10.times{ subject.update_quality } }
          it "should have a sell_in <= 5" do
              expect( backstage_passes.sell_in ).to be <= 5
          end

          it "should increase quality by 3 on update_quality" do
            expect{ subject.update_quality }.to change{backstage_passes.quality}.by(3)
          end
        end
        context "sell_in == 0" do
          before(:each) { 15.times{ subject.update_quality } }
          it "should have a sell_in == 0" do
              expect( backstage_passes.sell_in ).to eq(0)
          end

          it "should have a quality of 0" do
            expect{ subject.update_quality }.to change{backstage_passes.quality}.to(0)
          end
        end
      end

      context "Conjured" do
        it "should reduce quality by 2 on update_quality" do
          pending "Conjured items decrease by 2 on update_quality feature"
          expect{ subject.update_quality }.to change{conjured.quality}.by(-2)
        end

      end
  end

end

describe 'Item' do
  subject { Item.new :foo, :bar, :baz }

  it { should respond_to(:name) }
  it { should respond_to(:sell_in) }
  it { should respond_to(:quality) }

end
