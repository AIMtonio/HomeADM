<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
	
	<script type="text/javascript" src="js/utileria.js"></script>
	<script type="text/javascript" src="js/date.js"></script>
	<script type="text/javascript" src="dwr/interface/requisicionGastosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
	
	<script type="text/javascript" src="js/tesoreria/requisicionGastos.js"></script>
	
	
<title>Requisicion de Gastos</title>
</head>
<body>
 
	<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Requisici&oacute;n de Gastos</legend>
	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="requisicionGastosBean" > 
		
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Generales</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td><label>Numero Requisicion:</label></td>
					<td><form:input type="text" name="requisicionID" id="requisicionID" path="requisicionID"
										  size="11"  autocomplete="off" tabindex="1" />
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td><label>Sucursal:</label></td>
					<td><form:input type="text" name="sucursalID" id="sucursalID" size="11"
								   tabindex="2" autocomplete="off" path="sucursalID" readOnly="true" disabled = "true" />
						<input type="text" name="nombreSucursal" id="nombreSucursal" size="50"
								  readOnly="true" disabled = "true"   />
					</td>
				</tr>
				<tr>
					<td><label>Elaboro:</label></td>
					<td><form:input type="text" name="usuarioID" id="usuarioID" size="11"
								   tabindex="3" autocomplete="off" path="usuarioID" readOnly="true" disabled = "true" />
						<input type="text" name="nombreUsuario" id="nombreUsuario" size="35" readOnly="true" disabled = "true" />	
					</td>
				</tr>
				<tr>
					<td><label>Tipo Gasto:</label></td>
					<td><form:input type="text" name="tipoGastoID" id="tipoGastoID" size="11"
								   tabindex="4" autocomplete="off" path="tipoGastoID" />
						<input type="text" name="descripcionTG" id="descripcionTG" size="40" readOnly="true" disabled = "true" /></td>
				</tr>
				<tr >
					<td><label>Descripcion:</label></td>
					<td>
						<form:textarea   type="text" rows="3" cols="80" name="descripcionRG" id="descripcionRG" path="descripcionRG"
								 tabIndex="5"/>
						
					</td>
				<tr>
					<td><label>Monto:</label></td>
					<td><form:input type="text" name="monto" id="monto" path="monto" size="11"
								   tabindex="6" autocomplete="off"  />
					</td>	
				</tr>
            <tr>
					<td><label>Tipo de Pago:</label></td>
					<td>  
					          <form:select id="tipoPago" name="tipoPago" path="tipoPago" tabindex="7" >
                         				         
					          <form:option value="sp">Spei</form:option>
				 	          <form:option value="ch">Cheque</form:option>
					          </form:select> 
					</td>	
				</tr> 
           
              
			    <tr>
					<td><label id="resTipoPagolbl">Numero de Cuenta Bancaria:</label></td>
					<td>  
                   <form:input id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" size="30"  maxlength="18" autocomplete="off" />
					     
					</td>	
				</tr> 
												
<!-- 				<tr><td colspan='4'>&nbsp;</td></tr>
				 -->
				<tr>
					<td><label>Centro Costo:</label></td>
					<td><form:input id="centroCostoID" name="centroCostoID" path="centroCostoID" size="11" 
										  tabIndex = "8" autocomplete="off" />
						<input type="text" id="centroCosto" name="centroCosto"size="25" readOnly="true" disabled="true" />

					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td><label>Fecha Requisicion:</label><div id="fecha"></div></td>
					<td><form:input type="text" name="fechaSolicitada" id="fechaSolicitada" path="fechaSolicitada" tabIndex="9"  /> </td>
				</tr>
				<tr>
					<td><label>Cuenta Depositar:</label></td>
					<td colspan="3">
						<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID"
										tabIndex = "10" size="11"  autocomplete="off" />
						<input type="text" id="cuenta" name="cuenta"  size="25" radOnly="true"
								 disabled="true" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								 
					</td>			 
				</tr>	
				<tr>
					<td><label>Estatus:</label></td>
					<td><form:input type="text" name="status" id="status" path="status" size="11"
								   tabindex="11" autocomplete="off" readOnly="true" disabled="true"/>
					</td>	
				</tr>			
				<tr><td colspan='4' ></td>
				</tr>
				<tr >
		
				</tr>
								
				<tr><td colspan='4'>&nbsp;</td></tr>

			</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
										<input type="submit" id="agregar" name="agregar" class="submit"
												 tabIndex = "10" value="Agregar" />
										<input type="submit" id="modificar" name="modificar" class="submit"
												 value="Modificar" tabIndex = "11" />
										<input type="submit" id="cancelar" name="cancelar" class="submit"
												 value="Cancelar" tabIndex="12">
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									</td>
								</tr>
							</table>		
						</td>
					</tr>	
				</table>
			</fieldset>			
		</form:form> 
		</fieldset>
	</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div> 
<div id="mensaje" style="display: none;"/>
</body>
</html>
