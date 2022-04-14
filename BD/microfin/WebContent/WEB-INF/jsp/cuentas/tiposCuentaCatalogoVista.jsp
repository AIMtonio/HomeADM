<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/smsPlantillaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	    <script type="text/javascript" src="dwr/interface/catalogoNivelesServicio.js"></script>
		<script type="text/javascript" src="js/cuentas/tiposCuentaCatalogo.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposCuenta">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de <s:message code="safilocale.ctaAhorro"/></legend>
		   <table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
			     <td class="label">
			         <label for="tipoCuentaID">Tipo Cuenta:</label>
			     </td>
			     <td>
			         <form:input type="text" id="tipoCuentaID" name="tipoCuentaID" path="tipoCuentaID" size="7" tabindex="1" />
			         </td>
			      <td class="separador"></td>

			      <td class="label">
			         <label for="monedaID">Moneda:</label>
			     </td>
			     <td>
			         <form:select id="monedaID" name="monedaID" path="monedaID" tabindex="2">
							<form:option value="">SELECCIONAR</form:option>
					</form:select>
			     </td>
			 	</tr>
				<tr>
			     <td class="label">
			         <label for="descripcion">Descripci&oacute;n: </label>
			     </td>
			     <td>
			         <form:input type="text" id="descripcion" name="descripcion" path="descripcion" size="30"
			         	onBlur=" ponerMayusculas(this)" tabindex="3" maxlength="30"/>
			     </td>
			          <td class="separador"></td>

			      <td class="label">
			         <label for="abreviacion">Abreviaci&oacute;n: </label>
			     </td>
			     <td>
			         <form:input type="text" id="abreviacion" name="abreviacion" path="abreviacion" size="20"
			         	onBlur=" ponerMayusculas(this)" tabindex="4" maxlength="10" />
			     </td>
				 </tr>

				<tr>
			     <td class="label">
			         <label for="lblIntereses">Genera Inter&eacute;s: </label>
			     </td>
			     <td>
						<form:select id="generaInteres" name="generaInteres" path="generaInteres" tabindex="5">
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
					</td>
			      <td class="separador"></td>
			      <td class="label">
			         <label for="lblTipoInteres">Tipo Inter&eacute;s: </label>
			     </td>
			     <td>
			     		<label for="lblTipoInteresD">Diario</label>
						<form:radiobutton id="tipoInteresD" name="tipoInteres" path="tipoInteres"
						 	value="D" tabindex="6" checked="checked" />&nbsp;&nbsp;
						<label for="lblTipoInteresM">Mensual</label>
						<form:radiobutton id="tipoInteresM" name="tipoInteres" path="tipoInteres"
						 	value="M" tabindex="7"/>
					</td>
			 	</tr>

				<tr>
					<td class="label">
			         <label for="lblServicio">Es Cuenta de Servicio: </label>
			     	</td>
			     	<td>
			         <form:select id="esServicio" name="esServicio" path="esServicio" tabindex="8">
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
			     	</td>
			   	<td class="separador"></td>
			     	<td class="label">
			         <label for="EsBancaria">Es Cuenta Bancaria: </label>
			     	</td>
			     	<td>
						<form:select id="esBancaria" name="esBancaria" path="esBancaria"  tabindex="9">
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
			     	</td>
			 	</tr>
			 	<tr>
			 		<td class="label">
			    		<label for="minimoApertura">Monto M&iacute;nimo Apertura: </label>
			     	</td>
			     	<td>
			         	<form:input type="text" id="minimoApertura" name="minimoApertura" path="minimoApertura" size="12" tabindex="10" esMoneda="true"
			         		style="text-align: right;" />
			     	</td>
			     	<td class="separador"></td>
				 	<td class="label">
			 			<label for="tipoPersona">Tipo Persona:</label>
			 		</td>
			 		<td>
			 			<select multiple id="tipoPersona" name="tipoPersona" tabindex="11" size="4">
							<option value="M">Persona Moral</option>
					     	<option value="A">Persona F&iacute;sica Con Actividad Empresarial</option>
					     	<option value="F">Persona F&iacute;sica Sin Actividad Empresarial</option>
					     	<option value="E">Menor de Edad</option>
			     		</select>
					</td>



			 	</tr>
			 	<tr>
			 	<td class="label">
			    		<label for="lblGatInformativo">GAT Informativo: </label>
			     	</td>
			     	<td>
			         	<form:input type="text" id="gatInformativo" name="gatInformativo" path="gatInformativo" size="5" tabindex="12" style="text-align: right;" onkeypress="return validaDigitosConNegat(event)"/>
			         	<label for="lblGatInformativo">%</label>
			     	</td>
			     	</tr>
			 	<tr>
			 		<td class="label">
			 			<label for="esBloqueoAuto">Es Bloqueo Autom&aacute;tico:</label>
			 		</td>
			 		<td>
			 			<form:select id="esBloqueoAuto" name="esBloqueoAuto" path="esBloqueoAuto" tabindex="13">
			 				<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
			 		</td>
			 		<td class="separador"></td>
				 	<td class="label">
			 			<label for="clasificacionConta">Clasificaci&oacute;n Contable:</label>
			 		</td>
			 		<td>
			 			<label for="clasificacionContaV">Dep&oacute;sitos a la Vista</label>
						<input type="radio" id="clasificacionContaV" name="clasificacionContaV" value="V" tabindex="14" checked="checked" />&nbsp;&nbsp;
						<label for="clasificacionContaA">Ahorro(Ordinario)</label>
						<input type="radio" id="clasificacionContaA" name="clasificacionContaA" value="A" tabindex="15" />
						<form:input type="hidden" id="clasificacionConta" name="clasificacionConta" path="clasificacionConta" size="12" tabindex="16" value="V" />
					</td>
			 	</tr>
			 	<tr>
			 		<td>
			 			<label for="lblNotificaSmsLabel">Notifica via SMS Autorización: </label>
			 		</td>
			 		<td>
			 			<form:input type="radio" id="notificaSms" name="notificaSms" path="notificaSms" tabindex="16" value="S"/><label id="notificaSmsSilbl">Si</label>
			 			<form:input type="radio" id="notificaSms2" name="notificaSms" path="notificaSms" tabindex="16" value="N"/><label id="notificaSmsSilbl">No</label>
			 		</td>
			 		<td class="separador"></td>
			 		<td id="plantillaLbl">
			 			<label for="lblPlantilla SMS">Plantilla SMS: </label>
			 		</td>
			 		<td id="plantillaFields">
			 			<form:input type="text" id="plantillaID" name="plantillaID" path="plantillaID" size="10" tabindex="17" maxlength="3" autoComplete="off"/>
			 			<form:input type="text" id="plantillaDes" name="plantillaDes" path="plantillaDes" size="25" tabindex="18" maxlength="15" onBlur="ponerMayusculas(this)" disabled="true"/>
			 		</td>
				</tr>
				<tr>
			 		<td>
			 			<label for="depositoActivaSI">Depósito para Activación: </label>
			 		</td>
			 		<td>
			 			<form:input type="radio" id="depositoActivaSI" name="depositoActiva" path="depositoActiva" tabindex="18" value="S"/><label>Si</label>
			 			<form:input type="radio" id="depositoActivaNO" name="depositoActiva" path="depositoActiva" tabindex="18" value="N"/><label>No</label>
			 		</td>
			 		<td class="separador"></td>
					<td class="label" id="tdLblMontoDepositoActiva" style="display: none;"> 
					    <label for="montoDepositoActiva">Monto para Activación Cta: </label> 
					</td> 
					<td id="tdMontoDepositoActiva" style="display: none;"> 
					    <form:input type="text" id="montoDepositoActiva" name="montoDepositoActiva" path="montoDepositoActiva" size="15" tabindex="18" esMoneda="true" style="text-align: right;"  maxlength="18"/> 
					</td> 					
				</tr>
			 </table>
			 <br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Nivel de Cuenta</legend>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
		 	    <td class="label" width="140">
		         <label for="nivelCtaID">Nivel de Cuenta: </label>
		     	</td>
		    	<td>
			     		<select id="nivelCtaID" name="nivelCtaID" tabindex="18">
							<option value="">SELECCIONAR</option>
						</select>
			 	</td>
		 	</tr>
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Restricciones Generales por Nivel de Cuenta</legend>
		   <table border="0" cellpadding="2" cellspacing="0" width="100%">

				<tr>
					<td class="label"><label for="lblDireccionOficial">Valida
							Direcci&oacute;n Oficial: </label></td>
					<td><form:select id="direccionOficial"
							name="direccionOficial" path="" tabindex="19"
							style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
							<form:option value="I">INDISTINTO</form:option>
						</form:select></td>
					<td class="separador"></td>
					<td class="label"><label for="lblIdenOficial">Valida
							Identificaci&oacute;n Oficial: </label></td>
					<td><form:select id="idenOficial" name="idenOficial"
							path="" tabindex="20" style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
							<form:option value="I">INDISTINTO</form:option>
						</form:select></td>

				</tr>
				<tr>
					<td class="label"><label for="lblConCuenta">Valida
							Conocimiento de Cliente y Cuenta: </label></td>
					<td><form:select id="conCuenta" name="conCuenta"
							path="" tabindex="21" style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
							<form:option value="I">INDISTINTO</form:option>
						</form:select></td>
					<td class="separador"></td>
					<td class="label"><label for="lblRegistroFirmas">Valida
							Registro Firmas: </label></td>
					<td><form:select id="registroFirmas" name="registroFirmas"
							path="" tabindex="22" style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
							<form:option value="I">INDISTINTO</form:option>
						</form:select>
					</td>

				</tr>

				<tr>
					<td class="label"><label for="lblRelacionadoCuenta">Valida
							Relacionado Cuenta: </label></td>
					<td><form:select id="relacionadoCuenta"
							name="relacionadoCuenta" path="" tabindex="23"
							style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
							<form:option value="I">INDISTINTO</form:option>
						</form:select></td>
					<td class="separador"></td>

					<td class="label" style="display: none;"><label for="lblCheckListExpFisico">Requiere
							Check-List y Expediente F&iacute;sico: </label></td>
					<td style="display: none;"><form:select id="checkListExpFisico"
							name="checkListExpFisico" path=""
							tabindex="24" style="width:115px">
							<!--<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>-->
							<form:option value="N">NO</form:option>
							<!--<form:option value="I">INDISTINTO</form:option>-->
						</form:select>
					</td>

					<!--SELECT PARA VALIDACIÓN DE ESTADO CIVIL -->
					<td class="label"><label for="lblEstadoCivil">Valida
							Estado Civil: </label></td>
					<td><form:select id="estadoCivil"
							name="estadoCivil" path="" tabindex="24"
							style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
						</form:select>
					</td>

				</tr>

				<tr id="trHuella">

					<td class="label"><label for="lblHuellasFirmante">Valida
							Huellas Firmante: </label></td>
					<td><form:select id="huellasFirmante" name="huellasFirmante"
							path="" tabindex="25" style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
							<form:option value="I">INDISTINTO</form:option>
						</form:select></td>
				</tr>
				<tr>
					<td class="label"><label for="lblLimAbonosMensuales">Limita
							Abonos Mensuales: </label></td>
					<td><form:select id="limAbonosMensuales"
							name="limAbonosMensuales" path=""
							tabindex="26" style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
						</form:select></td>
					<td class="separador"></td>
					<td id="tdAbonosMenHastaLbl" class="label"><label
						for="lblAbonosMenHasta">Abonos Mensuales Hasta:</label></td>
					<td id="tdAbonosMenHastaText"><form:input type="text"
							id="abonosMenHasta" name="abonosMenHasta" path=""
							size="12" tabindex="27" style="text-align: right;" /> <label
						for="lblUdis">UDIS</label></td>

				</tr>

				<tr id="trPerAboAdi">
					<td id="tdPerAboAdiLbl" class="label"><label
						for="lblPerAboAdi">Permite Abonos Adicionales: </label></td>
					<td id="tdPerAboAdiSelect"><form:select id="perAboAdi"
							name="perAboAdi" path="" tabindex="28"
							style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
						</form:select></td>
					<td class="separador"></td>
					<td id="tdAboAdiHasLbl" class="label"><label
						for="lblAboAdiHas">Abonos Adicionales Hasta:</label></td>
					<td id="tdAboAdiHasText"><form:input type="text"
							id="aboAdiHas" name="aboAdiHas" path="" size="12"
							tabindex="29" style="text-align: right;" /> <label
						for="lblUdis">UDIS</label></td>

				</tr>

				<tr id="trLimSaldoCuenta">
					<td id="tdLimSaldoCuentaLbl" class="label"><label
						for="lblLimSaldoCuenta">Limita Saldo en Cuenta: </label></td>
					<td id="tdLimSaldoCuentaSelect"><form:select
							id="limSaldoCuenta" name="limSaldoCuenta" path=""
							tabindex="30" style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
						</form:select></td>
					<td class="separador"></td>
					<td id="tdSaldoHastaLbl" class="label"><label
						for="lblSaldoHasta">Limita Saldo Hasta:</label></td>
					<td id="tdSaldoHastaText"><form:input type="text"
							id="saldoHasta" name="saldoHasta" path="" size="12"
							tabindex="31" style="text-align: right;" /> <label
						for="lblUdis">UDIS</label></td>

				</tr>
			</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Comisiones</legend>
		   <table border="0" cellpadding="0" cellspacing="0" width="100%">
		   	<tr>
			     <td class="label">
			         <label for="lblcomApertura">Comisi&oacute;n por Apertura: </label>
			     </td>
			     <td>
			         <form:input type="text" id="comApertura" name="comApertura" path="comApertura" size="12"
			         		tabindex="32" esMoneda="true" style="text-align: right;"  />
			     </td>
			     <td class="separador"></td>

			     <td class="label">
			         <label for="lblComManejoCta">Comisi&oacute;n por Manejo Cuenta: </label>
			     </td>
			     <td>
			         <form:input type="text" id="comManejoCta" name="comManejoCta" path="comManejoCta" size="12"
			         		tabindex="33" esMoneda="true" style="text-align: right;" />
			     </td>
			    </tr>
				 <tr>
			      <td class="label">
			         <label for="lblCoAniversario">Comisi&oacute;n por Aniversario:</label>
			     </td>
			     <td>
			         <form:input type="text" id="comAniversario" name="comAniversario" path="comAniversario" size="12"
			          tabindex="34" esMoneda="true" style="text-align: right;" />
			     </td>
			     <td class="separador"></td>

			     <td class="label">
			         <label for="lblCobraCoBE">Comisi&oacute;n Banca En L&iacute;nea:</label>
			     </td>
			     <td>
			         <form:select id="cobraBanEle" name="cobraBanEle" path="cobraBanEle" tabindex="35">
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
			     </td>
			    </tr>
				<tr>
			        <td class="label">
			         <label for="lblCoFalsoCobro">Comisi&oacute;n por Falso Cobro: </label>
			     </td>
			     <td>
			         <form:input type="text" id="comFalsoCobro" name="comFalsoCobro" path="comFalsoCobro" size="12"
			         		tabindex="36" esMoneda="true" style="text-align: right;"/>
			     </td>

				   <td class="separador"></td>
			    <td class="label">
			         <label for="lblExPrTo">Exenta Cobro Comisi&oacute;n Primer Disp. Seg.: </label>
			     </td>
			     <td>
			         <form:select id="ExPrimDispSeg" name="ExPrimDispSeg" path="ExPrimDispSeg" tabindex="37" >
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
			     </td>
			     </tr>
			     <tr>

			    <td class="label">
			         <label for="lblCoDiSe">Comisi&oacute;n Dispositivo de Seguridad: </label>
			     </td>
			     <td>
			         <form:input type="text" id="comDispSeg" name="comDispSeg" path="comDispSeg" size="12" tabindex="38"
			         	esMoneda="true" style="text-align: right;" />
			     </td>
				 	<td class="separador"></td>
			         <td class="label">
			         <label for="lblsaldoMinReq">Saldo M&iacute;nimo Requerido: </label>
			     </td>
			     <td>
			          <form:input type="text" id="saldoMinReq" name="saldoMinReq" path="saldoMinReq" size="12" tabindex="39"
			         	esMoneda="true" style="text-align: right;"  />
			     </td>

				</tr>

				<tr id="trSaldoPromedio">
					<td id="tdLimSaldoCuentaLbl" class="label">
						<label	for="lblComisionSalProm">Comisión Por Saldo Promedio: </label>
					</td>
					<td id="tdComisionSalProm">
						<input type="text"	id="comisionSalProm" name="comisionSalProm" path="comisionSalProm" size="12" maxlength="15" tabindex="40" esMoneda="true" style="text-align: right;" onkeypress="return ingresaSoloNumeros(event,3,this.id);" />
					</td>
					<td class="separador"></td>
					<td id="tdSaldoPromMinReq" class="label">
						<label for="lblSaldoHasta">Saldo Promedio Mínimo Requerido:</label></td>
					<td id="tdSaldoPromMinReq">
						<input type="text"	id="saldoPromMinReq" name="saldoPromMinReq" path="saldoPromMinReq" size="12"  maxlength="15	" tabindex="41" esMoneda="true" style="text-align: right;" onkeypress="return ingresaSoloNumeros(event,3,this.id);" />
					</td>
				</tr>
				<tr id="trSaldoPromedio">
					<td id="tdLimSaldoCuentaLbl" class="label">
						<label	for="lblComisionSalProm">Exenta Cobro Comisión Saldo Prom. Otros Prod.: </label>
					</td>
					<td id="tdComisionSalProm">
						<form:select id="exentaCobroSalPromOtros" name="exentaCobroSalPromOtros" path="exentaCobroSalPromOtros" tabindex="42" style="width:115px">
							<form:option value="">SELECCIONAR</form:option>
							<form:option value="N">NO</form:option>
							<form:option value="S">SI</form:option>
						</form:select>
					</td>
				</tr>

			</table>
	</fieldset>
	<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>SPEI</legend>
		   <table border="0" cellpadding="0" cellspacing="0" width="100%">

				<tr>
			 	     <td class="label">
			         <label for="lblParticipaSpei">Participa en SPEI: </label>
			     </td>
			     <td>
						<form:select id="participaSpei" name="participaSpei" path="participaSpei" tabindex="50">
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
					</td>

				 <td class="label">
			         <label for="lblCobraSpei">Cobra SPEI: </label>
			     </td>
			     <td>
						<form:select id="cobraSpei" name="cobraSpei" path="cobraSpei" tabindex="51">
							<form:option value="S">Si</form:option>
					     	<form:option value="N">No</form:option>
						</form:select>
			     </td>

			 	</tr>
			 	<tr>
			 	    <td class="label">
			         <label for="lblComSpeiPerFis">Comisi&oacute;n Persona F&iacute;sica: </label>
			     </td>
			     <td>
			         <form:input type="text" id="comSpeiPerFis" name="comSpeiPerFis" path="comSpeiPerFis" size="12"
			         		tabindex="52" esMoneda="true" style="text-align: right;"/>
			     </td>

			     <td class="label">
			         <label for="lblComSpeiPerMor">Comisi&oacute;n Persona Moral: </label>
			     </td>
			     <td>
			         <form:input type="text" id="comSpeiPerMor" name="comSpeiPerFis" path="comSpeiPerMor" size="12"
			         		tabindex="53" esMoneda="true" style="text-align: right;"/>
			     </td>
			 	</tr>


			</table>
			<br>
			</fieldset>
					<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>RECA-CONDUSEF</legend>
				   <table border="0" cellpadding="3" cellspacing="0" width="100%">
				   	<tr>
					     <td class="label">
					         <label for="lblNumRegistroRECA">No. Registro RECA:</label>
					     </td>
					     <td>
					         <form:input type="text" id="numRegistroRECA" name="numRegistroRECA" path="numRegistroRECA" size="50"
					         		onblur="ponerMayusculas(this)" tabindex="54" maxlength="100"/>
					     </td>
					     <td class="separador"></td>

					     <td class="label">
					         <label for="lblFechaInscripcion">Fecha Inscripci&oacute;n: </label>
					     </td>
					     <td>
					         <form:input type="text" id="fechaInscripcion" name="fechaInscripcion" path="fechaInscripcion" size="20"
					         		iniForma='false' tabindex="55" esCalendario="true"/>
					     </td>
					    </tr>
						 <tr>
					      <td class="label">
					         <label for="lblNombreComercial">Nombre Comercial:</label>
					     </td>
					     <td>
					         <form:input type="text" id="nombreComercial" name="nombreComercial" path="nombreComercial" size="50"
					          onblur="ponerMayusculas(this)" tabindex="56" maxlength="100"/>
					     </td>

					    </tr>

					</table>
			</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Regulatorios</legend>
				   <table border="0" cellpadding="3" cellspacing="0" width="100%">
				   	<tr>
					     <td class="label">
					         <label for="claveCNBV">Clave Producto:</label>
					     </td>
					     <td>
					         <form:input type="text" id="claveCNBV" name="claveCNBV" path="claveCNBV" size="15"
					         		tabindex="57" maxlength="10"/>
					     </td>
					     <td class="separador"></td>

					     <td class="label">
					         <label for="claveCNBVAmpCred">Clave Prod. Ampara Crédito: </label>
					     </td>
					     <td>
					          <form:input type="text" id="claveCNBVAmpCred" name="claveCNBVAmpCred" path="claveCNBVAmpCred" size="15"
					         		tabindex="58" maxlength="10"/>
					     </td>
					    </tr>


					</table>
			</fieldset>
				<br>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Alertas SMS</legend>
					<table border="0" cellpadding="3" cellspacing="0" width="100%">
						<tr>
							<td>
								<input type="checkbox" id="chkEnvioSMSRetiro" name="chkEnvioSMSRetiro" tabindex="59">
								<form:input type="hidden" id="envioSMSRetiro" name="envioSMSRetiro" path="envioSMSRetiro" value=""/>
							</td>
							<td class="separador"></td>
							<td class="label">
								<label for="montoMinSMSRetiro">Retiros mayores a:</label>
							</td>
							<td>
								<form:input type="text" id="montoMinSMSRetiro" name="montoMinSMSRetiro" path="montoMinSMSRetiro" size="15" tabindex="60" maxlength="8" esMoneda="true" style="text-align: right;"/>
								<a href="javaScript:" onClick="mostrarAyudaSMSRetiros();"><img src="images/help-icon.gif" ></a>
							</td>
						</tr>
					</table>
				</fieldset>
				<br>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="61"/>
									<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="62"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
									<input type="hidden" id="tipoPersona" path="tipoPersona" name="tipoPersona"/>
								</td>
							</tr>
						</table>
					</td>
				</tr>
	     </table>
</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elemento"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>
