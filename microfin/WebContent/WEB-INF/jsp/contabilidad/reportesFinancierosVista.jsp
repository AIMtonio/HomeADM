<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/ejercicioContableServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoEstaFinancierosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
		<script type="text/javascript" src="js/contabilidad/reportesFinancieros.js"></script>
	</head>
	<body></br>
		<div id="contenedorForma">
			<fieldset class="ui-widget ui-widget-content ui-corner-all" >
			<legend class="ui-widget ui-widget-header ui-corner-all">Reportes Financieros</legend>	
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteFinancierosBean"  target="_blank">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>			
							<td class="label"> 
								<label for="lblTipoReporteFinanciero">Tipo Reporte:</label>        	
								<select id="estadoFinanID" name="estadoFinanID" path="estadoFinanID"  >
									<option value="0">TODOS</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="label"><br>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend><label>Consulta Balanza a</label></legend>
								<input type="radio" id="tipoConsulta" name="tipoConsulta" path="tipoConsulta" value="D" />
								<label> Fecha o D&iacute;a</label><br>
								<input type="radio" id="tipoConsulta2" name="tipoConsulta2"  path="tipoConsulta" value="P" />
								<label>Cierre del Periodo</label>
							</td>
							<td class="separador"></td>						
							<td class="separador"></td>
							<td class="separador"></td>	
							<td>
							<br>
								<label>Fecha:</label>					
								<input type="text" name="fecha" id="fecha" path="fecha"	disabled ="true"  size="10" esCalendario="true"  />		
							</td>
						</tr>					
						<tr>
							<td><br>
								<label>Ejercicio:</label>					
								<select id="numeroEjercicio" name="numeroEjercicio" path="numeroEjercicio"  >
									<option value="0">SELECCIONAR</option>
								</select>
								<input type="text" name="finEjercicio" id="finEjercicio" path="finEjercicio" autocomplete="off" size="14" />
								<input type="hidden" id="inicioEjercicio" name="inicioEjercicio"/>										 						
							</td>
							<td class="separador"></td>	
								<td class="separador"></td>	
								<td class="separador"></td>	
							<td><br>
								<label>Periodo:</label>					
								<select id="numeroPeriodo" name="numeroPeriodo" path="numeroPeriodo">
									<option value="0">SELECCIONAR</option>
								</select>				
								<input type="hidden" name="inicioPeriodo" id="inicioPeriodo" path="inicioPeriodo" autocomplete="off" size="14"  />	
								<input type="hidden" name="finPeriodo" id="finPeriodo" path="finPeriodo" autocomplete="off" size="14"  />	
							</td>		
						</tr>		
						<tr>				
							<td class="label"> <br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Cifras en </label></legend>
								<input type="radio" id="cifras" name="cifras" path="cifras" value="P" />
								<label> Pesos </label><br>
								<input type="radio" id="cifras2" name="cifras2" path="cifras" value="M" />
								<label> Miles </label>
							</td>
						</tr>
						<tr>
							<td><br></td>
						</tr>
						<tr>
							<td>
								<table>
									<tr>
										<td class="label">
											<label>C.Costos Inicial:</label>
										</td>
										<td>
											<input type="text" id="ccinicial" name="ccinicial" size="11" /> 
											<input type="text" id="descripcionI" name="descripcionI" size="30" readOnly="true"/> 
										</td>
									</tr>
									<tr>
										<td class="label">
											<label>C.Costos Final:&nbsp;</label>
										</td>
										<td>
											<input type="text" id="ccfinal" name="ccfinal" size="11"  /> 
											<input type="text" id="descripcionF" name="descripcionF" size="30" readOnly="true"/> 
										</td>
									</tr>
								</table>	
							</td>
						</tr>			
						<tr>
							<td class="label"><br>
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pantalla" name="pantalla" />
									<label> Pantalla </label><br> 	
									<input type="radio" id="pdf" name="pdf" value="pdf"/>
									<label> PDF </label><br>
									<input type="radio" id="excel" name="excel" value="excel" />
									<label id="lblExcel">Excel</label>
								</fieldset>
							</td>
						</tr>				
						<tr>		
							<td colspan="5"></br>
								<table align="right" border='0'>
									<tr>
										<td align="right">
											<input type="button"  id="generar" name="generar" class="submit" value="Generar" />
										</td>				
									</tr>
								</table>		
							</td>
						</tr>
					</table>
				</form:form>
			</fieldset>
		</div>						
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
</html>