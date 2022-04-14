<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/utileriaServicio.js"></script>
		<script type="text/javascript" src="js/ventanilla/tiraAuditora.js"></script>
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

	</head>
<body>

<div id="contenedorForma">
<form:form method="post" id="formaGenerica" name="formaGenerica" commandName="cajasVentanillaBean" >
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Tira Auditora</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	 	<tr>
	 		<td class="label">
				<label for="lblFecha">Fecha:</label>
			</td>
			<td>
				<input type="text" id="fecha" name="fecha" tabindex="1" path="fecha" size="10"  autocomplete="off" esCalendario="true" />
			</td>
			<td>
				<label>Sucursal:</label>
			</td>
			<td>
				<input type="text" id="nomSucursal" name="nomSucursal" disabled="true" style="display:none">
				<form:select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="2">
					<form:option value="0">Todas</form:option>
				</form:select>
			</td>
		</tr>
		<tr>
			<td>
				<label>Moneda:</label>
			</td>
			<td>
				<form:select id="monedaID" name="monedaID" path="monedaID" tabindex="3" disabled="true">
					<form:option value="0">Todas</form:option>
				</form:select>
			</td>
			<td class="label">
				<label>Caja:</label>
			</td>
			<td>
				<form:input id="cajaID" name="cajaID" path="cajaID" size="12" tabindex="4" />
				<input type="text" id="descripcionCaja" name="descripcionCaja" size="35" disabled="true" />
			</td>
		</tr>
	</table>
	<table align="right">
			<tr>
				<td align="right">
					<input type="button" id="consultar" name="consultarMovs" class="submit" value="ConsultarMovs" tabindex="5"/>
					<button type="button" class="submit" id="generar" tabindex="6" style="">Imprimir Tira </button> 
					<button type="button" class="submit" id="pdf" tabindex="7" style="">Exp.Tira PDF</button> 
				 	<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="nombreInstitucion" name="nombreInstitucion"/>					
					<input type="hidden" id="numUsuario" name="numUsuario"/>
					<input type="hidden" id="nomUsuario" name="nomUsuario"/>
					<input type="hidden" id="fechaSistemaP" name="fechaSistemaP"/>
					<input type="hidden" id="hora" name="hora"/>
				</td>
			</tr>

	</table>
	<br><br>
	<div id="gridMovimientos" style="display:none">
		<form id="gridDetalle" name="gridDetalle">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend>Reporte de Arqueo a Caja</legend>
					<table> 
						<tr>
							<td onclick="muestra_oculta('gridDetalleMovsEntrada');" class="label" nowrap="nowrap">
								<label style="color: #5C9CCC"><b>MOVIMIENTOS DE ENTRADA / ORIGEN</b></label></td>
						</tr>
 
						<tr id="gridDetalleMovsEntrada"></tr>
						<tr>
							   
							<td onclick="muestra_oculta('gridDetalleMovsSalida');" class="label"><label style="color: #5C9CCC"><b>MOVIMIENTOS DE SALIDA / APLICACION</b></label></td>
						</tr>
						<tr id="gridDetalleMovsSalida"></tr>
					</table>
			</fieldset>
		</form>
	</div>
	</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>