# ez-algo

A package to set algorithms in typst with ease.
It indents and dedents the lines based on some simple keywords, which you can cahnge if you like to.



<table><tr>
  <td>
      <img src="gallery/euclid.png" width="250px">
  </td>
  <td>

```typst
#ez-algo(
  input: [$a,b in ZZ$],
  output: [gcd of $a,b$],
)[
  *function* $"gcd"(a,b)$ \
  *while* $a != b$ \
  *if* $a>b$\
        $a <- a - b$ \
  *else* \
        $b <- b - a$ \
  *end if* \
  *end while*
]
``` 
</tr>
</table>


