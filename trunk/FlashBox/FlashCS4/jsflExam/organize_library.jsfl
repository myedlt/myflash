//create an instance of library object
mylibrary = fl.getDocumentDOM().library;
//create organization folders
fl.getDocumentDOM().library.newFolder("Audio");
fl.getDocumentDOM().library.newFolder("Buttons");
fl.getDocumentDOM().library.newFolder("Graphics");
fl.getDocumentDOM().library.newFolder("Movie Clips");

fl.getDocumentDOM().library.newFolder("Miscellaneous");

//get items in library in an Array
itemArray = mylibrary.items;
totalCount = itemArray.length;

//Comments : Begin
//iterate through the Library items in the library 
//iIdentify type of the item and move it to the respective folder
//The miscellaneous category represents anything that is not a graphic or movie clip // or button
//The miscellaneous item could be another folder or component 
//Comments : End


for(var i=0;i<totalCount;i++){
	myItem = itemArray[i];
	myItemType = myItem.itemType;
	myItemName = myItem.name;
	//fl.outputPanel.trace(myItemType +">>"+myItem);

	if(myItemType == "sound"){
		mylibrary.moveToFolder("Audio", myItemName, true); 
	}else if(myItemType == "button"){
		mylibrary.moveToFolder("Buttons", myItemName, true); 
	}else if(myItemType == "graphic"){
		mylibrary.moveToFolder("Graphics", myItemName, true); 
	}else if(myItemType == "movie clip"){
		mylibrary.moveToFolder("Movie Clips", myItemName, true); 
	}else if(myItemType == "folder"){

	}else{
		mylibrary.moveToFolder("Miscellaneous", myItemName, true); 		
	}
}