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
		<script type="text/javascript" src="dwr/interface/clienteArchivosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCheckListServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudArchivoServicio.js"></script>
		<script type="text/javascript" src="js/originacion/solicitudCheckList.js"></script>   		  

	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCheckList">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">CheckList</legend>
	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Solicitud</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		 <td> <table>
			<tr>
				<td class="label"> 
			    	<label for="solicitudCreditoID">Solicitud: </label> 
				</td>
			
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="6" tabindex="1" /> 				
				</td>
				 <td class="separador"></td> 
				<td class="label"> 
			    	<label for="fechaRegistro">Fecha Registro: </label> 
			   	</td> 
			    <td> 
			     	<input type="text" id="fechaRegistro" name="fechaRegistro"  size="20" readOnly="true" disabled="true"/> 
			  	</td>
			</tr>
			<tr> 
				<td class="label"> 
			    	<label for=productoCreditoID>Producto:</label> 
				</td> 		     		
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	<input  type="text" id="productoCreditoID" name="productoCreditoID"  size="6" readOnly="true" disabled="true"/> 
			        	 <input id="nombreProducto" name="nombreProducto" size="45" type="text" readOnly="true" disabled="true"/>
			   	</td> 	
			    <td class="separador"></td> 
			   	<td class="label"> 
			    	<label for="montoSolici">Monto Solicitado: </label> 
				</td> 
			    <td> 
			    	<input type="text" id="montoSolici" name="montoSolici"  size="20" readOnly="true" disabled="true"  esMoneda="true" />
				</td>
			</tr>
			<tr> 
				<td class="label"> 
					<label for="promotorID">Promotor: </label> 
				</td>   	
				<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="text" id="promotorID" name="promotorID"  size="6" readOnly="true" disabled="true" />
						<input id="nombrePromotor" name="nombrePromotor" size="45"  type="text" readOnly="true" disabled="true"/>
				</td>
				<td class="separador"></td>
				<td class="label"> 
					<label for="montoAutorizado">Monto Autorizado: </label> 
				</td>
				<td> 			
			   		<input  type="text" id="montoAutorizado" name="montoAutorizado"  size="20" readOnly="true" disabled="true"  esMoneda="true" /> 		  		        			 
				</td>
			</tr> 
			
			<tr> 		
				<td class="label"> 
					<label for="prospectoID">Prospecto: </label> 
				</td>   	
				<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
			</tr> 
			
			<tr> 		
				<td class="label"> 
					<label for="clienteID"><s:message code="safilocale.cliente"/>: </label> 
				</td>   	
				<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="clienteID" name="clienteID"  size="6"  type="text" readOnly="true" disabled="true"/>	
					<input id="nombreCompletoCliente" name="nombreCompletoCliente"  size="45" tabindex="5" type="text" readOnly="true" disabled="true"/>	         		    			
					<!-- <input id="nombreCliente" name="nombreCliente" size="45" tabindex="5" type="text" readOnly="true" disabled="true"/>-->
				</td>
			</tr> 
		
				</table>
				</td>
				</tr>


		<tr> 
			<td>
				<table>
          			<tr>
          				<td>
          					<table>
	          					<tr> 
									<td class="label"> 
					    				<label for="sucursalID">Sucursal:</label> 
									</td> 		     		
					    			<td>		         			
					         			<input id="sucursalID" name="sucursalID"  size="6" type="text" readOnly="true" disabled="true"/>
					         			<input id="nombreSucursal" name="nombreSucursal" size="45" type="text" readOnly="true" disabled="true"/>	 
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
										<textarea id="proyecto" name="proyecto" COLS="41" ROWS="4" readOnly="true" disabled="true"></textarea>				 
									</td>								
								</tr>
			  				</table>
			  			</td>
			  			<td class="separador"></td>
			  			<td>	 
				  			<fieldset class="ui-widget ui-widget-content ui-corner-all" id="solGrupo">                
							<legend><label>Grupo</label></legend>
							<table border="0" cellpadding="0" cellspacing="0" width="100%" hei>
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
				</table>
			</td>	
  		</tr>
  	</table>		
	</fieldset>
	

	<table border="0" cellpadding="0" cellspacing="0" width="100%">			
		<tr>
			<td colspan="7">
				<input type="hidden" id="datosGrid" name="datosGrid" size="100" />	
				<div id="gridSolicitudCheckList" name="gridSolicitudCheckList" style="display: none;"></div>							
			</td>	
		</tr>
	</table>
		
	<br>
	<table align="right">
		<tr>			
			<td class="label">
				<input type="button" class="submit" id="expediente" value="Expediente" tabindex="2" style='height:30px;'/> 
			</td> 
			<td align="right">												
				<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="3" />					
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>						
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