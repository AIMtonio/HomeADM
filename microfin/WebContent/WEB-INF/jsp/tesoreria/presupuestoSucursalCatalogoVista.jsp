<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>	     
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/requisicionGastosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/presupSucursalServicio.js"></script>  
		<script type="text/javascript" src="js/tesoreria/presupuestoPorSucursal.js"></script>  
		<script type="text/javascript" src="js/tesoreria/presupSucursalGrid.js"></script>

		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>

		
		<script>
			$(function() {
				$("#tabs").tabs();
			});
		</script>
		<style>
			.cajatexto{
                border-width:0;
                border-color: #000000;
                font-size: 12px;
            }
		</style>
      
	</head>
   
<body>

<div id="contenedorForma">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Presupuesto por Sucursal</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="presupuestoSucursalBean">          
  			<fieldset class="ui-widget ui-widget-content ui-corner-all">				
					<table >     
						<tr>
 
					     	  <td class="label"> 
					         <label for="lblfecha">Mes del Presupuesto:</label> 
					     	</td>
					     	<td >
					     		<label id="lblMesPresup" for="lblMesPresup"></label> 
					           <input type="text" id="fechaPresupuesto"  title="Seleccione el último día del mes." name="fechaPresupuesto" size="11" maxlength="18" esCalendario="true" />
					          
                               <form:input type="hidden" id="mesPresupuesto" name="mesPresupuesto" path="mesPresupuesto" /> 	
                               <form:input type="hidden" id="anioPresupuesto" name="anioPresupuesto" path="anioPresupuesto" /> 	
                               			
					      </td> 
					     		<td class="separador"></td>
					     		
					      
					      	<td class="label"> 
					         <label for="lblFolioID">Folio:</label> 
					     	</td>
					     	<td> 
			         		
			         		 <form:input type="text"  id="folio"  title="Escriba el nombre de la sucursal." name="folio" path="folio" size="11" tabindex="1"  /> 	
					     	</td> 
					    				    			     		
					   </tr>
					   <tr>  
					    <td class="label"> 
					         <label for="lblnumCtaAhorro">Usuario Elabora:</label> 
					         </td>
					      <td>
					     	
					         <form:input type="text"  id="usuario" name="usuario" path="usuario"  size="8"  disabled="true"/>
					         <input type="text"  id="nombreUsuario" name="nombreUsuario" type="text" readonly="true" disabled="true" size="30"/> 		          			
					      </td>  
					      <td class="separador"></td>  	
					     <td class="label">
					     <label for="lblfecha">Fecha Operaci&oacute;n:</label>
					     </td>
					    <td>
					     <input type="text" id="fechaOperacion" name="fechaOperacion" size="11" maxlength="18" />
                           <form:input type="hidden" id="fecha" name="fecha" path="fecha" /> 	
					    </td>
					      		
					  </tr>
					   
					   <tr>  
					      <td> 
					       
					     	</td>
					     	<td >
					     		  
					          	
					      </td> 
					      <td></td>  	
					     <td>
					     </td>
					   <td class="label">
					     <label for="lblfecha" id="lblFechaLim"></label>
					     </td>
					      		
					  </tr>					   
					   
					   
					    <tr>	
					     	<td class="label"> 
					         <label for="lblSucursal">Sucursal:</label> 
					     	</td>
					     	<td >
					   	 <form:input type="text" id="sucursal" name="sucursal" path="sucursal" size="8"  disabled="true"/>
					   	 <input type="text" id="sucursalNombre" name="sucursalNombre" type="text" disabled="true" = readonly="true" size="30"/> 		         	
			           	</td>
			           	
			           	<td class="separador"></td> 
			           	<td class="label"> 
					         <label for="lblestatus">Estatus de Captura:</label> 
					     	</td>
					      <td >
					          <input id="estatusPet" type="hidden" name="estatusPet"  path="estatusPet" value="S" />
					     		 <input id="estatusPre" name="estatusPre" type="hidden"   value="N" />					           				       
					          <input id="estatusVista" type="text" name="estatusVista" size="20" disabled="true" path="estatusVista" value="" />		
					      </td>    	 		
					     	 
					     		
						</tr>
						
						  						 
						
					  </table>
					  				  
					  </fieldset>
					  <br>
						<fieldset id="plantillaCaptura" class="ui-widget ui-widget-content ui-corner-all">
						<table >
				
						<tr>  
					      
					    </tr>
					    <tr>	
					     	<td class="label"> 
					         <label for="lblconceptoID">Concepto: </label> 
					     	</td>
					      	<td>
					          <input type="text" id="conceptoID" name="conceptoID" size="6" tabindex="2" />
					          <input type="text" id="conceptoDescri" name="conceptoDescri" disabled="true" size="35" /> 
					          
			           </td> 
			           <td class="separador"></td>
			           <td class="label"> 
					         <label for="lblmonto">Monto:</label> 
					         <input id="montoPet" name="montoPet" esMoneda="true" path="montoPet" size="11" tabindex="3"  />
					     	</td>
					     	
					     	<td class="separador"></td>
					     	
					     	<td class="label">
                      <label for="lblnombreSucursal">Descripci&oacute;n:</label>
                     </td> 
                     <td>
                   
					    <input type="text" id="descripcionPet" name="descripcionPet" path="descripcionPet" size="50" tabindex="4" onkeyup="aMays(event, this)" onblur="aMays(event, this)" /> 	
                     </td>
                     
                     <td>
                     <input type="button" id="agregar" name="agregar" value="Agregar" class="submit" tabindex="5" />
                     </td>
					     	
						</tr> 
                   				
					</table>
					</fieldset>
					
               <br>
							
				<input type="hidden" name="tipoAccion" id="tipoAccion" value="1"/>
				<div id="tabs">
					<ul style="font-size:80%">
						<li><a href="#presupuesto" id="presupuesto">Presupuestos</a></li>
					</ul>

					<div id="presupuesto">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend>Presupuestos</legend>
							<div id="tableCon">	
							<c:set var="listaResultado"  value="${listaResultado[0]}"/>
									<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
										<tbody>	
											<tr align="center">
											   <td class="label"> 
											   		<label for="lblNumero"></label> 
												</td>
									     		<td class="label"> 
									         		<label for="lblCuenta">Concepto</label> 
									     		</td>  
												<td class="label"> 
													<label for="lblDescripcion">Descripci&oacute;n</label> 
										  		</td>
										  		<td class="label" > 
									         		<label for="lblEstatus">Estatus</label> 
									     		</td>
									     		
												<td class="label" > 
									         		<label for="lblMonto">Monto</label> 
									     		</td>    
									     		<td class="label" > 
									         		<label for="lblObservaciones">Observaciones</label> 
									     		</td>  
									     		 
											</tr>
										</tbody>
									</table>
								<input type="hidden" value="-1" name="numeroDetalle" id="numeroDetalle" />
							
							</div>
							<br>
							<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
								<tr>
									<td colspan="5">
										<table align="right">
											<tr>
												<td align="right">
													<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar Pendiente" align="right" tabindex="6" />			
													<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" align="right" tabindex="8" />														
													<input type="submit" id="grabarCerrado" name="grabarCerrado" class="submit" value="Grabar y Cerrar" align="right" tabindex="7" />			
															

												</td>
											</tr>
										</table>		
									</td>
								</tr>	
							</table>
						</fieldset>
					</div>
					</div>
											
				
				
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<form:input type="hidden" value="0"  path="eliminados" name="eliminados" id="eliminados" />	 
				
	 	</form:form> 
</fieldset>
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
<div id="mensaje" style="display: none;"> </div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	

</body>
</html>