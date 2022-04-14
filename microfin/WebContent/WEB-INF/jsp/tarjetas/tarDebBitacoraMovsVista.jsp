<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>		
 	  	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/tarDebBitacoraMovsServicio.js"></script> 
     	 <script type="text/javascript" src="js/tarjetas/tarDebBitacoraMovs.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarDebBitacoraMovsBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<legend class="ui-widget ui-widget-header ui-corner-all">Check Out Para Transacciones POS </legend>
		
	<div id="gridCheckOut">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="label">Movimientos</legend>
		
				<input type="hidden" id="numCheckOut" name="numCheckOut" />
				<table id="tableCheckOut" border="0" cellpadding="0" cellspacing="0" width="100%">	
				</table>
		</fieldset>
	</div>	
	
	<table width="100%">
		<tr>
			<td align="right">		
				<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="47"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>		
	</table>
 </fieldset>		
</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>