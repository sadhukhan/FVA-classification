# FVA-classification
Flux variability analysis (FVA) is a widely used computational tool for evaluating the minimum and maximum range of each reaction flux that can still satisfy the constraints using a double LP problem (i.e. a maximization and a subsequent minimization) for each reaction of interest.

Based on the minimum and maximum possible flux through each reaction, each reaction in a given metabolic model can be classified into the 9 categories. Consider recation: A --> B

# Categories: 
(1) PositiveFixed - Reaction Flux at a fixed rate in A --> B direction.
(2) PositiveVariable - Reaction Flux at a variable rate in A --> B direction.
(3) 0 to Positive - Reaction Flux at a variable rate in A --> B direction, or No flux. 
(4) NegativeFixed - Reaction Flux at a fixed rate in B --> A direction.
(5) NegativeVariable - Reaction Flux at a variable rate in B --> A direction.
(6) Negative to 0 - Reaction Flux at a variable rate in B --> A direction, or No flux 
(7) Negligible - Negligible flux through the reaction (i.e. min/max values rang -0.001 to 0.001)
(8) Reversible - Reaction Flux at a variable rate in A --> B or B --> A direction (i.e. min <-0.001 to max >0.001)
(9) Blocked - No flux (i.e. min = max = 0)

Changes in the metabolic conditions, such as external stress, avalibilty of glucose, oxygen etc., metabolic reactions may be constrained differently in the cell. This program helps compare 2 different metabolic conditions or 2 different types of cells in the same condition.

# Command to run the code: 
> rxnClassification_usingFVA.pl ControlCell.FVA TestCell.FVA

# Output:
Tab-seperated file format. Change in FVA categories due to metabolic/conditional changes.
