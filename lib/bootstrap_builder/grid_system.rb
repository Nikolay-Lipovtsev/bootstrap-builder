module BootstrapBuilder
  
  # = Bootstrap Builder Grid System
  #
  # Provides a number of methods for creating a simple Bootstrap blocks
  #
  module GridSystem
    
    include ActionView::Helpers::TagHelper
    
    BASE_OPTIONS = [:class, :id]
    
    class Row
      
      delegate :content_tag, to: :@template
      
      def initialize(template, options = {})
        @template     = template
        @options      = options.slice(*BASE_OPTIONS)
        @row_disabled = options[:row_disabled]
      end
      
      def render(&block)
        raise ArgumentError, "Missing block" unless block_given?
        
        if @row_disabled
          yield
        else
          classes = @options[:class]
          @options[:class] = "row"
          @options[:class] = "#{@options[:class]} #{classes}" unless classes.blank?
          content_tag(:div, @options) { yield }
        end
      end
    end
    
    class Column
      
      delegate :content_tag, to: :@template
      
      def initialize(template, options = {})
        @template     = template
        @options      = options.slice(*BASE_OPTIONS)
        @grid_system  = options[:grid_system] || "md"
        @col          = options[:col] || 12
        @offset_col   = options[:offset_col]
        @col_disabled = options[:col_disabled]
      end
      
      def render(&block)
        raise ArgumentError, "Missing block" unless block_given?
        
        if @col_disabled
          yield
        else
          classes = @options[:class]
          @options[:class] = "col-#{@grid_system}-#{@col}"
          @options[:class] = "#{@options[:class]} col-#{@grid_system}-offset-#{@offset_col}" if @offset_col
          @options[:class] = "#{@options[:class]} #{classes}" unless classes.blank?
          content_tag(:div, @options) { yield }
        end
      end
    end
    
    # == Bootstrap row
    #
    # Creates a HTML div block with Bootstrap row class.
    #
    # === Options
    # You can use symbols or string for the attribute names.
    #
    # <tt>:row_disabled</tt> if set to true, the content will build without Bootstrap row div block, it will return
    # empty content.
    #
    # === Examples
    #   bootstrap_row { "Test" }
    #   # => <div class="row">Test</div>
    #
    #   bootstrap_row(class: "foo") { "Test" }
    #   # => <div class="row foo">Test</div>
    #
    #   bootstrap_row(row_disabled: true) { "Test" }
    #   # => Test
    #
    def bootstrap_row(options = {}, &block)
      options.symbolize_keys!
      Row.new(self, options).render(&block)
    end
    
    # == Bootstrap column
    #
    # Creates a HTML div block with Bootstrap grid column class.
    #
    # === Options
    # You can use symbols or string for the attribute names.
    #
    # <tt>:grid_system</tt> if the set value from Bootstrap grid system you can chenge default value "sm" to "xs",
    # "sm", "md" or "lg". You can use string and symbols for the values
    # 
    # <tt>:offset_col</tt> if the set value in the range from 1 to 12 it generate Bootstrap offset class in HTML div
    # block with Bootstrap grid column.
    #
    # === Examples
    #   bootstrap_col(col: 6) { "Test" }
    #   # => <div class="col-sm-6">Test</div>
    #
    #   bootstrap_col(col: 6, offset_col: 4) { "Test" }
    #   # => <div class="col-sm-6 col-sm-offset-4">Test</div>
    #
    #   bootstrap_col(col: 6, class: "foo") { "Test" }
    #   # => <div class="col-sm-6 foo">Test</div>
    #
    #   bootstrap_col(col: 6, grid_system: :lg) { "Test" }
    #   # => <div class="col-lg-6">Test</div>
    #
    #   bootstrap_col(col_disabled: true) { "Test" }
    #   # => Test
    #
    def bootstrap_col(options = {}, &block)
      options.symbolize_keys!
      Column.new(self, options).render(&block)
    end
  
    # == Bootstrap row with column
    #
    # Creates a HTML div block with Bootstrap row class and HTML div block with Bootstrap grid column class inside.
    #
    # === Options
    # You can use symbols or string for the attribute names.
    #
    # <tt>:row_disabled</tt> if set to true, it will create only HTML div block with Bootstrap grid column class
    # and without HTML div block with Bootstrap row class.
    #
    # === Examples
    #   bootstrap_row_with_col(col: 6) { "Test" }
    #   # => <div class="row">
    #          <div class="col-sm-6">
    #            Test
    #          </div>
    #        </div>
    #
    #   bootstrap_row_with_col(col: 6, offset_col: 4) { "Test" }
    #   # => <div class="row">
    #          <div class="col-sm-6 col-sm-offset-4">
    #            Test
    #          </div>
    #        </div>
    #
    #   bootstrap_row_with_col(col: 6, class: "foo") { "Test" }
    #   # => <div class="row foo">
    #          <div class="col-sm-6">
    #            Test
    #          </div>
    #        </div>
    #
    #   bootstrap_row_with_col(col: 6, grid_system: :lg) { "Test" }
    #   # => <div class="row">
    #          <div class="col-lg-6">
    #            Test
    #          </div>
    #        </div>
    #
    #   bootstrap_row_with_col(row_disabled: true) { "Test" }
    #   # => <div class="col-lg-6">
    #          Test
    #        </div>
    #
    #   bootstrap_row_with_col(col_disabled: true) { "Test" }
    #   # => <div class="row">
    #          Test
    #        </div>
    #
    def bootstrap_row_with_col(options = {}, &block)
      options.symbolize_keys!
      Row.new(self, options).render { Column.new(self, options).render(&block) }
    end
  end
end