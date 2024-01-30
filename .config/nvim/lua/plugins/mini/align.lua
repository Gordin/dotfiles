local align = require('mini.align')

function align_objects(key)
  return function(steps, opts)
      opts.split_pattern = ':'
      table.insert(steps.pre_justify, align.gen_step.trim())
      table.insert(steps.pre_justify, align.gen_step.pair())
      opts.merge_delimiter = ' '
    end
end

align.setup({
  mappings = {
    start_with_preview = '<leader>=',
  },

  modifiers = {
    -- Special configurations for common splits
    -- ['='] = --<function: enhanced setup for '='>,
    -- [','] = --<function: enhanced setup for ','>,
    -- [' '] = --<function: enhanced setup for ' '>,
    [':'] = align_objects(':'),
  },
})
