<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/reimpresionTicketServicio.js"></script>
<script type="text/javascript" src="dwr/interface/opcionesPorCajaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/amortizacionCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/utileriaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/arrendamientoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/reimpresionTicketServicio.js"></script>
<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="js/ventanilla/reimpresionTicket.js"></script>
<script>
	if(parametroBean.tipoImpresoraTicket == 'A'){
		importarScriptSAFI('js/soporte/impresoraTicket.js');
	}
	if(parametroBean.tipoImpresoraTicket == 'S'){
		if(applet == null){
			importarScriptSAFI('js/WebSocketImpresion.js');
			importarScriptSAFI('js/soporte/impresoraTicketSck.js');
		}
		
	}	
</script>
<script type="text/javascript" src="js/ventanilla/impresionReTicketGeneral.js"></script>
<script type="text/javascript" src="js/ventanilla/impresionTickets.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<input type="hidden" id="socioClienteAlert" name="socioClienteAlert" value="<s:message code="safilocale.cliente"/>" />
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reimpresionTicket">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reimpresi&oacute;n de Tickets</legend>
				<table border="0">
					<tr>
						<td class="label">
							<label for="tipoOpera">Tipo de Operaci&oacute;n: </label>
						</td>
						<td>
							<select id="tipoOpera" name="tipoOpera" tabindex="1">
								<option value="">SELECCIONAR</option>
							</select>
						</td>
						<td class="separador"></td>
						<td class="label">
							<label for="numTransaccion">N&uacute;mero de Transacci&oacute;n: </label>
						</td>
						<td>
							<input type="text" id="numTransaccion" name="numTransaccion" size="15" tabindex="2" />
							<br />
						</td>
					</tr>
				</table>
				<div id="gridReimpresion"></div>
				<table style="width: 100%;">
					<tr>
						<td align="right">
							<input type="button" id="reimprimir" name="reimprimir" class="submit" value="Reimprimir" tabindex="10" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>