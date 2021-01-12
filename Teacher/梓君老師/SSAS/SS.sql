WITH MEMBER [Measures].[上層業績]
AS
	([時間].[年_季_月].CURRENTMEMBER.PARENT,[Measures].[金額])

MEMBER [Measures].[上層業績比重]
AS
	[Measures].[金額]/[Measures].[上層業績]

MEMBER [Measures].[上上層業績]
AS
	([時間].[年_季_月].CURRENTMEMBER.PARENT.PARENT,[Measures].[金額])

MEMBER [Measures].[上上層業績比重]
AS
	[Measures].[金額]/[Measures].[上上層業績]

SELECT NON EMPTY { [Measures].[金額],[Measures].[上層業績比重],[Measures].[上上層業績比重] } ON COLUMNS	
	,NON EMPTY [時間].[年_季_月].[月].MEMBERS ON ROWS
FROM [中文北風Cube]
WHERE [時間].[年].[2003年]


