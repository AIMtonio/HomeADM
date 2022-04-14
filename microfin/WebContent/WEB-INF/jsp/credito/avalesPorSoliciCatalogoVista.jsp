<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>	 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/avalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/avalesPorSoliciServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
		<script type="text/javascript" src="js/credito/avalesPorSolici.js"></script>
		<script type="text/javascript" src="js/utileria.js"></script>
	</head>
<body>
	
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Avales Por Solicitud</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="avalesPorSolicitud">  	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="label" nowrap="nowrap"> 
					    	<label for="lblSolicitudID">Solicitud de Crédito:</label> 
					 	</td> 
					    <td> 
					   		<form:input id="solicitudCreditoID" name="soicitudCreditoID" path="solicitudCreditoID" size="5"  /> 
						</td>
					    <td> 
					     	<input id="clienteID" name="clienteID" size="10" type="hidden" /> 
					    </td>
					    <td> 
					     	<input id="prospectoID" name="prospectoID" size="10" tabindex="1"  type="hidden" />
					      	<input id="estSol" name="estSol" size="5" type="hidden" />  
					    </td>
					    <td class="separador"> 
					    <td class="label"> 
					    	<label for="lblSolicitudID">Tipo de Crédito:</label> 
					   	</td>
					    <td> 
					    	<input id="tipoCredito" name="tipoCredito" size="40" readOnly="true"  /> 
	                    </td>
					</tr>	
					<tr>
					    <td class="label"> 
					    	<label for="lblSolicitudID">Nombre:</label> 
						</td>
					    <td> 
					    	<input id="nombreCliente" name="nombreCliente" size="45" readOnly="true"  /> 
					    </td>
					    <td> 
					     	<input id="productoCreditoID" name="productoCreditoID" size="10" type="hidden" /> 
					    </td>
	
					    <td class="separador"> 
					    <td class="separador"> 
					    	
					    <td class="label"> 
	                        <label for="lblFecha">Fecha de Registro:</label> 
					  	</td> 
					    <td> 
					  		<form:input id="fechaReg" name="fechaReg" path="fechaRegistro" size="10" readOnly="true" iniforma="false"/> 
	                  	</td>
					</tr>
					
					<tr>
						<td><input type="hidden" id="avales" name="avales" size="100" /></td>
					</tr>
					<tr>
						<td colspan="9">
							<div id="gridAvales" style="display: none;"></div>							
						</td>						
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
					<tr>
						<td colspan="5" align="right">			
							<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>				
						</td>
					</tr>
				</table>	
			</form:form>	
		</fieldset> 
	</div>
	
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>