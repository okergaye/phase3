If Blank it will not be considered.
	<p>Category</p>
	<form name="user_search" method=get onsubmit="orders()" action="orders.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="cate">
	<p>Address (City, State)</p>
	<form name="user_search" method=get onsubmit="orders()" action="orders.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="address">
	<p>Car Model</p>
	<form name="user_search" method=get onsubmit="orders()" action="orders.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="model">
	<p>Sorting Order</p>
	<p>(A) Average Numerical Score of Feedbacks</p>
	<p>(B) Average Numerical Score of Trusted User Feedbacks</p>
	<input type=submit name="sort" value = "A">
	<input type=submit name="sort" value = "B">
	</form>