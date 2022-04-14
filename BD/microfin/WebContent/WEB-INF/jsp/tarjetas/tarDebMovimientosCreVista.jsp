<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>                                             
		<script type="text/javascript"	src="dwr/interface/tarDebMovimientosServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/tCPeriodoLineaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/lineaTarjetaCreditoServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/tarjetaCreditoServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript"	src="js/tarjetas/tardebMovimientosCre.js"></script>
	 	
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarDebMovimientosBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Consulta de Movimientos por Tarjeta</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						
						<tr>
							<td class="label" >
								<label for="lblTarjetaDebID">N&uacute;mero Tarjeta:</label>
			        		</td>
			 				<td>
			       		 		<input type="text" id="tarjetaID" name="tarjetaID" maxlength="16" tabindex="1" size="20"  />
							</td>
						 	<td class="separador"></td> 	
							<td class="label">
						  		<label for="lblEstatus">Estatus: </label>
				   			</td>
							<td>
								<input type="text" id="descripcion" name="descripcion" readOnly="true" size="30" />	
							</td>
						</tr>			
					</table>
					<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Datos Tarjeta</legend>
						<table>
		     			 	<tr>
							 	<td class="label">
						  			<label for="lblClienteID">Tarjetahabiente: </label>
							 	</td>
							 	<td>
									<input type="text" id="clienteID" name="clienteID" readOnly="true" size="15"  />
									<input type="text" id="nombreCompleto" name="nombreCompleto"  readOnly="true" size="50"  />	
								</td>
			  				</tr>
			  				<tr id="cteCorpTr">
								<td class="label">
						  			<label for="lblCoorporativo">Corporativo (Contrato): </label>
							 	</td>
							 	<td>
									<input type="text" id="coorporativo" name="coorporativo" readOnly="true" size="15"  />
									<input type="text" id="nombreCoorp" name="nombreCoorp" readOnly="true" size="50"  />	
								</td>
			  				</tr>

							<tr id="lineaCredito">
								<td class="label" >
									<label for="lblLineaCuenta" id="lineaCred">Producto:</label>
			               		</td>
			 		       		<td>
		       		 	        	<input  type="text" id="productoID" name="productoID" path="productoID" readOnly="true" size="15"/>
						      		<input type="text" id="descripcionProd" name="descripcionProd" readOnly="true" size="50"  />	

					    	   	</td>
							</tr>
								

			  				<tr>
								<td class="label">
						  			<label for="lblTipoTarjeta">Tipo Tarjeta: </label>
							 	</td>
							 	<td>
									<input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" readOnly="true" size="15"/>
									<input type="text" id="nombreTarjeta" name="nombreTarjeta"  readOnly="true" size="50"  />	
								</td>
			  				</tr>
		     			</table>
			     	</fieldset>
		     		<br>
		     		<fieldset class="ui-widget ui-widget-content ui-corner-all" id="infoLinea">
		  				<legend>&Uacute;ltimo Corte</legend>
		  				<table>
		     			 	<tr>
		     			 		<td class="label">
						  			<label >Saldo al Corte: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="saldoCorte" name="saldoCorte" readOnly="true" size="15" esMoneda="true" class="moneda"/>
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
						  			<label >Pago No Gen Interes: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="pagoNoGenInt" name="pagoNoGenInt" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
			  				</tr>
			  				<tr>
								<td class="label">
						  			<label>Cargos Recientes: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="cargosRecientes" name="cargosRecientes" readOnly="true" size="15" esMoneda="true" class="moneda"/>
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
						  			<label>Pago Mímino: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="pagoMinimo" name="pagoMinimo" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
			  				</tr>
			  				<tr>
			  					<td class="label">
						  			<label>Intereses: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="interes" name="interes" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
						  			<label>Fecha Lim Pago: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="fechaLimPago" name="fechaLimPago" readOnly="true" size="15"  />
								</td>
			  				</tr>

							<tr>
								<td class="label">
						  			<label>Comisiones: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="comisiones" name="comisiones" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
						  			<label for="lblClienteID">Proximo Corte: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="proximoCorte" name="proximoCorte" readOnly="true" size="15"  />
								</td>
							</tr>
								

			  				<tr>
								<td class="label">
						  			<label>Pagos: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="pagos" name="pagos" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
						  			<label for="lblClienteID">Limite Crédito: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="limiteCredito" name="limiteCredito" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
			  				</tr>

			  				<tr>
								<td class="label">
						  			<label>Saldo a la Fecha: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="saldoFecha" name="saldoFecha" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
								<td class="separador"></td>
								<td class="separador"></td>
								<td class="label">
						  			<label for="lblClienteID">Crédito Disponible: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="creditoDisponible" name="creditoDisponible" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
			  				</tr>
			  				<tr>
								<td class="label">
						  			<label>Saldo a Favor: </label>
						  		</td>
			 		       		<td>
									<input type="text" id="saldoFavor" name="saldoFavor" readOnly="true" size="15" esMoneda="true" class="moneda" />
								</td>
			  				</tr>

		     			</table>
		    		</fieldset><br>
		    		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend>Movimientos</legend>	
						<table>
							<tr>
							 	<td class="label">
						 	 		<label>Año: </label>
					     		</td>
						 		<td>
									<select id="fechaPeriodo" name="fechaPeriodo" tabindex="4" >
										<option value="0">SELECCIONAR</option>
						  			</select>
				   	  			</td>
				   	  			<td class="label">
					 	 			<label>Mes: </label>
					     		</td>
						 		<td>
									<select id="mesPeriodo" name="mesPeriodo" tabindex="4" >
						  				<option value="0">SELECCIONAR</option>
						   				<option value="1">ENERO</option>
						   				<option value="2">FEBRERO</option>
						   				<option value="3">MARZO</option>
						    			<option value="4">ABRIL</option>
						    			<option value="5">MAYO</option>
						    			<option value="6">JUNIO</option>
						    			<option value="7">JULIO</option>
						    			<option value="8">AGOSTO</option>
						    			<option value="9">SEPTIEMBRE</option>
						    			<option value="10">OCTUBRE</option>
						    			<option value="11">NOVIEMBRE</option>
						    			<option value="12">DICIEMBRE</option>
						  			</select>
				   	  			</td>
							</tr>
						</table>
						<table width="100%">
							<tr>
								<td align="right">
									<button type="button" class="submit" tabindex="5" id="consultar">Consultar</button> 						
								</td>
							</tr>
						</table>

						<table border="0" cellpadding="0" cellspacing="0" width="100%" >
			   				<tr>	
								<td>
					 				<div id="gridConsultaMovimientos" style="overflow: scroll; width: 935px; height: 350px; display: none;" />
								</td>		
							</tr>
							<tr>
								<td align="right">
									<a id="ligaGenerar" href="reporteMovimientos.htm" target="_blank" > 
									<button type="button" class="submit" id="generar" style="display: none" tabindex="3">Exportar PDF</button> 	
									</a>						
								</td>
							</tr>
	    				</table>
	    			</fieldset>
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

