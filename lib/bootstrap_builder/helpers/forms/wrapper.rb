require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module Wrapper
        
        class WrapperTest
          attr_reader :children
          attr_reader :root
  
          def initialize(root, &blk)
            @root = root
            @block = blk
            @children = []

            # Магию гуглить по этому методу
            instance_eval(&blk)

            if not root.nil?
              root.children << self
            end
          end
  
          # Магию гуглить по поведению ключевого слова self
          def wrap(&blk)
            WrapperTest.new(self, &blk)
          end
  
          def compile
               tmp = [tmp, "-- Before --"].join if root.nil? 
      
              if children.empty?
                tmp = [tmp, @block.call].join
              else
                children.map(&:compile)
              end
      
              tmp = [tmp, "-- After --"].join  if root.nil?
          end
        end

        def wrap(&blk)
          WrapperTest.new(nil, &blk).compile
        end
        
        class WrapperBuilder # :nodoc:
          
          include BootstrapBuilder::GridSystem
          
          attr_reader :children
          attr_reader :root
          
          def initialize(root, template, label, content_or_options, options, label_is_tag, &block)
            @root         = root
            @template     = template
            @label        = label
            @label_is_tag = label_is_tag
            @block        = block
            @children     = []
            
            if block_given?
              @options  = content_or_options || {}
              @block    = block
              # instance_eval(&block)
            else
              @options  = options || {}
              @content  = content_or_options
            end
            
            label_block unless @label_is_tag
            root.children << self unless root.nil?
          end
          
          delegate :content_tag, :label_tag, to: :@template
          
          def form_group(label = nil, content_or_options = nil, options = {}, label_is_tag = false, &block)
            WrapperBuilder.new(self, nil, label, content_or_options, options, label_is_tag, &block).mapper
          end
          
          def label_block
            @options[:label_class] = ["control-label", @options[:label_class]].compact.join(" ")
            @label = label_tag(nil, @label, class: @options[:label_class])
          end
          
          def mapper
            if children.empty?
              content = @content ? @content : @block.call
              # content = bootstrap_row { content } if @options[:layout] != "horizontal"
              form_group_builder(content)
            else
              children.map(&:mapper)
            end
          end
          
          private
          
          def form_group_builder(content)
            grid_system_options                 = {}
            grid_system_options[:col]           = @options[:control_col]        if @options[:control_col]
            grid_system_options[:grid_system]   = @options[:grid_system]        if @options[:grid_system]
            grid_system_options[:offset_col]    = @options[:offset_control_col] if @options[:offset_control_col]
            grid_system_options[:row_disabled]  = @options[:row_disabled]       if @options[:row_disabled]
            
            if @options[:layout] == "horizontal" && !(@options[:form_group_col_disabled])
              grid_system_options[:offset_col]  ||= 2 unless @label
              grid_system_options[:col]         ||= 10
              content = bootstrap_col(grid_system_options) { content.html_safe }
            end
            
            content = [@label, content].compact.join.html_safe
            content = bootstrap_row_with_col(grid_system_options) { content } if [:col, :offset_col].any? { |k| grid_system_options.key?(k) }
            return content if @options[:form_group_disabled] || !root.nil?
            @options[:class] = ["form-group", @options[:form_group_class]].compact.join(" ")
            @options[:id]    = @options[:form_group_id] if @options[:form_group_id]
            content_tag(:div, content, @options.slice(:id, :class))
          end
        end
      end
      
      include BootstrapBuilder::GridSystem
      
      FORM_GROUP_OPTIONS = [:form_group_disabled, :label_disabled, :layout, :row_disabled]
      
      def form_group(label = nil, content_or_options = nil, options = {}, label_is_tag = false, &block)
        options = @options.slice(*FORM_GROUP_OPTIONS).merge(options)
        WrapperBuilder.new(nil, @template, label, content_or_options, options, label_is_tag, &block).mapper
      end
        
      #def form_group_wrapper(label, content = nil, options = {})
      #  options ||= {}
      #  grid_system_options                 = {}
      #  grid_system_options[:offset_col]    = options.delete(:offset_control_col)
      #  grid_system_options[:col]           = options.delete(:control_col)
      #  grid_system_options[:grid_system]   = options.delete(:grid_system)
      #  grid_system_options[:row_disabled]  = options.delete(:row_disabled)
      #  if options[:layout] == "horizontal" && !(options[:form_group_col_disabled])
      #    grid_system_options[:offset_col] ||= 2 unless label
      #    grid_system_options[:col] ||= 10
      #    content = bootstrap_col(grid_system_options) { content.html_safe }
      #  else
      #    form_group_with_any_grid_system_options = true if grid_system_options[:col] || grid_system_options[:offset_col]
      #  end
      #  content = [label, content].compact.join.html_safe
      #  content = bootstrap_row_with_col(grid_system_options) { content } if form_group_with_any_grid_system_options
      #  form_group_builder content, options
      #end
    end
  end
end