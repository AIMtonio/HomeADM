<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
 	   <script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 	   <script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>                  

      <script type="text/javascript" src="js/cuentas/cuentaAhoCancela.js"></script>     
	</head>
   
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cuentasAhoBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cancelación de <s:message code="safilocale.ctaAhorro"/></legend>		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="label"> 
		         	<label for="lblCuentaAhoID">Cuenta: </label> 
				   </td>
				   <td>
				      <form:input type="text" id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="13" tabindex="1"/>  
				   </td>
				   <td class="separador"></td> 
				   <td class="label"> 
		         	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
		     		</td> 
		     		<td> 
		         	<form:input id="clienteID" name="clienteID" path="clienteID" size="15" 
		         		readOnly="true" disabled="true"/>
		         	<input id="nombreCte" name="nombreCte"size="50" type="text" readOnly="true" 
		         			disabled="true"/>
		     		</td>
		     		
				</tr>
				<tr> 
		     		<td class="label"> 
		         	<label for="lblusuarioCanID">Usuario Cancela: </label> 
		     		</td> 
		     		<td> 
		         	<form:input id="usuarioCanID" name="usuarioCanID" path="usuarioCanID" size="7" 
		         			tabindex="3" readOnly="true" disabled="true"/>
		         	<input id="nombreUsuario" name="nombreUsuario"size="40" tabindex="2"
		         			type="text" readOnly="true" disabled="true"/>
		     		</td>
		     		<td class="separador"></td> 
		     		<td class="label"> 
				   	<label for="lblEstatus">Estatus: </label> 
				   </td>   	
				   <td> 
		         	<input id="estatus" name="estatus" path="estatus" size="12" 
		         			 type="text" readOnly="true" disabled="true"/>
		     		</td>
		 		</tr> 
		 		<tr> 
		 			<td class="label"> 
				   	<label for="lblFecha">Fecha: </label> 
				   </td>   	
				   <td> 
		         	<form:input id="fechaCan" name="fechaCan" path="fechaCan" size="12" 
		         			tabindex="3" readOnly="true" disabled="true"/>
		     		</td>
		     		
		     		<td class="separador"></td> 
		     		<td class="label"> 
					     	<label for="lblMotivoCan">Motivo de la Cancelaci&oacute;n: </label> 
				   </td> 
				   <td colspan="4"> 
				    	<form:textarea id="motivoCan" name="motivoCan" path="motivoCan" cols="40" tabindex="4" onblur="ponerMayusculas(this)" /> 
				   </td> 
		 		</tr> 
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" />
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>		
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>	
									<input type="hidden" id="varSafilocale" name="varSafilocale" value="<s:message code="safilocale.ctaAhorro"/>"/>	
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