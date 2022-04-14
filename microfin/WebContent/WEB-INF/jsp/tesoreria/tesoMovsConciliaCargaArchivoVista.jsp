<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/tesoMovsServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>   	
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="js/tesoreria/tesoMvtsConCarga.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form method="POST" commandName="tesoMovsArch" enctype="multipart/form-data" name="formaGenerica" id="formaGenerica">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all"> Archivo de Conciliaci&oacute;n</legend>
				<table border="0" width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0" width="100%">
								<tr>
									<td class="label">
								        <label for="institucionID">Instituci&oacute;n: </label> 
								    </td>
								    <td colspan="3">
								        <input type="text" id="institucionID" name="institucionID"  size="24" tabindex="1" autocomplete="off" />
								        <input type="text" id="nombreInstitucion" name="nombreInstitucion" size="50" disabled="true" readOnly="true"/> 
								    </td>
								</tr>
								<tr>
									<td class="label">
								        <label for="cuentaBancaria">Cuenta Bancaria: </label> 
								    </td>
								    <td colspan="3">
								    	<input type="text" id="cuentaBancaria" name="cuentaBancaria"  size="24" tabindex="2" autocomplete="off" />
								    	<input type="hidden" id="cuentaAhoID" name="cuentaAhoID"  size="24" />
								    	<input type="text" id="nombreBanco" name="nombreBanco" size="50" disabled="true" readOnly="true"/> 
								    </td>
								</tr>
								<tr>
									<td class="label"> 
										<label for="radioFormatoEstandar">Formato:</label> 
								   	</td>
									<td class="label">
										<table border="0" width="35%">
											<tr style="width: 100%">
												<td style="width: 43%; text-align: right;">
													<label for="radioFormatoBanco">Banco</label> 
												</td>
												<td style="width: 10%;">
													<input type="radio" id="radioFormatoBanco" name="formatoBanco" value="B" tabindex="3"  />
												</td>
												<td style="width: 37%; text-align: right;">
													<label for="radioFormatoEstandar">Est&aacute;ndar</label> 
												</td>
												<td style="width: 10%;">
													<input type="radio" id="radioFormatoEstandar" name="formatoEstandar" value="E" checked="checked" tabindex="4" />
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr id="trVersion" style="display: none;">
									<td class="label"> 
										<label for="versionAnterior">Versi&oacute;n:</label> 
								   	</td>
									<td class="label" >
										<table border="0" width="35%">
											<tr style="width: 100%">
												<td style="width: 40%; text-align: right;">
													<label for="versionAnterior">Anterior</label> 
												</td>
												<td style="width: 10%;">
													<input type="radio" id="versionAnterior" name="versionFormato" value="1" tabindex="3" checked="checked"/>
												</td>
												<td style="width: 40%; text-align: right;">
													<label for="versionActual">Actual</label> 
												<td style="width: 10%;">
													<input type="radio" id="versionActual" name="versionFormato" value="2" tabindex="4" />
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td colspan="5">
						<br/>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<legend class="label"><label>Rango de Fechas:</label></legend>	
							<table border="0" width="100%">
								<tr>
									<td class="label"> 
										<label for="fechaCargaInicial">Fecha Inicial:</label> 
								   	</td> 
								   	<td> 
								    	<form:input type="text" id="fechaCargaInicial" name="fechaCargaInicial"  size="14" tabindex="5" path="fechaCargaInicial" esCalendario="true"/> 
								   	</td>
								   	 <td class="separador"></td>
								   	<td class="label"> 
										<label for="fechaCargaFinal">Fecha Final:</label> 
								   	</td> 
								   	<td> 
								    	<form:input type="text" id="fechaCargaFinal" name="fechaCargaFinal"  size="14" tabindex="6" path="fechaCargaFinal" esCalendario="true"/> 
								   	</td>
							   	</tr>
							</table>
							</fieldset>
						</td>	
					</tr>
					<tr>
						<td colspan="5" align="right">		
							<form:input type="hidden" id="fechaCarga" name="fechaCarga"  size="14" path="fechaCargaFinal"/>							
							<input type="button" id="obtenerArchivo" name="obtenerArchivo" class="submit" value="Enviar Archivo" tabindex="7" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
							<input type="hidden" id="bancoEstandar" name="bancoEstandar" value="E" />
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>