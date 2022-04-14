<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head> 
    <script type="text/javascript" src="js/contabilidad/estatusTimbradoProdVista.js"></script>
</head>

<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="estatusTimbradoProdBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">	
<legend class="ui-widget ui-widget-header ui-corner-all">Estatus de Timbrado por Producto</legend>			
<legend class="ui-widget"></legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label"> 
	        	<label for="observacion">Año</label>
	        	<select id="anio" name="anio"></select> 
	     	</td>
     	</tr>
     	<tr>
     		<td>
     			<div id="gridProductos"></div>
     		</td>
     	</tr>
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<a id="ligaGenerar">
					<input type="button" id="generar" name="generar" class="submit" tabindex="5" value="Generar">
				</a>
			</td> 
		</tr>
	</table>
</fieldset>	 
</form:form>
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
	<div id="elementoListaCte"></div>
</div>
</body>
<div id="mensaje" style="display:none;"></div> 
  
</html>