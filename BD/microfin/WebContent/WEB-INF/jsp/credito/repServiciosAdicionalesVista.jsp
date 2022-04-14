<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionNominaServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/serviciosAdicionalesServicio.js"></script> 
<script type="text/javascript" src="js/credito/repServiciosAdicionales.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteServiciosAdicionalesBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Servicios Adicionales</legend>
				<table style="width: 100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table style="width: 100%">
									<tr>
										<td class="label">
											<label for="sucursalID">Sucursal: </label>
										</td>
										<td>
											<select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="1" iniforma="false" style="width:50%;">
												<option value="0">TODOS</option>
											</select>
										</td>
										
									</tr>
									<tr>
										<td class="label"> 
											<label for="organoID">Producto de Crédito: </label> 
										</td>
										<td> 
							       			 <select id="producCreditoID" name="producCreditoID" path="producCreditoID" tabindex="2" style="width:50%;"  type="select" >
												<option value="0">TODOS</option>
											</select>       					        	
										</td>	
																
									</tr>
									<tr>
										<td class="label"> 
											<label for="servicioID">Servicio: </label> 
										</td>
										<td> 
							       			 <select id="servicioID" name="servicioID" path="servicioID" tabindex="3" style="width:50%;"  type="select" >
												<option value="0">TODOS</option>
											</select>       					        	
										</td>	
																
									</tr>				
									<tr class="datosNomina">
										<td class="label" >		
									         <label for="institNominaID">Empresa N&oacute;mina:</label> 
										</td>		
									    <td> 
									        <input type="text" id="institNominaID" name="institNominaID" size="11" tabindex="4"/> 
									        <input type="text" id="nombreinstitucionNomina" name="nombreinstitucionNomina" size="77"  disabled= "true" 
									          readonly="true" iniforma='true'/>
										</td>
									</tr>
									<tr class="datosNomina">
										<td class="label" >		
									         <label for="convenioNominaID">No. Convenio:</label> 
										</td>	
										<td>
											<input type="text" id="convenioNominaID" name="convenioNominaID" size="11" tabindex="5"/>
											<input type="text" id="desConvenio" name="desConvenio"   disabled="disabled" size="77"  />
										</td>
									</tr>
									<tr>
										<td class="label"><label for="estadoCredito">Estatus: </label></td>
										<td>  
											
											<select MULTIPLE id="estadoCredito" name="estadoCredito" path="estadoCredito" tabindex="6" size="11">	
										      <option value="">TODOS</option>
										      <option value="A">AUTORIZADO</option>
										      <option value="V">VIGENTE</option>
										      <option value="P">PAGADO</option>
										      <option value="C">CANCELADO</option>
										      <option value="B">VENCIDO</option>
										      <option value="K">CASTIGADO</option>
										      <option value="S">SUSPENDIDO</option>
										      <option value="I">INACTIVO</option>
										      
											 </select>
									  	</td>
									   </tr>  
								</table>
							</fieldset>
						</td>
					
						<td colspan="3">
							<table width="70px">
								<tr>
									<td class="label" style="width: 70px;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all" style="width: 70px;">
											<legend>
												<label>Presentaci&oacute;n</label>
											</legend>
											<table style="width: 50%">
												<tr>
													<td>
														<input type="radio" id="excel" name="tipoReporte" value="1"  checked="checked" tabindex="7" />
													</td>
													<td>
														<label for="excel"> Excel </label>
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">				
					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">							
										<a id="ligaGenerar" href="/ReporteServiciosAdicionales.htm" target="_blank" > 
											<input type="button" id="generar" name="generar" class="submit" value="Generar" tabindex="8"/>
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
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>