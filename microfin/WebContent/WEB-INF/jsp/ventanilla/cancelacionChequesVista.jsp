<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cancelacionChequesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/chequesEmitidosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/asignarChequeSucurServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>		
		<script type="text/javascript" src="js/ventanilla/cancelacionCheques.js"></script> 
	</head>
<body>
	

	
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cancelacionCheques">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Reemplazo de Cheques</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" >							 
		<tr>
	 		<td class="label">
	 			<label for="lblIntitucion">Instituci&oacute;n: </label>	 			
	 		</td>
	 		<td>
	 			<form:input id="institucionIDCan" name="institucionIDCan" path="institucionIDCan" size="5" tabindex="1" />
	 			<input type="text" id="nombreInstitucionCan" name="nombreInstitucionCan" size="60" disabled="true" />	 			
	 		</td>
	 		<td class="separador"></td>
	 		<td class="label">
	 			<label for="lblNumCtaBancariaCan">N&uacute;mero de Cuenta Bancaria: </label>	 				 			
	 		</td>
	 		<td>
	 			<form:input id="numCtaBancariaCan" name="numCtaBancariaCan" path="numCtaBancariaCan"  size="25" tabindex="2" />	 			 				 			
	 		</td>
	 	</tr>
	 	
	 	<tr>
			<td class="label" >
				<label for="lblTipoChequera">Formato Cheque Cancelar:</label>
			</td>
			<td>
				<select id="tipoChequeraCan" name="tipoChequeraCan" tabindex="3">
					<option value="">SELECCIONAR</option>
				</select>
			</td>					 				
		</tr>
		<tr>																			
	 		<td class="label">
	 			<label for="lblnumChequeCan">N&uacute;mero de Cheque: </label>
	 		</td>
	 		<td>
	 			<form:input id="numChequeCan" name="numChequeCan" path="numChequeCan" size="20" tabindex="4" />
	 		</td>		 				
		</tr>
		<tr>
			 <td class="label">
				<label for="lblbeneficiario">Beneficiario: </label>
			</td>
			<td>
	 			<form:input type="text" name="beneficiarioCan"	id="beneficiarioCan" path="beneficiarioCan" size="45" tabindex="5" readonly="true" />				
	 		</td> 
	 		<td class="separador"></td>	 
			<td class="label">
				<label for="lblmonto"> Monto:</label>
			</td>
			<td>
				<form:input type="text" name="montoCan" id="montoCan" path="montoCan" size="20" tabindex="6" readonly="true"/>
			</td>				
		</tr>
		<tr>
			<td class="label">
				<label for="lblconcepto">Concepto:</label>
			</td>
			<td>
				<form:input path="conceptoCan" name="conceptoCan" id="conceptoCan" size="45" tabindex="7" readonly="true"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label class="label">Fecha:</label>
			</td>
			<td>
				<form:input name="fechaCan"  path="fechaCan" id="fechaCan" autocomplete="off" size="14" tabindex="8" readonly="true"/>
			</td>
		</tr>
		</table>	

		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend><label>Nuevo Cheque</label></legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
			 		<td class="label">
			 			<label for="lblIntitucionn">Instituci&oacute;n: </label>	 			
			 		</td>
			 		<td>
			 			<form:input id="institucionID" name="institucionID" path="institucionID" size="5" tabindex="9" />
			 			<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="60" disabled="true" />	 			
			 		</td>
			 		<td class="separador"></td>
			 		<td class="label">
			 			<label for="lblNumCtaBancaria">N&uacute;mero de Cuenta Bancaria: </label>	 				 			
			 		</td>
			 		<td>
			 			<form:input id="numCtaBancaria" name="numCtaBancaria" path="numCtaBancaria"  size="25" tabindex="10" />	 			 				 			
			 		</td>
			 	</tr>
			 	<tr>
					<td class="label" >
						<label for="lblTipoChequera">Formato Cheque:</label>
					</td>
					<td>
						<select id="tipoChequera" name="tipoChequera" tabindex="11">
							<option value="">SELECCIONAR</option>
						</select>
					</td>																						
				</tr>
				<tr>
					<td >
						<label>&Uacute;ltimo Cheque Utilizado en Esta Cuenta:</label>
					</td>					
					<td >
						<form:input type="text" id="ultimoChequeUtili" name="ultimoChequeUtili" path="ultimoChequeUtili" size="25"  readonly="true" />
					</td>
					<td class="separador"></td>
					<td></td>
					<td></td>					
				</tr>
				<tr>
					<td>
						<label>N&uacute;mero de Cheque:</label>
					</td>
					<td>
						<form:input path="numCheque" id="numCheque" name="numCheque" size="25" tabindex="13"/>
					</td>
					<td class="separador"></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td>
						<label>Confirmar N&uacute;mero de Cheque:</label>
					</td>
					<td>
						<form:input path="confimaNumCheque" id="confimaNumCheque" name="confimaNumCheque" size="25" tabindex="14"/>
					</td>					
					<td class="separador"></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td>
						<label>Nombre del Beneficiario:</label>
					</td>
					<td>
						<form:input path="beneficiario" id="beneficiario" name="beneficiario" size="45" tabindex="15" onBlur=" ponerMayusculas(this)" maxlength="100"/>
					</td>
					<td class="separador"></td>
					<td></td>
					<td></td>
				</tr>
			</table>
	</fieldset>
		<br>
			<table border="0" cellpadding="0" cellspacing="0" width="97%">
				<tr>
					<td class="label">
						<label>Motivo de Reemplazo:</label>
					</td>
					<td>
						<form:input path="motivoCancela" id="motivoCancela" name="motivoCancela" size="67" tabindex="16" onBlur=" ponerMayusculas(this)" maxlength="100"/>						
					</td>
					<td class="separador"></td>
					<td></td>
					<td></td>
				</tr>
			</table>

	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fieldsetAutoriza">
		<legend><label>Usuario Autoriza</label></legend>
		<table border="0" cellpadding="0" cellspacing="0" width="65%">
			<tr>
				<td class="label" nowrap="nowrap">
					<label>Usuario Autoriza:</label>
				</td>
				<td colspan="0">
					<form:input type="password" path="usuarioAutoriza" id="usuarioAutoriza" name="usuarioAutoriza" size="25" tabindex="17" autocomplete="new-password"/>
				</td>
				<td class="separador"></td>
				<td></td>
				<td></td>				
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label>Contraseña:</label>
				</td>
				<td colspan="0">
					<form:input type="password" path="passwdAutoriza" id="passwdAutoriza" name="passwdAutoriza" size="25" tabindex="18" autocomplete="new-password"/>
				</td>
				<td class="separador"></td>
				<td></td>
				<td></td>	
			</tr>
			<tr>
				<td>					
				</td>
				<td>
				</td>
				<td class="separador"></td>
				<td></td>
				<td></td>	
			</tr>
		</table>
	</fieldset>

	
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="cancelarCheque" name="cancelarCheque"  value="Reemplazar Cheque" tabindex="20" class="submit" style='width:160px; height:28px'/>
				<input type="button" id="imprimirCheque" name="imprimirCheque"  value="Imprimir Cheque" tabindex="21" class="submit" style='width:150px; height:28px'/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="usuarioLogin" name="usuarioLogin"/>
				<input type="hidden" id="numeroPoliza" name="numeroPoliza"/>
				<input type="hidden" id="rutaCheque"	name="rutaCheque"/>
				<input type="hidden" id="emitidoEn" name="emitidoEn"/>
				<input type="hidden" id="sucursalID" name="sucursalID" iniForma="false" /> 
				<input type="hidden" id="cajaID" name="cajaID" iniForma="false" />
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
