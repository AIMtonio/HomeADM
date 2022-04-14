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
<script type="text/javascript" src="js/credito/repPagosdeAccesorios.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Pago de Accesorios</legend>
				<table style="width: 100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros</label></legend>
								<table style="width: 100%">
									<tr>
										<td class="label">
											<label for="fechaInicio">Fecha de Inicio: </label>
										</td>
										<td colspan="4">
											<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
							         			tabindex="1" type="text"  esCalendario="true" />	
										</td>					
									</tr>
									<tr>			
										<td class="label">
											<label for="fechaVencimien">Fecha de Fin: </label> 
										</td>
										<td colspan="4">
											<input id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="12" 
							         			tabindex="2" type="text" esCalendario="true"/>				
										</td>	
									</tr>
									<tr>

										<td class="label">
											<label for="sucursalID">Sucursal: </label>
										</td>
										<td>
											<select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="3" iniforma="false" style="width:50%;">
												<option value="0">TODOS</option>
											</select>
										</td>
										
									</tr>
									<tr>
										<td class="label"> 
											<label for="producCreditoID">Producto de Crédito: </label> 
										</td>
										<td> 
							       			 <select id="producCreditoID" name="producCreditoID" path="producCreditoID" tabindex="4" style="width:50%;"   >
												<option value="0">TODOS</option>
											</select>       					        	
										</td>	
																
									</tr>		
									<tr class="datosNomina">
										<td class="label" >		
									         <label for="institNominaID">Empresa N&oacute;mina:</label> 
										</td>		
									    <td> 
									        <input type="text" id="institNominaID" name="institNominaID" size="11" tabindex="5"/> 
									        <input type="text" id="nombreinstitucionNomina" name="nombreinstitucionNomina" size="77"  disabled= "true" 
									          readonly="true" iniforma='true'/>
										</td>
									</tr>
									<tr class="datosNomina">
										<td class="label" >		
									         <label for="convenioNominaID">No. Convenio:</label> 
										</td>	
										<td>
											<input type="text" id="convenioNominaID" name="convenioNominaID" size="11" tabindex="6"/>
											<input type="text" id="desConvenio" name="desConvenio"   disabled="disabled" size="77"  />
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
														<input type="radio" id="excel" name="tipoReporte" value="1"  tabindex="7" checked="checked" />
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