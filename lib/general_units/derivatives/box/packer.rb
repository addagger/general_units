module GeneralUnits
  class Box
    
    class Packer
      attr_reader :boxes, :gaps, :coupled, :gaps_used, :rotated
      
      def initialize(*boxes)
        @boxes = boxes.sort_by(&:max_face).reverse
        @coupled = @boxes.first # first box - biggest
        @gaps = []
        @gaps_used = [] # for test
        @rotated = 0 # if height > current length
        pack!
      end
      
      def to_s
        inspect
      end
      
      def inspect
        "<#{self.class.name} boxes=#{boxes.size} gaps=#{gaps.size} used=#{gaps_used.size} coupled=#{coupled}>"
      end
      
      private
      
      def pack!
        boxes[1..-1].each do |box|
          unless use_gap_for(box)
            @coupled = coupled.concat_with(box) {|r| @gaps << r}
            # if coupled.height > coupled.length
            #   @rotated += 1
            # end
          end
        end
        coupled
      end
      
      def use_gap_for(box)
        gap = @gaps.find_all {|g| g.includes?(box)}.min_by {|g| g.volume - box.volume}
        if gap && gap.estimated_spaces_with(box) {|r| @gaps << r}
          @gaps.delete_if {|r| r.object_id == gap.object_id}
          @gaps_used << box
          true
        else
          false
        end
      end
      
    end

  end
end