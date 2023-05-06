# Efficient RegExp

Heavily inspired by [this](https://swtch.com/~rsc/regexp/regexp1.html).

## How it works

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


## Approach 1: Convert NFA to DFA

### Description

with:
- $ Z $: set of all states 
- $ S $: set all starting states
- $ F $: set all accepting end states
- $ \Sigma $: set of all valid inputs
- $ \Delta \subseteq (Z \times \Sigma) \times Z $: transition relation

> All properties marked $'$ are those of the new DFA.

Now, let
- $ Z' = \mathcal{P}(Z) $, 
- $ S' = \Set{ S } $,
- $ \Delta' \subseteq (Z' \times \Sigma) \times Z' $
- and $ F' = \Set{ x | x \in Z' \land (\vert x \cap F \vert > 0) } $

### Note

The next step after conversion should be minimizing the automaton.


## Approach 3: VM-Based

### Opcodes
