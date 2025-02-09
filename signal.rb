STORE = []

def createSignal(defaultValue)
  value = defaultValue.is_a?(Proc) ? defaultValue.call() : defaultValue
  subs = []
  
  get = ->() {
    sub = STORE.last
    subs << sub if sub && !subs.include?(sub)
    value
  }
  
  set = ->(val) {
    value = val.is_a?(Proc) ? val.call(value) : val
    subs.each { |s| s.call() }
  }
  
  [get, set]
end

def createEffect(fn)
  exec = ->() {
    STORE.push(exec)
    begin
      fn.call()
    ensure
      STORE.pop()
    end
  }
  exec.call()
end

count, set_count = createSignal(0)

createEffect(->() {
  puts("The count is #{count.call()}")
})

set_count.call(count.call + 1)
set_count.call(count.call + 1)
set_count.call(count.call + 1)
set_count.call(count.call + 1)
set_count.call(count.call + 1)
