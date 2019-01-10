public String statement() {
		double totalAmount = 0;
		int frequentRenterPoints = 0;
		double tempTotal;
		
		String result = "Rental Record for " + getName() + "\n";
		for (Rental each : rentals)
		{
			//Determine amounts for each line
			tempTotal=calculate(each);
			
			//Add frequent renter points:
			frequentRenterPoints++;
			
			//add bonus for a two day new release rental
			if (isNewRelease(each)) 
			frequentRenterPoints++;
			
			//show figures for this rental
			result += each.getMovie().getTitle() +" " + String.valueOf(tempTotal) + "\n";
			totalAmount += tempTotal;
		}
	
		//Add footer lines
		result += "Amount owed is " + String.valueOf(totalAmount) + "\n";
		result += "You earned " + String.valueOf(frequentRenterPoints) + " frequent renter points";
		
		return result;
	}
	
		public boolean isNewRelease(Rental r){
		if ((r.getMovie().getPriceCode() == Movie.NEW_RELEASE) && r.getDaysRented() > 1)
			return true;
		else 
			return false;
	}
	
	
	public double calculate(Rental r){
		double thisAmount = 0;
		switch(r.getMovie().getPriceCode())
		{
		case Movie.REGULAR:
			thisAmount +=2;
			if (r.getDaysRented() > 2)
			{
				thisAmount += (r.getDaysRented() - 2) * 1.5;
			}
			break;
		case Movie.NEW_RELEASE:
			thisAmount += r.getDaysRented() * 3;
			break;
		case Movie.CHILDRENS:
			thisAmount += 1.5;
			if (r.getDaysRented() > 3)
			{
				thisAmount += (r.getDaysRented() - 3) * 1.5;
			}
			break;
		}
		return thisAmount;
	}