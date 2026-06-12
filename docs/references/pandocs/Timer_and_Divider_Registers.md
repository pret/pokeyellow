# Timer and Divider Registers

:::tip NOTE

The Timer described below is the built-in timer in the Game Boy. It has
nothing to do with the MBC3s battery buffered Real Time Clock - that\'s
a completely different thing, described in
[Memory Bank Controllers](#MBCs).

:::

## FF04 — DIV: Divider register

This register is incremented at a rate of 16384Hz (\~16779Hz on SGB).
Writing any value to this register resets it to $00.
Additionally, this register is reset when executing the `stop` instruction, and
only begins ticking again once `stop` mode ends. This also occurs during a
[speed switch](<#FF4D — KEY1/SPD (CGB Mode only): Prepare speed switch>).
(TODO: how is it affected by the wait after a speed switch?)

Note: The divider is affected by CGB double speed mode, and will
increment at 32768Hz in double speed.

## FF05 — TIMA: Timer counter

This timer is incremented at the clock frequency specified by the TAC
register (\$FF07). When the value overflows (exceeds $FF)
it is reset to the value specified in TMA (FF06) and [an interrupt](<#INT $50 — Timer interrupt>)
is requested, as described below.

## FF06 — TMA: Timer modulo

When TIMA overflows, it is reset to the value in this register and [an interrupt](<#INT $50 — Timer interrupt>) is requested.
Example of use: if TMA is set to $FF, an interrupt is requested at the clock frequency selected in
TAC (because every increment is an overflow). However, if TMA is set to $FE, an interrupt is
only requested every two increments, which effectively divides the selected clock by two. Setting
TMA to $FD would divide the clock by three, and so on.

If a TMA write is executed on the same M-cycle as the content of TMA is transferred to TIMA
due to a timer overflow, the old value is transferred to TIMA.

## FF07 — TAC: Timer control

{{#bits 8 >
  "TAC" 2:"Enable" 1-0:"Clock select"
}}

- **Enable**: Controls whether `TIMA` is incremented.
  Note that `DIV` is **always** counting, regardless of this bit.
- **Clock select**: Controls the frequency at which `TIMA` is incremented, as follows:
  
  <div class="table-wrapper"><table>
    <thead>
      <tr><th rowspan=2>Clock select</th><th rowspan=2>Increment every</th><th colspan=3>Frequency (Hz)</th></tr>
      <tr><th>DMG, SGB2, CGB in normal-speed mode</th><th>SGB1</th><th>CGB in double-speed mode</th></tr>
    </thead><tbody>
      <tr><td>00</td><td>256 M-cycles </td><td>  4096</td><td>  ~4194</td><td>  8192</td></tr>
      <tr><td>01</td><td>4 M-cycles   </td><td>262144</td><td>~268400</td><td>524288</td></tr>
      <tr><td>10</td><td>16 M-cycles  </td><td> 65536</td><td> ~67110</td><td>131072</td></tr>
      <tr><td>11</td><td>64 M-cycles  </td><td> 16384</td><td> ~16780</td><td> 32768</td></tr>
    </tbody>
  </table></div>

Note that writing to this register [may increase `TIMA` once](<#Relation between Timer and Divider register>)!
