<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>  
 	   	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>  
  	   	<script type="text/javascript" src="dwr/interface/cuentasFirmaServicio.js"></script>   	     	   	  
  	   	<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>  
  	   	<script type="text/javascript" src="js/soporte/ServerHuella.js"></script> 	
		<script type="text/javascript" src="js/cuentas/registroHuellaPersonaRel.js"></script>
	</head>
<body> 
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="huellaDigitalPerson">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                

	<legend class="ui-widget ui-widget-header ui-corner-all">Registro Huella Firmantes</legend> 
	
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%">    	 	
				<tr>
					<td class="label"> 
			         <label for="lblCuentaAhoID">Cuenta: </label> 
			     	</td>
			     	<td>
						<input type="text" id="cuentaAhoID" name="cuentaAhoID" size="13" 
			         		iniForma = 'false' tabindex="1"/> 
				  	</td> 
				    <td class="separador"></td> 	
				    <td class="label"> 
				    	<label for="lblCuentaAhoID">Tipo Cuenta: </label> 
				   	</td>
				    <td>
				    	<input id="tipoCuenta" name="tipoCuenta" size="25" iniForma = 'false'  
				     		type="text" readOnly="true"   />
				  	</td>       
				</tr> 
				<tr>	   	
					<td class="label" > 
				    	<label for="lblNombreCliente"><s:message code="safilocale.cliente"/>: </label> 
				 	</td> 
				    <td > 
				    	<input id="numCliente" name="numCliente"size="13" iniForma = 'false' type="text" readOnly="true"  />
				        <input id="nombreCliente" name="nombreCliente"size="60" iniForma = 'false' 	type="text" readOnly="true"  />
				  	</td> 		
				</tr> 
			</table>
			<br>
				<div id="gridFirmantes" style="display: none;"></div>
		
		<table>	
			<tr>
				<td >
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion""/>		
					<span id="statusSrvHuella"></span>		
				</td>
				<td class="separador"></td> 	
				<td class="separador"></td> 
				<td class="separador"></td> 	
				<td class="separador"></td> 
				<td class="separador"></td> 	
				<td class="separador"></td> 
				<td class="separador"></td> 	
				<td class="separador"></td> 
				<td class="separador"></td> 	
				<td class="separador"></td> 
				<td class="separador"></td> 	
				<td class="separador"></td> 	
				<td class="separador"></td> 	
				<td colspan="5" align="right">
					 <input type="button" class="submit" tabindex="3" id="registro"  value="Registar Huella" />
	                 <input type="hidden"  id="estatus" name="estatus" />
	                 <input type="hidden"  id="procede" name="procede" />
	                 <input type="hidden" id="tipoTransaccion" name="tipoTransaccion" iniForma="false" />

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