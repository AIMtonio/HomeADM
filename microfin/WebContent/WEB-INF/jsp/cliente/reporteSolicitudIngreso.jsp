<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
 		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script> 
 				
        <script type="text/javascript" src="js/cliente/repSolicitudIngreso.js"></script>  
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solclienteBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de Ingreso</legend>			
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
      <td class="label"> 
         <label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
    	</td>
      <td>
         <input type="text" id="clienteID" name="clienteID"path="clienteID" size="15" tabindex="1" iniforma='false' />  
         <input type="text" id="nombreCliente" name="nombreCliente" size="60" tabindex="2" disabled= "true" 
          readOnly="true"/>  
      </td> 
      <td class="separador"></td> 
	 
     
 	</tr> 


	<tr>
      <td class="label"> 
         <label for="clienteID">Sucursal: </label> 
    	</td>
      <td>
         <input type="text" id="sucursal" name="sucursal"  size="5"/>  
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
	 
			
 </table>
  </fieldset>
		<table align="right">
					<tr>
						<td>
						<a id="ligaGenerar" href="/repSolicitudIngreso.htm" target="_blank" >  		 
						<input type="button" id="impri" name="impri" class="submit" tabIndex = "3" value="Generar Solicitud" />
						</a>
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