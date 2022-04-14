<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
     <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  
   	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
     <script type="text/javascript" src="dwr/interface/seguroCliente.js"></script>
     <script type="text/javascript" src="js/cliente/repCertificadoSegVida.js"></script>  
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Certificado de Aportaci&oacute;n de Seguro de Vida </legend>
		<table border="0" cellpadding="0" cellspacing="0" width="600px">
      				    <tr>		
				<td class="label" nowrap= "nowrap"> 
		        	<label for="clientelb"><s:message code="safilocale.cliente"/>: </label> 
			     </td> 	
			     <td nowrap= "nowrap"> 
			         <input id="clienteID" name="clienteID"  size="12" tabindex="3" /> 
			         <input type="text" id="nombreCliente" name="nombreCliente" size="39"  tabindex="4"
			           readOnly="true"/>   
			     </td> 					
			</tr>
			<tr>
				<td class="label" nowrap= "nowrap">
					<label for="clientelb">No. P&oacute;liza: </label>
				</td>
				<td >
					<input id="seguroClienteID" name="seguroClienteID"  size="12" 
	         			tabindex="1" type="text" disabled="true"/>	
				</td>					
			    <td class="separador"></td>			
				<td class="label" nowrap= "nowrap">
					<label for="clientelb">Estatus: </label> 
				</td>
				<td>
					<input id="estatus" name="estatus"  size="12" 
	         			tabindex="2" type="text" disabled="true"/>				
				</td>	
			</tr>
			<tr>
				<td class="label" nowrap= "nowrap">
					<label for="clientelb">Fecha de Inicio: </label>
				</td>
				<td >
					<input id="fechaInicio" name="fechaInicio"  size="12" 
	         			tabindex="1" type="text" disabled="true"/>	
				</td>					
			    <td class="separador"></td>			
				<td class="label" nowrap= "nowrap">
					<label for="clientelb">Fecha de Fin: </label> 
				</td>
				<td>
					<input id="fechaFin" name="fechaFin"  size="12" 
	         			tabindex="2" type="text" disabled="true"/>				
				</td>	
			</tr>
			<tr>
				<td class="label" nowrap= "nowrap">
					<label>Monto Cobrado:</label>
				</td>
				<td nowrap= "nowrap">
 				    <input type="text"id="montoSeguro" name="montoSeguro" size="12" tabindex="7"  esMoneda="true" disabled="true"/>									 
				</td>
			</tr>
		</table>
</fieldset>
	<table width="100%">
		<tr>
			<td align="right">
				<a id="ligaPDF" href="repCertSegVida.htm" target="_blank" >
				  <button type="button" class="submit" id="imprimir">
				  Imprimir Certificado
				  </button> 
				</a>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>
	</table>
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