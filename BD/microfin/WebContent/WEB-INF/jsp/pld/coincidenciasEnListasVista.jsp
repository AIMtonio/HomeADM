<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/pld/coincidenciasListas.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargaListasPLDBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend
					class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Coincidencias en Listas</legend>

				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="tipoLista">Tipo de Lista:</label>
						</td>
						<td nowrap="nowrap">
							<form:radiobutton id="tipoListaN" name="tipoLista"  tabindex="15" path="tipoLista" value="N" checked="checked"/>
								<label for="tipoListaN">Listas Negras</label>

							<form:radiobutton id="tipoListaB" name="tipoLista"  tabindex="16" path="tipoLista" value="B" />
								<label for="tipoListaB">Lista de Personas Bloq.</label>
						</td>
					</tr>
				</table>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<div class="label">
								<label style="width: 520px; text-align:justify; display: inline-block;"></br><b>Nota: </b>Este proceso realiza la b&uacute;squeda de <s:message code="safilocale.cliente"/>s en Listas Negras o Lista de Personas Bloqueadas de manera masiva de acuerdo a la &uacute;ltima actualizaci&oacute;n hecha desde la <b>Carga de Listas</b>.</br> </br>Tenga en cuenta que este proceso puede tardar varios minutos dependiendo del n&uacute;mero de registros en las listas PLD y el n&uacute;mero de <s:message code="safilocale.cliente"/>s activos.</label>
							</div>
						</td>
					</tr>
					<table width="100%">
						<tr>
							<td>
								<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="7" style="float: right;"/> 
								<input type="hidden" id="numError" name="numError" size="10" tabindex="4" disabled="true"/>
      							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1" />	
      							<input type="hidden" id="masivo" name="masivo" value="S"  />	
							</td>
						</tr>
					</table>
				</table>
			</fieldset>
		</form:form>
		</div>
		<div id="ejemploArchivo" style="display: none"></div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>