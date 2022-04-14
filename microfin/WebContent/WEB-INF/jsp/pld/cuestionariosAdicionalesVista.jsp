<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="js/pld/cuestionariosAdicionales.js"></script>
	</head>
<body>
<br>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
		<legend class="ui-widget ui-widget-header ui-corner-all">Cuestionarios Adicionales</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cliente"  target="_blank">
			<table>
				<tr>
					<td>
						<label for="clienteID"> Cliente:</label>
					</td>
					<td>
						<form:input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1"  />
						<form:input id="nombreCompleto" name="nombreCompleto" path="nombreCompleto"  size="60" readonly="true" readOnly="true" />
					</td>
				</tr>
				<tr>
					<td>
						<label>Nivel de Riesgo:</label>
					</td>
					<td>
						<input type="text" id="nivelDeRiesgo" size="50" readonly="true" readOnly="true" />
						<form:input type="hidden" id="nivelRiesgo" name="nivelRiesgo" path="nivelRiesgo" size="10" />
					</td>
				</tr>
				<tr>
					<td>
						<label>Tipo de Persona:</label>
					</td>
					<td>
						<input type="text" id="tipoPer" size="50" readonly="true" readOnly="true" />
						<form:input type="hidden" id="tipoPersona" name="tipoPersona" path="tipoPersona" size="10" />
					</td>
				</tr>
			</table>
			<table align="right">
					<tr>
						<td align="right">
								<input type="button" id="imprimir" name="imprimir" class="submit" 
								value="Imprimir" tabindex="2" />
						</td>
					</tr>
				</table>
		</form:form>	
	</fieldset>
</div>
<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>