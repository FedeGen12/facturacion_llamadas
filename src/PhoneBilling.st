!classDefinition: #BillingCalculator category: 'PhoneBilling'!
Object subclass: #BillingCalculator
	instanceVariableNames: 'monthlyFee'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!BillingCalculator methodsFor: 'initialize' stamp: 'FG 25/May/2026 21:36:57'!
initializeWithMonthlyFee: aMonthlyFee 
	monthlyFee := aMonthlyFee.! !


!BillingCalculator methodsFor: 'billing' stamp: 'FG 25/May/2026 22:29:10'!
calculateBillForMonth: aMonth forCustomer: aCustomer 	
	| calls bill |
	
	bill := PhoneBill withTotalCost: monthlyFee.
	
	calls := (aCustomer calls)
	select: [:aCall | aCall isFromMonth: aMonth ].
	
	calls do: [:aCall | bill addBillingFor: aCall].
	
	^bill.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BillingCalculator class' category: 'PhoneBilling'!
BillingCalculator class
	instanceVariableNames: ''!

!BillingCalculator class methodsFor: 'class initialization' stamp: 'FG 25/May/2026 21:36:50'!
withMonthlyFee: aMonthlyFee 
	^BillingCalculator new initializeWithMonthlyFee: aMonthlyFee.! !


!classDefinition: #Call category: 'PhoneBilling'!
Object subclass: #Call
	instanceVariableNames: 'duration timestamp'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!Call methodsFor: 'initialize' stamp: 'FG 25/May/2026 21:56:36'!
initializeWithDuration: aDuration andTimestamp: aTimestamp
	duration := aDuration.
	timestamp := aTimestamp.! !


!Call methodsFor: 'billing' stamp: 'FG 25/May/2026 21:37:14'!
billingCost
	self subclassResponsibility! !

!Call methodsFor: 'billing' stamp: 'FG 25/May/2026 16:32:49'!
isFromMonth: aMonth
	^timestamp monthIndex = aMonth.! !


!classDefinition: #InternationalCall category: 'PhoneBilling'!
Call subclass: #InternationalCall
	instanceVariableNames: 'country'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!InternationalCall methodsFor: 'billing' stamp: 'FG 25/May/2026 22:23:03'!
billingCost
	^country costForDuration: duration.! !


!InternationalCall methodsFor: 'initialize' stamp: 'FG 25/May/2026 22:10:24'!
initializeWithDuration: aDuration country: aCountry andTimestamp: aTimestamp 
	
	super initializeWithDuration: aDuration andTimestamp: aTimestamp.
	country := aCountry.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternationalCall class' category: 'PhoneBilling'!
InternationalCall class
	instanceVariableNames: ''!

!InternationalCall class methodsFor: 'instance creation' stamp: 'FG 25/May/2026 21:46:59'!
withDuration: aDuration country: aCountry andTimestamp: aTimestamp
	^InternationalCall new initializeWithDuration: aDuration country: aCountry andTimestamp: aTimestamp! !


!classDefinition: #LocalCall category: 'PhoneBilling'!
Call subclass: #LocalCall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!LocalCall methodsFor: 'billing' stamp: 'FG 25/May/2026 23:05:26'!
billingCost

	^(self isOnBusinessDay
		and: [ self wasMadeBetween: self regularRateStartHour
			and: self regularRateEndHour ])
		ifTrue: [ self regularRatePerMinute * duration ]
		ifFalse: [ self reducedRatePerMinute * duration ].! !

!LocalCall methodsFor: 'billing' stamp: 'FG 25/May/2026 21:51:41'!
isOnBusinessDay
	| day |
	
	day := timestamp dayOfWeek.
	
	^day >= 1 and: [ day <= 5 ].! !

!LocalCall methodsFor: 'billing' stamp: 'FG 25/May/2026 21:54:33'!
wasMadeBetween: aStartHour and: anEndHour
	| hour |
	
	hour := timestamp hour.
	
	^hour >= aStartHour and: [ hour < anEndHour ].! !


!LocalCall methodsFor: 'rates' stamp: 'FG 25/May/2026 23:07:35'!
reducedRatePerMinute
	^0.10! !

!LocalCall methodsFor: 'rates' stamp: 'FG 25/May/2026 23:07:25'!
regularRateEndHour
	^20! !

!LocalCall methodsFor: 'rates' stamp: 'FG 25/May/2026 23:07:32'!
regularRatePerMinute
	^0.20! !

!LocalCall methodsFor: 'rates' stamp: 'FG 25/May/2026 23:07:16'!
regularRateStartHour
	^8! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LocalCall class' category: 'PhoneBilling'!
LocalCall class
	instanceVariableNames: ''!

!LocalCall class methodsFor: 'instance creation' stamp: 'FG 25/May/2026 22:08:29'!
withDuration: aDuration andTimestamp: aTimestamp.
	^LocalCall new initializeWithDuration: aDuration andTimestamp: aTimestamp.! !


!classDefinition: #NationalCall category: 'PhoneBilling'!
Call subclass: #NationalCall
	instanceVariableNames: 'locality'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!NationalCall methodsFor: 'billing' stamp: 'FG 25/May/2026 22:27:04'!
billingCost
	^locality costForDuration: duration.! !


!NationalCall methodsFor: 'initialize' stamp: 'FG 25/May/2026 22:07:00'!
initializeWithDuration: aDuration locality: aLocality andTimestamp: aTimestamp
	
	super initializeWithDuration: aDuration andTimestamp: aTimestamp.	
	locality := aLocality.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NationalCall class' category: 'PhoneBilling'!
NationalCall class
	instanceVariableNames: ''!

!NationalCall class methodsFor: 'instance creation' stamp: 'FG 25/May/2026 22:06:41'!
withDuration: aDuration locality: aLocality andTimestamp: aTimestamp 
	^NationalCall new initializeWithDuration: aDuration locality: aLocality andTimestamp: aTimestamp.! !


!classDefinition: #Customer category: 'PhoneBilling'!
Object subclass: #Customer
	instanceVariableNames: 'calls'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!Customer methodsFor: 'initialize' stamp: 'FG 25/May/2026 16:18:32'!
initialize
	calls := OrderedCollection new.! !

!Customer methodsFor: 'initialize' stamp: 'FG 25/May/2026 22:19:07'!
initializeWithCalls: aCollectionOfCalls

	self initialize.
	calls addAll: aCollectionOfCalls.! !


!Customer methodsFor: 'calls' stamp: 'FG 25/May/2026 16:31:32'!
calls
	^calls.! !

!Customer methodsFor: 'calls' stamp: 'FG 25/May/2026 22:21:15'!
hasCallCount: aCallCount 
	^calls size = aCallCount.! !

!Customer methodsFor: 'calls' stamp: 'FG 25/May/2026 21:46:59'!
makeInternationalCallWithDuration: aDuration andCountry: aCountry
	| call |
	call := InternationalCall withDuration: aDuration country: aCountry andTimestamp: DateAndTime now.
	calls add: call.! !

!Customer methodsFor: 'calls' stamp: 'FG 25/May/2026 21:56:03'!
makeLocalCallWithDuration: aDuration 
	| call |
	call := LocalCall withDuration: aDuration andTimestamp: DateAndTime now.
	calls add: call.! !

!Customer methodsFor: 'calls' stamp: 'FG 25/May/2026 22:01:00'!
makeNationalCallWithDuration: aDuration andLocality: aLocality
	| call |
	call := NationalCall withDuration: aDuration locality: aLocality andTimestamp: DateAndTime now.
	calls add: call.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'PhoneBilling'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'instance creation' stamp: 'FG 25/May/2026 22:21:59'!
withCalls: aCollectionOfCalls 
	^Customer new initializeWithCalls: aCollectionOfCalls.! !


!classDefinition: #Destination category: 'PhoneBilling'!
Object subclass: #Destination
	instanceVariableNames: 'name ratePerMinute'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!Destination methodsFor: 'billing' stamp: 'FG 25/May/2026 22:23:09'!
costForDuration: aDuration
	^aDuration * ratePerMinute.! !


!Destination methodsFor: 'initialize' stamp: 'FG 25/May/2026 16:34:05'!
initializeWithName: aName andRatePerMinute: aRate 
	name := aName.
	ratePerMinute := aRate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Destination class' category: 'PhoneBilling'!
Destination class
	instanceVariableNames: ''!

!Destination class methodsFor: 'instance creation' stamp: 'FG 25/May/2026 16:35:02'!
withName: aName andRatePerMinute: aRate 
	^Destination new initializeWithName: aName andRatePerMinute: aRate! !


!classDefinition: #PhoneBill category: 'PhoneBilling'!
Object subclass: #PhoneBill
	instanceVariableNames: 'totalCost'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!PhoneBill methodsFor: 'billing' stamp: 'FG 25/May/2026 22:29:22'!
addBillingFor: aCall 
	totalCost := totalCost + aCall billingCost.! !

!PhoneBill methodsFor: 'billing' stamp: 'FG 25/May/2026 22:28:35'!
initializeWithTotalCost: anAmount
	totalCost := anAmount.! !

!PhoneBill methodsFor: 'billing' stamp: 'FG 25/May/2026 22:26:04'!
summary
	^'Total billed: ', totalCost printString! !

!PhoneBill methodsFor: 'billing' stamp: 'FG 25/May/2026 22:24:01'!
totalCost
	^totalCost! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PhoneBill class' category: 'PhoneBilling'!
PhoneBill class
	instanceVariableNames: ''!

!PhoneBill class methodsFor: 'instance creation' stamp: 'FG 25/May/2026 22:28:22'!
withTotalCost: anAmount
	^PhoneBill new initializeWithTotalCost: anAmount.! !


!classDefinition: #PhoneBilling category: 'PhoneBilling'!
Object subclass: #PhoneBilling
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PhoneBilling class' category: 'PhoneBilling'!
PhoneBilling class
	instanceVariableNames: ''!

!PhoneBilling class methodsFor: 'demo' stamp: 'FG 26/May/2026 10:25:17'!
run
	| customer billingCalculator bill locality timestamp localCall |

	timestamp := DateAndTime
		year: 2026
		month: 5
		day: 24
		hour: 10
		minute: 0
		second: 0
		offset: 0 hours.

	localCall := LocalCall withDuration: 10 andTimestamp: timestamp.      		"Cost: 10 * 0.1 (Sunday) = 1"
	customer := Customer withCalls: {localCall}.
	
	locality := Destination withName: 'Cordoba' andRatePerMinute: 0.7.
	customer makeNationalCallWithDuration: 1 andLocality: locality.               		"Cost: 1 * 0.7 = 0.7"

	billingCalculator := BillingCalculator withMonthlyFee: 20.

	bill := billingCalculator calculateBillForMonth: 5 forCustomer: customer.		"Cost: 1 + 0.7 + 20 = 21.7"

	^ bill summary.! !


!classDefinition: #BillingTest category: 'PhoneBilling'!
TestCase subclass: #BillingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:32:19'!
test01BillForCustomerWithoutCallsShowsMonthlyFee
	| customer bill billingCalculator monthlyFee |
	
	monthlyFee := 20.
	customer := Customer new.
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	bill := billingCalculator calculateBillForMonth: 1 forCustomer: customer.
	
	self assert: bill totalCost = monthlyFee.! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:35:58'!
test02BillForCustomerWithOneLocalCallIncreasesMonthlyFee
	| customer bill billingCalculator monthlyFee |
	
	monthlyFee := 20.
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	customer := Customer new.
	customer makeLocalCallWithDuration: 4.
	
	bill := billingCalculator calculateBillForMonth: (DateAndTime now monthIndex) forCustomer: customer.
	
	self assert: bill totalCost > monthlyFee.! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:36:12'!
test03BillForCustomerWithLocalCallOnBusinessDayAt8AMIncreasesMonthlyFeeBy20CentsPerMinute
	| customer bill billingCalculator monthlyFee timestamp call duration callCost |
	
	duration := 5.
	monthlyFee := 20.
	callCost := duration * 0.2.
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	timestamp := DateAndTime year: 2026 
								month: 5
								day: 18
								hour: 8
								minute: 0
								second: 0
								offset: 0 hours.
								
	call := LocalCall withDuration: duration andTimestamp: timestamp.
	
	customer := Customer withCalls: {call}.
	
	bill := billingCalculator calculateBillForMonth: (timestamp monthIndex) forCustomer: customer.
	
	self assert: bill totalCost = (monthlyFee + callCost).! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:36:23'!
test04BillForCustomerWithLocalCallOnBusinessDayAt9PMIncreasesMonthlyFeeBy10CentsPerMinute
	| customer bill billingCalculator monthlyFee timestamp call duration callCost |
	
	duration := 5.
	monthlyFee := 20.
	callCost := duration * 0.1.
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	timestamp := DateAndTime year: 2026 
								month: 5
								day: 18
								hour: 21
								minute: 0
								second: 0
								offset: 0 hours.
								
	call := LocalCall withDuration: duration andTimestamp: timestamp.
	
	customer := Customer withCalls: {call}.
	
	bill := billingCalculator calculateBillForMonth: (timestamp monthIndex) forCustomer: customer.
	
	self assert: bill totalCost = (monthlyFee + callCost).! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:38:13'!
test05BillForCustomerWithLocalCallOnWeekendIncreasesMonthlyFeeBy10CentsPerMinute
	| customer bill billingCalculator monthlyFee timestamp call duration callCost |
	
	duration := 5.
	monthlyFee := 20.
	callCost := duration * 0.1.
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	timestamp := DateAndTime year: 2026 
								month: 5
								day: 24
								hour: 9
								minute: 0
								second: 0
								offset: 0 hours.
								
	call := LocalCall withDuration: duration andTimestamp: timestamp.
	
	customer := Customer withCalls: {call}.
	
	bill := billingCalculator calculateBillForMonth: (timestamp monthIndex) forCustomer: customer.
	
	self assert: bill totalCost = (monthlyFee + callCost).! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:38:49'!
test06BillForCustomerWithoutCallsInBillingMonthDoesNotIncreaseMonthlyFee
	| customer bill billingCalculator monthlyFee timestamp call |
	
	monthlyFee := 20.
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	timestamp := DateAndTime year: 2026 
								month: 5
								day: 24
								hour: 9
								minute: 0
								second: 0
								offset: 0 hours.
								
	call := LocalCall withDuration: 5 andTimestamp: timestamp.
	
	customer := Customer withCalls: {call}.
	
	bill := billingCalculator calculateBillForMonth: 1 forCustomer: customer.
	
	self assert: bill totalCost = monthlyFee.! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:39:35'!
test07BillForCustomerWithNationalCallIncreasesMonthlyFeeAccordingToLocality
	| customer bill billingCalculator monthlyFee timestamp call duration callCost locality localityRatePerMinute |
	
	duration := 5.
	monthlyFee := 20.
	localityRatePerMinute := 0.2.
	callCost := duration * localityRatePerMinute.
	
	locality := Destination withName: 'Córdoba' andRatePerMinute: localityRatePerMinute.
	
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	timestamp := DateAndTime year: 2026 
								month: 5
								day: 24
								hour: 9
								minute: 0
								second: 0
								offset: 0 hours.
								
	call := NationalCall withDuration: duration locality: locality andTimestamp: timestamp.
	
	customer := Customer withCalls: {call}.
	
	bill := billingCalculator calculateBillForMonth: (timestamp monthIndex) forCustomer: customer.
	
	self assert: bill totalCost = (monthlyFee + callCost).! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:41:45'!
test08BillForCustomerWithInternationalCallIncreasesMonthlyFeeAccordingToCountry
	| customer bill billingCalculator monthlyFee timestamp call duration callCost country countryRatePerMinute |
	
	duration := 5.
	monthlyFee := 20.
	countryRatePerMinute := 5.
	callCost := duration * countryRatePerMinute.
	
	country := Destination withName: 'Inglaterra' andRatePerMinute: countryRatePerMinute.
	
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	timestamp := DateAndTime year: 2026 
								month: 5
								day: 24
								hour: 9
								minute: 0
								second: 0
								offset: 0 hours.
								
	call := InternationalCall withDuration: duration country: country andTimestamp: timestamp.
	
	customer := Customer withCalls: {call}.
	
	bill := billingCalculator calculateBillForMonth: (timestamp monthIndex) forCustomer: customer.
	
	self assert: bill totalCost = (monthlyFee + callCost).! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:51:34'!
test09BillWithoutCallsCanBeDisplayed
	| customer bill billingCalculator monthlyFee representation |
	
	monthlyFee := 20.
	customer := Customer new.
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	bill := billingCalculator calculateBillForMonth: 1 forCustomer: customer.
	
	representation := bill summary.
	
	self assert: representation = 'Total billed: 20'.! !

!BillingTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:51:42'!
test10BillWithCallsCanBeDisplayed
	| customer bill billingCalculator monthlyFee timestamp call duration callCost representation totalCost expectedRepresentation |
	
	duration := 5.
	monthlyFee := 20.
	callCost := duration * 0.2.
	totalCost := monthlyFee + callCost.
	
	billingCalculator := BillingCalculator withMonthlyFee: monthlyFee.
	
	timestamp := DateAndTime year: 2026 
								month: 5
								day: 18
								hour: 8
								minute: 0
								second: 0
								offset: 0 hours.
								
	call := LocalCall withDuration: duration andTimestamp: timestamp.
	customer := Customer withCalls: {call}.
	
	bill := billingCalculator calculateBillForMonth: (timestamp monthIndex) forCustomer: customer.
	representation := bill summary.
	expectedRepresentation := 'Total billed: ', totalCost printString.
	
	self assert: representation = expectedRepresentation.! !


!classDefinition: #CustomerTest category: 'PhoneBilling'!
TestCase subclass: #CustomerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PhoneBilling'!

!CustomerTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:21:09'!
test01MakingLocalCallAddsCallToCustomerCallHistory
	| customer |
	
	customer := Customer new.
	customer makeLocalCallWithDuration: 4.
	
	self assert: (customer hasCallCount: 1).! !

!CustomerTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:21:09'!
test02MakingTwoLocalCallsAddsBothCallsToCustomerCallHistory
	| customer |
	
	customer := Customer new.
	customer makeLocalCallWithDuration: 4.
	customer makeLocalCallWithDuration: 4.
	
	self assert: (customer hasCallCount: 2).! !

!CustomerTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:21:09'!
test03MakingNationalCallAddsCallToCustomerCallHistory

	| customer locality |

	customer := Customer new.
	locality := Destination withName: 'Córdoba' andRatePerMinute: 0.1.

	customer makeNationalCallWithDuration: 5 andLocality: locality.

	self assert: (customer hasCallCount: 1).! !

!CustomerTest methodsFor: 'tests' stamp: 'FG 25/May/2026 22:55:21'!
test04MakingInternationalCallAddsCallToCustomerCallHistory

	| customer country |

	customer := Customer new.
	country := Destination withName: 'England' andRatePerMinute: 5.

	customer makeInternationalCallWithDuration: 5	 andCountry: country.

	self assert: (customer hasCallCount: 1).! !
