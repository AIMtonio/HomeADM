<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/nivelesRiesgoCatalogoPLD.js"></script>
<script type="text/javascript" src="js/pld/nivelesRiesgoCatalogo.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="nivelesRiesgoCatalog">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros de Niveles de Riesgo PLD</legend>
				<table>
					<tr>
						<td class="label"><label for="tipoPersona">Tipo Persona:</label></td>
						<td><select id="tipoPersona" name="tipoPersona" path="tipoPersona" tabindex="1">
								<option value="T">TODAS</option>
								<option value="F">FÍSICA</option>
								<option value="A">FÍSICA CON ACTIVIDAD EMPRESARIAL</option>
								<option value="M">MORAL</option>
						</select></td>
					</tr>
				</table>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Detalle</legend>
					<div id="gridNiveles">
						<input type="hidden" id="lisNiveles" name="lisNiveles" />
						<table id="tablaNiveles" border="0" cellpadding="0" cellspacing="0" width="100%">
						</table>
					</div>
				</fieldset>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label"><input type="checkbox" id="nivelActivoM" value="" name="nivelActivoM" onclick="inactivaNivel()" /> <label> Desactivar Nivel de Riesgo Medio </label></td>
					</tr>
					<tr>
						<td align="right"><input type="submit" id="guardar" name="guardar" class="submit" value="Grabar" tabindex="6" /> <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" /> <input type="hidden" id="listaNivelesPLD" name="listaNivelesPLD" /></td>
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