<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/paramsReservCastigServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>   
	<script type="text/javascript" src="js/credito/paramsReservCastig.js"></script>  
</head>
<body>
<div id="contenedorForma">
<input type="hidden" id="transaccionGeneral" name="transaccionGeneral" />  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramsReservCastigBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros Calificaci&oacute;n y Castigos</legend>		
	<br>				
	<table border="0" cellpadding="0" cellspacing="0" width="30%">
		<tr>
			<td class="label">
				<label>Empresa:</label>
			</td>
			<td>
				<form:input id="empresaID" name="empresaID" path="empresaID" type="text" size="6" tabindex="1"/>
			<td>		
		</tr>
	</table>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend>Estimaci&oacute;n de Reservas</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label>Registro Contable EPRC:</label>
			</td>
			<td>
				<form:radiobutton id="regContaEPRC" name="regContaEPRC" path="regContaEPRC" value="P" tabindex="2" />
				<label for="">Cuenta Puente</label>
				<form:radiobutton id="regContaEPRC1" name="regContaEPRC1" path="regContaEPRC" value="R" tabindex="3" />
				<label for="">Cuenta de Resultados</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>EPRC de Int. Moratorio:</label>
			</td>
			<td>
				<form:radiobutton id="ePRCIntMorato" name="ePRCIntMorato" path="ePRCIntMorato" value="S" tabindex="4" />
				<label for="si">Si</label>
				<form:radiobutton id="ePRCIntMorato1" name="ePRCIntMorato1" path="ePRCIntMorato" value="N" tabindex="5" />
				<label for="no">No</label>			
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>Dividir EPRC de Capital e Intereses:</label>
			</td>
			<td>
				<form:radiobutton id="divideEPRCCapitaInteres" name="divideEPRCCapitaInteres" path="divideEPRCCapitaInteres" value="S" tabindex="6" />
				<label for="si">Si</label>
				<form:radiobutton id="divideEPRCCapitaInteres1" name="divideEPRCCapitaInteres1" path="divideEPRCCapitaInteres" value="N" tabindex="7" />
				<label for="no">No</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>EPRC Adicional de Cartera Vencida: </label>
			</td>
			<td>
				<form:radiobutton id="eprcAdicional" name="eprcAdicional" path="eprcAdicional" value="S" tabindex="8" />
				<label for="si">Si</label>
				<form:radiobutton id="eprcAdicional1" name="eprcAdicional1" path="eprcAdicional" value="N" tabindex="9" />
				<label for="no">No</label>
			</td>
		</tr>
		
	</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend >Castigos</legend>						
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="label">
				<label>Condonar Inter&eacute;s de Cartera Vencida:</label>
			</td>
			<td>
				<form:radiobutton id="condonaIntereCarVen" name="condonaIntereCarVen" path="condonaIntereCarVen" value="S" tabindex="10" />
				<label for="si">Si</label>
				<form:radiobutton id="condonaIntereCarVen1" name="condonaIntereCarVen1" path="condonaIntereCarVen" value="N" tabindex="11" />
				<label for="no">No</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>Condonar Moratorios de Cartera Vencida:</label>
			</td>
			<td>
				<form:radiobutton id="condonaMoratoCarVen" name="condonaMoratoCarVen" path="condonaMoratoCarVen" value="S" tabindex="12" />
				<label for="si">Si</label>
				<form:radiobutton id="condonaMoratoCarVen1" name="condonaMoratoCarVen1" path="condonaMoratoCarVen" value="N" tabindex="13" />
				<label for="no">No</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>Condonar Accesorios:</label>
			</td>
			<td>
				<form:radiobutton id="condonaAccesorios" name="condonaAccesorios" path="condonaAccesorios" value="S" tabindex="14" />
				<label for="si">Si</label>
				<form:radiobutton id="condonaAccesorios1" name="condonaAccesorios1" path="condonaAccesorios" value="N" tabindex="15" />
				<label for="no">No</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>Dividir Castigo (Capital, Interés, Moratorio): </label>
			</td>
			<td>
				<form:radiobutton id="divideCastigo" name="divideCastigo" path="divideCastigo" value="S" tabindex="16" />
				<label for="si">Si</label>
				<form:radiobutton id="divideCastigo1" name="divideCastigo1" path="divideCastigo" value="N" tabindex="17" />
				<label for="no">No</label>
			</td>
		</tr>
		<tr>
			<td class="label">
				<label>IVA en Recuperaci&oacute;n: </label>
			</td>
			<td>
				<form:radiobutton id="IVARecuperacion" name="IVARecuperacion" path="IVARecuperacion" value="S" tabindex="16" />
				<label for="si">Si</label>
				<form:radiobutton id="IVARecuperacion1" name="IVARecuperacion" path="IVARecuperacion" value="N" tabindex="17" />
				<label for="no">No</label>
			</td>
		</tr>
	</table>
	</fieldset>
	<table width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="18"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>
	</table>		
</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;"></div>
<div id="mensaje" style="display: none;"></div>	
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
</html>