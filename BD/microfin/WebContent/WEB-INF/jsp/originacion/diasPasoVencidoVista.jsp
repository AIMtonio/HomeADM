<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/diasPasoVencidoServicio.js"></script>
		<script type="text/javascript" src="js/originacion/diasPasoVencido.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="diasPasoVencido">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Dias Paso Vencido</legend>	
	<br>
	 	<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
					<label for="lblProductoCredito">Producto de Crédito: </label> 
				</td>
				<td> 
	       			 <form:select id="producCreditoID" name="producCreditoID" path="producCreditoID" tabindex="10" type="select" >
						<form:option value=" ">SELECCIONAR</form:option>
					</form:select>       					        	
				</td>	
			</tr>						
	 	</table>
		<div id="divDiasPasoVencido" style="display: none;"></div>		
	</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>