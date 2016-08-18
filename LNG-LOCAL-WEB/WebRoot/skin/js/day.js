//һ�캬 86,400,000 ����(24* 60 * 60*1000)
//����
function showToDay()
{
	var Nowdate = new Date();
	M = Number(Nowdate.getMonth()) + 1;
	return Nowdate.getFullYear() + "-" + M + "-" + Nowdate.getDate();
}

//���ܵ�һ��
function showWeekFirstDay()
{
	var Nowdate = new Date();
	var WeekFirstDay = new Date(Nowdate-(Nowdate.getDay()-1)*86400000);
	return WeekFirstDay;
}

//�������һ��
function showWeekLastDay()
{
	var Nowdate = new Date();
	var WeekFirstDay = new Date(Nowdate-(Nowdate.getDay()-1)*86400000);
	var WeekLastDay = new Date((WeekFirstDay/1000+6*86400)*1000);
	return WeekLastDay;
}

//���µ�һ��
function showMonthFirstDay()
{
	var Nowdate = new Date();
	var MonthFirstDay = new Date(Nowdate.getFullYear(),Nowdate.getMonth(),1);
	return MonthFirstDay;
}

//�������һ��
function showMonthLastDay()
{
	var Nowdate = new Date();
	var MonthNextFirstDay = new Date(Nowdate.getFullYear(),Nowdate.getMonth()+1,1);
	var MonthLastDay = new Date(MonthNextFirstDay-86400000);
	return MonthLastDay;
}

//���µ�һ��
function showPreviousFirstDay()
{
	var MonthFirstDay = showMonthFirstDay();
	return new Date(MonthFirstDay.getFullYear(),MonthFirstDay.getMonth()-1,1);
}

//�������һ��
function showPreviousLastDay()
{
	var MonthFirstDay = showMonthFirstDay();   
	return new Date(MonthFirstDay-86400000);   
}   

//���ܵ�һ��   
function showPreviousFirstWeekDay()   
{   
	var WeekFirstDay = showWeekFirstDay();
	return new Date(WeekFirstDay-86400000*7);
}   

//�������һ��   
function showPreviousLastWeekDay()   
{   
	var WeekFirstDay = showWeekFirstDay();
	return new Date(WeekFirstDay-86400000);
}   

//��һ��   
function showPreviousDay()   
{   
	var MonthFirstDay = new Date();   
	return new Date(MonthFirstDay-86400000);
}   

//��һ��   
function showNextDay()   
{   
	var MonthFirstDay = new Date();
	return new Date((MonthFirstDay/1000+86400)*1000);   
}   

//���ܵ�һ��   
function showNextFirstWeekDay()   
{   
	var MonthFirstDay = showWeekLastDay();
	return new Date((MonthFirstDay/1000+86400)*1000);
}

//�������һ��
function showNextLastWeekDay()   
{   
	var MonthFirstDay = showWeekLastDay();
	return new Date((MonthFirstDay/1000+7*86400)*1000);
}

//���µ�һ��
function showNextFirstDay()   
{   
	var MonthFirstDay = showMonthFirstDay();
	return new Date(MonthFirstDay.getFullYear(),MonthFirstDay.getMonth()+1,1);
}

//�������һ��
function showNextLastDay()
{   
	var MonthFirstDay=showMonthFirstDay();
	return new Date(new Date(MonthFirstDay.getFullYear(),MonthFirstDay.getMonth()+2,1)-86400000);   
}

//��ȡ�������һ������
function getFirstAndLastMonthDay(year, month)
{
 	var firstdate = year + '-' + month + '-01';
 	var day = new Date(year, month, 0);
 	var lastdate = year + '-' + month + '-' + day.getDate();
 	return lastdate;
}

Date.prototype.toString = function() 
{
	return this.getFullYear()+"-"+(this.getMonth()+1)+"-"+this.getDate();
}