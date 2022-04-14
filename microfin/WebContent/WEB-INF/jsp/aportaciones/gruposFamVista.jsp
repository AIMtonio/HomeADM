<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/gruposFamiliarServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/gruposFamiliarServicio.js"></script>
	<script type="text/javascript" src="js/aportaciones/gpoFamiliarAport.js"></script>
	<script type="text/javascript" src="js/utileria.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="gruposFamiliarBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Grupo Familiar</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap">
							<label for="clienteID"><s:message code="safilocale.cliente"/>:</label>
						</td>
						<td>
							<form:input type='text' id="clienteID" name="clienteID" path="" size="15" tabindex="3"/>
							<input type='text' id="clienteIDDes" name="clienteIDDes" size="45" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td colspan="5" valign="top">
							</br>
							<div id="gridGrupoFam"></div>
							<table style="margin-left:auto;margin-right:0px">
								<tr>
									<td nowrap="nowrap">
										<input type="button" class="submit" value="Grabar" id="grabar" tabindex="601" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<input id="detalle" type="hidden" name="detalle" />
							<input id="tipoTransaccion" type="hidden" name="tipoTransaccion" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height=150px;"></div>
	<div id="elementoListaCte"></div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>