class Module

  # Fancy version does not restricts to only modules.
  def fancy_include(*modules)
    modules.reverse_each do |mod|
      mod.send :fancy_append_features, self
      mod.send :included, self
    end
  end

  # Fancy version does not restricts to only modules.
  ###
  #
  # Called when this Module is being included in another Module.
  # This may be overridden for custom behaviour. The default
  # is to add constants, instance methods and module variables
  # of this Module and all Modules that this one includes to +klass+.
  #
  # See also #include.
  #
  def fancy_append_features(klass)
    # check other.frozen
    # taint other from self

    insert_at = klass
    mod = self
    changed = false

    while mod

      # Check for a cyclic include
      if mod == klass
        raise ArgumentError, "cyclic include detected"
      end

      # Try and detect check_mod in klass's heirarchy, and where.
      #
      # I (emp) tried to use Module#< here, but we need to also know
      # where in the heirarchy the module is to change the insertion point.
      # Since Module#< doesn't report that, we're going to just search directly.
      #
      superclass_seen = false
      add = true

      k = klass.direct_superclass
      while k
        if k.kind_of? Rubinius::IncludedModule
          # Oh, we found it.
          if k == mod
            # ok, if we're still within the directly included modules
            # of klass, then put future things after mod, not at the
            # beginning.
            insert_at = k unless superclass_seen
            add = false
            break
          end
        else
          superclass_seen = true
        end

        k = k.direct_superclass
      end

      if add
        if mod.kind_of? Rubinius::IncludedModule
          original_mod = mod.module
        else
          original_mod = mod
        end

        im = Rubinius::IncludedModule.new(original_mod).attach_to insert_at
        insert_at = im

        changed = true
      end

      mod = mod.direct_superclass
    end

    if changed
      method_table.each do |meth, obj, vis|
        Rubinius::VM.reset_method_cache meth
      end
    end

    return self
  end
end