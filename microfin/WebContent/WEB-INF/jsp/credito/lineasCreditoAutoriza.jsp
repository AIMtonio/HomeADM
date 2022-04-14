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
 	   <script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>               
 	                   

      <script type="text/javascript" src="js/credito/lineaCreditoAutorizacion.js"></script>     
	</head>
   
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="lineasCreditoBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Autorización de Líneas de Crédito</legend>
						
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
		         	<label for="lbllineaCreditoID">Línea Crédito: </label> 
				   </td>
				   <td>
				      <form:input id="lineaCreditoID" name="	lineaCreditoID" path="lineaCreditoID" size="20" tabindex="1"/>  
				   </td>
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		     		</td> 
		     		<td> 
		         	<form:input id="clienteID" name="clienteID" path="clienteID" size="20" tabindex="2"
		         			readOnly="true" disabled = "true"/>
		         	<textarea id="nombreCte" name="nombreCte"size="50" type="text" tabindex="3" 
		         		readOnly="true" disabled = "true" />
		     		</td> 
				</tr>
				<tr> 
					<td class="label"> 
		         	<label for="lblfechaAutoriza">Fecha de Autorizaci&oacute;n: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="fechaAutoriza" name="fechaAutoriza" path="fechaAutoriza" size="20" 
		         	 		tabindex="4" readOnly="true" disabled = "true"/>  
		     		</td>
		     		<td class="separador"></td> 
		     		<td class="label"> 
		         	<label for="lblusuario">Usuario: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="usuarioAutoriza" name="usuarioAutoriza" path="usuarioAutoriza" size="20" 
		         	 		tabindex="5" readOnly="true" disabled="true"/>  
         	 		<input id="nombreUsuario" name="nombreUsuario"size="40" 
         			type="text" readOnly="true" disabled="true" />
		     		</td>
		 		</tr>   
		 		<tr> 
		 			<td class="label"> 
		         	<label for="lblSolicitado">Monto Solicitado: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="solicitado" name="solicitado" path="solicitado" size="20" 
		         	 		tabindex="6" esMoneda="true" disabled="true"/>  
		     		</td>
		     		<td class="separador"></td> 
					<td class="label"> 
		         	<label for="lblAutorizado">Monto Autorizado: </label> 
		     		</td> 
		     		<td> 
		         	 <form:input id="autorizado" name="autorizado" path="autorizado" size="20" 
		         	 		tabindex="7" esMoneda="true" style="text-align: right" />  
		     		</td>
		     	</tr> 
				<tr> 
		 		<td class="label"> 
				   	<label for="lblEstatus">Estatus: </label> 
				   </td>   	
				   <td> 
		         	<input id="estatus" name="estatus" path="estatus" size="20" 
		         			tabindex="8" type="text" readOnly="true" disabled="true"/>
		     		</td>
		     	</tr> 
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="9"  />
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>	
									<input type="hidden" id="montoMinimo" name="montoMinimo" />				
									<input type="hidden" id="montoMaximo" name="montoMaximo"/>				
															
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