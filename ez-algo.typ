
#let ind(input_text: "text",level: 0,h-spacing: 10pt,stroke: 1pt +black) = {
  let nums = range(0, level+2 )
  let numbers = range(0, level+2 )

  for it in range(0,level+1){
    if it >=1 and it < level{
      nums.at(it) = [#h(1.5*h-spacing)]
    }else {
      nums.at(it) = [#h(h-spacing)]
  }}
  if level ==0 {
    nums.at(0) = [#h(5pt)]
  }
  nums.at(level + 1) = input_text

  //nums = nums.map(x => text(x,red))
  //return #text([#text],red)]
  
  table(
    columns: level +2,
    stroke: (x, y) => if x == level +1 or x == 0 { 
                          none
                      } else {
                           (left: stroke,
                             top: none,
                          bottom: none,
                           right: none)},
    inset: (x, y) => if x == level +1{
    (left: 0% + 0pt,bottom: 0% + 6pt,right: 0% + 5pt,top: 0% + 6pt)
    } else{(0% + 0pt)},
    ..numbers.map(val => [#nums.at(val)])
  )
}


#let algo_header(input: none,output: none) = {
  let a
  if input != none and type(input) != "array" {
      input = ([*Input:*],[#input])
  }

  if output != none and type(output) != "array" {
      output = ([*Output:*],[#output])
  }

  if input != none and output != none{
    a = input +output
  } else if input != none {
    a = input
  } else if output!= none {
    a = output
  } else{return}

  table(columns: (auto,auto),stroke: none,
      ..range(a.len()).map(val => a.at(val)))
  } 
}

#let ez-algo_backend(
  pseudocode: (),
  input: none,
  output: none,
  indent_keywords: none,
  dedent_keywords: none,
  other_keywords: none,
  line_color : black,
  line_stroke: 1pt + black,
  number_color: black,
  fill: (x, y) =>  if calc.even(y) {gray.lighten(70%)}, 
  head_color: none,
) = {

  let test = pseudocode

  let algo_ray = range(test.len()).map(x => 0)
  let indent = 0
  let indent_array = range(test.len()).map(x => 0)
  let trigger = false;

  if indent_keywords != none and dedent_keywords != none and other_keywords != none{
  for it in range(test.len()){
    if type(test.at(it)) == content {
      if test.at(it).has("children") {
        for body in test.at(it).children {
          if body.func() == strong{
            if other_keywords.contains(body.body){
              indent_array.at(it) = indent - 1
              trigger = true
            } else if  indent_keywords.contains(body.body)  {
              indent_array.at(it) = indent
              indent = indent +1
              trigger = true
            } else if dedent_keywords.contains(body.body) {
              indent = indent -1
              indent_array.at(it) = indent
              trigger = true
            } 
          }
        }
      }
      if test.at(it).has("body"){
        if other_keywords.contains(test.at(it).body){
          indent_array.at(it) = indent - 1
          trigger = true
        }else if indent_keywords.contains(test.at(it).body) {
        //test.at(it).body == [while] or test.at(it).body == [if]{ 
          indent_array.at(it) = indent
          indent = indent + 1
          trigger = true
        } else if dedent_keywords.contains(test.at(it).body){ 
          indent = indent - 1
          indent_array.at(it) = indent
          trigger = true
        }  
      }
    }
    if trigger == false {
        indent_array.at(it) = indent
    } 
    trigger = false
  }}
  
  for it in range(test.len()){
    algo_ray.at(it) = ind(input_text: [#text(test.at(it),line_color)], stroke: line_stroke,level: indent_array.at(it))
  }
  
  let numbers = range(1,algo_ray.len()+1).map(x => text([#x],number_color))
  let a = numbers.zip(algo_ray).flatten()
  let head_stroke = false
  let filling = (x,y) => fill(x,y)
  if input != none or output != none {
    a = ([],algo_header(input: input,output: output)) + a
    head_stroke = true
    filling = (x,y) => if y >= 1 {fill(x,y)} else {head_color}
  } 
  let nums = range(0, a.len() )

  
  return table(
    columns: (auto, auto),
    fill: filling,
    align: left,
    stroke: (x, y) => if y == 0 and head_stroke {
                        (bottom: 1pt + black, top: 1pt + black) },
    inset: (x, y) => if y ==0 and head_stroke{
                        (bottom: 0% + 3pt)
                     }else if x==1 { 
                        (0% + 0pt)
                     }else{
                        (0% + 5pt)
    }, 
    
    ..nums.map(val => [#a.at(val)])
  )

} 

#let ez-algo(body,
               input: none,
              output: none,
                fill: (x, y) =>  if calc.even(y) {gray.lighten(70%)},
          head_color: none,
              stroke: none,
     indent_keywords: ([while], [if], [for]),
     dedent_keywords: ([end while], [end if]),
      other_keywords: ([else], [else if], [end for]),
              indent: true,
               inset: 5pt,
       content_color: (numbers: black, stroke: 1pt +black, lines: black),
) = {
  let liste = ()
  let tmp = [] 
  if body.has("children"){
  for elem in body.children{
    if elem == linebreak() {
      liste.push(tmp)
      tmp = []
    } else {
       tmp = tmp + elem
    }
  }
  liste.push(tmp)
  }else{liste = ([],)}

  // Disable the indeting with one command
  if not indent{
    indent_keywords=none
    dedent_keywords=none
    other_keywords=none}

    
  rect(stroke:stroke,
  inset: inset,
  )[
  #ez-algo_backend(input: input, 
          output: output,
      pseudocode: liste,
            fill: fill,
      head_color: head_color,
 indent_keywords: indent_keywords,
 dedent_keywords: dedent_keywords,
  other_keywords: other_keywords,
     line_color : content_color.lines,
     line_stroke: content_color.stroke,
    number_color: content_color.numbers,)]
}
