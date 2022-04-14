	<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> 
	<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
	<%@page contentType="text/html"%> 
	<%@page pageEncoding="UTF-8"%>
	<html>
	<head> 
	    <script type="text/javascript" src="js/pld/operVulnerablesVista.js"></script>
	</head>

	<body>

	<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operVulnerablesBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Actividades Vulnerables</legend>			
	<legend class="ui-widget"></legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="label"> 
		        	<label for="mes">Año</label>
		     	</td>
		     	<td>
		     		<select id="anio" name="anio"></select> 
		     	</td>
		     	<td class="separador"></td>
	     	</tr>

	     	<tr>
	     		<td class="label"> 
		        	<label for="mes">Mes</label>
		     	</td>
		     	<td>
		     		<select id="mes" name="mes">
		     			<option value="01">ENERO</option>
		     			<option value="02">FEBRERO</option>
		     			<option value="03">MARZO</option>
		     			<option value="04">ABRIL</option>
		     			<option value="05">MAYO</option>
		     			<option value="06">JUNIO</option>
		     			<option value="07">JULIO</option>
		     			<option value="08">AGOSTO</option>
		     			<option value="09">SEPTIEMBRE</option>
		     			<option value="10">OCTUBRE</option>
		     			<option value="11">NOVIEMBRE</option>
		     			<option value="12">DICIEMBRE</option>
		     		</select> 
		     	</td>
	     	</tr>
		</table>
		<table align="right">
			<tr>
				<td align="right">
					<a id="ligaGenerar" target="_blank">
						<input type="button" id="generar" name="generar" class="submit" tabindex="5" value="Generar XML">
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