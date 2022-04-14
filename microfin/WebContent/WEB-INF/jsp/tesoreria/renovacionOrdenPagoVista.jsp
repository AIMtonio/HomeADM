<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/renovacionOrdenPagoServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/renovacionOrdenPago.js"></script> 
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="renovacionOrdenPago">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Renovaci&oacute;n de Orden de Pago</legend>
					<table border="0" width="100%" >							 
						<tr>
					 		<td class="label">
					 			<label for="institucionIDCan">Instituci&oacute;n: </label>	 			
					 		</td>
					 		<td>
					 			<form:input id="institucionIDCan" name="institucionIDCan" path="institucionIDCan" size="5" tabindex="1" autocomplete="off"/>
					 			<input type="text" id="nombreInstitucionCan" name="nombreInstitucionCan" size="60" disabled="true" />	 			
					 		</td>
					 		<td class="separador"></td>
					 		<td class="label">
					 			<label for="numCtaInstitCan">N&uacute;mero de Cuenta Bancaria: </label>	 				 			
					 		</td>
					 		<td>
					 			<form:input id="numCtaInstitCan" name="numCtaInstitCan" path="numCtaInstitCan"  size="25" tabindex="2"  maxlength="20" autocomplete="off"/>	 			 				 			
					 		</td>
					 	</tr>
					 	<tr>
					 		<td class="label">
					 			<label for="numOrdenPagoCan">Referencia: </label>
					 		</td>
					 		<td>
					 			<form:input id="numOrdenPagoCan" name="numOrdenPagoCan" path="numOrdenPagoCan" size="25" tabindex="3" maxlength="25" onBlur=" ponerMayusculas(this)" autocomplete="off"/>
					 		</td>		 		
					 		<td class="separador"></td>	 			
					 		<td class="label">
								<label for="beneficiarioCan">Beneficiario: </label>
							</td>
							<td>
					 			<form:input type="text" name="beneficiarioCan"	id="beneficiarioCan" path="beneficiarioCan" size="45" tabindex="4" readonly="true" autocomplete="off"/>				
					 		</td> 		
						</tr>
						<tr>
							<td class="label">
								<label for="montoCan"> Monto:</label>
							</td>
							<td>
								<form:input type="text" name="montoCan" id="montoCan" path="montoCan" size="25" tabindex="5" readonly="true" autocomplete="off"/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="conceptoCan">Concepto:</label>
							</td>
							<td>
								<form:input path="conceptoCan" name="conceptoCan" id="conceptoCan" size="45" tabindex="6" readonly="true" autocomplete="off"/>
							</td>				
						</tr>
						<tr>
							<td class="label">
								<label class="fechaCan">Fecha:</label>
							</td>
							<td>
								<form:input name="fechaCan"  path="fechaCan" id="fechaCan" autocomplete="off" size="25" tabindex="7" readonly="true"/>
							</td>
						</tr>
					</table>
					<br>	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend><label>Nueva Orden de Pago</label></legend>
						<table border="0" width="100%">
							<tr>
						 		<td class="label">
						 			<label for="institucionID">Instituci&oacute;n: </label>	 			
						 		</td>
						 		<td>
						 			<form:input id="institucionID" name="institucionID" path="institucionID" size="5" tabindex="8" autocomplete="off"/>
						 			<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="60" disabled="true" autocomplete="off"/>	 			
						 		</td>
						 		<td class="separador"></td>
						 		<td class="label">
						 			<label for="numCtaInstit">N&uacute;mero de Cuenta Bancaria: </label>	 				 			
						 		</td>
						 		<td>
						 			<form:input id="numCtaInstit" name="numCtaInstit" path="numCtaInstit"  size="25" tabindex="9"  maxlength="20" autocomplete="off"/>	 			 				 			
						 		</td>
						 	</tr>
							<tr>
								<td>
									<label for="numOrdenPago">Referencia:</label>
								</td>
								<td>
									<form:input path="numOrdenPago" id="numOrdenPago" name="numOrdenPago" size="25" tabindex="10" maxlength="25" onBlur=" ponerMayusculas(this)" autocomplete="off"/>
								</td>
								<td class="separador"></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td>
									<label for="confimaNumOrdenPago">Confirmar Referencia:</label>
								</td>
								<td>
									<form:input path="confimaNumOrdenPago" id="confimaNumOrdenPago" name="confimaNumCheque" size="25" tabindex="11" maxlength="25" onBlur=" ponerMayusculas(this)" autocomplete="off"/>
								</td>					
								<td class="separador"></td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td>
									<label for="beneficiario">Nombre del Beneficiario:</label>
								</td>
								<td>
									<form:input path="beneficiario" id="beneficiario" name="beneficiario" size="66" tabindex="12" onBlur=" ponerMayusculas(this)" maxlength="200" autocomplete="off"/>
								</td>
								<td class="separador"></td>
								<td></td>
								<td></td>
							</tr>
						</table>
					</fieldset>
					<br>
					<table border="0">
						<tr>
							<td class="label">
								<label for="motivoRenov">Motivo de Renovaci&oacute;n:</label>
							</td>
							<td>
								<form:input path="motivoRenov" id="motivoRenov" name="motivoRenov" size="70" tabindex="13" onBlur=" ponerMayusculas(this)" maxlength="150" autocomplete="off"/>						
							</td>
							<td class="separador"></td>
							<td></td>
							<td></td>
						</tr>
					</table>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="renovacion" name="renovacion"  value="Renovaci&oacute;n Orden de Pago" tabindex="20" class="submit" style='width:210px; height:28px'/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							</td>
						</tr>
					</table>
				</fieldset>	
			</form:form>
		</div>
		<div id="cargando" style="display: none;">	
		</div>
		<div id="cajaLista" style="display: none;">
		<div id="elementoLista"/></div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>