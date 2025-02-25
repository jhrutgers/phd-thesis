# Programming Models for Many-Core Architectures -- A Co-design Approach

It is unlikely that general-purpose single-core performance will improve much
in the coming years. The clock speed is limited by physical constraints, and
recent architectural improvements are not as beneficial for performance as
those were several years ago. However, the transistor count and density per
chip still increase, as feature sizes reduce, and material and processing
techniques improve. Given a limited single-core performance, but plenty of
transistors, the logical next step is towards many-core. Programming models for
many-core architectures: a co-design approach A many-core processor contains at
least tens of cores and usually distributed memory, which are connected (but
physically separated) by an interconnect that has a communication latency of
multiple clock cycles. In contrast to a multicore system, which only has a few
tightly coupled cores sharing a single bus and memory, several complex problems
arise. Notably, many cores require many parallel tasks to fully utilize the
cores, and communication happens in a distributed and decentralized way.
Therefore, programming such a processor requires the application to exhibit
concurrency. Moreover, a concurrent application has to deal with memory state
changes with an observable (non-deterministic) intermediate state, whereas
single-core applications observe all state changes to happen atomically. The
complexity introduced by these problems makes programming a many-core system
with a single-core-based programming approach notoriously hard.

The central concept of this thesis is that abstractions, which are related to
(many-core) programming, are structured in a single platform model. A platform
is a layered view of the hardware, a memory model, a concurrency model, a model
of computation, and compile-time and run-time tooling. Then, a programming
model is a specific view on this platform, which is used by a programmer.

In this view, some details can be hidden from the programmer's perspective,
some details cannot. For example, an operating system presents an infinite
number of parallel virtual execution units to the application--details
regarding scheduling and context switching of processes on one core are hidden
from the programmer. On the other hand, a programmer usually has to take full
control over separation, distribution, and balancing of workload among
different worker threads. To what extent a programmer can rely on automated
control over low-level platform-specific details is part of the programming
model. This thesis presents modifications to different abstraction layers of a
many-core architecture, in order to make the system as a whole more efficient,
and to reduce the complexity that is exposed to the programmer via the
programming model.

For evaluation of many-core hardware and corresponding (concurrent) programming
techniques, a 32-core MicroBlaze system, named Starburst, is designed and
implemented on FPGA. On the hardware architecture level, a network-on-chip is
presented that is tailored towards a typical many-core application
communication pattern. All cores can access a shared memory, but as this memory
becomes a bottleneck, inter-core communication bypasses memory by means of
message passing between cores and scratchpad memories. Using message passing
and local memories, a new distributed lock algorithm is presented to implement
mutexes. The network scales linearly in hardware costs to the number of cores,
and the performance of the system scales close to linear (until bounded by
memory bandwidth).

Different many-core architectures implement different memory models. However,
they have in common that atomicity of state changes should be avoided to reduce
hardware complexity. This typically results in a (weak) memory model that does
not require caches to be coherent, and processes that disagree on the order of
write operations. Moreover, porting applications between hardware with a
different memory model requires intrusive modifications, which is error-prone
work. In this thesis, a memory model abstraction is defined, which hides the
memory model of the hardware from the programmer, and reduces hardware
complexity by reducing the atomicity requirements to a minimum, but still
allows an efficient implementation for multiple memory hierarchies. Experiments
with Starburst demonstrate that software cache coherency can transparently be
applied to applications that use this memory model abstraction.

A common approach to exploit the parallel power of a many-core architecture is
to use the threaded concurrency model. However, this approach is based on a
sequential model of computation, namely a register machine, which does not
allow concurrency easily. In order to hide concurrency from the programmer, a
change in the model of computation is required. This thesis shows that a
programming model based on lambda-calculus instead is able to hide the
underlying concurrency and memory model. Moreover, the implementation is able
to cope with higher interconnect latencies, software cache coherency, and the
lack of atomicity of state changes of memory, which is demonstrated using
Starburst. Therefore, this approach matches the trends in scalable many-core
architectures.

The changes to the abstraction layers and models above have influence on other
abstractions in the platform, and especially the programming model. To improve
the overall system and its programmability, the changes that seem to improve
one layer should fit the properties and goals of other layers. Therefore, this
thesis applies co-design on all models. Notably, co-design of the memory model,
concurrency model, and model of computation is required for a scalable
implementation of lambda-calculus. Moreover, only the combination of
requirements of the many-core hardware from one side and the concurrency model
from the other leads to the memory model abstraction above. Hence, this thesis
shows that to cope with the current trends in many-core architectures from a
programming perspective, it is essential and feasible to inspect and adapt all
abstractions collectively.

The [document](https://github.com/jhrutgers/phd-thesis/blob/master/Rutgers%20-%20Programming%20Models%20for%20Many-Core%20Architectures.pdf)
is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

