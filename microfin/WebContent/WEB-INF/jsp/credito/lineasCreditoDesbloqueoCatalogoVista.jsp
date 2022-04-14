<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
      <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>    
 	 	<script type="text/javascript" src="dwr/interface/lineasCreditoServicio.js"></script>                

      <script type="text/javascript" src="js/credito/lineasCreditoDesbloqueoCatalogoVista.js"></script>     
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="lineasCreditoBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Desbloqueo de Líneas de Cr&eacute;dito</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
		         	<label for="lbllineaCreditoID">Línea de Cr&eacute;dito: </label> 
				   </td>
				    <td>
				      <form:input id="lineaCreditoID" name="lineaCreditoID" path="lineaCreditoID" size="12" tabindex="1"/>  
				   </td>
				   		     		
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		     		</td> 
		     		<td> 
		         	<form:input id="clienteID" name="clienteID" path="clienteID" size="11" 
		         		readOnly="true" disabled="true"/>
		         		
		         	<input id="nombreCte" name="nombreCte"size="50" type="text" readOnly="true" 
		         			disabled="true"/>
		     		</td> 
				</tr>
				<tr>
				<td class="label"> 
		         	<label for="lblCuentaAhoID">Cuenta: </label> 
		     		</td> 
		     		<td> 
		         	 <!--<form:input id="cuentaID" name="cuentaID" path="cuentaID" size="12" 
		         	 		tabindex="18" esMoneda="true"/>-->  
		         	 		<input id="cuentaID" name="cuentaID" path="cuentaID" size="12" 
		         			tabindex="2" type="text" readOnly="true" disabled="true"/>
	
		     		</td> 
		     		<td class="separador"></td> 
					<td class="label"> 
				   	<label for="lblEstatus">Estatus: </label> 
				   </td>   	
				   <td> 
				   <!-- <form:input id="estatus" name="estatus" path="estatus" size="12" 
		         	 		tabindex="18" esMoneda="true"/>--> 
		         	<input id="estatus" name="estatus" path="estatus" size="12" 
		         			tabindex="2" type="text" readOnly="true" disabled="true"/>
		     		</td>
					
		 		</tr>   
		 		<tr>
		 		<td class="label"> 
		         	<label for="lblfechaBloquea">Usuario Desbloquea: </label> 
		     		</td> 
		     		
		     		<td> 
		         	 <form:input id="usuarioDesbloquea" name="usuarioDesbloquea" path="usuarioDesbloquea" size="12" 
		         	 		tabindex="3" readOnly="true" disabled="true"/>  
         	 		<input id="nombreUsuario" name="nombreUsuario"size="40" 
         			type="text" readOnly="true" disabled="true" iniForma = 'false'/>
		     		</td> 
					
								<td class="separador"></td>
					<td class="label">
					
				<label for="motivo">Motivo de Desbloqueo: </label>
			</td>
			<td>
				<form:textarea id="motivoDesbloqueo" name="motivoDesbloqueo" path="motivoDesbloqueo" cols="35" rows="3" 
				tabindex="4" />   
			
			</td>
		     		
		     		
		     		
		     		
		     	</tr> 
		   <tr> 
						
			<td class="label">
				<label for="fechaBloq">Fecha de Desbloqueo: </label>
						     		<td> 
		         	 <form:input id="fechaDesbloqueo" name="fechaDesbloqueo" path="fechaDesbloqueo" size="12" 
		         	 		readOnly="true" disabled = "true"/>  
		     		</td>

			</td>
		</tr>
		 		
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="desbloquear" name="desbloquear" class="submit" value="Desbloquear" tabindex="5"  />
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>				
								</td>
								
							</tr>
						</table>		
					</td>
				</tr>	
			</table>
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>