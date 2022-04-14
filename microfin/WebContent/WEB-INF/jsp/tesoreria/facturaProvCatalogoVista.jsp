<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>	
<html>
	<head>	
 		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/facturaProvServicio.js"></script>  
 	   	<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script>  
 	   	<script type="text/javascript" src="dwr/interface/tipoProvServicio.js"></script>  
 		<script type="text/javascript" src="dwr/interface/requisicionGastosServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/tipoprovimpServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/impuestoServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/condicionespagServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/prorrateoContableServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoPagoProvServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/empleadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/polizaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/detfacturaProvServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/detImpuestoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	 
		
 		<script type="text/javascript" src="js/tesoreria/facturaProv.js"></script> 
 		
 		
	</head>
<body>
<div id="contenedorForma">	

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="facturaprovBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Facturación Proveedores</legend>
	<table border="0" width="100%">
		<tr>  
	    	<td class="label"> 
		    	<label for="lblProveedor">Proveedor: </label> 
			</td> 
		    <td> 
				<form:input type="text" id="proveedorID" name="proveedorID" path="proveedorID" size="15" tabindex="1" iniForma="false" />
			    <input type="text" id="nombreProv" name="nombreProv" size="45"  onblur="ponerMayusculas(this)" tabindex="3" readonly= "true" disabled = "true" />
			    <input type="hidden" id="folioCargaID" name="folioCargaID" value=""/>
			    <input type="hidden" id="folioFacturaID" name="folioFacturaID" value=""/>
			    <input type="hidden" id="mesSubirFact" name="mesSubirFact" value=""/>
		  	</td> 
	     	<td class="separador"></td> 
	     	<td class="label"> 
	        	<label for="lblNoFactura">Número de Factura: </label> 
			</td>
			<td>
				<form:input type="text" id="noFactura" name="noFactura" path="noFactura" size="15" tabindex="2" onBlur=" ponerMayusculas(this)" autocomplete="off"  />  
			</td>
	 	</tr>
	 	<tr> 
			<td class="label"> 
	        	<label for="lblTipoProveedor">Tipo de Proveedor: </label> 
			</td>
			<td> 
				<input type="text" id="tipoProveedor" name="tipoProveedor" size="15" tabindex="4" disabled="true"/>
			    <input type="text" id="descripTipoProv" name="descripTipoProv"size="45"  tabindex="5" readonly= "true" disabled = "true" />
		  	</td> 
		    <td class="separador"></td> 
		    <td class="label">  
				<label for="lblSucursalID">Estatus: </label> 
			</td> 
			<td> 
			  	<form:select id="estatus" name="estatus" path="estatus"  tabindex="6" disabled="true" >
					<form:option value="A">ALTA</form:option>
				    <form:option value="P">PARCIALMENTE PAGADA</form:option>
					<form:option value="C">CANCELADA</form:option>
					<form:option value="L">LIQUIDADA</form:option>
					<form:option value="V">VENCIDA</form:option>
					<form:option value="R">EN PROCESO DE REQUISICIÓN</form:option>
					<form:option value="I">IMPORTADA</form:option>
				</form:select>
			</td>  
		</tr>
		<tr>
			<td>
				<label for="esPagadaAnt">Pagada Anticipadamente: </label>							
			</td>
			<td>
				<input type="radio" id="pagadaAntSI" 	name="pagadaAnt" value="S" tabindex="7"/><label>Si</label>
				<input type="radio"	id="pagadaAntNO"	name="pagadaAnt" value="N" tabindex="8" checked="checked"/><label>No</label>
				<form:input type="hidden" id="pagoAnticipado" name="pagoAnticipado" path="pagoAnticipado" value=""/>
			</td>
			<td class="separador"/>
			<td class="label"> 
	        	<label for="lblcondicionesPag">Condiciones de Pago: </label> 
	     	</td> 
	     	<td>
	     		<form:select id="condicionesPago" name="condicionesPago" path="condicionesPago"  tabindex="9" >
			    	<form:option value="">SELECCIONAR</form:option>
				</form:select>
	     	</td>
		</tr>	
		<tr>
			<td>
				<label for="prorrateaImpuesto">Prorratea Impuesto: </label>		
			</td>
			<td>
				<input type="radio" id="prorrateaImpSI" name="prorrateaImpuesto" value="S" tabindex="10"/><label>Si</label>
				<input type="radio" id="prorrateaImpNO" name="prorrateaImpuesto" value="N" tabindex="11" checked="checked"/><label>No</label>
				<form:input type="hidden" id="prorrateaImp" name="prorrateaImp" path="prorrateaImp" value=""/>
			</td>
			<td class="separador"/>
			<td id="lblCxP">
				<label for="centroCostosManual">C.Costos(CxP): </label>
			</td>
			<td id="tdCxP">
				<form:input type="text" id="cenCostoManualID" name="cenCostoManualID" path="cenCostoManualID" tabindex="12" size="8" maxlength="50" />
				<input type="text" id="nombreCenCostoManual" name="nombreCeCostoManual" readOnly="readOnly" size="20" maxlength="50"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div id="detallesPagoPro" style="display: none;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Detalles de Pago</legend>
						<table width="80%">
							<tr>	
								<td>
									<label for="tipoPagoAnt">Tipo de Pago: </label>
								</td>
								<td>
									<form:select id="tipoPagoAnt" name="tipoPagoAnt" path="tipoPagoAnt" tabindex="13"/>																
								</td>
							</tr>
							<tr>								
								<td>
									<label for="cenCostosAntID">C. Costos: </label>
								</td>
								<td>
									<form:input type="text" id="cenCostoAntID" name="cenCostoAntID" path="cenCostoAntID" tabindex="14" size="8" maxlength="50"/>
									<input type="text" id="nombreCenCostoAnt" name="nombreCenCostoAnt" readOnly="readOnly" size="20" maxlength="50"/>
								</td>							
							</tr>
							<tr>								
								<td>
									<label for="noEmpleadoID">No. Empleado: </label>
								</td>
								<td>
									<form:input type="text" id="noEmpleadoID" name="noEmpleadoID" path="noEmpleadoID" tabindex="15" size="8" maxlength="50"/>
									<input type="text" id="nombreEmpleado" name="nombreEmpleado" readOnly="readOnly" size="45" maxlength="50"/>
								</td>							
							</tr>
						</table>
					</fieldset>
				</div>
			</td>
		</tr>
	 	<tr> 
	    	<td class="label"> 
	        	<label for="lblFechaFactura">Fecha Factura: </label> 
	     	</td>  
	     	<td> 
				<form:input type="text" id="fechaFactura" name="fechaFactura" path="fechaFactura" size="15" tabindex="15" 
					esCalendario="true"/>
	     	</td> 
			<td class="separador"></td>
			<td class="label"> 
	        	<label for="lblfechaVencimiento">Fecha Vencimiento: </label> 
	     	</td> 
	     	<td> 
	        	<form:input type="text" id="fechaVencimiento" name="fechaVencimiento" path="fechaVencimiento" size="15" tabindex="17" readonly="true" 
	         		disabled="true" />  
	     	</td>			
	    </tr> 
		<tr>
	     		<td class="label"> 
	         		<label for="lblfechProgPag">Fecha Programada de Pago:</label> 
				</td> 		     		
	     		<td>
	         	 	<form:input type="text" id="fechaProgPago" name="fechaProgPago" path="fechaProgPago" size="15" tabindex="18" esCalendario="true"/>  
	     		</td>
	     		<td class="separador"/>
	     		<td class="label"> 
	         		<label for="lblSaldoFac">Saldo de la Factura:</label> 
				</td> 		     		
	     		<td>
	         		<form:input type="text" id="saldoFactura" name="saldoFactura" path="saldoFactura" style="text-align:right;" size="15" tabindex="19" /> 
	     		</td> 	
	 	</tr>  
	 
	 	<tr>   
	 		
	     		<td class="label" id="tdLabelFechCancela"> 
	         		<label for="lblfechProgPag">Fecha de Cancelación:</label> 
				</td>	     		
	     		<td id="tdFechCancelacion">
	         	 	<form:input type="text" id="fechaCancelacion" name="fechaCancelacion" disabled="true" path="fechaCancelacion" size="15" tabindex="20"  />  
	     		</td> 	
	     		
	    </tr>
	</table>		     
	     <table>
	     	<tr>
	     		<td>
		     		<div id="gridDetalle" style="display: none;" ></div>
		     		<input type="hidden" id="detalleFactura" name="detalleFactura" size="100" />
		     		<input type="hidden" id="detalleFacturaImp" name="detalleFacturaImp" size="100" />
		    	</td>		
		 	</tr>
	    </table>
	 	<div id="Todo" style="display: none;"></div>
		<div id="arrendamiento" style="display: none;" ></div>
		  	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend >Digitalización de Factura</legend>
		  
		     	<table >
		     		<tr>
			     		<td class="label"> 
			         		<label for="lbltipoArchivo">Tipo de Archivo: </label> 
					   </td>
			     		<td> 
			     			<input id="tipoArchivo" name="tipoArchivo"   type="hidden" />
			     			
			     		</td>
			     		<td class="separador"></td>
			     	
			     	</tr>
			     	<tr>
			     		<td> 
			     			<input type="button" id="adjuntarImagen" name="adjuntarImagen" class="submit" value="Adjuntar Imagen Factura" />
							<input type="button" id="verImagen" name="verImagen" class="submit" value="Ver" />
							<form:input type="hidden" id="rutaImagenFact" name="rutaImagenFact" path="rutaImagenFact" /> 
			     		</td>
			     		<td class="separador"></td>
			     		<td class="separador"></td>
			     		<td> 
			     			<input type="button" id="adjuntarXML" name="adjuntarXML" class="submit"  value="Adjuntar Archivo XML" />
			     			<input type="button" id="verArchivo" name="verArchivo" class="submit"  value="Ver" />
			     			<form:input type="hidden" id="rutaXMLFact" name="rutaXMLFact" path="rutaXMLFact" />
			     		</td> 
			 
			     	</tr>
			     	<tr>
			     	    	<td class="label"> 
	         		<label for="lblFolioUUID">Folio UUID:</label> 
				
	         		<form:input type="text" id="folioUUID" name="folioUUID" path="folioUUID" size="49"  maxlenght = "36" 
	         		 onBlur=" ponerMayusculas(this);" onkeyup="mascara(this,'-',patronFolio,true);"/> 
	     			</td> 
	     			<td> 
 	     				<input type="submit" id="enviarUUID" name="enviarUUID" class="submit" value="Modificar"  style="display:none"/> 
	     			</td> 
			     	</tr>
		     </table>
		    </fieldset>
		    <table>
		   		<tr>
					<td>
						<div id="imagenFactura" style="overflow: scroll; width: 950px; height: 500px;display: none;">
			 				<IMG id= "imgFactura" SRC=""  BORDER=0 ALT="Imagen Factura"/> 
						</div>
       				</td> 
				</tr>
			</table>										
		     <table border="0" cellpadding="0" cellspacing="0"  width="100%">    	   
				<tr>					
					<td colspan="5">
						<table align="right"> 
						<tr id="labelMotivoCancel">
			     		<td  class="label"> 
			         	<label for="lbltipoArchivo">Motivo de Cancelación: </label> 
					   </td>
					   </tr>
							<tr id="trMotivoCancel">
								<td align="right">
									<textarea id="motivoCancelacion" name="motivoCancelacion" path="motivoCancelacion" 
									 onBlur=" ponerMayusculas(this);"	style="margin: 2px; width: 847px; height: 37px;"></textarea>
 
   						  		</td>
							</tr>
							<tr>								
								<td align="right">
									<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" />
									<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" />
									<input type="submit" id="cancelar" name="cancelar" class="submit" value="Cancelar" />
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>	
									<input type="hidden" id="tipoActualizacion" name="tipoActualizacion"/>	
									<input type="hidden" id="totalGravable" name="totalGravable" path="totalGravable" />	
									<input type="hidden" id="prorrateoHecho" name="prorrateoHecho" value="N"/>
									<input type="hidden" id="aplicaFolioUUID" name="aplicaFolioUUID"/> 
									<button type="button" class="submit" id="impPoliza" style="display:none">Ver Póliza</button>
									<input type="hidden" id="polizaID" name="polizaID" iniForma="false"/>
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
