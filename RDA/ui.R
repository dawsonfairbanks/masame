#runApp('C:\\Users\\pbuttigi\\Documents\\Revolution\\EATME\\RDA', launch.browser = FALSE)

library(shiny)

## ui.R

shinyUI(
	pageWithSidebar(
		
		# Header defintion
		headerPanel("Perform a (partial) redundancy analysis..."),
		
		# Sidebar defintion
		sidebarPanel(
			tabsetPanel(
			tabPanel("Data upload", 
				h5("Description"),
				p("This App will perform an RDA using the rda() function from the vegan package for R. Transformations are performed by decostand(), also from vegan"),
				
				h5("Example data"),
				p("Tick the box below if you'd like to use the 'mite' dataset included in the vegan package as an example."),
				checkboxInput('useExampleData', 'Use an example dataset', FALSE),
				
				
				h5("CSV parameters"),
				p("Note that these parameters apply to all files uploaded. If your files are not correctly formatted, errors will result."),
				# Parameters for read.csv...
				checkboxInput('header', 'Header', TRUE),
				
				numericInput(
					inputId = 'rownames',
					value = 1,
					min = 0,
 					label = 'In each file, which column contains row lables (enter "0" if there are no such columns)?'
					),
				
				radioButtons(
					inputId = 'sep',
 					label = 'Separator',
					choices = c(
						Comma = ',',
						Semicolon = ';',
						Tab = '\t'
						)
					),
				
				radioButtons(
					inputId = 'quote',
					label = 'Quote',
					choices = c(
						'Double quotes' = '"',
						'Single quotes' = "'",
						'None' = ''
						)
					), 
				
				# Upload files...
				h5("Response data"),
				strong("This data set should contain only numeric variables."),
				fileInput(
					inputId = 'dataset', 
					label = 'Select a CSV file with a table of objects (sites, samples, etc) as rows and response variables as columns.',
					accept = c('text/csv','text/comma-separated-values','.csv')
					),
				
				h5("Explanatory data"),
				fileInput(
					'explanatoryVars', 
					'Select a CSV file with a table of objects (sites, samples, etc) as rows and explanatory variables as columns. Factor levels should have at least one non-numeric character. Numeric variables should have values that are solely numbers with no whitespace. Note: all columns will be used as contraints!',
					accept = c('text/csv','text/comma-separated-values','.csv')
					),
				
				h5("Conditioning data"),
				fileInput(
					'conditioningVars', 
					'Select a CSV file with a table of objects (sites, samples, etc) as rows and conditioning variables as columns. Factor levels should have at least one non-numeric character. Numeric variables should have values that are solely numbers with no whitespace. All columns will be used as conditioning variables!',
					accept = c('text/csv','text/comma-separated-values','.csv')
					),
				
				h5("Stratification data"),
				fileInput(
					'strata', 
					'If your objects are stratified (e.g. nested), select the CSV file which specifes which rows belong to each stratum. Strata should be represented by integers.',
					accept = c('text/csv','text/comma-separated-values','.csv')
					)
				
				
				),
			
   tabPanel(
      "Transformations...",
			strong("Note, most of these transformations are only valid for numeric variables. Attempting these transformation on non-numeric variables will lead to errors."),		
			# Should the data be transformed? Input for decostand()
			h5("Response data"),
			radioButtons(
				inputId = 'transform',
				label = 'If needed, select a transformation for your response data...',
				choices = c(
					'No transformation' = 'none',
					'Z score' = 'standardize',
					'Chi square' = 'chi.square',
					'Hellinger' = 'hellinger'
					)
				),
			# Scale variables to unit variance?
			checkboxInput('scaleVars', 'Would you like to scale your response variables to unit variance?', FALSE),

			
			# Should the explanatory data be transformed? Input for decostand()
			h5("Explanatory data"),
			radioButtons(
				inputId = 'expTransform',
				label = 'If needed, select a transformation for your explanatory variables.',
				choices = c(
					'No transformation' = 'none',
					'Z score' = 'standardize',
					'Chi square' = 'chi.square',
					'Hellinger' = 'hellinger'
					)
				),
			
			# Should the conditioning variables be transformed? Input for decostand()
			h5("Conditioning data"),
			radioButtons(
				inputId = 'condTransform',
				label = 'If needed, select a transformation for your conditioning variables...',
				choices = c(
					'No transformation' = 'none',
					'Z score' = 'standardize',
					'Chi square' = 'chi.square',
					'Hellinger' = 'hellinger'
					)
				)
		
			
		),
		
		tabPanel(
			"RDA parameters...",
			
			# Type of scaling to use in plot...
			radioButtons(
				inputId = 'scaling',
				label = 'Would you like Type I or Type II scaling used in your plot?',
				choices = c(
					'Type I' = 1,
					'Type II' = 2
				)
			),
		
			
			# Select the conditioning variables of interest...
				
			htmlOutput("whichCondVarsUI"),
			
			# Label points?
			radioButtons(
				inputId = 'labels',
				label = 'Would you like points to be labeled?',
				choices = c(
					'Yes' = "text",
					'No' = "points"
				)
			),
			

			# Objects, variables, or both?
			radioButtons(
				inputId = 'display',
				label = 'Would you like to plot the objects, the response variables, or both?',
				choices = c(
					'both' = "both",
					'objects' = "sites",
					'variables' = "species"
				)
			)
		),
		
		# Download panel
		tabPanel(
			"Download results...",
			downloadButton('downloadData.plot', 'Download ordination...'),
			br(),
			downloadButton('downloadData.objectCoordinates', 'Download object coordinates...'),
			br(),			
			downloadButton('downloadData.variableCoordinates', 'Download variable coordinates...')	
			)
		)
	),
			# Main panel defintion
			mainPanel(
				tabsetPanel(
					tabPanel("Plot", plotOutput("plot")),
					tabPanel("Summary", verbatimTextOutput("print")),
					tabPanel("ANOVA test of significance", verbatimTextOutput("printSig"))
					)
				)

			)
		)
	#)