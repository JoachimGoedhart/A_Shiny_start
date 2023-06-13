# A Shiny start - Tutorial

The aim of the tutorial is to demonstrate basic aspects of a Shiny app and how to add new user interface (UI) elements and how to connect these elements to output. The final version of the app is available online: <https://amsterdamstudygroup.shinyapps.io/A_Shiny_start/>

Below you find step-by-step instructions that you can follow to add and modify functionality to a Shiny app that is created by default. With each step, the functionality (and hence complexity) of the app increases. Knowledge of R is not required for this tutorial, but is highly recommended when you want to develop your own app.

After completion of steps 1-8 of this tutorial you should have an understanding of the components of a Shiny app, have an idea of how to modify existing Shiny apps and be able to generate a basic Shiny app for interactive display of data. Steps 9-11 are more advanced, and are especially useful when you are interested in using your own data in a Shiny app. Some tips for using your own data in a Shiny app can be found at the very end of this tutorial.

If you have any suggestions or feedback, please reach out!

## Preparations

You will need RStudio and the two R packages `{shiny}` and `{tidyverse}`. The code below will install the packages if not present yet. You can copy paste it into the Console of RStudio and run it:

```         
if (!require(shiny)) {
    install.packages("shiny")
}
if (!require(tidyverse)) {
    install.packages("tidyverse")
}
```

------------------------------------------------------------------------

Now we can start coding. In RStudio we can create a new Shiny app by selecting from the menu bar: File \> New File \> Shiny Web App... Conveniently, this generates a file with code for a very basic app that you can run without any modifications. To launch the app you can either hit the play icon or use `<Control> + <Shift> + <Enter>`. Try it! This should fire up a new window with the app.

## Bugs

Anytime that you write code, you will introduce bugs. Finding and solving bugs (debugging) is an integral part of writing code and (often) you learn something from this process. Debugging a Shiny app can be hard, and I have not found the best way of doing this. A bracket or comma that is missing or in the wrong place can break the app. So pay attention and be precise when introducing new lines of code. One piece of advice is to often run the app and see if it runs at all and if so, whether it runs as designed. If it does not run, check the newly introduced code and any brackets and commas near the new code.

## Step 1 - Use ggplot2 for the output

We will first use a more modern and nicer looking way of plotting the same data. Therefore, you should replace existing code that is responsible for the plot within `renderPlot({})` (watch the brackets!) for ggplot code:

```         
ggplot(data = faithful, aes(x=waiting)) + geom_histogram(bins = input$bins)
```

We also need the app that the `{tidyverse}` package needs to be loaded upon the start of the app. So we add:

```         
library(tidyverse)
```

<details>
<summary>Hint</summary>
-   Look for <code>library(shiny)</code> somwhere at the top of the code and add it on the line below
</details>

Try to run this code, does it work?

------------------------------------------------------------------------

## Step 2 - Change the dataset

Replace the existing dataset for the `iris` dataset (this dataset is an integral part of the {tidyverse} package and does not need to be loaded separately) and change the name of the column that is used for plotting to `Sepal.Width`:

```         
ggplot(data = iris, aes(x=Sepal.Width)) + geom_histogram(bins = input$bins)
```

**Question**: Can you change the title that is shown when running the app?

<details>
<summary>Hint</summary>
-   look for <code>titlePanel()</code>
</details>

<details>
<summary>Solution</summary>
-   <code>titlePanel("Iris data")</code>
</details>

------------------------------------------------------------------------

## Step 3 - Add a UI element to control transparency

The `sliderInput()` function generates a slider in the User Interface and can is used for user input. Add another slider by copy-pasting the `sliderInput()` code (also all text and values in the brackets). Note: within the `sidebarPanel()` items (i.e. user interface elements) are separated with a comma. The last item is NOT followed by a comma. So when you add another slider by using another `sliderInput()` function, this needs to be separated by a comma:

```         
    sliderInput(...),
    sliderInput(...)
```

**Question**: What happens when you run this code?

<details>
<summary>Hint</summary>
-   Change the values of both sliders
</details>

<details>
<summary>Solution</summary>
-   Only the input from the upper slider is used by the app.
</details>

------------------------------------------------------------------------

**Question**: Change the ID of the second slider to `“transparency”` and adjust range to 0-1 and the default to 0.7.

<details>
<summary>Hint</summary>
-   The first value inside <code>sliderInput()</code> is the ID.
</details>

<details>
<summary>Solution</summary>
-   <code>sliderInput("transparency", ""Number of bins:", min = 0, max = 1, value = 0.7),</code>
</details>

------------------------------------------------------------------------

**Question**: Can you also adjust the label of the slider?

<details>
<summary>Hint</summary>
-   The second field inside <code>sliderInput()</code> is the label.
</details>

<details>
<summary>Solution</summary>
-   <code>sliderInput("transparency", "Transparency:", min = 0, max = 1, value = 0.7),</code>
</details>

------------------------------------------------------------------------

> You can introduce new UI elements that take user input, but are not yet connected to an action. This is nice, as it allows you to build the UI elements and add user input elements without breaking the app.

------------------------------------------------------------------------

The next step is to connect the input of the slider to the code that is used to generate the plot. Let's define the value of alpha (transparency) in the ggplot code:

```         
ggplot(data = iris, (x=Sepal.Width)) + geom_histogram(bins = input$bins, alpha=0.3)
```

Run the code and check whether the plot output has changed.

Now we need to connect the value of the slider to the code that renders the plot. This value from the slider is encoded by `input$transparency` (because the ID of the slide is transparency).

**Question**: Can you connect the value of alpha to input of the slider?

<details>
<summary>Hint</summary>
-   look at how bins is defined by the value taken from the slider.
</details>

<details>
<summary>Solution</summary>
-   <code>ggplot(data = iris, (x=Sepal.Width)) + geom_histogram(bins = input$bins, alpha=input$transparency)</code>
</details>

------------------------------------------------------------------------

Add other UI elements. Replace `sliderInput()` by `numericInput()` to change alpha:

```         
numericInput("transparency", "Transparency:", value = 0.7, step = 0.1)
```

Run the code to see whether the new UI element appears and to verify its effect on the plot. Note: We removed the min and max variables from the `nummericInput()`. You can check whether this has any effect.


**Question**: Can you add sensible min and max values to `nummericInput()`?

<details>
<summary>Solution</summary>
-   <code>numericInput("transparency", "Transparency:", value = 0.7, min = 0, max = 1, step = 0.1)</code>
</details>
------------------------------------------------------------------------


## Step 4 - Add a checkbox to control the plot

Add a new UI element `checkboxInput()`, which will be used to control whether to plot per `'Species'`:

```         
checkboxInput("ungroup", "Per species?", value = FALSE)
```

Make sure that the elements are properly separated by commas.

Run the code to see whether the new UI element appears.

Let's connect the UI elements to the plotting code. First, we modify the plotting code to:

```         
p <- ggplot(data = iris, aes(x=Sepal.Width)) + geom_histogram(bins = input$bins, alpha=input$transparency)
return(p)
```

> Although the output did not change, we have done something important here. We assign the plotting code to an object `p`. We return this object, which will be rendered as a plot by the app. This way of encoding a plot increases the flexibility, as we can add new functions to the object `p`. Let's look at an example below.

For displaying separate plots for 'Species' we can add (before returning p):

```         
p <- p + facet_wrap(~Species)
```

**Question**: Use an `if()` statement to make the call to `facet_wrap()` conditional?

<details>
<summary>Hint</summary>
-   <code>input$ungroup</code> is "TRUE" or "FALSE", depending on the state of the checkbox.
</details>
<details>
<summary>Hint</summary>
-   To evaluate the state of the checkbx you can use <code>input$ungroup == TRUE</code> inside <code>if()</code>
</details>

<details>
<summary>Solution</summary>
-   <code>if (input$ungroup == TRUE) p <- p + facet_wrap(~Species)</code>
</details>

------------------------------------------------------------------------

## Step 5 - Add a UI element to control the plot title

**Question**: can you introduce the UI element: `textInput("title", "Title:", value = "Plot title")` and add code to the server side to enable the change of the plot title?

<details>
<summary>Hint</summary>
-   <code>p <- p + labs(title = …)</code> can be used to change the title of a plot
</details>

<details>
<summary>Solution</summary>
-   <code>p <- p + labs(title = input$title)</code>
</details>

------------------------------------------------------------------------

Note: If you are familiar with ggplot code, you can improve or style the plot by adding functions to the object, for instance, setting the theme and font size:

```         
p <- p + theme_bw(base_size = 16)
```

## Step 6 - Add text to the UI

Text can be added to the UI, by using quotation marks. To insert a title for the sidebarpanel, add (followed by a comma):

```         
"Plot controls"
```

Styling of the text is achieved with HTML tags as follows:

```         
h2("Plot Controls")
```

The `h2()` in Shiny corresponds to `<h2></h2>` in HTML A separating line can be added with hr():

```         
h2("Plot Controls"), hr()
```

## Step 7 - Conditional UI elements

UI elements can be hidden and revealed by conditional statements. Usually, this is controlled by a checkbox or radiobuttons. Here, we use the checkbox to make another UI element conditional. We can use the output of the checkbox with the `Id="ungroup"` to control a UI element with the function `conditionalPanel(condition = "input.ungroup==true", .......)`. After the condition, any other UI element can be inserted. Here, we insert text to explain the action of the checkbox:

```         
conditionalPanel(condition = "input.ungroup==true", "The plot shows the data per species")
```

**Question**: Does the location of this conditional statement in the sidebarPanel() matter?

<details>
<summary>Solution</summary>
-   The location matters for the layout of the User Interface, but it does not matter for reactivity. It will react to the state of the checkbox, regardless of its position within <code>sidebarPanel()</code>.
</details>

## Step 8 - Adding a table to the output

In this step, we add a table to the output. To render the output, we need to add this to the server:

```         
output$someTable <- renderTable({
  head(iris)
})
```

This may be an obvious warning, but make sure that you don't copy this statement inside `renderPlot({})`

Now we have code to render the table, but it still needs to be displayed in the UI.

To show the output add the object to `mainPanel()` by adding this line (use commas where necessary)

```         
tableOutput("someTable")
```

**Question**: Can you modify the output to display a summary of the data instead of the data itself?

<details>
<summary>Hint</summary>
-   use the function <code>summary()</code> on the iris dataset.
</details>

<details>
<summary>Solution</summary>
-   <code>summary(iris)</code>
</details>


------------------------------------------------------------------------

Change the table to display the summary data of `Sepal.Width` (this makes more sense, as this is the data that is plotted in the histograms):

```         
iris %>% group_by(Species) %>% summarise(n=n(), mean = mean(Sepal.Width))
```

## Step 9 - Selecting input from a list

-Add `selectInput()` to control variable for plotting from a predefined list:

```         
selectInput(inputId = "var", label = "Variable", choices = "")
```

The choices can be inserted by coding them `choices = c("Sepal.Length", "Sepal.Width")`

Check that the dropdown menu shows the two choices.

The input of the dropdown menu can be used to control the data for the plot. Replace `aes(x=Sepal.Width)` with `aes_string(x=input$var)`

Since `aes_string()` is soft deprecated, it's better to use 'tidy evaluation': `aes(x=.data[[input$var]])`

(This is rather ugly code, but that's currently the right way to do it)

## Step 10 - Reactive updating of choices

Instead of hard-coding the choices, it would be more elegant (and flexible) to read the choices from the dataframe.

We add an 'observer' to read and print the column names. To demonstrate the `observe({})` function, we add to the server code block:

```         
observe({print(head(iris))})
```

When you run the app, the data is printed in the Console window of RStudio. This method of using `print()` inside `observe({})` is great for debugging an app as it allows to print the output from the app in the Console.

**Question**: Can you add an observer that prints the status of the checkbox? What do you see in the Console when you click on the checkbox?

<details>
<summary>Hint</summary>
-   the status is stored in <code>input$ungroup</code>
</details>

<details>
<summary>Solution</summary>
-   <code>observe({print(input$ungroup)})</code>
-   The console should report on the state of the checkbox when it changes.
</details>

------------------------------------------------------------------------

**Question**: Change the observer to print the column names of iris with the function `colnames()`

<details>
<summary>Hint</summary>
-   You need to use <code>colnames()</code> inside the <code>print()</code> function
</details>

<details>
<summary>Solution</summary>
-   <code>observe({print(colnames(iris))})</code>
</details>

------------------------------------------------------------------------

We can use the observer to read the column names and store it in a variable named `colNames`:

```         
observe({colNames <- colnames(iris)})
```

Now we need to update the `selectInput()` with this new list. Within the observer function we add `updateSelectInput()`, which will update the list of choices. The complete code is:

```         
observe({
  colNames <- colnames(iris)
  updateSelectInput(session, inputId = "var", choices = colNames)
  })
```

Before this works, we need to add session to the server: Replace `server <- function(input, output)` with `server <- function(session, input, output)`

## Step 11 - Improvements of the app

**Question**: The table with the summary shows the data from `Sepal.Width`. Can you make the table reactive and update the summary with the parameter that is displayed?

<details>
<summary>Hint</summary>
-   Look at the code for the plot. The keyword here is 'tidy evalution'
</details>

<details>
<summary>Solution</summary>
-   <code>iris %>% group_by(Species) %>% summarise(n=n(), mean = mean(.data[[input$var]]))</code>
</details>


------------------------------------------------------------------------

The column with `Species` doesn't contain numbers and selecting this column throws an error. So it would be nice to use only column names in the dropdown menu that contain numeric values. In the observer when can create a temporary dataframe that only contains columns with numeric values:

```         
df_num <- iris %>% select(where(is.numeric))
```

**Question**: can you extract the column names from the `df_num` and update the list of choices accordingly?

<details>
<summary>Solution</summary>
-   <code>colNames <- colnames(df_num)</code>
</details>


## Conclusion

This concludes the tutorial and you should have a fully working app that looks like this: [https://amsterdamstudygroup.shinyapps.io/A_Shiny_start/](https://amsterdamstudygroup.shinyapps.io/A_Shiny_start/)

You can compare your own code with the code that I wrote. You can find my code in the app.R file that is part of this repository. See also [this link](https://raw.githubusercontent.com/JoachimGoedhart/A_Shiny_start/main/app.R).

I hope that you had fun and learned how a Shiny app can be developed. If you want to use a Shiny app to share or display your own data, read on for some tips on how to do that.

## Post Scriptum - Using your own data in an app

Thus far, we only used example datasets. If you want to use external datasets, there are a couple of options. The most straightforward way is to read a CSV file that is present in the same folder as the app.R file. The code to read the data is outside of the ui and server elements just like loading the packages is. So you can add this code just below the code to load the packages:

```         
my_data <- read.csv(“data_for_app.csv”)
```

After that, you can replace any instances where you use a dataframe (`iris` in our example) by `my_data`

Suppose that you want to load external data, you could add the following line (this will actually work):

```         
my_data <- read.csv("https://raw.githubusercontent.com/JoachimGoedhart/DataViz-protocols/main/Area_tidy.csv")
```

Note that when you load your own data, you need to adjust the variables as well if you want to plot this data. For instance, there is no column named `"Species"`, so the code needs to be adjusted accordingly. For this specific dataframe, this should work:

```         
p <- ggplot(data = my_data, aes(x = value)) + geom_histogram(bins = input$bins, alpha=input$alpha)
if (input$ungroup) p <- p + facet_wrap(~Condition)
```

One approach that I use is to first hard-code the plot, based on the data. After that, I introduce the controls (sliders, input fields) in the User Interface. Finally, the controls can be connected to the variables in the code. Check frequently whether the app runs, because debugging can be complicated and becomes more difficult with every line of code that you add.

## Post Post Scriptum - Dashboard versus Tool

When the data is included in the app, the result is much like a data *dashboard*. The users can interact with the data, visualize it in different ways to explore and understand it. Many of the apps that I developed are a data visualization *tool*. Users can upload their own data and explore it. This adds another layer of complexity, since this type of app needs to handle different types of data and the app needs to be designed with this in mind. Luckily there is code available that should provide some help to get started. You can check out [my Github repository](https://github.com/JoachimGoedhart) for inspiration!



------------------

