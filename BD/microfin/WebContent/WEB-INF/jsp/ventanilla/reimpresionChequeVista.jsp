<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/reimpresionChequeServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
		<script type="text/javascript" src="js/ventanilla/reimpresionCheque.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reimpresionCheque">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Reimpresión de Cheques</legend>			
	<table border="0" cellpadding="0" cellspacing="0" >
	 	
		<tr>
	 		<td class="label">
	 			<label for="lblIntitucion">Institución: </label>	 			
	 		</td>
	 		<td>
	 			<form:input id="institucionID" name="institucionID" path="institucionID" size="5" tabindex="1" />
	 			<input type="text" id="nombreInstitucion" name="numCtaBancaria" size="50" disabled="true" />	 			
	 		</td>
	 		<td class="separador"></td>
	 		<td>	 				 			
	 		</td>
	 		<td>	 				 			
	 		</td>
	 	</tr>
	 	<tr>
	 		<td class="label">
	 			<label for="lblNumCtaBancaria">Número de Cuenta Bancaria: </label>
	 		</td>
	 		<td>
	 			<form:input id="numCtaBancaria" name="numCtaBancaria" path="numCtaBancaria" size="25" tabindex="2" />
	 		</td>
	 	</tr>
	 	<tr>
			<td class="label" >
				<label for="lblTipoChequera">Formato Cheque:</label>
			</td>
			<td>
				<select id="tipoChequera" name="tipoChequera" tabindex="3">
					<option value="">SELECCIONAR</option>
				</select>
			</td>					 				
	 		<td class="separador"></td>
	 		<td>
				<label for="lblfemaEmision">Fecha Emisión: </label>
			</td>
			<td>
	 			<form:input type="text" name="fechaEmision"	id="fechaEmision" path="fechaEmision" autocomplete="off"
			esCalendario="true" size="14" tabindex="4" />
				
	 		</td>
		</tr>
		<tr>
			<td class="label">
	 			<label for="lblNroCheque">No. Cheque: </label>
	 		</td>
	 		<td>
	 		<form:input type="text" name="numCheque"	id="numCheque" path="numCheque" autocomplete="off"
			 size="14" tabindex="5" />
	 		</td>
	 		<td class="separador"></td>
	 		<td>
	 		<label for="lblNumCliente">No. <s:message code="safilocale.cliente"/>: </label>	 		
			</td>
			<td>
			<form:input type="text" name="numCliente"	id="numCliente" path="numCliente" autocomplete="off"
			 size="14" tabindex="6" readOnly="true" />
			</td>					 			
		</tr>	
		<tr>
			<td class="label">
	 			<label for="lblBeneficiario">Beneficiario: </label>
	 		</td>
	 		<td>
	 		<form:input type="text" name="beneficiario"	id="beneficiario" path="beneficiario" autocomplete="off"
			size="60" tabindex="7" readOnly="true"/>
			</td>
			<td class="separador"></td>
			<td class="label">
	 			<label for="lblMonto">Monto: </label>
	 		</td>
	 		<td>
	 		<form:input type="text" name="monto"	id="monto" path="monto" autocomplete="off"
			 size="14" tabindex="8" readOnly="true" />
			</td>				 			
		</tr>		
		<tr>
			<td class="label">
	 			<label for="lblConcepto">Concepto: </label>
	 		</td>
	 		<td>
	 		<form:input type="text" name="concepto"	id="concepto" path="concepto" autocomplete="off"
			 size="60" tabindex="9" readOnly="true" />
			</td>
			<td class="separador"></td>
			<td class="label">
	 			<label for="lblReferencia">Referencia:</label>
	 		</td>
	 		<td>
	 		<form:input type="text" name="referencia"	id="referencia" path="referencia" autocomplete="off"
			size="14" tabindex="10" readOnly="true"/>
			</td>				 			
		</tr>
		
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<input type="button" id="reimprimirCheque" name="reimprimirCheque" class="submit" value="Reimprime Cheque" tabindex="11" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="transaccion" name="transaccion">
				<input type="hidden" id="rutaCheque" name="rutaCheque">	
				<input type="hidden" id="cajaCheque" name="cajaCheque">
				<input type="hidden" id="sucursalCheque" name="sucursalCheque">	
				<input type="hidden" id="fechaEmisionCheque" name="fechaEmisionCheque">	
				<input type="hidden" id="horaCheque" name="horaCheque">	
				<input type="hidden" id="usuarioCheque" name="usuarioCheque">	
				<input type="hidden" id="polizaCheque" name="polizaCheque">	
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