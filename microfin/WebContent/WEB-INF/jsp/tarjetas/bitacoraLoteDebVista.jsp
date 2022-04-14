<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript"	src="js/tarjetas/creaImportLoteTarjetas.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarjetaDebito">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Creación o Importación Lotes de Tarjetas</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label" colspan="3"><label for="fecha">Fecha:</label>
							<form:input id="fechaRegistro" name="fechaRegistro"  size="10" disabled="true" readonly="true" path="fechaRegistro" iniForma="false"/>
							<form:input type="hidden" id="sucursalID" name="sucursalID"  size="10" disabled="true" readonly="true" path="sucursalID" iniForma="false"/>
						</td>
						<td class="separador"></td>
						<td class="label" nowrap="nowrap">
							<label for="lblHabilitado">Maquilador en tipo de tarjeta: </label>
						</td>
						<td class="label">
							<input type="radio" id="habilitadoProsa" name="habilitadoProsa"  tabindex="1">
							<label>Prosa</label>
						</td>
						<td class="label">
							<input type="radio" id="habilitadoSAFI" name="habilitadoSAFI"  tabindex="2">
							<label>TGS</label>
						</td>
					</tr>
					<tr>
						<td class="label" id="tdImportar">
							<input type="radio" id="importar" name="importar"  tabindex="2">
							<label> Importar Lote de Tarjetas </label>
						</td>
					  	<td id="tdImportar1" class="separador"></td>
					  	<td class="label">
					  		<input type="radio" id="generar" name="generar"  value="generar" tabindex="3"  >
							<label> Generar Lote de Tarjetas </label>
						</td>
					</tr>
					<tr>
						<td class="label" colspan="3">
							<label for="ruta" id="rutalb">Ruta Archivo a Importar: </label>
							<input type="button" id="adjuntar" name="adjuntar" class="submit" value="Adjuntar" tabindex="4" />
							<input id="ruta" name="ruta"  size="40" disabled="true" readonly="true" >
							<input type="hidden" id="resultadoArchivoTran" name="resultadoArchivoTran"  size="15" disabled="true" readonly="true" >
							<input type="hidden" id="bitCargaID" name="bitCargaID" size="6"/>
						</td>
					
					</tr>
			
		<table border="0">
			<tr>				
			<td class="label">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label >Validación del archivo: </label></legend>
	
							<input id="regisCorrectos" name="regCorrectos"  size="4" disabled="true" readonly="true" value=""  tabindex="5" >
							<label for="regisCorrectos" id="regisCorrectos"> Registros Correctos </label>
									
							<input id="regIncorrectos" name="regIncorrectos"  size="4" disabled="true" readonly="true" value=""  tabindex="6" >
							<label  for="regIncorrectos" id="regisIncorrectos"> Registros Fallidos</label><br>
						
					<table align="center">
						<tr>
							<td colspan="4">
								<label for="tipoTarjetaDebID" id="tipTarjeta">Producto de Tarjeta: </label>
							</td>
							<td colspan="4">
								<select id="tipoTarjetaDebID" name="tipoTarjetaDebID" path="tipoTarjetaDebID"  tabindex="7" >
									<option value='0'>SELECCIONAR</option>
									 </select>	
							</td>
							<td class="separador"></td>
							<td>
								<label for="sucursalSolicita" id="sucursal">Sucursal Solicitante: </label>
							</td>
							<td colspan="4">
								<input type="text"  id="sucursalSolicita" name="sucursalSolicita" path="sucursalSolicita" size="10" maxlength="5" tabindex="8"/>
								<input type="text" id="desSucursal" name="desSucursal" size="35" disabled="true" />
							</td>
						</tr>	
						<tr>
							<td colspan="4">
								<label for="numTarjetas" id="numTarjeta">Número de Tarjetas a Generar: </label>

							</td>
							<td colspan="4" >
							 <input id="numTarjetas" name="numTarjetas" path="numTarjetas" size="12" maxlength="11" tabindex="9" type="text" style="text-align:right;"/>	
							</td>
							<td class="separador"></td>
							<td>
								<label for="esAdicional" id="adicional">Tipo de Tarjeta: </label>
							</td>
							<td colspan="4">
								<select id="esAdicional" name="esAdicional" path="esAdicional"  tabindex="10" >
									<option value=''>SELECCIONAR</option>
									<option value='N'>TITULAR</option>
									<option value='S'>ADICIONAL</option>
								</select>	
							</td>
						</tr>
						<tr id="trServiceCode">
							<td colspan="4">
								<label for="numeroServicio" id="catServiceCode">Código de Servicio: </label>
							</td>
							<td colspan="8">
								<select id="numeroServicio" name="numeroServicio" path="numeroServicio" tabindex="13" >
									<option value='000'>SELECCIONAR</option>
								</select>
							</td>
						</tr>
						<tr id="trLoteTarVirtual">
							<td colspan="4">
								<label for="esVirtual" id="loteTarVirtual">Lote de Tarjetas Virtual: </label>
							</td>
							<td colspan="4">
								<select id="esVirtual" name="esVirtual" path="esVirtual"  tabindex="14" >
									<option value=''>SELECCIONAR</option>
									<option value='S'>SI</option>
									<option value='N'>NO</option>
								</select>	
							</td>
						</tr>
						<tr>
							<td >
								<input type="hidden" id="folioInicial" name="folioInicial"  size="12" disabled="true" readonly="true" value="" >
							</td>
							<td >
								<input type="hidden" id="folioFinal" name="folioFinal"  size="12" disabled="true" readonly="true" value="" >
							</td>
						</tr>
							
					</table>		
	 				<table align="right">
					<tr>
						<td align="right">
							<input type="button" id="cancelar" name="cancelar" class="submit" value="Cancelar" tabindex="14" />
							<align="right"><input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="15"  style='height:25px;'/>
							<input type="button" id="verBitacora" name="verBitacora" class="submit" value="Ver Fallidos" tabindex="16" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
							<form:input type="hidden" id="loteDebitoID" name="loteDebitoID" size="6" path="loteDebitoID"/>		
							<form:input type="hidden" id="loteDebitoSAFIID" name="loteDebitoSAFIID" size="6" path="loteDebitoSAFIID"/>						
						</td>
					</tr>
					</table>
					
					</fieldset>
				</td>
				</tr>
		</table>
		<div id="gridBitacoraCargaLote" style="display: none;">
		
</div>	
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