<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
     	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="js/fira/repSolicitudCreditoVista.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCreditoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Solicitud Crédito </legend>
	<table  width="100%">
		<tr>
			<td class="label"> 
		    	<label for="solicitudCreditoID">Solicitud: </label> 
			</td>
			
			<td>
				<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="6" tabindex="1" /> 				
			</td>
			<td class="separador"></td> 
			<td width="120px"> 
		    	<label for="fechaRegistro">Fecha Registro: </label> 
		   	</td> 
		    <td > 
		     	<input type="text" id="fechaRegistro" name="fechaRegistro"  size="20" readOnly="true" disabled="true"/> 
		  	</td>
		  	<td></td>
		  	<td></td>
		</tr>
		<tr> 
			<td class="label"> 
		    	<label for=productoCreditoID>Producto:</label> 
			</td> 		     		
		    <td>
		    	<input  type="text" id="productoCreditoID" name="productoCreditoID"  size="6" readOnly="true" disabled="true"/> 
		        <input id="nombreProducto" name="nombreProducto" size="45" type="text" readOnly="true" disabled="true"/>
		   	</td> 	
			<td class="separador"></td> 
		   	<td class="label"> 
		    	<label for="montoSolici">Monto Solicitado: </label> 
			</td> 
		    <td> 
		    	<input type="text" id="montoSolici" name="montoSolici"  size="20" readOnly="true" disabled="true"  esMoneda="true" style='text-align:right;'/>
			</td>
			<td></td>
		  	<td></td>
		</tr>
		<tr> 
			<td class="label"> 
				<label for="promotorID">Promotor: </label> 
			</td>   	
			<td>
				<input type="text" id="promotorID" name="promotorID"  size="6" readOnly="true" disabled="true"/>
				<input id="nombrePromotor" name="nombrePromotor" size="45"  type="text" readOnly="true" disabled="true"/>
			</td>
			<td class="separador"></td>
			<td class="label"> 
				<label for="montoAutorizado">Monto Autorizado: </label> 
			</td>
			<td> 			
		   		<input  type="text" id="montoAutorizado" name="montoAutorizado"  size="20" readOnly="true" disabled="true"  esMoneda="true" style='text-align:right;'/> 		  		        			 
			</td>
			<td></td>
		  	<td></td>
		</tr> 
			
		<tr> 		
			<td class="label"> 
				<label for="prospectoID">Prospecto: </label> 
			</td>   	
			<td>
				<input id="prospectoID" name="prospectoID"  size="6" type="text" readOnly="true" disabled="true"/>
				<input id="nombreCompletoProspecto" name="nombreCompletoProspecto" size="45" type="text" readOnly="true" disabled="true"/>		         		    			
			</td>
			<td class="separador"></td>
			<td class="label"> 
				<label for="estatus">Estatus: </label> 
			</td>
			<td> 			
		   		<input type="text" id="estatus" name="estatus"  size="20" readOnly="true" disabled="true" /> 		  		        			 
			</td>
			<td></td>
		  	<td></td>
		</tr> 
			
		<tr> 		
			<td class="label"> 
				<label for="clienteID"><s:message code="safilocale.cliente"/>: </label> 
			</td>   	
			<td>
				<input id="clienteID" name="clienteID"  size="6"  type="text" readOnly="true" disabled="true"/>	
				<input id="nombreCompletoCliente" name="nombreCompletoCliente"  size="45" tabindex="5" type="text" readOnly="true" disabled="true"/>	         		    			
			</td>
		</tr> 
		<tr> 
			
			<td class="label"> 
				<label for="sucursalID">Sucursal:</label> 
			</td> 		     		
			<td>		         			
     			<input id="sucursalID" name="sucursalID"  size="6" type="text" readOnly="true" disabled="true"/>
     			<input id="nombreSucursal" name="nombreSucursal" size="45" type="text" readOnly="true" disabled="true"/>	 
		   	</td> 	
		   	<td class="separador"></td>
		   	<td colspan="4" rowspan="4">
				<fieldset class="ui-widget ui-widget-content ui-corner-all" id="solGrupo">                
							<legend><label>Grupo</label></legend>
							<table >
								<tr> 		
									<td class="label"> 
										<label for="grupoID">Grupo: </label> 
									</td>   	
									<td> 
										<input id="grupoID" name="grupoID" size="6"  type="text" readOnly="true" disabled="true"/>	
										<input id="nombreGrupo" name="nombreGrupo" size="40" tabindex="5" type="text" readOnly="true" disabled="true"/>	         		    			
									</td>
								</tr> 
								<tr> 		
									<td class="label"> 
										<label for="fechaRegistroGr">Fecha Registro: </label> 
									</td>   	
									<td> 
										<input id="fechaRegistroGr" name="fechaRegistroGr"  size="20"  type="text" readOnly="true" disabled="true"/>							         		    		
									</td>
								</tr> 
								<tr> 		
									<td class="label"> 
										<label for="cicloActual">Ciclo Actual: </label> 
									</td>   	
									<td> 
										<input id="cicloActual" name="cicloActual"  size="20"  type="text" readOnly="true" disabled="true"/>							         		    		
									</td>
								</tr> 																		
							</table>
				</fieldset>
			</td>	
		</tr>
		<tr>
			<td class="label"> 
    			<label for="destinoCreID">Destino del Crédito: </label> 
			</td> 
    		<td> 
    			<input  type="text" id="destinoCreID" name="destinoCreID" size="6"  readOnly="true" disabled="true" />
    			<input id="nombreDestinoCre" name="nombreDestinoCre" size="45" type="text" readOnly="true" disabled="true"/>
			</td>
		</tr>
		<tr>
			<td class="label"> 
    			<label for="proyecto">Proyecto </label> 
			</td>
			<td>
				<textarea id="proyecto" name="proyecto" COLS="41" ROWS="4" readOnly="true"></textarea>				 
			</td>								
		</tr>
		<tr>
			
		</tr>	  			

  		<tr>
  			<td colspan="6" align="right">
				<input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "48" value="Generar" />
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" />
			</td>
  		</tr>
  	</table>
			

</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>