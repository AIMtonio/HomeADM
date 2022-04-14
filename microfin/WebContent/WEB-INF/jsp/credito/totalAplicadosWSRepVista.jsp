<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>  
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="js/credito/totalAplicadosWSRep.js"></script>
	</head>
      
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bitacoraDomiciPagosBean">

			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Bit&aacute;cora Domiciliaci&oacute;n</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr> 
	 					<td> 
			 				<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend><label>Par&aacute;metros: </label> </legend>
		 						<table border="0" width="100%">
									<tr> 
										<td class="label"> 
											<label for="lblFechaInicio">Fecha de Inicio:</label> 
										</td> 
										<td class="separador"/>
					   					<td> 
					    					<input type="text" id="fechaInicio" name="fechaInicio"  size="12" tabindex="2" esCalendario="true"/> 
					   					</td>
					   					<td class="separador"/>
				 					</tr>
					 				<tr>
					   					<td class="label"> 
											<label for="lblFechaFin">Fecha de Fin:</label> 
					   					</td> 
					   					<td class="separador"/>
					   					<td> 
					    					<input type="text" id="fechaFin" name="fechaFin"  size="12" tabindex="3" esCalendario="true"/> 
					   						
					   					</td>
					   					<td class="separador"/> 
									</tr>
									<tr>
										<td class="label">
											<label>Instituci&oacute;n de N&oacute;mina:</label>
										</td>
										<td class="separador"/>
										<td nowrap="nowrap">
											<input type="text" id="institNominaID" name="institNominaID" size="10" tabindex="4"/>
											<input type="text" id="institNomina" name="institNomina" size="40" readonly="readonly" disabled="disabled"/>
										</td>
										<td class="separador"/>
									</tr>
									<tr>
										<td class="label">
											<label>Convenio de N&oacute;mina:</label>
										</td>
										<td class="separador"/>
										<td nowrap="nowrap">
											<input type="text" id="convenioNominaID" name="convenioNominaID" size="10" tabindex="5"/>
											<input type="text" id="nombreConvenio" name="nombreConvenio" size="40" readonly="readonly" disabled="disabled"/>
										</td>
										<td class="separador"/>
									</tr>
																
								</table>
							</fieldset>
						</td>
							
						<td>
							<table width="200px"> 
								<tr>
									<td class="label" style="position:absolute;top:8%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">                
											<legend><label>Presentaci&oacute;n</label></legend>
													<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="12">
													<label> Excel </label>
						 				</fieldset>
									</td>      
								</tr>
							</table> 
						</td>
					</tr>
				</table>
				<input type="hidden" id="reporte" name="reporte"/>
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tbody>
						<tr>
							<td align="right">
								<a id="ligaGenerar" href="repBitacoraPagos.htm" target="_blank">
									<input type="button" class="submit" id="generar" name="generar" value="Generar" tabindex="13"/>
								</a>
							</td>
						</tr>
					</tbody>
					
				</table>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>	
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	</body>
	<div id="Contenedor" style="display: none;"></div>
	<div id="mensaje" style="display: none;"></div>
</html>