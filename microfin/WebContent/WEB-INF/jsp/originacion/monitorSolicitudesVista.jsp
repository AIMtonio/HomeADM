<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>	 

		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>    
        <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script> 
        <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
	    <script type="text/javascript" src="dwr/interface/monitorSolicitudesServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>

	  	<script type="text/javascript" src="js/originacion/monitorSolicitudes.js"></script>   
	</head>
<body>
<div id="contenedorForma">
		<div id="solicitud"></div>		
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="monitorSolicitud">
		<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetEstSol">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Monitor de Solicitudes</legend>
        	<table >		
         		<tr> <td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all" >                
					<legend>Parámetros</legend>         
          			<table  border="0"  >
         				<tr>
							<td class="label">
								<label for="fecha">Fecha: </label>
							</td>
							<td >
								<input id="fechaInicio" name="fechaInicio" size="12" tabindex="1" type="text" readOnly="true" disabled= "true" />	
							</td>					
						</tr>							
						<tr>
							<td class="label" nowrap="nowrap">
								<label for="sucursal">Sucursal: </label>
							</td> 
							<td nowrap="nowrap">
								<input id="sucursal" name="sucursal"   size="6" tabindex="3" />
								<input type="text" id="nombreSucursal" name="nombreSucursal"  readOnly="true" disabled= "true" size="39"/> 
							</td>  
						</tr>
						<tr> 
							<td class="label">
								<label for="promotor">Promotor:</label>
							</td>
							<td  colspan="4">
								<form:input id="promotorID" name="promotorID" path="promotorID" size="6" tabindex="4"/>
								<input type="text" id="nombrePromotor" name="nombrePromotor" size="39" tabindex="10" disabled= "true" readOnly="true" />	 
							</td>
						</tr>		
						<tr> 
							<td class="label" nowrap="nowrap">
								<label >Producto de Cr&eacute;dito:</label>
							</td>
							<td  colspan="4">
								<form:input id="productoCreditoID" name="productoCreditoID" path="productoCreditoID" size="6" tabindex="6"/>
								<input type="text" id="nomProducto" name="nomProducto" size="39" tabindex="6" disabled= "true" readOnly="true" />	 
							</td>
						</tr>							
						<tr>
							<td class="label">
								<label for="estatus"> Estatus:</label>
							</td>
							<td  colspan="4">
								<form:select id="estatus" name="estatus" path="estatus" tabindex="5">
								<form:option value="">TODOS</form:option>
								<form:option value="SI">SOLICITUD INACTIVA</form:option>
						   		<form:option value="SL">SOLICITUD LIBERADA</form:option>
						   		<form:option value="SA">SOLICITUD AUTORIZADA</form:option>
						   		<form:option value="SR">SOLICITUD RECHAZADA</form:option>
						   		<form:option value="SM">SOLICITUD EN ACTUALIZACIÓN</form:option>
						   		<form:option value="SC">SOLICITUD CANCELADA</form:option>
						   		<form:option value="CI">CRÉDITO INACTIVO</form:option>
						   		<form:option value="CC">CRÉDITO CONDICIONADO</form:option>
						   		<form:option value="CA">CRÉDITO AUTORIZADO</form:option>
						   		<form:option value="CD">CRÉDITO DESEMBOLSADO</form:option>
								</form:select>
							</td>			
						</tr>
					</table> 
				</fieldset>  </td>  
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td >
							<table align="right" border='0'>
								<tr>
									<td >
										<input type="button" id="generar" name="generar" class="submit" tabIndex = "15" value="Generar" />										
									</td>
								</tr>			
							</table>		
						</td>
					</tr>					
				</table>
			</table>
		</fieldset>
		<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisTotal" style="display: none;" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Estatus</legend>	
				<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetSolEst" style="display: none;" >
					<legend >Solicitudes</legend>	
					<table align="right">
						<tr>
							<div id="divListaEstatus" style="overflow: auto; height: 100%; display: none;" ></div>
								<td align="right">																	
							</td>		
										
						</tr>
					</table>
				</fieldset>
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetCanalIng" style="display: none;" >
					<legend >Canal de Ingreso</legend>	
				<table align="right">
					<tr>
						<div id="divListaCanalIngreso" style="display: none;" ></div>
							<td align="right">	
						</td>		
									
					</tr>
				</table>	
			</fieldset>															
		</fieldset>
		<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetLisDetalle" style="display: none;" >
			<legend class="ui-widget ui-widget-header ui-corner-all" id="textoDetalle"></legend>	
			<table align="right">
				<tr>
					<div id="divListaDetalle" style="display: none;" ></div>
						<td align="right">	
					</td>		
								
				</tr>				
			</table>
			<table align="right">
				<tr>
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td class="separador"></td> 
					<td align="right">	
					<td align="right">	
						<input type="submit" id="solventar" name="solventar" class="botonDeshabilitado" tabIndex = "15" value="Solventar" disabled />
					</td>	
					<td align="right">	
						<input type="button" class="submit" value="Guardar" id="guardar" tabindex="4 " name="guardar"  />
					</td>		
								
				</tr>	
				<tr>			
			</table>
			
				
		</fieldset>		
		<input  type="hidden"  id="monitorSolicitud" name="monitorSolicitud"  size="15" value="S" tabindex="3" />
		<form:input type="hidden" id="claveUsuario" name="claveUsuario" path="claveUsuario"/>	
		<input type="hidden" id="estatusSol" name="estatusSol"  value="" /> 
		<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
		<input type="hidden" id="detalleEstatus" name="detalleEstatus"  value="" /> 


		<br>		
	</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista" ></div>
</div>
</body>
<div id="mensaje" style="display: none;" ></div>
</html>
