<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="dwr/interface/remesasPagadasServicio.js"></script>
		<script type="text/javascript" src="js/ventanilla/remesasPagadas.js"></script>
		<script type="text/javascript" src="js/ventanilla/impTicketVentSofiExpress.js"></script>
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
			findPrinter();
		</script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form method="POST" id="formaGenerica" name="formaGenerica"	commandName="remesasPagadasBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Remesas Pagadas</legend>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<table border="0" width="100%">
							<tr>
								<td class="label">
									<label for="referencia">Referencia: </label>
								</td>
								<td>
									<form:input type="text" id="referencia" name="referencia" path="referencia" size="50" tabindex="1" autocomplete="off" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="remesadora">Remesadora: </label>
								</td>
								<td>
									<input type="text" id="remesadora" name="remesadora" path="remesadora" size="50" tabindex="2"  disabled="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="monto">Monto: </label>
								</td>
								<td>
									<input type="text" id="monto" name="monto" path="monto" size="50" tabindex="3"  disabled="true" style="text-align: right;" esMoneda="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="cliente">Cliente: </label>
								</td>
								<td>
									<input type="text" id="clienteID" name="clienteID" path="clienteID" size="13" tabindex="4" disabled="true"  />
									<input type="text" id="nombreCliente" name="nombreCliente"  size="50" tabindex="5" disabled="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="usuario">Usuario: </label>
								</td>
								<td>
									<input type="text" id="usuarioID" name="usuarioID" path="usuarioID" size="13" tabindex="6" disabled="true"  />
									<input type="text" id="usuario" name="usuario"  size="50" tabindex="7" disabled="true"/>
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="direccion">Dirección: </label>
								</td>
								<td>
									<textarea id="direccion" name="direccion" path="direccion" tabindex="8"  disabled="true" />
								</td>
							</tr>
							<tr>
								<td class="label">
									<label for="numeroTelefono">Teléfono: </label>
								</td>
								<td>
									<input type="text" id="numeroTelefono" name="numeroTelefono" path="numeroTelefono" size="50" tabindex="9"  disabled="true" />
								</td>
							</tr>
							<tr>
								<td>
									<label for="formaPago">Forma de Pago: </label>
								</td>
								<td class="radio">
									<input type="radio" id="retiroEfectivo" name="formaPago" value="R" tabindex="9" disabled="true">
									<label for="retiroEfectivo">Retiro Efectivo</label><br>
									<input type="radio" id="depositoCuenta" name="formaPago" value="D" tabindex="10" disabled="true">
									<label for="depositoCuenta">Deposito a Cuenta</label><br>
									<input type="radio" id="cheque" name="formaPago" value="C" tabindex="11" disabled="true">
									<label for="cheque">Cheque</label><br>
									<input type="radio" id="transferencia" name="formaPago" value="T" tabindex="12" disabled="true">
									<label for="transferencia">Transferencia</label><br>
								</td>
							</tr>

						</table>
					</fieldset>
				</fieldset>

				<div>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend class="ui-widget ui-corner-all">Salida de Efectivo</legend>

								<table width="100%">
									<tr>
										<td>
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend class="ui-widget ui-corner-all">Billetes</legend>
													<table border="0" width="100%">
														<tr>
															<th class="label"><label>Denominación</label></th>
															<th class="label"><label>Disponible</label></th>
															<th class="label"><label>Cantidad</label></th>
															<th class="label"><label>Monto</label></th>
														</tr>
														<tr>
															<td><input type="text" id="denominacion1000" value="1000" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="disponible1000" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="cantidad1000" class="cantidad" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="monto1000" class="monto" value="0.00" disabled="true" style="text-align: right;" esMoneda="true"></td>
														</tr>
														<tr>
															<td><input type="text" id="denominacion500" value="500" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="disponible500" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="cantidad500" class="cantidad" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="monto500" class="monto" value="0.00" disabled="true" style="text-align: right;" esMoneda="true"></td>
														</tr>
														<tr>
															<td><input type="text" id="denominacion200" value="200" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="disponible200" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="cantidad200" class="cantidad" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="monto200" class="monto" value="0.00" disabled="true" style="text-align: right;" esMoneda="true"></td>
														</tr>
														<tr>
															<td><input type="text" id="denominacion100" value="100" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="disponible100" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="cantidad100" class="cantidad" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="monto100" class="monto" value="0.00" disabled="true" style="text-align: right;" esMoneda="true"></td>
														</tr>
														<tr>
															<td><input type="text" id="denominacion50" value="50" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="disponible50" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="cantidad50" class="cantidad" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="monto50" class="monto" value="0.00" disabled="true" style="text-align: right;" esMoneda="true"></td>
														</tr>
														<tr>
															<td><input type="text" id="denominacion20" value="20" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="disponible20" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="cantidad20" class="cantidad" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="monto20" class="monto" value="0.00" disabled="true" style="text-align: right;" esMoneda="true"></td>
														</tr>
													</table>
											</fieldset>
										</td>

										<td style="width: 259px; vertical-align:top">
											<fieldset class="ui-widget ui-widget-content ui-corner-all style="height:100%;">
												<legend class="ui-widget ui-corner-all">Monedas</legend>
													<table>
														<tr>
															<th class="label"><label>Disponible</label></th>
															<th class="label"><label>Cantidad</label></th>
															<th class="label"><label>Monto</label></th>
														</tr>
													 	<tr>
															<td><input type="text" id="disponible1" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="cantidad1" class="cantidad" value="0" disabled="true" style="text-align: right;" esMoneda="true"></td>
															<td><input type="text" id="monto1" class="monto" value="0.00" disabled="true" style="text-align: right;" esMoneda="true"></td>
														</tr>

													</table>
											</fieldset>
										</td>
									</tr>
								</table>
							<table align="right">
								<tr>
									<td colspan="5" align="right" class="label">
										<label>Total Salida de Efectivo: </label>
									</td>
									<td>
										<input type="text" id="totalSalidaEfectivo" value="0" disabled="true" style="text-align: right;" esMoneda="true">
									</td>
								</tr>
								<tr>
									<td colspan="5" align="right" class="label">
										<label>Número de Reimpresiones: </label>
									</td>
									<td>
										<input type="text" id="numeroReimpresinoes" value="0" disabled="true">
									</td>
								</tr>
								<tr>
									<td class="separador"></td>
									<td colspan="5" align="right" >
										<input type="submit" id="reimprimir" name="reimprimir" class="submit" value="Reimprimir" disabled="true">
									</td>
								</tr>
							</table>
					</fieldset>
				</div>
			</form:form>
		</div>
		
	
	

	<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista" />
		</div>
		<div id="mensaje" style="display: none;" />
	</body>
</html>