<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
	<head>                                             
		<script type="text/javascript"	src="dwr/interface/tarDebMovimientosServicio.js"></script>
		<script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript"	src="js/tarjetas/tardebMovimientos.js"></script>
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
			       		 		<input type="text" id="tarjetaDebID" name="tarjetaDebID" maxlength="16" tabindex="1" size="20"  />
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
			  				<tr>
								<td class="label" >
									<label for="lblNumeroCuenta">Cuenta Asociada:</label>
			               		</td>
			 		       		<td>
		       		 	        	<input  type="text" id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" readOnly="true"  size="15"  />
					  	       		<label for="lblTipoCuenta">Tipo Cuenta: </label>
						      		<input type="text" id="tipoCuentaID" name="tipoCuentaID" readOnly="true" size="34"  />	
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
		     		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		  				<legend>Par&aacute;metros</legend>
						<table>
							<tr>
								<td class="label" >
								<label for="lblFechaRegistro">Fecha Inicio:</label>
				        	</td>
					 		<td>					
				 			 	<input type="text" id="fechaInicio" name="fechaInicio" size="12" esCalendario="true"  tabindex="2" />	
				 			</td>	
							<td class="label">
								<label for="lblFechaVencimiento">Fecha Fin: </label>
					    	</td>
					    	<td>
					 		 	<input type="text" id="fechaVencimiento" name="fechaVencimiento" size="12" esCalendario="true"  tabindex="3" />	
							</td>
						</tr>
						<tr>
						 	<td class="label">
					 	 		<label for="lblTipoOperacion">Tipo Operaci&oacute;n: </label>
				     		</td>
					 		<td>
								<select id="tipoOperacion" name="tipoOperacion" tabindex="4" >
					  				<option value="0">TODOS</option>
					   				<option value="00">COMPRA NORMAL</option>
					   				<option value="01">RETIRO EN EFECTIVO</option>
					   				<option value="09">COMPRA MAS RETIRO EN EFECTIVO</option>
					    			<option value="31">CONSULTA DE SALDO</option>
					    			<option value="10">COMPRA DE TIEMPO AIRE ATM</option>
					    			<option value="02">AJUSTE DE COMPRA</option>
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
		    	</fieldset>	
				<br>
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
		</form:form>
	</div> 	
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>