# IOS Assessment App

XCode project which displays the places in **Canada**. 
Each place has place image , title and the description of the place. In case of no image it shows default image.
  
Developed using XCode , Swift 4.
Supports ios10 & ios11 versions in both iPhone & iPad.

## Implementation
It is implemented using MVC design pattern .
	
### Model

It has a model class called **ParserHelper.swift** , where data pasing has been done using JSonDecoder , using decodable protocol.

It has **getData method** implements getting data using **UrlSession** , after getting data trying to parese using JSonDecoder . which uses 2 structs that confirms to decodable protocol.

	struct CanadaPlaces : Decodable {
	    let title : String
	    let rows : [Place]
	}

	struct Place : Decodable {
	    let title : String?
	    let description : String?
	    let imageHref : String?
	}
	
	
### View

To customize the tableview cell design , Implemented a view **CustomCanadaPlaceTableViewCell** which is subclass of UITableViewCell .
	
### Controller
	
It has a **AboutCanadaTableViewController** which is subclass of UITableViewController , from where we are trying get datasource by calling the **getData method** in the **ParserHelper.swift** .

It has a refresh button , on click it refreshes the table data.



 


