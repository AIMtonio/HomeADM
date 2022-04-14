<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/engine.js"></script>
		<script type="text/javascript" src="dwr/util.js"></script>
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/asignaCartaLiqServicio.js"></script>
	 	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/casasComercialesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cartaLiquidacionServicio.js"></script>
		<script type="text/javascript" src="js/originacion/asignaCartaLiq.js"></script>
		
	</head>

	<body>
	<div id="contenedorForma">

		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Asignaci&oacute;n de Cartas de Liquidaci&oacute;n</legend>
			
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="asignaCarta">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<!-- Cabecera de la cosolidacion -->
					<tr>
						<td class="label">
			         		<label id="Consolida" for="lblConsolida">Consolidaci&oacute;n: </label>
			     		</td>
			     		<td>
							<input type= "text" id="consolidacionCartaID" name="consolidacionID" size="10" tabindex="1" iniforma="false"/>
							
							<input type= "hidden" id="estatus" name="estatus" readOnly="true" disabled = "true" iniforma="false"/>
							<input type= "hidden" id="esConsolidado" name="esConsolidado" readOnly="true" disabled = "true" iniforma="false"/>
	  						<input type= "hidden" id="tipoCredito" name="tipoCredito" readOnly="true" disabled = "true" iniforma="false"/>
	  						<input type= "hidden" id="relacionado" name="relacionado" readOnly="true" disabled = "true" iniforma="false"/>
	  						<input type= "hidden" id="montoConsolida" name="montoConsolida" readOnly="true" disabled = "true" iniforma="false"/>
	  						<input type= "hidden" id="rutaFiles" name="rutaFiles" readOnly="true" disabled = "true" iniforma="false"/>
	  					</td>
					</tr>
					
					<!-- Ver folio de la solicitud de credito -->
					<tr>
						<td>
							<label id="labelSolicitud" for="lblSolicitud">Solicitud Cr&eacute;dito: </label>
						</td>
						<td>
							<form:input type="text" id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="10" readOnly="true" disabled = "true" iniforma="false"/>
						</td>
						
					</tr>
					
					<tr>
						<td class="label">
			         		<label id="labelCliente" for="lblCliente">Cliente: </label>
			     		</td>
			     		<td>
							<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="10" tabindex="2" iniforma="false"/>
							<input type= "text" id="nombreCliente" name="nombreCliente"size="50" tabindex="3" readOnly="true" disabled = "true" iniforma="false"/>
	  					</td>
					</tr>
				</table>
				<table align="right">
					<tr>
						<td align="right">
							<input type="button" id="grabar" name="grabar" class="submit" value="Guardar" tabindex="4" />
							<input id="detalleCartas" type="hidden" name="detalleCartas" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							<input type="hidden" id="registroAdjunto" name="registroAdjunto"/>
						</td>
					</tr>
				</table>
				<div id="gridCartaLiq"></div>
			</form:form>
			<!--<form:form id="formaGenericaExt" name="formaGenericaExt" method="POST" action="/microfin/asignaCartasExt.htm" commandName="asignaCartaExt">
				<div id="gridCartaLiq"></div>
			</form:form>-->
			<form:form id="formaGenerica2" name="formaGenerica2" method="POST" action="/microfin/asignaCartasInt.htm" commandName="asignaCartaInt">
			<div id="gridCartaLiqInt"></div>
			</form:form>
		</fieldset>
	</div>
	
	<div id="cargando" style="display: none;"></div>
	
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>