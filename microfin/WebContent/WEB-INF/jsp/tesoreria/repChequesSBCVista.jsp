<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
<script type="text/javascript" src="js/tesoreria/repChequesSBC.js"></script>
</head>
<body>
	<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteChequesSBCBean" target="_blank">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Cheques SBC</legend>
			
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			 <tr> 
			 	<td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
         			<table  border="0"  width="100%">
						<tr>
							<td class="label"> 
								<label>Fecha Inicio: </label>
							</td>
							<td>
								<form:input type="text" name="fechaInicial" id="fechaInicial" path="fechaInicial" autocomplete="off" size="12" tabindex="1"  esCalendario="true"/>						
							</td>
						</tr>
						<tr>
							<td class="label"> 
								<label>Fecha Final: </label>
							</td>
							<td>
								<form:input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal" autocomplete="off" size="12" tabindex="2"  esCalendario="true"/>						
							</td>
						</tr>	
						<tr>
							<td class="label"><label>Institución:</label></td>
							<td>
								<form:input type="text" name="institucionIDIni"	id="institucionIDIni" path="institucionIDIni" autocomplete="off" size="12" tabindex="3" /> 
								<form:input type="text"	name="nombInstitucionIni" id="nombInstitucionIni" path="nombInstitucionIni" autocomplete="off" size="40"  disabled="true" />
							</td>
						
						</tr>
						<tr>	
							<td class="label"><label>Cuenta Bancaria:</label></td>
							<td>
								<form:input type="text" name="noCuentaInstituIni"	id="noCuentaInstituIni" path="noCuentaInstituIni" autocomplete="off" size="12" tabindex="4" />
								<input type="text" 	name="nombreCuenta" id="nombreCuenta" autocomplete="off" size="40" disabled="true" />
							</td>
						</tr>	
				
						<tr>
							<td class="label"><label>Cliente: </label></td>
							<td>
								<form:input id="clienteIDIni" name="clienteIDIni" path="clienteIDIni" tabindex="5" autocomplete="off" size="12" />
								<form:input type="text" name="nombreClienteIni" id="nombreClienteIni" path="nombreClienteIni" autocomplete="off" size="40" disabled="true" />
							</td>
						</tr>
						<tr>
							<td class="label"><label>Sucursal : </label></td>
							<td>
								<form:select id="sucursalID" name="sucursalID"		path="sucursalID" tabindex="6">
								<form:option value="0">TODAS</form:option>
								</form:select>
							</td>					
							
						</tr>
				
						<tr> 
							<td class="label" nowrap="nowrap">
								<label>Estatus de	Cheque: </label>
							</td>
							<td>
								<form:select id="estatusCheque" name="estatusCheque" path="estatusCheque" tabindex="7">
								<form:option value="R">RECIBIDO</form:option>
								<form:option value="A">APLICADO</form:option>
								<form:option value="C">CANCELADO</form:option>
								</form:select>
							</td>
								
								
						</tr>
						<tr>
							<td>
								<form:input type="hidden" name="nombreInstitucion" id="nombreInstitucion" path="nombreInstitucion" size="30" /> 
								<form:input type="hidden" name="nombreUsuario" id="nombreUsuario"	path="nombreUsuario" size="30" />
								<form:input type="hidden" name="fechaSistema" id="fechaSistema" path="fechaSistema"	size="12" />
							</td>
						</tr>
				
				  </table>
				 </fieldset>  
			</td> 
				
			<td> <table width="200px"> 
					<tr>
						<td class="label" style="position:absolute;top:12%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
									<legend>
										<label>Presentación: </label>
									</legend>
									<input type="radio" id="excel" name="excel"  tabindex="8" />
									<label> Excel </label>
									<br> 
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="9" /> 
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
									<input type="button" id="generar"	name="generar" class="submit" tabindex="12" value="Generar" />
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