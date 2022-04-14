<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>	
   		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  
   		<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tiposDireccionServicio.js"></script> 
		 <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB6-3X95DFPxVjSbonYpOTYUHf3KjepOFs&signed_in=true"></script>
		
      	<script type="text/javascript" src="js/cliente/mapaDirecciones.js"></script>
      
	</head>
<body>
		<div id="contenedorForma">
		
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="direcClientes">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">		
						<legend class="ui-widget ui-widget-header ui-corner-all">Mapa de Direcciones del <s:message code="safilocale.cliente"/></legend>
								<table border="0" cellpadding="0" cellspacing="0" width="950px">
										<tr>
											      <td class="label"> 
											         <label for="clienteID">No. de <s:message code="safilocale.cliente"/>: </label> 
											     </td>
											     <td>
											         <input  type="text" id="clienteID" name="clienteID"  size="12" tabindex="1" iniforma='false' />  
											         <input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "true" 
											          readOnly="true"/>  
											      </td> 
											     
											      <td class="separador"></td> 
													<td class="label"> 
											         <label for="direccionID">Número: </label> 
											     </td> 
											     <td> 
											         <input type="text" id="direccionID" name="direccionID" size="6" tabindex="3" iniforma='false'/>  
											     </td> 
												
										 </tr> 
										
										<tr> 
											     <td class="label"> 
											         <label for="tipoDireccionID">Tipo de Dirección: </label> 
											     </td> 
											     <td> 
											      <input id="tipoDireccionID" name="tipoDireccionID"  size="20" tabindex="16" 
											       readOnly="true"/>  
											        
											     </td> 
											          <td class="separador"></td> 
													<td class="label">  
											         <label for="Direccion">Dirección: </label> 
											     	</td> 
											      <td>
													<TEXTAREA type="text" id="direccionCompleta" name="direccionCompleta" COLS=40 ROWS=4 tabindex="19" 
													 readOnly="true"></TEXTAREA>
													</td> 
										      
										 </tr> 
										  <tr>
											    <td class="label"> 
											         <label for="Latitud">Latitud: </label> 
											     </td> 
											     <td> 
											         <input id="latitud" name="latitud" size="20" tabindex="20" readOnly="true"/>  
											     </td>    	   
										 </tr> 
										 
										 <tr> 
											     <td class="label"> 
											         <label for="Longitud">Longitud: </label> 
											     </td> 
											     <td> 
											         <input id="longitud" name="longitud" size="20" tabindex="21" readOnly="true"/>  
											         <input type="button" name="verMapa" value="Ver Mapa" id="verMapa" tabindex="22" class="submit"/>	
											      </td>
										 </tr>
										    <tr>   
											     <td align="right" colspan="5">
											         <input type="submit" name="actualizar" value="Actualizar" id="actualizar" class="submit" tabindex="23">	
											         			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
											         
											     </td>
										    </tr>	
								  </table>
						  </fieldset>  
						<div id="mapDiv" style="display: none;"></div>
				</form:form> 
		</div> <!-- contenedorForma -->
		
		<div id="cargando" style="display: none;"></div>	
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>

</body>
<div id="mensaje" style="display: none;"></div>
</html>

  