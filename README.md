# Into the Tidyverse
 
## Introduction

This repository contains learning materials for R/Tidyverse.

Generally, I developed these materials with college undergraduates (or comparable) in mind as a target audience. Specifically, these materials were created to help train undergraduate research assistants in the Brown Dept. of Cognitive, Linguistic, and Psychological Sciences (CLPS), as well as students in an introductory psychology class.

I assume you have no prior programming or heavy stats experience. To the extent you have either, that's great, and you may find it useful to follow along as review.

A little about me: I'm neither a programmer nor a statistician by training. I'm an experimental psychologist who twice failed introductory computer science classes in undergrad, and who had to take what was essentially the same introductory stats class three times in order to (finally) understand any of it. This is to say that, if you feel any code-phobia/stats-phobia, I can empathize with you. There is definitely a learning curve to both code and stats, and there are no easy shortcuts for learning either. But, I hope that these materials will provide you with enough scaffolding of the fundamental concepts that you can learn to venture out and learn new things on your own.

## File and folder structure

Files in the parent folder:
Whenever you want to engage with these workshops, remember to first double-click on `into-the-tidyverse.Rproj` first. This opens up a new R session (so that work you're doing for this project doesn't disturb whatever work you might be doing for other R projects).

Sandbox:
For reasons that are explained in more detail in *Sandbox/readme.txt*, you should never, ever, ever modify anything that's in any other folder. Seriously, under most circumstances, there should be no reason for you to ever navigate into these directories or open these files. If you're wanting to save scripts, plots, whatever, you should do it in the Sandbox.

Code:
I'm providing all of the code from the videos in the Code folder. These scripts are provided primarily for folks with visual impairments, who would find it useful to have the raw text for accessibility reasons. By and large, I do NOT want any other group of people looking at this code. Why? Because most of your learning occurs when you make (and correct) mistakes, and you can only make mistakes if you're trying things out from scratch. You can't make mistakes if you're simply running someone else's code, or just copy/pasting code.

Data:
We will be using a diverse range of datasets from a variety of sources. There are times when it will make sense for you to directly download the data from the source (such as timeseries data on covid19, which is updated on a daily basis), but otherwise, the datasets will be provided in the Data folder. When applicable/available, the URLs will be documented in the relevant scripts.

Output:
Sometimes, there will be some kind of output we want to save to our hard drive (like a plot or table). These will be saved in the Output folder.

## Session descriptions

1. A motivating example for why you might want to learn R or Tidyverse.
2. Tech setup.
	- Downloading R and RStudio. Installing relevant R libraries.
	- Creating a GitHub account and downloading GitHub Desktop. Creating a forked clone of the GitHub repository for this workshop.
	- Understanding (at a basic level) what the fork that last sentence means.
	- If you're following along with this as I'm creating new materials in realtime, how to "sync" new materials so that you have the most recent version of my materials on your computer, and how to avoid creating headaches for yourself.
3. Reading data.
	- Using `readr` to get data into R.
	- Understanding dataframes and their close cousins, the `tibble`.
	- Datatypes.
4. Manipulating data.
	- Getting familiar with functions.
	- An introduction to using `dplyr` to manipulate data.
5. Tidying data.
	- Introduction to the "tidy" philosophy (after which the `tidyverse` is named)
	- More practice using `dplyr` and learning some handy `tidyr` functions.
6. Plotting data.
	- Understanding the grammar of graphics.
	- Using `ggplot` to make beautiful plots.
7. The integrated tidyverse and beyond.
	- What does it mean for a non `tidyverse` library to be tidy-friendly?
8. Special topics.
	- Why do `stringr`, `forcats`, and `lubridate` exist?
	- Revisiting `readr`, and introducing `haven` and `readxl`.
9. An introduction to statistical modeling.
	- The paradox of learning from first principles.
	- My approach: learning statistics backwards.
10. Simple regression.
	- Testing mean differences using the t-test.
	- Testing association strengths using correlations.
	- Surprise! These techniques are all secretly simple regression.
11. Multiple regression I.
	- The problem of shared variance.
	- Semi-partial estimates.
	- Interpreting model estimates.
12. Multiple regression II.
	- Why categorical variables make analysis more complicated.
	- Contrasts.
13. Multiple regression III.
	- Interactions.
14. Generalized linear models.
	- Distributional assumptions.
	- Logistic and Poisson regression.
15. Multilevel modeling.
	- The problem of repeated measures.
	- The logic of mixed-effects regression.
	- Introduction to `lme4`.

## Useful resources
1. [R for Data Science](https://r4ds.had.co.nz/)
	- Oriented around data science workflows, and less around statistics
	- Extremely accessible to people who know nothing about programming
	- Makes extensive use of the tidyverse, which is a collection of R packages that streamlines the process of cleaning/analyzing data
	- Written by one of the lead programmers of many tidyverse packages
2. [Learning Statistics with R](https://learningstatisticswithr.com/)
	- Oriented around statistics
	- Extremely accessible to people who know very little about statistics or programming
	- Teaches statistics from first principles, and focuses on conceptual underpinnings
	- Written by a psychologist whose speciality is in computational modeling
3. [Deep dive into statistics using R](http://users.stat.umn.edu/~helwig/teaching.html)
	- A wealth of resources for people who want more statistical grounding and translations of mathematical formalisms into R code
	- Covers everything from simple linear regression to multivariate/nonparametric statistics
	- Great resource for brushing up on advanced statistical concepts
4. [Advanced R](https://adv-r.hadley.nz/)
	- For people who are specifically interested in doing a deep-dive into R *as a programming language*
	- Not really necessary for the average user, but may be a good resource if you're getting a weird error message and want to figure out exactly what it means
