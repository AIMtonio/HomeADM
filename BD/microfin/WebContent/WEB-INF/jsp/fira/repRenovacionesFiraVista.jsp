<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   

<html>

<head>		

	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
	<script type="text/javascript" src="js/fira/repRenovacionesVista.js"></script>  
</head>

<body>
<div id="contendorForma"></div>
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repRenovaciones">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Renovaciones Agro</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend><label>Par&aacute;metros</label></legend>         
						<table  border="0"  width="560px">
							<tr>
								<td class="label"> 
							    	<label for=fechaInicio>Fecha Inicio:</label> 
								</td> 		     		
							    <td>
							    	<input  type="text" id="fechaInicio" name="fechaInicio" size="15" esCalendario="true" tabindex="1"/> 
							   	</td> 
							</tr>	  
							<tr> 
								<td class="label"> 
							    	<label for=fechaInicio>Fecha Fin:</label> 
								</td> 		     		
							    <td>
							    	<input  type="text" id="fechaFin" name="fechaFin"  esCalendario="true" tabindex="2" size="15"/> 
							   	</td> 	
							</tr>	
							<tr> 
								<td class="label"> 
				    				<label for="sucursalID">Sucursal:</label> 
								</td> 		     		
				    			<td>		         			
				         			<input  type="text" id="sucursalID" name="sucursalID"  size="15" maxlength="10"   tabIndex="3" />
				         			<input  type="text" id="nombreSucursal" name="nombreSucursal" size="55"   readOnly="true" />	 
							   	</td> 			   	
							</tr> 
							<tr> 
								<td class="label"> 
				    				<label for="productoCreditoID">Producto Cr&eacute;dito:</label> 
								</td> 		     		
				    			<td>		         			
				         			<input  type="text" id="productoCreditoID" name="productoCreditoID"  size="15"    tabIndex="4" />
				         			<input  type="text" id="nombreProductoCredito" name="nombreProductoCredito" size="55"   readOnly="true" />	 

							   	</td> 			   	
							</tr>  									
							<tr>
							<td class="label">
							<br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Presentación: </label></legend>
										<input type="radio" id="excel" name="excel" value="excel" tabindex="5">
										<label> Excel </label><br> 	
										<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="6">
										<label> PDF </label>
									</fieldset>
								</td>
							</tr> 	

						</table>
							<tr>		
								<td colspan="5">
									</br>
						<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />									
									<table align="right" border='0'>
										<tr>
											<td width="350px">
												&nbsp;					
											</td>		
						<td align="right">
						<a id="ligaGenerar"  target="_blank" >  
							<input type="button" id="generar" name="generar" class="submit" value="Generar" tabindex="7"/>
						</a>
								
										</tr>
									</table>		
								</td>
							</tr>					                
					</fieldset>
				</td>
			</tr>
		</table>
</fieldset>

</form:form>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;overflow:">
	<div id="elementoLista"></div>
</div>
</body>

</html>