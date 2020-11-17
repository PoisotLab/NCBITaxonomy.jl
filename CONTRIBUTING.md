# Thank you for wanting to contribute!

## Coding conventions

- function/methods names are lowercase
  - internal methods *always* start with an underscore, and *can* use underscores in their name (`_my_internal`)
  - exported methods conform to the Julia convention of having no underscores (`exported`)
  - internal methods are meant to be manipulated by people who *write* code, so it is better to give them long but descriptive names (`_count_species_in_patch`)
  - methods that modify their argument end with a `!` and return `nothing`
 - functions that fit in a single instruction should be written in a single line (`double(x::T) where {T <: Number} = 2x`)
 - module and struct names are camel case (`MyType`)
 - the type of arguments should be annotated as much as possible - this helps ensuring that only appropriate arguments are passed
 - the `return` statement of functions that return something must always be explicit
 - fail early, fail explicitely, fail often (but in a lot of cases, having `nothing` to return is *not* a failure)
 
 ## About branches
 
 - no one can push to `master`
 - that's it
 
 ## Documentation
 
 - methods must be documented
 - use-cases and examples in the documentation are often more important than function docstrings
 - comments in the code are good (but self-explanatory code is better)
 
 ## Testing

- functions should be tested
- tests that use more than one function are good, as they can identify issues in integration
