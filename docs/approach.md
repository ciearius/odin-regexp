# ~~Efficient~~ RegExp (it's a VM)

## VM approach

This is the solution I went with.

## NFA approach

First, we tokenize, parse, and compile the query into a non-deterministic finite automaton (NFA). Then, we have two options: we can convert the NFA into an equivalent DFA, improving runtime performance but slowing down regexp compilation time, or we can use the NFA as a matcher. 

The paper I linked above suggests a solution in between: we use the NFA but cache results if we visit a state that we've already cached before.

## RegExp to NFA conversion

### Match single char

#### Raw
```regexp
e
```

#### Automaton
```mermaid
stateDiagram-v2
    direction LR
    
    state "Match" as m1 {
        direction LR

        [*] --> [*] : 'e'
    }

    [*] --> m1
    m1 --> [*]
```

### Concatenation (appending fragments)

#### Raw
```regexp
ee
```

#### Automaton
```mermaid
stateDiagram-v2
    direction LR
    
    state "Concatenation" as c {
        direction LR

        state "Match" as m1 {
            direction LR

            [*] --> [*] : 'e'
        }

        state "Match" as m2 {
            direction LR

            [*] --> [*] : 'e'
        }

        [*] --> m1
        m1 --> m2
        m2 --> [*]
    }

    [*] --> c
    c --> [*]
```

### Alternation `|`

#### Raw
```regexp
a|b
```

#### Automaton
```mermaid
stateDiagram-v2
    direction LR
    
    state "Alternation" as c {
        direction LR

        state "Match a" as m1 {
            direction LR

            [*] --> [*] : 'a'
        }

        state "Match b" as m2 {
            direction LR

            [*] --> [*] : 'b'
        }

        state s <<choice>>

        [*] --> s

        s --> m1
        s --> m2

        m1 --> [*]
        m2 --> [*]
    }

    [*] --> c
    c --> [*]
```


### Optional `?`

#### Raw
```regexp
a?
```

#### Automaton
```mermaid
stateDiagram-v2
    direction LR
    
    state "Optional" as c {
        direction LR

        state "Match" as m1 {
            direction LR

            [*] --> [*] : 'a'
        }

        state s <<choice>>

        [*] --> s

        s --> m1
        s -->[*]

        m1 --> [*]
    }

    [*] --> c
    c --> [*]
```

### Howevermany with `*`

#### Raw
```regexp
a*
```

#### Automaton
```mermaid
stateDiagram-v2
    direction LR
    
    state "Howevermany" as c {
        direction LR

        state "Match" as m1 {
            direction LR

            [*] --> [*] : 'a'
        }
        
        state s <<choice>>

        [*] --> s

        s --> [*]
        
        s --> m1
        m1 --> s
    }

    [*] --> c
    c --> [*]
```

### At least once `+`

#### Raw
```regexp
a+
```

#### Automaton
```mermaid
stateDiagram-v2
    direction LR
    
    state "At least once" as c {
        direction LR

        state "Match" as m1 {
            direction LR

            [*] --> [*] : 'a'
        }
        
        [*] --> s0

        s0 --> m1

        m1 --> s0
        m1 --> [*]
    }

    [*] --> c
    c --> [*]
```
