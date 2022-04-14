<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
 		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
 				
        <script type="text/javascript" src="js/cliente/repPerfilCliente.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="clienteBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Perfil <s:message code="safilocale.cliente"/></legend>			
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr id ="tarjetaIdentiCA">
		<td class="label"><label for="IdentificaSocio">N&uacute;mero Tarjeta:</label>
		<td nowrap="nowrap">
			<input id="numeroTarjeta" name="numeroTarjeta" size="20" tabindex="1" type="text" />
			<input id="idCtePorTarjeta" name="idCtePorTarjeta" size="20" type="hidden" />
			<input id="nomTarjetaHabiente" name="nomTarjetaHabiente" size="20" type="hidden" />
		</td>
	</tr>
	<tr>
      <td class="label"> 
         <label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
    	</td>
      <td>
         <input type="text" id="clienteID" name="clienteID"path="clienteID" size="15" tabindex="1" iniforma='false' />  
         <input type="text" id="nombreCliente" name="nombreCliente" size="45" tabindex="2" disabled= "true" 
          readOnly="true"/>  
      </td> 
      <td class="separador"></td> 
	 
     
 	</tr> 


	<tr>
      <td class="label"> 
         <label for="clienteID">Sucursal: </label> 
    	</td>
      <td>
         <input type="text" id="sucursal" name="sucursal"  size="5"  disabled= "true" 
          readOnly="true"  />  
         <input type="text" id="nombreSucursal" name="nombreSucursal" size="45" tabindex="2" disabled= "true" 
          readOnly="true"/>  
      </td> 
      <td class="separador"></td> 
	 
     
 	</tr> 
	 
	 
	 
	 	<tr>
      <td class="label"> 
         <label for="clienteID">Promotor: </label> 
    	</td>
      <td>
         <input type="text" id="promotorID" name="promotorID"   size="5"  disabled= "true" 
          readOnly="true"  />  
         <input type="text" id="nombrePromotor" name="nombrePromotor" size="45" tabindex="2" disabled= "true" 
          readOnly="true"/>  
      </td> 
      <td class="separador"></td> 
	      
 	</tr> 
	 
					<table align="right">
					<tr>
									<td align="right">
								
									<a id="ligaGenerar" href="repPerfilCliente.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "48" value="Generar" />
									</a>
									
									</td>
								</tr>
				</table>	
					
					
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