# Figures and practice blocks in Knot notes

Two fenced blocks work inside any note, next to `quiz`:

- ` ```fig ` draws a picture from plain commands.
- ` ```practice ` is a set of exercises checked one at a time, inside the note.

## fig

One command per line (or several on a line split with `;`). Coordinates are ordinary math coordinates: x to the right, y **up**. The picture is fitted to its content automatically unless `view` is given. Lines starting with `//` are ignored.

**Values.** Any number may be an expression: `3`, `-1.5`, `7/2`, `sqrt(2)`, `2pi/3`. No spaces inside one value.
**Points.** A point is a name defined earlier (`A`) or a literal `x,y` with no space (`3,4`, `-1,sqrt(3)`).
**Text.** Labels go in double quotes: `"a = 5"`. Plain text and Unicode only (² √ π α β γ θ ° ′ ≈ ≤). No `$`, no `;` and no `"` inside.
**Flags** (anywhere after the command): `dashed` `dotted` `thick` `fill` and a colour `acc` (accent) `ok` (green) `warn` (orange) `mute` (grey) `ink`.
**Directions** for labels: `n s e w ne nw se sw c`.

### Setup
| Command | Meaning |
|---|---|
| `view x0 x1 y0 y1` | fixed window. Always give it for `plot`. |
| `size W` / `size W H` | width in px (default 340, max 640). With H the two axes scale independently (use for graphs whose x and y ranges differ a lot); without H one unit is the same length on both axes (use for geometry). |
| `grid` / `grid 2` | light grid, every 1 (or given) unit |
| `axes` / `axes "t" "s"` | coordinate axes with numbers; optional axis names; `axes nonum` hides numbers |
| `ticks 2` / `ticks pi/2 1` | tick step for x and y; a step written with `pi` labels the axis in multiples of π |
| `caption "text"` | caption under the picture (`$math$` works here) |

### Points
| Command | Meaning |
|---|---|
| `point A 1 2` / `point A 1 2 sw` | define A, draw a dot, label it "A" (label direction default `ne`) |
| `point A sw` | draw an already defined point |
| `point A 1 2 n "A(1, 2)"` | custom label; `""` = dot without label |
| `point 3,4 e "P"` | dot at a literal position |
| `def A 1 2` | define without drawing |
| `mid M A B` | midpoint (not drawn) |
| `along Q A B 0.25` | point a fraction of the way from A to B |
| `foot H P A B` | foot of the perpendicular from P to line AB |
| `inter X A B C D` | intersection of lines AB and CD |
| `rot Q P O 90` | P rotated about O by degrees, counter-clockwise |
| `refl Q P A B` | P reflected in line AB |
| `onc Q O 2 40` | point on the circle centre O radius 2 at 40° |
| `shift Q P 3 -1` | P moved by (3, −1) |

Derived points are only defined; draw them with `point Q` when the dot should be visible.

### Lines and shapes
| Command | Meaning |
|---|---|
| `seg A B` / `seg A B "c"` | segment; the label sits beside the middle, on the right-hand side when walking A→B (add `flip` for the other side). For a polygon listed counter-clockwise the default side is outside. |
| `line A B` | infinite line through A and B (clipped to the picture) |
| `ray A B` | ray from A through B |
| `vec A B "v"` | arrow from A to B |
| `poly A B C ...` | closed polygon; `fill` shades it |
| `circle O 2` / `circle O A` | circle with radius 2, or through point A; `fill` shades |
| `ellipse O 3 2` | ellipse with semi-axes 3 (x) and 2 (y) |
| `arc O 2 30 120 "label"` | arc of the circle centre O radius 2 from 30° to 120° |
| `angle A B C "α"` | angle mark at vertex **B** between BA and BC (always the angle under 180°); optional 4th value = radius in px (default 22) |
| `right A B C` | right-angle square at vertex **B** |
| `tick A B` / `tick A B 2` | one or two small marks on segment AB (equal sides) |
| `label 2 3 "text"` / `label A "text" sw` | free text at a position or beside a point |

### Graphs
| Command | Meaning |
|---|---|
| `plot x^2 - 2` | graph of y = f(x); optional `from a to b`. Give `view` first. |
| `param 2cos(t) | 3sin(t) from 0 to 2pi` | parametric curve (x(t) | y(t)) |
| `polar 1 + cos(t) from 0 to 2pi` | polar curve r(t) |
| `area x^2 from 0 to 2` | shade between the curve and the x-axis |
| `area x + 2 | x^2 from -1 to 2` | shade between two curves |
| `scatter 1,2 2,3.5 3,3` | dots without labels |

Expressions: `+ - * / ^`, brackets, implicit product (`2x`, `3sin(x)`, `x(x - 1)`), `x` or `t`, constants `pi` `e`, functions `sin cos tan asin acos atan sqrt abs ln log exp floor sinh cosh tanh sign` (`log` is base 10). Write `x*e^x`, not `xe^x`. A vertical line is `line 2,0 2,1 dashed`.

### Number line and data
| Command | Meaning |
|---|---|
| `numline 0 10` | number line; options `step 0.5`, `labels 1` (label every 1), flags `frac` (labels as k/d when step is 1/d), `nonum` |
| `jump 3 7 "+4"` | arched arrow above the number line from 3 to 7 |
| `dots 2 3 3 5 5 5` | dot plot stacked above a number line (use with `numline`) |
| `boxplot 2 6 9 13 19 "A"` | box plot (min q1 median q3 max) above a number line (use with `numline`) |
| `bars "pon" 3 "uto" 5` | bar chart: label and value pairs |
| `hist 0 10 2 5 8 4` | histogram: start, bin width, then the counts |

On a number line points have y = 0: `point 3,0 n "A"`.

### Fractions and counting
| Command | Meaning |
|---|---|
| `fracbar 4 3 "3/4"` | bar cut into 4 parts with 3 shaded; several `fracbar` lines stack under each other (good for comparing) |
| `pie 6 5 "5/6"` | circle cut into 6 with 5 shaded; several pies sit side by side; `at x,y` and `r 1.5` optional |
| `array 3 5` | 3 rows of 5 dots; `at x,y` optional (top-left dot) |

### Solids (oblique sketches, hidden edges dashed)
| Command | Meaning |
|---|---|
| `cuboid 4 2.5 3 "a" "b" "c"` | box: width, height, depth; optional labels |
| `cylinder 1.5 3 "r" "h"` | radius, height |
| `cone 1.5 3 "r" "h" "s"` | radius, height (third label = slant side) |
| `sphere 1.5 "r"` | radius |
| `pyramid 3 3 "a" "h"` | square base side, height |

All take `at x,y` (cuboid/pyramid: front-left bottom corner; cylinder/cone: centre of the base; sphere: centre).

### Example
````
```fig
point A 0 0 sw
point B 5 0 se
point C 1.5 3.5 n
poly A B C fill acc
seg A B "c"
seg B C "a"
seg C A "b"
foot H C A B
seg C H dashed mute "h" flip
right C H B
angle B A C "α"
caption "Trougao $ABC$ sa visinom $h$"
```
````

## practice

````
```practice
? Koliko je $7 · 8$?
= 56
! $7 · 8 = 56$.

? Koji je ugao prav?
~ point A 0 0 sw; point B 3 0 se; point C 0 2 nw; poly A B C; right B A C
* Ugao kod $A$
- Ugao kod $B$
- Ugao kod $C$
! Kvadratić u temenu označava prav ugao.
```
````

- `? ` starts an exercise.
- `~ ` optional picture: fig commands split with `;` (several `~` lines are joined).
- `= ` typed answer; alternatives split with `|`. Case, spaces, `°`, `%`, decimal comma and the kind of minus sign do not matter. If the expected answer is not written as a fraction, any equal number is accepted (0.5 or 1/2 for `= 0.5`).
- `* ` the right option and `- ` wrong options make a multiple-choice exercise (options are shown in a fixed mixed order).
- `! ` explanation shown after answering.

Progress is saved on the device. A note's `practice` block does not affect flashcards or quizzes.
