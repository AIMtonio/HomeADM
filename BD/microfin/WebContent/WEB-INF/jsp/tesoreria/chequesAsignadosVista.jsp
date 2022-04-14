<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/chequesEmitidosServicio.js"></script>		
<script type="text/javascript" src="js/tesoreria/repChequesAsignados.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="chequesAsignados" target="_blank">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Cheques Asignados</legend>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
					 		<tr> 
					 			<td> 
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
		         						<table  border="0"  width="100%">
											<tr>
												<td class="label"> 
													<label>Fecha Inicio Dotaci&oacute;n: </label>
												</td>
												<td>
													<form:input type="text" name="fechaInicioEmision" id="fechaInicioEmision" path="fechaInicioEmision" autocomplete="off" size="12" tabindex="1"  esCalendario="true"/>						
												</td>
											</tr>
											<tr>
												<td class="label"> 
													<label>Fecha Final Dotaci&oacute;n: </label>
												</td>
												<td>
													<form:input type="text" name="fechaFinalEmision" id="fechaFinalEmision" path="fechaFinalEmision" autocomplete="off" size="12" tabindex="2"  esCalendario="true"/>						
												</td>
											</tr>
											<tr>
												<td class="label"><label>Instituci&oacute;n Bancaria:</label></td>
												<td>
													<form:input type="text" name="institucionID"	id="institucionID" path="institucionID" autocomplete="off" size="12" tabindex="3" />
													<input type="text"	name="nombInstitucionIni" id="nombInstitucionIni" autocomplete="off" size="40"  disabled="true" /> 
												</td>
											</tr>
											<tr>
												<td class="label"><label>N&uacute;mero Cuenta Bancaria:</label></td>
												<td>
													<form:input type="text" name="numCtaInstit" id="numCtaInstit" path="numCtaInstit" autocomplete="off" size="12
													" tabindex="4" />
													<input type="text" 	name="nombreCuenta" id="nombreCuenta" autocomplete="off" size="40" disabled="true" />
												</td>
											</tr>
											<tr>
												<td class="label"> 
										    		<label id="lbltipoChequera">Tipo Chequera:</label> 
												</td>
												<td>
								          			<form:select id="tipoChequera" name="tipoChequera" path="tipoChequera" tabindex="5" >
								          				<form:option value="P">PROFORMA</form:option>
							 	          				<form:option value="E">CHEQUERA</form:option>
							 	          				<form:option value="A">TODAS</form:option>
								          			</form:select>
								             	</td>
											</tr>
											<tr>
												<td class="label"><label>Sucursal: </label></td>
												<td>
													<form:input type="text" name="sucursalID" id="sucursalID" path="" autocomplete="off" size="12" tabindex="6" />
													<input type="text" 	name="nombreSucursal" id="nombreSucursal" autocomplete="off" size="40" disabled="true" />
												</td>		
											</tr>
						  			</table>
						 		</fieldset>  
							</td> 
							<td>
								<table width="200px"> 
								<tr>
									<td class="label" style="position:absolute;top:12%;">
										<fieldset class="ui-widget ui-widget-content ui-corner-all">
											<legend>
												<label>Presentaci&oacute;n: </label>
											</legend>
											<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="8" checked/> 
											<label>	PDF </label>
										</fieldset>
									</td>
								</tr>
								</table>
					  		</td>
						</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="5">
							<table align="right" border='0'>
								<tr>
									<td width="350px">&nbsp;</td>
									<td align="right">
										<input type="button" id="generar"	name="generar" class="submit" tabindex="9" value="Generar" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>	
			</fieldset>
		</form:form>
		</div>

		<div id="cajaLista" style="display: none;">
			<div id="elementoLista" />
		</div>
	</body>
</html>