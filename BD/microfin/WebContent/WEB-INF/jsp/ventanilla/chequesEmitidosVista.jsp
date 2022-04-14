<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 	
		<script type="text/javascript" src="js/ventanilla/chequesEmitidos.js"></script>   		     
	</head>
   
<body>
<div id="contenedorForma">													  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="abonoChequeSBCBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Cheques Recibidos</legend>
	<table border="0" width="100%">
		<tr> 
		 <td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>
					<label>Parámetros: </label> 
				</legend>
					<table border="0" width="100%">
						<tr>
							<td class="label">
								<label for="fechaRecepcion">Fecha Inicio Recepci&oacute;n: </label>
							</td>
							<td>
								<form:input type="text" id="fechaCobro" name="fechaRecepcion" size="14" tabindex="1" autocomplete="off" path="fechaCobro" esCalendario="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="fechaFinCobro">Fecha Final Recepci&oacute;n: </label>
							</td>
							<td>
								<form:input type="text" id="fechaFinCobro" name="fechaFinCobro" size="14" tabindex="2" autocomplete="off" path="fechaFinCobro" esCalendario="true"/>
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="bancoEmisor">Instituci&oacute;n Bancaria:</label>
							</td>
							<td>
								<form:input type="text" id="bancoEmisor" name="bancoEmisor" size="14" tabindex="3" autocomplete="off" path="bancoEmisor" />
								<input type="text" id="nombreInstitucion" name="nombreInstitucion"  autocomplete="off" size="40"  readOnly="true" /> 
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="cuentaEmisor">N&uacute;mero Cuenta Bancaria:</label>
							</td>
							<td>
								<form:input type="text" id="cuentaEmisor" name="cuentaEmisor" size="14" tabindex="4" autocomplete="off" path="cuentaEmisor" />
								<input type="text" 	name="nombreCuenta" id="nombreCuenta" autocomplete="off" size="40" readonly="true" />
							</td>
						</tr>
						<tr>
							<td class="label"> 
								<label for="numCheque">N&uacute;mero Cheque: </label> 
							</td>
							<td>
								<form:input type="text" id="numCheque" name="numCheque" size="14" tabindex="5" autocomplete="off" path="numCheque" />					 
							</td>
						</tr>
						<tr>
							<td class="label">
								<label for="clienteID">Socio:</label>
							</td>
							<td>
								<form:input type="text" id="clienteID" name="clienteID" size="14" tabindex="6" autocomplete="off" path="clienteID" />
								<input type="text" id="nombreCliente" name="nombreCliente"  size="40"  autocomplete="off" readOnly="true" /> 
							</td>
						</tr>
						<tr>
							<td class="label"> 
								<label for="estatus">Estatus: </label> 
							</td>
							<td>
								<select id="estatus" name="estatus" path="estatus" tabindex="7" >
									<option value="T">TODOS</option>
									<option value="R">RECIBIDO</option>
									<option value="A">APLICADO</option>
									<option value="C">CANCELADO</option>
								</select>									 
							</td>
						</tr>
						<tr>
							<td class="label"> 
						         <label for="sucursalID">Sucursal Recepci&oacute;n: </label> 
						      </td>
						      <td>
						         <input type="text" id="sucursalID" name="sucursalID" size="14" tabindex="8" value="0" autocomplete="off"/> 
						          <input type="text" id="sucursalDes" name="sucursalDes" size="40" value="TODAS" readonly="true" /> 
						      </td> 
						</tr>
	 
					</table>
				</fieldset>
			</td>
			<td> 
				 <table width="200px"> 
					<tr>
						<td class="label" style="position: absolute; top: 10%;" > 	
							<fieldset class="ui-widget ui-widget-content ui-corner-all">		
								<legend><label>Presentaci&oacute;n</label></legend>
								<table border="0" width="100%" position>
									<tr>
										<td>
											<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="9"  checked="checked" >
											<label> PDF </label>
											<br>
											<input type="radio" id="excel" name="pdf" value="excel" tabindex="10">
											<label> Excel </label>
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
	<br>
	<table align="right">
		<tr>
			<td class="label"> 
				<label for="lblExporta"> </label> 
			</td>
			<td align="right">		
				<a id="ligaGenerar" href="exportaReporteCheques.htm" target="_blank">
					 <input type="button" class="submit" id="generarArchivo" tabindex="11" value="Generar" />
				</a>		
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