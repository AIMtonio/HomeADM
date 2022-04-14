<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
 	   	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>   
 	   	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/bloqueoSaldoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="js/cuentas/bloqueoSaldoPet.js"></script>          
	</head>
   	<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bloqueoSaldoPet">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Bloqueo Manual de Saldo</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr> 
				     		<td class="label"> 
				         		<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
				     		</td> 
				     		<td> 
				         		<form:input type="text" id="clienteID" name="clienteID" path="clienteID" size="15" tabindex="1" />
				         		<input type="text" id="nombreCte" name="nombreCte" size="70" tabindex="2" readOnly="true" iniForma ='false'/>
				     		</td> 
				         	<td class="separador"></td> 				
						   	<td class="label"> 
						   		<label for="lblSucursalID">Fecha: </label> 
						   	</td> 
						   	<td> 
						   		<input type="text" id="fechaMov" name="fechaMov" path="fechaMov" size="12" tabindex="3" readOnly="true"  />
						   	</td>
				 		</tr> 
				 		<tr>
                   			<td>
		                   	</td>				 		
				 		</tr>
				 	</table>	
				 	
					<br>
					
			 		<div id="gridAhoCte"></div>
			 		
			 		<br>
			 		
			 		
			 <div id="contenedorBloqueos">
			 	<fieldset class="ui-widget ui-widget-content ui-corner-all">
			 		<legend class="ui-widget ui-widget-header ui-corner-all">Bloqueos</legend>
			 		<c:set var="listaResultado"  value="${listaResultado[0]}"/>	
			 		<table id="miTabla"  border="0" cellpadding="0" cellspacing="0" width="100%">
				 		<tr>
				 		  	<td></td>
					 		    <td class="label" nowrap="nowrap"> 
						     		<label for="lblEdoCta">Cuenta:</label> 
						     	</td>
						     	<td class="label" nowrap="nowrap"> 
						     		<label for="lblTipo">Tipo:</label> 
						     	</td>
						        <td class="label"> 
						     		<label for="lblEdoCta">Saldo<br>Disponible:</label> 
						     	</td>
					 		    <td class="label"> 
						     		<label for="lblEdoCta">Saldo<br>Bloqueado:</label> 
						     	</td>
						        <td class="label"> 
						     		<label for="lblEdoCta">Saldo<br>SBC:</label> 
						     	</td>
						       <td class="label"> 
						     		<label for="lblEdoCta">Descripci&oacute;n:</label> 
						       </td>	
						     	
	   					    	<td class="label"> 
						     		<label for="lblEdoCta">Tipo Bloqueo:</label> 
						       </td>	
						       <td class="label"> 
						     		<label for="lblReferencia">Referencia:</label> 
						       </td>
						      	<td class="label"> 
						     		<label for="lblEdoCta">Monto:</label> 
						     	</td>
						     	<td nowrap="nowrap"></td>
					 		</tr>					 		
				 	</table>
				 		 <input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
				 						 		 
			</fieldset>
				 		
				 		
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agregar" name="agregar" class="submit" value="Agrega" tabindex="13"/>
								
								<input type="hidden" id="tipoTransaccion" value="2" name="tipoTransaccion"/>	
								<input type="hidden" id="operacion" value="1" name="operacion"/>				
							</td>
						</tr> 
					</table>		
		</div>	
	</fieldset>
</form:form>
</div>
	
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>