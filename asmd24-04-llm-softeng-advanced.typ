#import "@preview/touying:0.7.3": *
#import "themes/theme.typ": *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "utils.typ": *

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let pdfpc-config = pdfpc.config(
    duration-minutes: 30,
    start-time: datetime(hour: 14, minute: 10, second: 0),
    end-time: datetime(hour: 14, minute: 40, second: 0),
    last-minutes: 5,
    note-font-size: 12,
    disable-markdown: false,
    default-transition: (
      type: "push",
      duration-seconds: 2,
      angle: ltr,
      alignment: "vertical",
      direction: "inward",
    ),
  )

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: theme.with(
  aspect-ratio: "4-3",
  footer: self => self.info.author + ", " + self.info.institution + " - " + self.info.date,
  config-common(
    // handout: true,
    preamble: pdfpc-config, 
  ),
  config-info(
    title: [AI-Assisted Software Engineering],
    //subtitle: [Vibe Coding, AI-Assisted Development, and Levels of Autonomy],
    author: [Gianluca Aguzzi],
    date: datetime.today().display("[day] [month repr:long] [year]"),
    institution: [Università di Bologna],
    // logo: emoji.school,
  ),
)

#set text(font: "Source Sans Pro", weight: "regular", size: 20pt)
#show math.equation: set text(font: "Fira Math")
#show strong: set text(weight: "bold", fill: rgb("#005587"))
#show emph: set text(style: "italic", fill: rgb("#00a3e0"))
#set underline(stroke: 1.5pt + rgb("#005587"), offset: 2pt)
#show quote.where(block: true): it => block(
  fill: rgb("#f4f8fa"),
  inset: 1em,
  radius: 0.2em,
  stroke: (left: 4pt + rgb("#005587")),
  text(style: "italic", it)
)

#title-slide()

== Today's Lesson: LLMs in Software Engineering

*Learning Objectives:*
- #underline[Explore] how LLMs apply across the *Software Development Lifecycle*
  - AI as pair programmer, validator, and beyond
- #underline[Understand] the distinction between _Vibe Coding_ and _AI-Assisted Programming_
  - Two paradigms on the same spectrum, with fundamentally different philosophies
- #underline[Analyze] the levels of autonomy in AI-powered coding tools
  - From inline completion to fully autonomous agents
- #underline[Apply] guidelines for effectively using LLMs in an AI-assisted scenario
  - Prompt engineering, context engineering, iterative workflows, and testing

*Key Topics We'll Cover:*
- AI × Software Engineering: how LLMs augment the development process
- The _AI Coding Spectrum_: from vibe coding to engineering-grade AI assistance
- AI-assisted tool categories, Copilot case study, and levels of autonomy
- The _70% Problem_ and how to manage AI-generated code
- Practical guidelines and the evolving role of the developer

#v(0.5em)
#underline[*Note:*] This field is evolving rapidly—_concepts matter more than specific implementations_ #fa-lightbulb()

== AI x Soft. Eng. vs. Soft. Eng. x AI

#v(0.5em)
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  // Row 1: Titles
  [#align(center)[#underline[*AI × Software Engineering*]]],
  [#align(center)[#underline[*Software Engineering × AI*]]],
  
  // Row 2: Subtitles
  [#v(0em) _Using AI to improve the *development process*_],
  [#v(0em) _Using SE to build and manage *AI products*_],

  // Row 3: Content
  [
    - *Focus:* Enhancing developer productivity and output quality
    - *How:* Autocompletion, code generation, test generation, refactoring, bug detection
    - *Examples:* GitHub Copilot, AI test generators, code-review assistants
    - *Metrics:* Time-to-delivery, defect density, test coverage
    #v(0.3em)
    #text(size: 16pt, style: "italic")[Optimizes the #underline["how"] — the development process itself.]
  ],
  [
    - *Focus:* Infrastructure, pipelines, and governance for models and agents
    - *How:* RAG pipelines, model serving, observability, agentic orchestration
    - *Examples:* Chatbots, NotebookLMs, new autonomous coding agents-
    - *Metrics:* Latency, availability, compliance, operational cost
    #v(0.3em)
    #text(size: 16pt, style: "italic")[Defines the #underline["what"] — the AI product itself.]
  ]
)

#v(0.5em)
#align(center)[
  _This lecture focuses on *AI × SE*: how LLMs can augment the developer across the entire SDLC._
]

= Vibe Coding vs. AI-Assisted Programming

#focus-slide()[
  #text(size: 28pt, weight: "bold")[
    #underline[Vibe Coding]
  ]
  #v(1em)
  #text(size: 20pt)[
    A prompt-first, exploratory approach where the developer _describes intent_ in natural language and lets the AI fill in the implementation.
  ]
  #v(0.5em)
  #text(size: 16pt)[
    — Addy Osmani, _Beyond Vibe Coding_ (2025)
  ]
]

== The AI Coding Spectrum

The way developers use AI exists on a *spectrum* of control and rigor:

#v(0.5em)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  // Row 1: Titles
  [#align(center)[#underline[*Autocomplete*]]],
  [#align(center)[#underline[*Vibe Coding*]]],
  [#align(center)[#underline[*AI-Assisted Engineering*]]],

  // Row 2: Subtitles
  [#align(center)[#v(0.5em) _Passive Assistance_]],
  [#align(center)[#v(0.5em) _Prompt-First Prototyping_]],
  [#align(center)[#v(0.5em) _Human-Guided, AI-Augmented_]],

  // Row 3: Bullet points
  [
    #v(0.3em)
    - Inline suggestions
    - Single-line or block completion
    - Developer retains #underline[full control]
  ],
  [
    #v(0.3em)
    - "Just make it work"
    - Natural language to working app
    - Minimal code inspection
  ],
  [
    #v(0.3em)
    - High-quality, production code
    - Systematic review and testing
    - Engineering standards enforced
  ],
)


== Defining the Terms

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  // Row 1: Titles
  [#align(center)[#underline[*Vibe Coding*]]],
  [#align(center)[#underline[*AI-Assisted Programming*]]],
  
  // Row 2: Subtitles/Descriptions
  [
    #v(0.5em)
    Development guided #underline[solely by natural language], without reading or deeply analyzing the generated code.
  ],
  [
    #v(0.5em)
    AI acts as a *collaborator under human guidance*, augmenting—not replacing—engineering skills.
  ],
  
  // Row 3: Bullet points
  [
    - #underline[Chat-based iterations]: describe $arrow.r$ generate $arrow.r$ run $arrow.r$ re-describe
    - The code is a *"black box"*—you evaluate if it "works," not _how_
    - Rapid validation of ideas, MVPs, glue code
    - Typically *solo*; the developer is a _prompt artist_
    - *Risk*: _technical debt_ and _fragile codebases_
  ],
  [
    - AI creativity is bounded by _specifications and constraints_
    - Developer #underline[reviews], #underline[refines], and #underline[owns] every line
    - Systematic and iterative: TDD, context engineering, prompt discipline
    - *Team*-based: developer acts as *architect and technical lead*
    - *Risk*: overhead of review and process discipline
  ]
)

== AI Use Cases: Bootstrappers vs. Iterators

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Bootstrappers*]]
    #v(0.5em)
    _Taking a new project from zero to MVP._
    - Tools: Bolt, Lovable, "screenshot-to-code AI"
    - Start with a design or rough concept
    - AI generates a complete initial codebase
    - Working prototype in _hours_, not weeks
    - Focus on rapid validation and iteration
    
    #v(0.3em)
    #text(size: 16pt, style: "italic")[Not production-ready, but good enough for early user feedback.]
  ],
  [
    #align(center)[#underline[*Iterators*]]
    #v(0.5em)
    _Using AI in daily development workflow._
    - Tools: Cursor, Copilot, Windsurf, Cline
    - AI for code completion and suggestions
    - Complex refactoring and migrations
    - Test and documentation generation
    - AI as a _"pair programmer"_ for problem-solving
    
    #v(0.3em)
    #text(size: 16pt, style: "italic")[Less flashy, but potentially more transformative for daily output.]
  ]
)

== AI as Pair Programmer vs. AI as Validator

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*AI as Pair Programmer*]]
    #v(0.5em)
    - Developer and AI in *constant conversation*
    - Tight feedback loops, frequent review
    - AI handles repetitive tasks (boilerplate, test cases)
    - Developer maintains oversight for quality and relevance
    - Accelerates development _and_ facilitates knowledge acquisition
    
    #v(0.3em)
    #text(size: 16pt, style: "italic")[Particularly beneficial for solo developers or limited team resources.]
  ],
  [
    #align(center)[#underline[*AI as Validator*]]
    #v(0.5em)
    - AI analyzes code for *bugs, vulnerabilities, and best practices*
    - Tools: DeepCode, Snyk, Qodo
    - Identifies missing input sanitization, insecure configurations
    - Automatically generates test cases for broader coverage
    - Monitors application performance, detects anomalies
    
    #v(0.3em)
    #text(size: 16pt, style: "italic")[Complements human oversight; handles repetitive QA tasks.]
  ]
)

== How to Choose the Right Paradigm

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Vibe Coding Works Well For*]]
    #v(0.5em)
    - Rapid #underline[prototyping] and idea validation
    - One-off scripts and _glue code_
    - _Modern framework scaffolding_ (Next.js, FastAPI, etc.)
    - Repetitive code generation (CRUD, boilerplate)
    - Personal side projects and _MVPs_
    - Learning a new framework quickly
  ],
  [
    #align(center)[#underline[*AI-Assisted Programming Needed When*]]
    #v(0.5em)
    - *Failure cost is high* (financial, safety, reputation)
    - Technical debt would be #underline[unacceptable]
    - Code must integrate with _complex existing systems_
    - _Security_ and _compliance_ are mandatory
    - Long-term _maintainability_ is required
    - The team needs _shared understanding_ of the codebase
  ]
)

#v(0.5em)
#underline[*Where AI Struggles (Both Paradigms):*]
#v(0.3em)
#grid(
  columns: (1.2fr, 1.1fr, 1fr),
  gutter: 0.5em,
  [#align(center)[_Complex system design_ \ (e.g., distributed algorithms)]],
  [#align(center)[_Low-level optimization_ \ (e.g., CPU cache, real-time)]],
  [#align(center)[_Novel/niche frameworks_ \ and creative UX/UI]],
)

== The Knowledge Paradox

#quote(block: true)[
  "AI tools often benefit experienced developers more than beginners, because seniors have the judgment necessary to guide the AI and catch its mistakes." — Osmani, _Beyond Vibe Coding_
]

#v(0.5em)
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    #align(center)[#underline[*Senior Engineers*]]
    #v(0.5em)
    - Use AI to #underline[accelerate] what they already know
    - Can validate and _debug_ AI output effectively
    - Guide the AI with precise #underline[constraints]
    - Think of AI as a _"very eager junior developer"_
  ],
  [
    #align(center)[#underline[*Junior Developers*]]
    #v(0.5em)
    - Risk accepting _"polished-looking" but flawed_ code
    - Struggle to debug code they didn't write
    - May create _fragile systems_ they don't fully understand
    - Temptation to skip learning fundamentals
  ]
)

#v(0.5em)
#align(center)[
  *Takeaway:* _The more you know, the better you can guide AI._ The tools amplify existing skill—they don't replace it.
]

== The Intent-Driven Workflow

Programming is evolving from *imperative* ("How do I do X?") to *declarative/intent-driven* ("I need X done"):

#v(0.5em)

#grid(
  columns: (1fr, auto, 1fr),
  gutter: 1em,
  align: horizon,
  [
    #align(center)[
      #align(center)[#underline[*Traditional*]]
      #v(0.5em)
      Developer writes _every line_
      #v(0.3em)
      #underline[Focus]: *syntax and implementation*
      #v(0.3em)
      Skill: typing code correctly
    ]
  ],
  [
    #text(size: 24pt)[#fa-arrow-right()]
  ],
  [
    #align(center)[
      #align(center)[#underline[*Intent-Driven*]]
      #v(0.5em)
      Developer _specifies what_ they want
      #v(0.3em)
      #underline[Focus]: *clarity of specification*
      #v(0.3em)
      Skill: articulating intent precisely
    ]
  ]
)

#v(1em)
#align(center)[
  _From "prompt artists" to *orchestra conductors*—the developer's role shifts from writing code to #underline[directing] it._
]


= AI-Assisted Tools: Categories and Landscape


== Three Approaches to AI-Assisted Tools

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1.5em,
  align: top,
  [
    #align(center)[#underline[*1. Plugins / Extensions*]]
    #v(0.5em)
    _Integrate AI into your existing IDE._
    - *GitHub Copilot* (VS Code, JetBrains, Neovim)
    - Amazon Q Developer (multi-IDE)
    - Tabnine, Codeium
    #v(0.5em)
    #text(fill: rgb("#16a34a"))[+ Full IDE ecosystem preserved]
    #text(fill: rgb("#16a34a"))[+ Non-invasive, portable]
    #v(0.2em)
    - #text(fill: rgb("#dc2626"))[Limited by IDE APIs]
    - #text(fill: rgb("#dc2626"))[AI features can feel secondary]
  ],
  [
    #align(center)[#underline[*2. AI-Native IDEs*]]
    #v(0.5em)
    _Editors built from the ground up with AI at the center._
    - *Cursor* (VS Code fork, 2022)
    - *Windsurf* (Codeium, Cascade)
    - Zed (fast + AI), Replit
    #v(0.5em)
    #text(fill: rgb("#16a34a"))[+ Advanced agentic features]
    #text(fill: rgb("#16a34a"))[+ Seamless AI-first UX]
    #v(0.2em)
    - #text(fill: rgb("#dc2626"))[Editor lock-in]
    - #text(fill: rgb("#dc2626"))[Less mature ecosystems]
  ],
  [
    #align(center)[#underline[*3. Web-Based*]]
    #v(0.5em)
    _Full IDE in the browser with AI and instant deploy._
    - Replit (Ghostwriter)
    - StackBlitz (WebContainers)
    - *Bolt.new* (AI full-stack)
    #v(0.5em)
    #text(fill: rgb("#16a34a"))[+ Zero setup, multi-device]
    #text(fill: rgb("#16a34a"))[+ Instant deploy and sharing]
    #v(0.2em)
    - #text(fill: rgb("#dc2626"))[Web dev focus, privacy concerns]
    - #text(fill: rgb("#dc2626"))[Not suited for large projects]
  ]
)

== Anatomy of an AI-Assisted Tool (Basics Component)

Regardless of category, every AI-assisted tool shares *three core components*

#v(0.3em)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1.5em,
  align: top,
  [
    #align(center)[#underline[*1. Editor / IDE*]]
    #v(0.3em)
    - Development environment
    - Local context awareness
    - UI for suggestions and chat
    - Real-time feedback loop
  ],
  [
    #align(center)[#underline[*2. AI Model (LLM)*]]
    #v(0.3em)
    - Generates code from intent
    - Trained on millions of repos
    - Understands semantics and patterns
    - Model-agnostic: swap per task
  ],
  [
    #align(center)[#underline[*3. Integration Layer*]]
    #v(0.3em)
    - Plugin / API bridge
    - Workflow orchestration
    - Bidirectional communication
    - Tool coordination (MCP, LSP)
  ]
)

== Choosing the Right Model

Different models serve different purposes—*model selection is a developer skill*:

#v(0.5em)
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    #align(center)[#underline[*Model Categories*]]
    #v(0.5em)
    - *Speed-optimized:* For autocomplete and inline suggestions (low latency, high throughput)
    - *Deep reasoning:* For long-context, complex tasks (architecture, debugging, planning)
    - *Multi-model powerhouses:* For prototyping and broad capability
    - *Open source:* For local reproducibility, privacy, and stability
  ],
  [
    #align(center)[#underline[*Selection Criteria*]]
    #v(0.5em)
    - _Task requirements_: multi-modal? deep reasoning? fast completion?
    - _Computational resources_: can you run it locally?
    - _Privacy and security_: data sensitivity constraints?
    - _Cost_: API pricing vs. local inference cost?
    - _Context window_: how much code can the model "see"?
  ]
)

== Advanced Capabilities: Context Engineering & Agentic Tools

#v(0.8em)
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    #align(center)[#underline[*4. Context Indexing & Retrieval*]]
    #v(0.3em)
    - Project parsing (AST, symbol tables, dependency graphs)
    - Vector embeddings for semantic search
    - Context retrieval: open files, selections, `#codebase`, git history
    - Without this, AI generates *generic, disconnected* code
  ],
  [
    #align(center)[#underline[*5. Tool Use & Agentic Capabilities*]]
    #v(0.3em)
    - *Passive tools:* code completion, inline suggestions, chat Q&A
    - *Active (agentic) tools:* terminal execution, autonomous codebase navigation, web search, multi-file edits, automated testing
    - Higher integration $arrow.r$ better developer experience
  ]
)

== On Agentic AI
#quote(block: true)[
  "Agentic AI tools can autonomously execute tasks, navigate codebases, and even self-correct based on outcomes. They represent a shift from 'AI assists' to 'AI acts' under human supervision." 
]

- *How do they work?*
  - LLMs still generate just text, but an integration layer allows them to *invoke tools* (terminal, search, code edits) as part of their output.
    - _We will cover how to define tools later._
  - Conceptually, all available tools are defined in the prompt, and the LLM "decides" when to use them based on the task and context.
  - The strongest models learn how to use tools via fine-tuning, not merely through zero-shot prompting.
  - Most recent models inherently support tool calling, enabling *Agentic AI*.


== Copilot — A Case Study

#align(center)[
  #image("figures/copilot-logo.png", width: 15%)
  #v(0.3em)
  #link("https://github.com/features/copilot")
]
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Overview*]]
    #v(0.5em)
    - Advanced AI coding assistant by GitHub/Microsoft
    - Released 2021, *20M+ active developers*
    - Uses a family of specialized language models
    - (Mostly) Model-agnostic: swap between GPT-\*, Claude, Gemini, Local, etc.
  ],
  [
    #align(center)[#underline[*Key Features*]]
    #v(0.5em)
    - Real-time code suggestions
    - Context-aware assistance (RAG-based)
    - Inline chat, full chat, and agent mode
    - IDE integration (VS Code, JetBrains, Neovim)
  ]
)

== Inside the Pilot — RAG Architecture

#v(0.5em)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align: top,
  [
    #align(center)[#underline[*Data Indexing*]]
    #v(0.3em)
    - Parse and chunk the #underline[source code]
    - Generate #underline[vector embeddings]
    - Build a searchable #underline[vector database]
    - Extract and annotate #underline[metadata]
  ],
  [
    #align(center)[#underline[*Retrieval*]]
    #v(0.3em)
    - Embed the #underline[user query]
      - E.g., "How do I implement feature X?" or "What does this function do?"
    - Perform #underline[similarity searches]
    - Rank results by #underline[relevance]
    - Select the #underline[top-$k$] code snippets
  ],
  [
    #align(center)[#underline[*Augmented Generation*]]
    #v(0.3em)
    - Enrich the prompt with #underline[context]
    - Include project-specific #underline[APIs]
    - Generate #underline[grounded] responses
    - Reduce LLM #underline[hallucinations]
  ]
)

#align(center)[
  #image("figures/RAG-phases.png", width: 0%)
]

= Levels of Autonomy in AI-Assisted Tools

== The Autonomy Spectrum — Overview

We illustrate each level through *GitHub Copilot*, which spans the entire spectrum:

#v(0.3em)
#text(size: 17pt)[
#grid(
  columns: (0.2fr, 0.5fr, 1fr, 1fr),
  gutter: 0.8em,
  align: top,
  [*Level*], [*Name*], [*Copilot Feature*], [*Human Role*],
  [*L0*], [_Code Completion_], [Inline ghost-text suggestions based on immediate context], [Full control; accepts or rejects each suggestion],
  [*L1*], [_Code Creation_], [Inline chat, `/doc` `/test` `/fix` commands, full chat with `#`-mentions], [Supervises, integrates, and iterates],
  [*L2*], [_Supervised Automation_], [*Agent Mode*: plans, edits, runs terminal, monitors outcomes], [Validates the final result; acts as quality gate],
  [*L3*], [_Full Automation_], [*Coding Agent*: background agent triggered from GitHub Issues / PRs], [Monitors; reviews PR and intervenes on exceptions],
  [*L4*], [_AI-Led Autonomy_], [#underline[Future]: AI defines own goals and strategies], [Strategic oversight only],
)
]

#v(0.5em)
#align(center)[
  #text(size: 16pt, style: "italic")[Analogous to autonomous driving levels—each step trades human control for AI initiative.]
]

== Level 0 — Code Completion 

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*How It Works*]]
    #v(0.5em)
    - AI *completes single lines or code blocks* as you type
    - Based on the #underline[immediate context] of the file
      - And use the contextual representation of the codebase
    - Developer maintains *total control* of direction
    - Acts as an *accelerator for repetitive tasks*
    - First feature introduced by Copilot (2021)
    - Default model (and only one available): GPT-4.1 
  ],
  [
    #align(center)[#underline[*Copilot Interactions*]]
    #v(0.5em)
    - `Tab` to *accept*, `Esc` to *reject*
    - `Ctrl+Right` to accept _partially_ (word by word)
    - `F1` $arrow.r$ _Open Completions Panel_ to see *alternatives*
    - Best for: boilerplate, standard patterns, known idioms
    - Limitation: *context window* and *limited project awareness* (and no "natural language" interaction)
  ]
)

== Level 1 — Code Creation #h(0.3em) #text(size: 16pt)[(Copilot Chat & Commands)]

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    #align(center)[#underline[*Inline Chat*] (`Ctrl+I`)]
    #v(0.5em)
    - Describe intent in natural language $arrow.r$ *code generated in-place*
    - Accept, reject, or write _follow-up_ to refine
    - Can #underline[limit context] by selecting specific code
    - Swap model per interaction (GPT-4, Claude, etc.)
  ],
  [
    #align(center)[#underline[*Predefined Commands & Full Chat*]]
    #v(0.5em)
    - `/doc` $arrow.r$ generate documentation
    - `/tests` $arrow.r$ create unit testsù
    - `/fix` $arrow.r$ correct errors
    - Full chat supports `#`-mentions: `#file`, `#codebase`, `#selection`, `#fetch`
  ]
)


#v(0.3em)
#align(center)[
  #text(size: 16pt, style: "italic")[The developer still #underline[reviews and integrates] every generated snippet. AI creates, the human supervises.]
]

== Level 2 — Supervised Automation #h(0.3em) #text(size: 16pt)[(Copilot Agent Mode)]

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*What Agent Mode Does*]]
    #v(0.5em)
    - Receives a *high-level task* in natural language
    - *Plans the steps* needed to accomplish the goal
    - Executes *code edits* and *tool invocations* autonomously
    - Monitors outcomes and #underline[iterates on errors]
    - Functions like an _autonomous junior developer_
  ],
  [
    #align(center)[#underline[*Copilot-Specific Features*]]
    #v(0.5em)
    - Runs *terminal commands* (build, test, lint)
    - Navigates and searches the codebase
    - Performs *web search* and fetches docs
    - Coordinates *multi-file edits*
    - Custom _agents_ (`.github/agents/`) for specialized use cases (planning, TDD, review)
  ]
)

#v(0.5em)
#quote(block: true)[
  "Agent mode uses a combination of code editing and tool invocation to accomplish the task. As it processes your request, it monitors the outcome of edits and tools, and iterates to resolve any issues that arise." — GitHub Copilot Docs
]

== Agent Mode vs. Previous Levels

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*L0–L1 (Reactive Tools)*]]
    #v(0.5em)
    - Respond to *specific requests*
    - Operate on #underline[context provided by the user]
    - Do not plan autonomously
    - Do not execute changes without explicit input
    - Do not use external tools
  ],
  [
    #align(center)[#underline[*L2 (Agent Mode — Proactive)*]]
    #v(0.5em)
    - Receives a *broad goal*, not a single request
    - #underline[Plans steps] and executes them
    - Uses external tools (terminal, web, search)
    - *Self-corrects*: monitors output and iterates
    - Human validates the _final_ result, not each step
  ]
)

#v(0.5em)
#align(center)[
  _L0–L1 tools are #underline[reactive]—they answer. Agent mode is #underline[proactive]—it acts. The shift is from "AI assists" to "AI drives (under supervision)."_
]

== Level 3 — Full Automation #h(0.3em) #text(size: 16pt)[(Copilot Coding Agent)]

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    #align(center)[#underline[*Background Agents*]]
    #v(0.5em)
    - AI handles *complex tasks in complete autonomy*
    - Triggered from a *GitHub Issue* or PR, not from the IDE
    - Does not require human approval for each change
    - Navigates codebases, runs tests, *submits PRs*
    - Operates as a _"trusted senior engineer"_
  ],
  [
    #align(center)[#underline[*Copilot Coding Agent*]]
    #v(0.5em)
    - Assign an Issue $arrow.r$ agent works *in the background*
    - Follows a *plan–execute–verify* loop
    - Provides logs and diffs for human audit
    - _Multi-model orchestration:_ larger LLMs for reasoning + smaller ones for syntax
    - *Agent wrangling:* a new skill for developers
  ]
)

#v(0.5em)
#underline[*Key Shift — From Copilot to Agent:*]
- Interactive copilots _wait for a prompt_; background agents _receive a goal and work independently_
- Introduces _"cognitive overload"_ for the reviewer—large PRs from agents can be harder to audit than human code
- Both Level 2 and 3 require clear *context engineering* (architecture, guidelines) to *steer* agent behavior

== The Copilot Journey — L0 to L3 at a Glance

#text(size: 17pt)[
#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    #align(center)[#underline[*L0: Ghost Text*]]
    #v(0.3em)
    Developer types $arrow.r$ AI suggests inline
    #v(0.2em)
    _"AI accelerates what you're already writing."_
  ],
  [
    #align(center)[#underline[*L1: Chat & Commands*]]
    #v(0.3em)
    Developer describes $arrow.r$ AI generates
    #v(0.2em)
    _"AI creates from intent, developer reviews."_
  ],
  [
    #align(center)[#underline[*L2: Agent Mode*]]
    #v(0.3em)
    Developer sets a goal $arrow.r$ AI plans and executes
    #v(0.2em)
    _"AI drives, developer validates the destination."_
  ],
  [
    #align(center)[#underline[*L3: Coding Agent*]]
    #v(0.3em)
    Issue assigned $arrow.r$ AI works independently, submits PR
    #v(0.2em)
    _"AI operates autonomously, developer audits."_
  ],
)
]

#v(0.5em)
#align(center)[
  _Each level adds autonomy—and demands more from the developer in terms of *review, context engineering, and trust calibration*._
]

== Bridging the Gap — From Autonomy to Quality

Increasing autonomy raises a critical question: *how do we ensure quality* in AI-generated code?

#v(0.5em)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align: top,
  [
    #align(center)[#underline[*The 70% Problem*]]
    #v(0.5em)
    - AI gets you _most_ of the way—but the remaining part is often the hardest
    - Requires disciplined *review, testing, and refactoring*
    - The human must #underline[own] the final output
  ],
  [
    #align(center)[#underline[*Context Engineering*]]
    #v(0.5em)
    - Provide AI with _targeted project knowledge_
    - Architecture docs, conventions, product vision
    - Persistent instructions (e.g., `copilot-instructions.md`)
    - Better context $arrow.r$ fewer corrections
  ],
  [
    #align(center)[#underline[*Custom Instructions & Styling*]]
    #v(0.5em)
    - Define _ad hoc rules_ for code style
    - Custom agents and personas (`.github/agents/` and `prompts/`)
    - Enforce naming, formatting, and architectural constraints
    - The AI _adapts_ to your project, not the other way around
  ]
)

#v(0.5em)
#align(center)[
  _The next sections explore each of these strategies: managing AI output quality, engineering the right context, and crafting effective prompts._
]


== AI as a "First Drafter"

#quote(block: true)[
  "Honest reflection from coding with AI: It can get you 70% of the way there, but that last 30% is frustrating. It keeps taking one step forward and two steps backward with new bugs and issues."
]

#v(0.5em)
#grid(
  columns: (1fr, 1.1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Where AI Excels (the 70%)*]]
    #v(0.5em)
    - _Boilerplate generation_ and repetitive patterns
    - Unit test skeleton creation and documentation
    - Legacy code refactoring and migrations
    - Scaffolding projects and standard CRUD logic
    - Mechanical transformations (e.g., React class $arrow.r$ functional)
  ],
  [
    #align(center)[#underline[*Where Humans Are Essential (the 30%)*]]
    #v(0.5em)
    - *Architecture* and system design decisions
    - Complex _edge cases_ and failure modes
    - Business requirement translation
    - _Security_ and performance optimization
    - Integration of components into a cohesive whole
  ]
)

== The "Majority Solution" Effect

AI models trained on vast code repositories tend to produce the *most statistically common solution*—not necessarily the _best_ one for your context:

#v(0.5em)
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Common Issues*]]
    #v(0.5em)
    - *Off-by-one errors:* Loop boundaries remain tricky for AI
    - *Unhandled exceptions:* Code assumes happy-path inputs
    - *Outdated APIs:* AI may use deprecated library functions
    - *Library bloat:* `import org.apache.commons.io.FileUtils` for basic file operations
    - *Inconsistencies:* Docstring says one thing, code does another
  ],
  [
    #align(center)[#underline[*Mitigation Strategies*]]
    #v(0.5em)
    - Always #underline[mentally test] edge cases through the logic
    - Add *error handling* the AI likely missed
    - Check _library versions_ against current documentation
    - Look for #underline[unusual structure]—too many classes? Too clever?
    - Inline or simplify where the AI has over-complicated
    - Apply the same review rigor as for any *untested contribution*
  ]
)

== Review, Refine, Own — A Six-Step Process

Once AI-generated code is _functionally correct_, refactor it to *align with your standards*:

#v(0.5em)
#text(size: 18pt)[
#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  align: top,
  [
    *1. Align with style guidelines*
    - Run through your formatter/linter
    - Fix naming, line length, conventions
    
    *2. Improve naming and structure*
    - Replace generic names (`helper1`, `helper2`)
    - Inline trivial functions, or split large ones
    
    *3. Remove unnecessary parts*
    - Strip out unrequested test blocks or `main` sections
    - Remove dead code the AI generated
  ],
  [
    *4. Add documentation*
    - Ensure docstrings meet your project format
    - Add comments for non-obvious logic
    
    *5. Optimize if needed*
    - Check algorithmic complexity
    - Replace naive loops with efficient structures
    
    *6. Simplify*
    - Reduce verbosity (e.g., `if-else` $arrow.r$ single `return`)
    - Improve readability without sacrificing clarity
  ]
)
]

== Testing AI-Generated Code

Testing is the ultimate act of #underline[ownership]—it locks down behavior and guards against regression:

#v(0.5em)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align: top,
  [
    #align(center)[#underline[*Unit Tests*]]
    #v(0.5em)
    - Test each function/module individually
    - Cover edge cases the AI likely missed
    - You can ask AI to _generate_ tests—but using them as a basis and then #underline[review them]
    - Human intuition for creative edge cases remains valuable
  ],
  [
    #align(center)[#underline[*Integration Tests*]]
    #v(0.5em)
    - Test AI code _in context_ with the rest of the codebase
    - Does it store to the database correctly?
    - Does output chain properly to the next function?
  ],
  [
    #align(center)[#underline[*End-to-End Tests*]]
    #v(0.5em)
    - Run full scenarios from start to finish
    - Test request $arrow.r$ route $arrow.r$ response in a test environment
    - Verify error handling, format, and edge cases hold up
  ]
)

#v(0.5em)
#align(center)[
  _Once you've tested and fixed any issues, the code is #underline[yours]—you understand it, trust it, and have tests to guard it._
]

= Prompt Engineering for AI-Assisted Programming


== Effective Prompting Strategies

#quote(block: true)[
  *The ultimate goal:* Write a prompt that consistently generates, across different models, the same correct output aligned with the project.
]

We have already seen some of these aspects in previous slides, but the core principles remain:

- *Be Specific & Contextual:*
  - Mention the language, framework, and version.
  - Define the exact scope (e.g., single function vs. full module).
  - Include necessary requirements and constraints.
- *Structure Your Request:*
  - *Start general, then detail:* Use a top-down approach.
  - *Break complex tasks:* Divide et impera.
  - *Name your output format:* E.g., "Return only the function, no explanation".
  - Avoid ambiguous references like "it" or "this".
- *Manage the Session:*
  - *Iterate:* The first response is rarely perfect—refine it.
  - *Maintain a clean history:* Use a new thread for new topics.


== Common Antipatterns
- *Overloaded prompts:* Asking for too much at once.
  - #text(size: 16pt)[#underline[Example:] _"Build a REST API, add authentication, write tests, and deploy it."_]
- *Vague success criteria:* "Make it good" instead of defining what good means.
  - #text(size: 16pt)[#underline[Example:] _"Refactor this function and improve it."_]
- *Missing constraints:* Leaving out key requirements such as error handling or thread safety.
  - #text(size: 16pt)[#underline[Example:] _"Write a cache for this service."_]
- *Open-ended creative prompts:* Too broad to guide the model.
  - #text(size: 16pt)[#underline[Example:] _"Write some Python code to analyze this data."_]
- *Novel-length preambles:* Long roleplay before the actual task adds noise.
  - #text(size: 16pt)[#underline[Example:] _"You are a world-class programmer... now write a regex for emails."_]

#v(0.5em)
#align(center)[
  _A vague prompt like "write a login system" produces insecure code. A structured prompt with data models, error-handling, and security constraints yields production-ready results._
]


#focus-slide()[
  #text(size: 28pt, weight: "bold")[Context Engineering]
  #v(1em)
  #text(size: 20pt)[
    A systematic approach to providing AI with #underline[targeted project information], improving the accuracy and alignment of generated code.
  ]
]

== Context Engineering — Why It Matters

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Without* Context Engineering]]
    #v(0.5em)
    - AI generates _generic_ code
    - Does not respect project conventions
    - Ignores existing architecture
    - Suggestions are inconsistent
    - Repeated back-and-forth to correct
  ],
  [
    #align(center)[#underline[*With* Context Engineering]]
    #v(0.5em)
    - Code #underline[aligned to the project]
    - Respects patterns and conventions
    - Architectural decisions are coherent
    - Knowledge is _persistent_ across sessions
    - Fewer corrections needed
  ]
)

#v(0.5em)
#quote(block: true)[
  "Context is the bridge between the programmer's intent and the AI's action. Without curated context, the AI generates generic solutions; with targeted context, it becomes a collaborator that understands the project."
]

== Contextual Prompting as Context Engineering

Contextual prompting is the _in-prompt_ dimension of context engineering—providing the AI with *project-specific knowledge at interaction time*:

#v(0.5em)
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    #align(center)[#underline[*What to Include in Context*]]
    #v(0.5em)
    - Share _data models_ and existing patterns
    - Reference project conventions and style guides
    - Use `#file`, `#codebase`, `#selection` references
    - Provide examples of the desired style/logic (few-shot)
    - Modern tools work best with #underline[full codebase access]
  ],
  [
    #align(center)[#underline[*Persistent vs. Per-Prompt Context*]]
    #v(0.5em)
    - *Persistent:* Copilot customization layers (instructions, agents, skills, hooks — see next slides)
    - *Per-prompt:* `#file` mentions, selected code, data models
    - *Ad hoc styling rules:* naming conventions, formatting, patterns to follow or avoid
    - Combine both for #underline[consistent, project-aligned] output
  ]
)

== Context Engineering — The Workflow

Copilot (so each project may follow a different context engineering appraoch)
  A three-step, iterative process:

#v(0.5em)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align: top,
  [
    #align(center)[#underline[*1. Curate Project Context*]]
    #v(0.5em)
    - Create `ARCHITECTURE.md`: design patterns, principles, dependencies
    - Create `PRODUCT.md`: vision, objectives, user personas
    - Create `CONTRIBUTING.md`: code style, best practices, workflow
    - Link them in `.github/copilot-instructions.md`
  ],
  [
    #align(center)[#underline[*2. Generate Implementation Plan*]]
    #v(0.5em)
    - Use a _planning persona_ (custom chat mode)
    - Analyze requirements and codebase context
    - Produce a structured plan with task breakdown
    - Pause for human review and feedback
  ],
  [
    #align(center)[#underline[*3. Implement with AI*]]
    #v(0.5em)
    - Feed the plan to the AI (agent mode for complex tasks)
    - Follow TDD: tests first $arrow.r$ minimal code $arrow.r$ refactor
    - Validate against the plan
    - Iterate in a feedback loop
  ]
)


== Copilot Customization — Context Engineering in Practice

Copilot customization layers are the _practical implementation_ of context engineering — they make project knowledge *persistent, structured, and automatic*:

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align: top,
  [
    #align(center)[#underline[*Always-On Context*]]
    - *Custom instructions* (`copilot-instructions.md`, `AGENTS.md`): added to _every_ request
    - *File-based instructions* (`.instructions.md`): applied when files match a glob
    - _Maps to:_ *Curate Project Context* — conventions, architecture, and style are #underline[always available]
  ],
  [
    #align(center)[#underline[*On-Demand Workflows*]]
    - *Prompt files* (`.prompt.md`): reusable `/` commands with variables and model overrides
    - *Agent skills* (`SKILL.md`): portable instructions _+ scripts + examples_
    - _Maps to:_ *Implementation Plan* — codify #underline[repeatable tasks] and planning personas
  ],
  [
    #align(center)[#underline[*Personas & Integrations*]]
    - *Custom agents* (`.agent.md`): specialized personas with restricted tools and handoffs
    - *MCP servers:* connect to APIs, DBs, and issue trackers
    - *Hooks:* shell commands for format, lint, and audit
    - _Maps to:_ *Implement with AI* — #underline[orchestrate agents] with the right tools
  ]
)


#text(size: 16pt)[For some examples, take a look at the #link("https://github.com/github/awesome-copilot")]

== The Golden Rules of AI-Assisted Development

Best practices distilled from professional teams using AI tools.

#v(0.3em)
#text(size: 18pt)[
#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    - *All AI output requires review:* Test and validate before merging
    - *Use AI to expand capabilities, not replace thinking:* Stay actively engaged
    - *Isolate AI changes in Git:* Separate commits for AI-generated code
    - *All code undergoes code review:* Human or AI-written, same standard
    - *Don't merge code you don't understand:* Understanding is critical to security
  ],
  [
    - *Prioritize documentation and ADRs:* Reduce future technical debt
    - *Share and reuse effective prompts:* Build a team prompt library
    - *Be the Architect and Editor-in-Chief:* AI handles first draft, you shape the product
    - *Mentor and set standards:* Teach juniors to self-review AI output
    - *Regularly reflect and iterate:* Refine your AI development workflow
  ]
)
]

#align(center)[
  #text(size: 15pt, fill: rgb("#005587"))[
    *Source:* Addy Osmani, _Beyond Vibe Coding: Mastering AI-Assisted Development_
  ]
]


= Challenges, Concerns, and the Future


== Known Challenges

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Technical Challenges*]]
    #v(0.5em)
    - *Variable output quality:* Inconsistent results across prompts
    - *Ambiguous prompts $arrow.r$ ambiguous code:* Garbage in, garbage out
    - *Outdated APIs:* Models may suggest deprecated patterns
    - *Security blind spots:* AI may generate code with vulnerabilities
    - *Performance:* The "majority solution" is often _correct but not optimal_
    - *Context window limits:* Large codebases exceed what the model can see
  ],
  [
    #align(center)[#underline[*Human & Organizational Challenges*]]
    #v(0.5em)
    - *Overreliance and skill atrophy:* Documented phenomenon under active study
    - *Bias in AI output:* Models reflect training data biases
    - *Trust and correctness:* Temptation to accept "it compiles" as "it's correct"
    - *Job shifting:* Roles evolve from coder to orchestrator
    - *Licensing risks:* AI may suggest restrictively licensed code
    - *Transparency:* Normalizing AI use as a standard professional skill
  ]
)

== Security, Maintainability, and Reliability

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Security Concerns*]]
    #v(0.5em)
    - AI-generated code may use outdated patterns or miss recent attack vectors
    - Error handlers may *leak stack traces*
    - Database queries may be *susceptible to injection*
    - Must supplement AI output with #underline[current security knowledge]
    - Use specialized AI auditors (Snyk, DeepCode) as a safety net
  ],
  [
    #align(center)[#underline[*Maintaining Reliability*]]
    #v(0.5em)
    - Move beyond _"it runs"_ to _"it is robust"_
    - Build automated testing that keeps pace with generated code
    - Disciplined *refactoring* and *code review* are non-negotiable
    - Deployment: gradual rollouts, heavy monitoring, quick rollback
    - Performance: human intervention required for optimization the AI overlooks
  ]
)

== The Evolving Developer Role

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align: top,
  [
    #align(center)[#underline[*Senior Engineers*]]
    #v(0.5em)
    - Transition from _"code artisan"_ to *orchestrator*
    - Translate complex requirements into effective prompts
    - Act as *Architect and Editor-in-Chief*
    - Mentor juniors on AI-assisted workflows
    - Value: system design, judgment, product vision
  ],
  [
    #align(center)[#underline[*Mid-Level Engineers*]]
    #v(0.5em)
    - Become _"product-minded engineers"_
    - See code as a *means to an end*
    - Specialize in AI-human workflow optimization
    - Bridge between business needs and AI capabilities
  ],
  [
    #align(center)[#underline[*Junior Developers*]]
    #v(0.5em)
    - Use AI to _learn_ without becoming reliant
    - Must verify AI outputs independently
    - Avoid the _"hallucination trap"_
    - Build foundation in fundamentals alongside AI skills
  ]
)

#v(0.5em)
#align(center)[
  _Professional development is shifting: the human provides #underline[direction], #underline[depth], and #underline[values]; the AI provides #underline[speed] and #underline[breadth]._
]

== What Developers Are Saying

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Perceived Benefits*]]
    #v(0.5em)
    - *Boosting productivity:* Significant time savings on routine tasks
    - *Staying in the flow:* Fewer context switches
    - *Lowering barriers to entry:* New developers onboard faster
    - *Changing roles and tools:* New workflows emerge
    - *10x to 100x potential:* Automating routine coding and boilerplate
  ],
  [
    #align(center)[#underline[*Persistent Concerns*]]
    #v(0.5em)
    - *The 30% frustration:* AI gets close, but the remaining fix is harder
    - *Debugging unfamiliar code:* Fixing code you didn't write demands different skills
    - *Cognitive offloading:* The temptation to stop thinking critically
    - *Learning vs. producing:* Unclear whether AI accelerates growth or hinders it
    - *Workflow dependency:* Feeling less productive without AI tools
  ]
)

#v(0.5em)
#quote(block: true)[
  "If I knew how the code worked I could probably fix it myself. But since I don't, I question if I'm actually learning that much."
]

== Looking Ahead — The Future of AI-Augmented Development

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Emerging Trends*]]
    #v(0.5em)
    - *Natural-language-first development:* The line between writing code and describing systems blurs further
    - *Specialized AI roles:* "AI Wranglers," "Automation Leads"
    - *Multi-model orchestration:* Different models for different tasks
    - *Autonomous background agents:* From copilot to full agent
  ],
  [
    #align(center)[#underline[*The Human Linchpin*]]
    #v(0.5em)
    - Despite extreme automation, #underline[human creativity] and #underline[judgment] remain the primary drivers
    - *System design* and *product vision* become the most valuable skills
    - AI handles execution; humans focus on _empathy, system thinking, and solving real-world problems_
    - _The future developer doesn't type perfectly—they #underline[explain perfectly] what they want to achieve_
  ]
)

= Conclusion

== Summary

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  align: top,
  [
    #align(center)[#underline[*Key Takeaways*]]
    #v(0.5em)
    - *Vibe Coding* and *AI-Assisted Programming* are two paradigms on the same spectrum—each has its place
    - *Levels of autonomy* range from inline completion to fully autonomous agents
    - The *70% Problem* means AI is a powerful first-drafter, but humans must own the rest
    - *Prompt engineering* and *context engineering* are essential skills for modern developers
  ],
  [
    #align(center)[#underline[*What's Next*]]
    #v(0.5em)
    - Vertical focus on _Agentic AI_ for software engineering
    - Advanced *context engineering* and *MCP* (Model Context Protocol)
    - *Next lab*:
      - Hands-on practice with AI-assisted development workflows
  ]
)

#v(1em)
#align(center)[
  _LLMs aren't just tools—they're becoming #underline[collaborative partners] in software engineering. Your value lies in knowing #underline[when to trust them], #underline[when to override them], and #underline[how to guide them]._
]

== Resources

- *Book:* Addy Osmani, _Beyond Vibe Coding_ (2025) — #link("https://www.oreilly.com/library/view/beyond-vibe-coding/9781098175481/")
- *Book:* _AI-Assisted Programming_ — O'Reilly Media, 2024 — #link("https://www.oreilly.com/library/view/ai-assisted-programming/9781098164553/")
- *Copilot Docs:* #link("https://code.visualstudio.com/docs/copilot/overview")
- *Copilot Chat Cookbook:* #link("https://docs.github.com/en/copilot/tutorials/copilot-chat-cookbook")
- *Prompt Engineering Guide:* #link("https://www.promptingguide.ai/")
