<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

<head>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/fwProductosCreditosServicio.js)"></script>
	<script type="text/javascript" src="js/formularioWeb/productosFWCatalogo.js"></script>
</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" pcommandName="productosCreditoFWBean">

	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros Formulario Web</legend>
		
		<div id="gridProductosCreditos" style="display: none;"></div>
		
		<br>
		
		<table align="right">
			<tr>
				<td align="right">				
					<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="100"/>
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
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>

</body>
<div id="mensaje" style="display: none;"></div>