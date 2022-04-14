<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
      
 	 <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
  	<script type="text/javascript" src="dwr/interface/proveedoresServicio.js"></script>
		      
      <script type="text/javascript" src="js/tesoreria/reporteFacturas.js"></script>  
				
	</head>
      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="facturaBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Facturas</legend>
		
			<table border="0" width="100%">
			 <tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Par&aacute;metros</label></legend>         
          <table  border="0"  width="100%">
				<tr>
					<td class="label">
						<label for="creditoID">Fecha de Inicio: </label>
					</td>
					<td >
						<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
		         			tabindex="1" type="text" autocomplete="off" esCalendario="true" />	
					</td>					
				</tr>
				<tr>			
					<td class="label">
						<label for="creditoID">Fecha de Fin: </label> 
					</td>
					<td>
						<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" 
		         			tabindex="2" type="text" autocomplete="off" esCalendario="true"/>				
					</td>	
				</tr>
				
				<tr>
					<td>
						<label>Estatus:</label> 
					</td>
					<td><select id="estatus" name="estatus" path="estatus"  tabindex="3" >
				         <option value="T">TODOS</option>
				         <option value="A">PENDIENTE DE PAGO</option>
				         <option value="C">CANCELADA</option>
				         <option value="P">PARCIALMENTE PAGADA</option>
				         <option value="L">PAGADA</option>
				         <option value="R">EN PROC. REQUISICIÓN</option>
				         </select>									 
					</td>
				
					
				</tr>
				
					
					<tr>		
					<td>
						<label>Proveedor:</label>
					</td>
					<td><input type="text" name="proveedorID" id="proveedorID" size="5" path="proveedorID" tabindex="4" />	 						
						 <input type="text" name="NombreProveedor" id="NombreProveedor" size="50" disabled="true" path="NombreProveedor" tabindex="4" />	 
									 
					</td>
				</tr>
				
				<tr>
					<td>
						<label>Sucursal:</label>
					</td>
					<td><select id="sucursal" name="sucursal" path="sucursal" tabindex="5" >
				         <option value="0">TODAS</option>
					      </select>									 
					</td>
					

					</tr>
				<tr>
					<td>
						<label>Tipo Captura:</label>
					</td>
					<td>
						<select id="tipoCaptura" name="tipoCaptura" path="tipoCaptura"  tabindex="6" >
					         <option value="0">TODOS</option>
					         <option value="1">MANUAL</option>
					         <option value="2">MASIVA</option>
				         </select>									 
					</td>
					
				</tr>
				
	  </table> </fieldset>  </td>  
	      
	<td>
		<table width="200px">
				<tr>
				
					<td class="label" style="position:absolute;top:12%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
							<div id="generaPDFPRPT">
							<input type="radio" id="pdf" name="generaRpt" value="pdf" tabindex="6" checked/>
							<label> PDF </label></div>		
				            <input type="radio" id="excel" name="generaRpt" value="excel" tabindex="7"/>
							<label> Excel </label>			 	
						</fieldset>
					</td>      
				</tr>		
				
				<tr id ="nivel" style="display:none;">
					<td class="label" id="tdPresenacion" style="position:absolute;top:45%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend>
							<label>Nivel de Detalle</label></legend>
								<input type="radio" id="detallado" name="presentacion" value="detallado" />
							<label> Detallado </label>
				            <br>
							<input type="radio" id="sumarizado" name="presentacion" value="sumarizado">
							<label> Sumarizado</label>
					</fieldset>
					</td>  
				</tr> 		 
		 </table> 
	</td>
              
    </tr>
     
	</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" />
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">
								
									<a id="ligaGenerar" href="reporteFacturas.htm" target="_blank" >  		 
										 <input type="button" id="generar" name="generar" class="submit" 
												 tabIndex = "48" value="Generar" />
									</a>
									
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