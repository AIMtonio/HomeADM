<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/paramTarjetasServicio.js"></script>
		<script type="text/javascript" src="js/tarjetas/paramAutorizacionTercerosVista.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramTarjetasBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros Autorizaci&oacute;n Terceros.</legend>
					<table width="100%">
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="usuario"> Compa&ntilde;ia: </label>
							</td>
							<td nowrap="nowrap">
								<input type="text" id="companiaID" name="companiaID" size="50" maxlength="200" tabindex="1" autocomplete="off" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="emisorID"> ID Del Emisor: </label>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" id="llaveEmisorID" name="listaLlaveParametro"/>
								<input type="text" id="valorEmisorID" name="listaValorParametro" size="50" maxlength="11" tabindex="2" autocomplete="off" onkeypress="return ingresaSoloNumeros(event,1,this.id);" />
							</td>
						</tr>
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="url"> Prefijo Emisor: </label>
							</td>
							<td nowrap="nowrap">
								<input type="hidden" id="llavePrefijoEmisor" name="listaLlaveParametro"/>
								<input type="text" id="valorPrefijoEmisor" name="listaValorParametro" size="50" maxlength="200" tabindex="2" autocomplete="off" onBlur="ponerMayusculas(this)" />
							</td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="guardar" name="actualizacion" class="submit" tabindex="18" value="Guardar"/>
								<input type="hidden" id="tipoActualizacion" name="tipoActualizacion" value="0"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"  value="0" />
							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		 </div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>