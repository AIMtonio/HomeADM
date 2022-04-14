<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<script type="text/javascript" src="dwr/interface/segtoManualServicio.js"></script>
	<script type="text/javascript" charset="utf-8" src="js/seguimiento/calSeguimiento.js"></script>
	
  	<link rel="stylesheet" href="css/jcalendar.css" type="text/css" media="screen" charset="utf-8">
  	<script type="text/javascript" charset="utf-8">
    $(document).ready(function() {
      $('fieldset.jcalendar').jcalendar();
    });
  </script>
</head>
<body>
	<fieldset class="ui-widget ui-widget-content ui-corner-all"  >
	<legend class="ui-widget ui-widget-header ui-corner-all"  >Calendario de Seguimiento</legend>
<table border="0" cellpadding="0" cellspacing="5px" width="1000px" >
	<tr>
		<td width="535px">

			<div id="wrapper">
			    <form>
			    <fieldset class="jcalendar">
			       <div class="jcalendar-wrapper">
			       <div class="jcalendar-selects">
			        <select name="day" id="day" class="jcalendar-select-day">
			           <option value="0"></option>
			           <option value="1">1</option>
			           <option value="2">2</option>
			           <option value="3">3</option>
			           <option value="4">4</option>
			           <option value="5">5</option>
			           <option value="6">6</option>
			           <option value="7">7</option>
			           <option value="8">8</option>
			           <option value="9">9</option>
			           <option value="10">10</option>
			           <option value="11">11</option>
			           <option value="12">12</option>
			           <option value="13">13</option>
			           <option value="14">14</option>
			           <option value="15">15</option>
			           <option value="16">16</option>
			           <option value="17">17</option>
			           <option value="18">18</option>
			           <option value="19">19</option>
			           <option value="20">20</option>
			           <option value="21">21</option>
			           <option value="22">22</option>
			           <option value="23">23</option>
			           <option value="24">24</option>
			           <option value="25">25</option>
			           <option value="26">26</option>
			           <option value="27">27</option>
			           <option value="28">28</option>
			           <option value="29">29</option>
			           <option value="30">30</option>
			           <option value="31">31</option>
			         </select>
			         <select name="month" id="month" class="jcalendar-select-month">
			           <option value="0"></option>
			           <option value="1">Enero</option>
			           <option value="2">Febrero</option>
			           <option value="3">Marzo</option>
			           <option value="4">Abril</option>
			           <option value="5">Mayo</option>
			           <option value="6">Junio</option>
			           <option value="7">Julio</option>
			           <option value="8">Agosto</option>
			           <option value="9">Septiembre</option>
			           <option value="10">Octubre</option>
			           <option value="11">Noviembre</option>
			           <option value="12">Diciembre</option>
			         </select>
			         <select name="year" id="year" class="jcalendar-select-year">
			           <option value="0"></option>
			           <option value="1982">1982</option>
			           <option value="1983">1983</option>
			           <option value="1984">1984</option>
			           <option value="1985">1985</option>
			           <option value="1986">1986</option>
			           <option value="1987">1987</option>
			           <option value="1988">1988</option>
			           <option value="1989">1989</option>
			           <option value="1990">1990</option>
			           <option value="1991">1991</option>
			           <option value="1992">1992</option>
			           <option value="1993">1993</option>
			           <option value="1994">1994</option>
			           <option value="1995">1995</option>
			           <option value="1996">1996</option>
			           <option value="1997">1997</option>
			           <option value="1998">1998</option>
			           <option value="1999">1999</option>
			           <option value="2000">2000</option>
			           <option value="2001">2001</option>
			           <option value="2002">2002</option>
			           <option value="2003">2003</option>
			           <option value="2004">2004</option>
			           <option value="2005">2005</option>
			           <option value="2006">2006</option>
			           <option value="2007">2007</option>
			           <option value="2008">2008</option>
			           <option value="2009">2009</option>
			           <option value="2010">2010</option>
			           <option value="2011">2011</option>
			           <option value="2012">2012</option>
			           <option value="2013">2013</option>
			           <option value="2014">2014</option>
			           <option value="2015">2015</option>
			           <option value="2016">2016</option>
			           <option value="2017">2017</option>
			           <option value="2018">2018</option>
			           <option value="2019">2019</option>
			           <option value="2020">2020</option>
			           <option value="2021">2021</option>
			           <option value="2022">2022</option>
			           <option value="2023">2023</option>
			           <option value="2024">2024</option>
			           <option value="2025">2025</option>
			           <option value="2026">2026</option>
			           <option value="2027">2027</option>
			           <option value="2028">2028</option>
			           <option value="2029">2029</option>
			           <option value="2030">2030</option>
			           <option value="2031">2031</option>
			           <option value="2032">2032</option>
			         </select>
			       </div>
			       </div>
			    </fieldset>
			    </form>
			  </div>
		</td>
		<td  valign="top">
			<div id = "listaPrev" >
			</div>
		</td>
	</tr>
	<tr>
		<td colspan = "2">	
			<input type="hidden" id="consultaID" value="0">
			<div id = "listaDetalle">
			</div>
		</td>
	</tr>
</table>
<input type="hidden" id="listaActividades" >

<!-- 	<div id="menuContextualPropio"> -->
<!-- 		<ul> -->
<!-- 			<li id="menu_anterior">Anterior</li> -->
<!-- 			<li id="menu_siguiente" class="disabled">Siguiente</li> -->
<!-- 			<li id="menu_recargar">Recargar</li> -->
<!-- 			<li id="menu_web"><a href="http://web.ontuts.com">Visitar web.ontuts</a></li> -->
<!-- 			<li id="menu_favoritos">Agregar a favoritos...</li> -->
<!-- 		</ul> -->
<!-- 	</div> -->
	
</fieldset>
</body>
</html>