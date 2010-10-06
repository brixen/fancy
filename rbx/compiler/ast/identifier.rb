module Fancy
  module AST

    class Identifier < Node
      name :ident

      attr_reader :identifier

      def initialize(line, identifier)
        super(line)
        @identifier = identifier
      end

      def constant?
        @identifier =~ /^[A-Z]/
      end

      def instance_variable?
        @identifier =~ /^@/
      end

      def class_variable?
        @identifier =~ /^@@/
      end

      def local_variable?
        !(constant? || instance_variable?)
      end

      def nested_classname?
        constant? && @identifier.include?("::")
      end

      def name
        if constant?
          @identifier.to_sym
        elsif instance_variable?
          @identifier[1..-1].to_sym
        else
          rubyfy(@identifier).to_sym
        end
      end

      def rubyfy(ident)
        if ident.split(":").size > 1
          ident
        else
          if ident =~ /:$/
            ident[0..-2]
          else
            ident[0..-1]
          end
        end
      end

      def bytecode(g)
        if nested_classname?
          classnames = @identifier.split("::")
          parent = Identifier.new(@line, classnames.shift)
          classnames.each do |cn|
            Rubinius::AST::ScopedConstant.new(@line, parent, cn.to_sym).bytecode(g)
            child = Identifier.new(@line, cn)
            parent = child
          end
        elsif constant?
          Rubinius::AST::ConstantAccess.new(line, name).bytecode(g)
        elsif class_variable?
          Rubinius::AST::ClassVariableAccess.new(line, name).bytecode(g)
        elsif instance_variable?
          Rubinius::AST::InstanceVariableAccess.new(line, name).bytecode(g)
        else
          Rubinius::AST::LocalVariableAccess.new(line, name).bytecode(g)
        end
      end

    end

  end
end
