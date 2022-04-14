<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Esquema de Seguros por Cuota</title>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/catFrecuenciasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/esquemaSeguroServicio.js"></script>
	<script type="text/javascript" src="js/originacion/esquemaSeguro.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="esquemaSeguro">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Esquema de Seguros por Cuota</legend>
				<table border="0" width="100%">
					<tr>
						<td class="label"><label for="lblProductoCredito">Producto de Cr&eacute;dito: </label></td>
						<td>
							<form:input id="producCreditoID" name="producCreditoID" path="producCreditoID" size="12" tabindex="2" iniforma="false" maxlength="11" /> <input type="text" id="descripProducto" name="descripProducto" size="50" type="text" readOnly="true" disabled="true" iniforma="false" />
							<select id="frecuenciaBase" name="frecuenciaBase" style="display: none"></select>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<div id="gridDetalleDiv"></div>
						</td>
					</tr>
					<tr>
						<td align="right" colspan="5"><input id="grabar" type="button" class="submit" value="Grabar" tabindex="999" /> <input id="tipoTransaccion" type="hidden" name="tipoTransaccion" value="1" /> <input id="detalle" type="hidden" name="detalle" /></td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="ejemploArchivo" style="display: none"></div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;overflow:">
	<input type="hidden" size = "5" id="estatusProducCredito" name="estatusProducCredito"/>
		<div id="elementoLista"></div>
	</div>
	<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
		<div id="elementoListaCte"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>