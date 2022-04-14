<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/tarEnvioCorreoParamServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
<script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>
<script type="text/javascript" src="dwr/interface/catalogoServicios.js"></script>
<script type="text/javascript" src="dwr/interface/opcionesMenuRegServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoInstitucionCirculoServicio.js"></script>
<script type="text/javascript" src="js/soporte/mascara.js"></script>
<script type="text/javascript" src="js/soporte/parametrosSis.js"></script>
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosSisBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros del Sistema</legend>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table border="0" width="100%">
			<tr>
				<td class="label">
			    	<label for="empredaID">Empresa: </label>
				</td>
				<td>
					<form:input id="empresaID" name="empresaID" path="empresaID" size="6" tabindex="1"/>
				</td>
				 <td class="separador"></td>
			</tr>
			<tr>
				<td>
			    	<label for=sucursalMatrizID>Sucursal Matriz:</label>
				</td>
			    <td>
			    	<form:input id="sucursalMatrizID" name="sucursalMatrizID" path="sucursalMatrizID"
			        			 tabindex="2" size="6"/>
			        	 <input id="nombreMatriz" name="nombreMatriz" size="40" type="text" readOnly="true"
			        			disabled="true" />
			   	</td>
			    <td class="separador"></td>
			   	<td class="label">
			    	<label for="telefonoLocal">Tel&eacute;fono Local: </label>
				</td>
			    <td>
			    	<form:input id="telefonoLocal" name="telefonoLocal" path="telefonoLocal" size="15" maxlength="10"
			         			tabindex="3" />
			         <label for="lblExt">Ext.:</label>
			         <form:input id="extTelefonoLocal" name="extTelefonoLocal"  path="extTelefonoLocal" size="10" maxlength="6" tabindex="4" />
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="telefonoInterior">Tel&eacute;fono Interior: </label>
				</td>
				<td>
					<input id="telefonoInterior" name="telefonoInterior" path="telefonoInterior" size="20"
			         			tabindex="5" type="text"/>
			         <label for="lblext">Ext.:</label>
			         <form:input id="extTelefonoInt" name="extTelefonoInt" path="extTelefonoInt" size="10" maxlength="6" tabindex="6" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="institucionID">Instituci&oacute;n: </label>
				</td>
				<td>
			   		<form:input id="institucionID" name="institucionID" path="institucionID"
			        			 tabindex="7" size="6" />
			         <input id="nombreInstitucion" name="nombreInstitucion" size="35" type="text" readOnly="true" disabled="true"/>
				</td>
			</tr>

			<tr>
				<td class="label">
					<label for="empresaDefault">Empresa Default: </label>
				</td>
				<td>
					<input id="empresaDefault" name="empresaDefault" path="empresaDefault" size="11"
			         			tabindex="8" type="text"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="nombreRepresentante">Representante Legal: </label>
				</td>
				<td>
			   		<form:input id="nombreRepresentante" name="nombreRepresentante" path="nombreRepresentante"
			        			 tabindex="9" size="45" onBlur=" ponerMayusculas(this)"/>
				</td>
			</tr>

			<tr>
				<td class="label" nowrap="nowrap">
					<label for="RFCRepresentante">RFC del Representante: </label>
				</td>
				<td>
					<input id="RFCRepresentante" name="RFCRepresentante" path="RFCRepresentante" size="20"
			         			tabindex="10" type="text"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="monedaBaseID">Moneda Base: </label>
				</td>
				<td>
			         <form:select id="monedaBaseID" name="monedaBaseID" path="monedaBaseID" tabindex="11" type="select" >
						<form:option value=" ">SELECCIONAR</form:option>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
			    	<label for="monedaExtrangeraID">Moneda Extranjera:</label>
				</td>
			    <td>
			         <form:select id="monedaExtrangeraID" name="monedaExtrangeraID" path="monedaExtrangeraID" tabindex="12" type="select">
						<form:option value=" ">SELECCIONAR</form:option>
					</form:select>
			   	</td>
			    <td class="separador"></td>
			   	<td class="label">
			    	<label for="tasaISR">Tasa del ISR: </label>
				</td>
			    <td>
			    	<form:input id="tasaISR" name="tasaISR" path="tasaISR" size="15"
			         			tabindex="13"   esTasa="true"/>
				</td>
			</tr>

			<tr>
				<td class="label">
			    	<label for="tasaIDE">Tasa IDE: </label>
				</td>
				<td>
					<form:input id="tasaIDE" name="tasaIDE" path="tasaIDE" size="11" tabindex="14" esTasa="true"/>
				</td>
				<td class="separador"></td>
				<td class="label">
			    	<label for="montoExcIDE">Monto Exento para IDE: </label>
			   	</td>
			    <td>
			     	<form:input id="montoExcIDE" name="montoExcIDE" path="montoExcIDE" size="15"
			        	 tabindex="15" esMoneda="true"/>
			  	</td>
			</tr>

			<tr>
				<td class="label">
			    	<label for="ejercicioVigente">Ejercicio Vigente: </label>
				</td>
				<td>
					<form:input id="ejercicioVigente" name="ejercicioVigente" path="ejercicioVigente" size="11"
							tabindex="16" disabled="true" readonly="true"/>
				</td>
				<td class="separador"></td>
				<td class="label">
			    	<label for="periodoVigente">Periodo Vigente: </label>
			   	</td>
			    <td>
			     	<form:input id="periodoVigente" name="periodoVigente" path="periodoVigente" size="11"
			        	 tabindex="17" disabled="true" readonly="true"/>
			  	</td>
			</tr>


			<tr>
				<td class="label">
			    	<label for="diasInversion">D&iacute;as de Inversi&oacute;n: </label>
				</td>
				<td>
					<form:input id="diasInversion" name="diasInversion" path="diasInversion" size="11" tabindex="18"/>
				</td>
				<td class="separador"></td>
				<td class="label">
			    	<label for="diasCredito">D&iacute;as de Cr&eacute;dito: </label>
			   	</td>
			    <td>
			     	<form:input id="diasCredito" name="diasCredito" path="diasCredito" size="11"
			        	 tabindex="19"/>
			  	</td>
			</tr>

			<tr>
				<td class="label">
			    	<label for="diasCambioPass">D&iacute;as de cambio de Password : </label>
				</td>
				<td>
					<form:input id="diasCambioPass" name="diasCambioPass" path="diasCambioPass" size="11" tabindex="20"/>
				</td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
			    	<label for="lonMinCaracPass">Longitud M&iacute;nima de Caracteres: </label>
			   	</td>
			    <td>
			     	<form:input id="lonMinCaracPass" name="lonMinCaracPass" path="lonMinCaracPass" size="6"
			        	 tabindex="21"/>
			  	</td>
			</tr>

			<tr>
				<td class="label">
			    	<label for="clienteInstitucion"><s:message code="safilocale.cliente"/> Instituci&oacute;n : </label>
				</td>
				<td>
					<form:input id="clienteInstitucion" name="clienteInstitucion" path="clienteInstitucion" size="11" tabindex="22"/>
					 <input id="nombreInstitucionCliente" name="nombreInstitucionCliente"size="50" type="text" readOnly="true" disabled="true"/>

				</td>
				<td class="separador"></td>
				<td class="label">
			    	<label for="cuentaInstituc">Cuenta Instituci&oacute;n: </label>
			   	</td>
			    <td>
			     	<form:input id="cuentaInstituc" name="cuentaInstituc" path="cuentaInstituc" size="11"
			        	 tabindex="23"/>
			  	</td>
			</tr>
			<tr>

				<td class="label">
			    	<label for="manejaCaptacion">Maneja Captaci&oacute;n: </label>
				</td>
				<td>
					<form:radiobutton id="manejaCaptacion" name="manejaCaptacion" path="manejaCaptacion"
					 		value="S" tabindex="24" checked="checked" />
						<label for="manejaCaptacion">Si</label>
						<form:radiobutton id="manejaCaptacion1" name="manejaCaptacion1" path="manejaCaptacion"
							value="N" tabindex="25"/>
						<label for="manejaCaptacion">No</label>

				</td>

				<td class="separador"></td>
				<td class="label">
			    	<label id="maneja" for="bancoCaptacion">Banco Captaci&oacute;n: </label>
			   	</td>
			    <td>
			     	<form:input id="bancoCaptacion" name="bancoCaptacion" path="bancoCaptacion" size="6"
			        	 tabindex="26"/>
			         <input id="nombreInstituciones" name="nombreInstituciones"size="40" type="text" readOnly="true" disabled="true"/>
			  	</td>
			</tr>


			<tr>
				<td class="label">
			    	<label for="tipoCuenta">Tipo de Cuenta Tesorer&iacute;a: </label>
				</td>
				<td>
					<form:input id="tipoCuenta" name="tipoCuenta" path="tipoCuenta" size="6" tabindex="27"/>
					 <input id="descripcion" name="descripcion"size="55" type="text" readOnly="true" disabled="true"/>
				</td>
				<td class="separador"></td>
				<td class="label">
			    	<label for="rolTesoreria">Rol Tesorer&iacute;a: </label>
				</td>
				<td>
					<form:input id="rolTesoreria" name="rolTesoreria" path="rolTesoreria" size="6" tabindex="28"/>
					<input id="nombreRolTesoreria" name="nombreRolTesoreria"size="40"
			         			type="text" readOnly="true" disabled="true" />
				</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for="rolAdminTeso">Rol Administraci&oacute;n Tesorer&iacute;a: </label>
			   	</td>
			    <td>
			     	<form:input id="rolAdminTeso" name="rolAdminTeso" path="rolAdminTeso" size="6"
			        	 tabindex="29"/>
			        	 <input id="nombreAdminRolTesoreria" name="nombreAdminRolTesoreria"size="55"
			         			type="text" readOnly="true" disabled="true"/>
			  	</td>
			  	<td class="separador"></td>
			  	<td class="label">
			    	<label for="usuarioOC">Usuario Oficial de Cumplimiento: </label>
			   	</td>
			    <td>
			     	<form:input id="oficialCumID" name="oficialCumID" path="oficialCumID" size="6" 	 tabindex="30"/>
			        	 <input id="nombreOficialCumID" name="nombreOficialCumID" size="40"
			         			type="text" readOnly="true" disabled="true"/>
			  	</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for="directorGeneral">Director General: </label>
			   	</td>
			    <td>
			     	<form:input id="dirGeneralID" name="dirGeneralID" path="dirGeneralID" size="6"
			        	 tabindex="31"/>
			        	 <input id="nombredirGeneralID" name="nombredirGeneralID"size="55"
			         			type="text" readOnly="true" disabled="true"/>
			  	</td>
			  	<td class="separador"></td>
			  	<td class="label">
			    	<label for="directorOper">Director de Operaciones: </label>
			   	</td>
			    <td>
			     	<form:input id="dirOperID" name="dirOperID" path="dirOperID" size="6" 	 tabindex="32"/>
			        	 <input id="nombreDirOperID" name="nombreDirOperID" size="40"
			         			type="text" readOnly="true" disabled="true"/>
			  	</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for="jefeCobranza">Jefe de Cobranza: </label>
			   	</td>
			    <td>
			       	 <input id="nombreJefeCobranza" name="nombreJefeCobranza"size="55"
			         			type="text" onBlur=" ponerMayusculas(this)" tabindex="33"/>
			  	</td>
			  	<td class="separador"></td>
			  	<td class="label">
			    	<label for="jefeOperaPromo">Jefe de Operaciones y Promoci&oacute;n: </label>
			   	</td>
			    <td>
			        <input id="nomJefeOperayPromo" name="nomJefeOperayPromo" size="55"
			         			type="text" onBlur=" ponerMayusculas(this)" tabindex="34"/>
			  	</td>
			</tr>
			<tr>
			    <td class="label">
			    	<label for="tipoCtaGeneralAdi">Cuenta General Adicional: </label>
			   	</td>
			   	<td>
				    <form:select id="tipoCtaGLAdi" name="tipoCtaGLAdi" path="tipoCtaGLAdi" tabindex="35">
					<form:option value="">SELECCIONAR</form:option>
					</form:select>
				</td>
				<td class="separador"></td>
			  	<td class="label">
			    	<label for="lblctaIniGastoEmp">Cuenta Inicial Gasto Empleado: </label>
			   	</td>
			    <td>
			     	<form:input id="ctaIniGastoEmp" name="ctaIniGastoEmp" path="ctaIniGastoEmp" size="15" 	 tabindex="36"/>
			        	 <input id="descCuentaInicial" name="descCuentaInicial" size="33"
			         			type="text" readOnly="true" disabled="true"/>
			  	</td>
			</tr>
			<tr>
			    <td class="label">
			    	<label for="lblCtaFinGastoEmp">Cuenta Final Gasto Empleado: </label>
			   	</td>
			    <td>
			     	<form:input id="ctaFinGastoEmp" name="ctaFinGastoEmp" path="ctaFinGastoEmp" size="15" 	 tabindex="37"/>
			        	 <input id="decctaFinGastoEmp" name="desctaFinGastoEmp" size="45"
			         			type="text" readOnly="true" disabled="true"/>
			  	</td>
				<td class="separador"></td>
			  	<td class="label">
			    	<label for="lblImpTicket">Nombre Impresora Tickets: </label>
			   	</td>
			    <td>
			     	<form:input id="impTicket" name="impTicket" path="impTicket" size="6" tabindex="38"/>
			  	</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for="lblTipoImpTicket">Tamaño Tickets: </label>
			   	</td>
			   	<td>
			   	 	<form:radiobutton id="tipoImpTicket1" name="tipoImpTicket" path="tipoImpTicket"
					 		value="C" tabindex="39" checked="checked" />
						<label for="lblTipoImpTicket1">Carta</label>
						<form:radiobutton id="tipoImpTicket2" name="tipoImpTicket" path="tipoImpTicket"
							value="T" tabindex="40"/>
						<label for="lblTipoImpTicket2">Ticket</label>
				</td>
			   	<td class="separador"></td>
			    <td class="label">
			    	<label for="lblReqAportacionSo">Requiere Aportaci&oacute;n Social: </label>
			   	</td>
			   	<td>
		   		   	<form:radiobutton id="reqAportacionSo1" name="reqAportacionSo" path="reqAportacionSo"
					 		value="S" tabindex="41" checked="checked" />
						<label for="lblreqAportacionSo1">Si</label>
						<form:radiobutton id="reqAportacionSo2" name="reqAportacionSo" path="reqAportacionSo"
							value="N" tabindex="42"/>
						<label for="lblreqAportacionSo2">No</label>
			   	</td>
			</tr>
			<tr  id="tdMontoAportacion">
			  	<td class="label">
			    	<label for="lblMontoAportacion"  id="tlMontoAportacion">Monto Aportaci&oacute;n Social: </label>
			   	</td>
			    <td >
			     	<form:input id="montoAportacion" name="montoAportacion" path="montoAportacion" size="15"  tabindex="43" esMoneda="true"/>
			  	</td>
			  	<td class="separador"></td>
			   <td class="label">
			    	<label for="lblFechaComite">Fecha &Uacute;ltimo Consejo Admon: </label>
			   	</td>
			   	<td>
			   	 	<form:input type="text" id="fechaUltimoComite" name="fechaUltimoComite" path="fechaUltimoComite" tabindex="44" esCalendario="true"/>
				</td>
			 </tr>
			<tr>
				<td class="label">
			    	<label for="lblfoliosAutActaComite">Folios Autom&aacute;ticos Acta Comit&eacute; en Cierre D&iacute;a: </label>
			   	</td>
			   	<td>
		   		   	<form:radiobutton id="foliosAutActaComiteSi" name="foliosAutActaComite" path="foliosAutActaComite"
		   		   					  value="S" tabindex="45" />
						<label for="lblopcionSiFoliosAut">Si</label>
						<form:radiobutton id="foliosAutActaComiteNo" name="foliosAutActaComite" path="foliosAutActaComite"
							value="N" tabindex="46" checked="checked"/>
						<label for="lblopcionNoFoiosAut">No</label>
				</td>
				<td class="separador"></td>
			  	<td class="label">
			    	<label for=lblServReactivaCliID>Servicio Reactivaci&oacute;n <s:message code="safilocale.cliente"/>:</label>
				</td>
			    <td>
			    	<form:input id="servReactivaCliID" name="servReactivaCliID" path="servReactivaCliID"
			        			 tabindex="47" size="6"/>
			        	 <input id="nombreServReactivaCli" name="nombreServReactivaCli" size="40" type="text" readOnly="true" disabled="true"/>
			        	 <input type="hidden" id="tipoCliente" name="tipoCliente" value="<s:message code="safilocale.cliente"/>"/>
			   	</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for="lblContaGL">Contabilidad Garant&iacute;a L&iacute;quida: </label>
			   	</td>
			   	<td>
		   		   	<form:radiobutton id="contabilidadGLS" name="contabilidadGLS" path="contabilidadGL" value="S" tabindex="48" />
						<label for="lblopcionSiContaGL">Si</label>
						<form:radiobutton id="contabilidadGLN" name="contabilidadGLN" path="contabilidadGL" value="N" tabindex="49"/>
						<label for="lblopcionNOContaGL">No</label>
				</td>
				<td class="separador"></td>
				<td class="label">
			    	<label for=validaAutComite>Valida Cr&eacute;ditos para <s:message code="safilocale.cliente"/>s Funcionarios:</label>
				</td>
			    <td>
			    	<form:radiobutton id="validaAutComiteS" name="validaAutComite" path="validaAutComite" value="S" tabindex="50" />
						<label for="validaAutComiteS">Si</label>
					<form:radiobutton id="validaAutComiteN" name="validaAutComite" path="validaAutComite" value="N" tabindex="51"/>
						<label for="validaAutComiteN">No</label>
			   	</td>
			</tr>
			 <tr>

			   	<tr>
			   		<td class="label">
			    	<label for=activaPromotorCapta>Promotor de Captaci&oacute;n:</label>
				</td>
			 	<td>
			  		<form:radiobutton id="activaPromotorCaptaS" name="activaPromotorCaptaS" path="activaPromotorCapta" value="S" tabindex="52" />
						<label for="activaPromotorCaptaS">Si</label>
					<form:radiobutton id="activaPromotorCaptaN" name="activaPromotorCaptaN" path="activaPromotorCapta" value="N" tabindex="53"/>
						<label for="activaPromotorCaptaN">No</label>
			   	</td>
			   	<td class="separador"></td>
			   	<td class="label">
			    	<label for=checList>Check List en Registro de  <s:message code="safilocale.cliente"/>: </label>
				</td>
			 	<td>
			  		<form:radiobutton id="checListCteS" name="checListCteS" path="checListCte" value="S" tabindex="54" />
						<label for="checListCteS">Si</label>
					<form:radiobutton id="checListCteN" name="checListCteN" path="checListCte" value="N" tabindex="55"/>
						<label for="checListCteN">No</label>
			   	</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for=tarIdentiSocio>Identificar <s:message code="safilocale.cliente"/> Por Tarjeta:</label>
				</td>
			 	<td>
			  		<form:radiobutton id="tarjetaIdentiSocioS" name="tarjetaIdentiSocioS" path="tarjetaIdentiSocio" value="S" tabindex="56" />
						<label for="tarjetaIdentiSocioSi">Si</label>
					<form:radiobutton id="tarjetaIdentiSocioN" name="tarjetaIdentiSocioN" path="tarjetaIdentiSocio" value="N" tabindex="57"/>
						<label for="tarjetaIdentiSocioNo">No</label>
			   	</td>
			  	<td class="separador"></td>
			  	<td class="label">
			    	<label for="sistemasID">Encargado de Sistemas/T.I.: </label>
			   	</td>
			    <td>
			     	<form:input id="sistemasID" name="sistemasID" path="sistemasID" size="6" tabindex="58"/>
			        <input id="nombreEncargadoSistemas" name="nombreEncargadoSistemas" size="40" type="text" readOnly="true" disabled="true"/>
			  	</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for="perfilWsVbc">Perfil WS VBC: </label>
				</td>
				<td>
					<form:input id="perfilWsVbc" name="perfilWsVbc" path="perfilWsVbc" size="6" tabindex="59"/>
					<input id="nombrePerfilWsVbc" name="nombrePerfilWsVbc"size="40" type="text" readOnly="true" disabled="true" />
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="calCURPyRFCsi">Calcular CURP y RFC:</label>
				</td>
				<td>
				 	<form:radiobutton id="calCURPyRFCsi" name="calculaCURPyRFC" path="calculaCURPyRFC" value="S" tabindex="60" />
					<label for="calCURPyRFCsi">Si</label>
					<form:radiobutton id="calCURPyRFCno" name="calculaCURPyRFC" path="calculaCURPyRFC" value="N" tabindex="61" />
					<label for="calCURPyRFCno">No</label>
				 </td>
			</tr>
			<tr>
				<td class="label">
					<label for="fechaConsDispSi">Fecha Consulta Disp.:</label>
				</td>
				<td>
				 	<form:radiobutton id="fechaConsDispSi" name="fechaConsDisp" path="fechaConsDisp" value="S" tabindex="62" />
					<label for="fechaConsDispSi">Si</label>
					<form:radiobutton id="fechaConsDispNo" name="fechaConsDisp" path="fechaConsDisp" value="N" tabindex="63" />
					<label for="fechaConsDispNo">No</label>
				 </td>
				 <td class="separador"></td>
				 <td class="label">
					<label for="perfAutEspAport">Perfil Aut. Especial Aportaci&oacute;n:</label>
				</td>
				<td>
				 	<form:input id="perfilAutEspAport" name="perfilAutEspAport" path="perfilAutEspAport" size="6" tabindex="64"/>
					<input id="nomPerfilAutEspAport" name="nomPerfilAutEspAport"size="40" type="text" readOnly="true" disabled="true" />
				 </td>
			</tr>

			<tr>
				<td class="label">
					<label for="invPagoPeriodico">Valida Inversiones Pago Peri&oacute;dico:</label>
				</td>
				<td>
				 	<form:radiobutton id="invPagoPeriodicoSi" name="invPagoPeriodico" path="invPagoPeriodico" value="S" tabindex="65" />
					<label for="invPagoPeriodicoSi">Si</label>
					<form:radiobutton id="invPagoPeriodicoNo" name="invPagoPeriodico" path="invPagoPeriodico" value="N" tabindex="66" />
					<label for="invPagoPeriodicoNo">No</label>
				 </td>
				   <td class="separador"></td>


					 <td class="label">
						<label for="perfCamCarLiqui">Perfil Cam. Carta Liquidaci&oacute;n:</label>
					</td>
					<td>
					 	<form:input id="perfilCamCarLiqui" name="perfilCamCarLiqui" path="perfilCamCarLiqui" size="6" tabindex="67"/>
						<input id="nomPerfilCamCarLiqui" name="nomPerfilCamCarLiqui"size="40" type="text" readOnly="true" disabled="true" />
					 </td>

			</tr>
			<tr>
				<td class="label"></td>
				<td></td>
				<td class="separador"></td>
				  <td class="label">
					<label for="personNoDeseadas">Validación en lista interna de personas no deseadas</label>
				</td>

				<td>
				 	<form:radiobutton id="personNoDeseadasSi" path="personNoDeseadas" value="S" tabindex="68" />
					<label for="personNoDeseadasSi">Si</label>
					<form:radiobutton id="personNoDeseadasNo" name="personNoDeseadas" path="personNoDeseadas" value="N" tabindex="69" />
					<label for="personNoDeseadasNo">No</label>
				</td>
			</tr>
			<tr>
				<td class="label"><label>Requiere Huella:</label></td>
				<td>
					<form:radiobutton id="funcionHuellaSi" name="funcionHuella" path="funcionHuella" value="S" tabindex="70" />
					<label for="funcionHuellaSi">Si</label>
					<form:radiobutton id="funcionHuellaNo" name="funcionHuella" path="funcionHuella" value="N" tabindex="71" />
					<label for="funcionHuellaNo">No</label>
				</td>
				<td class="separador"></td>
				<td class="label"><label>Requiere Huella Productos:</label></td>
				<td>
					<form:radiobutton id="reqhuellaProductosSi" name="reqhuellaProductos" path="reqhuellaProductos" value="S" tabindex="72" />
					<label for="reqhuellaProductosSi">Si</label>
					<form:radiobutton id="reqhuellaProductosNo" name="reqhuellaProductos" path="reqhuellaProductos" value="N" tabindex="73" />
					<label for="reqhuellaProductosNo">No</label>
				</td>
			</tr>

	</table>
	</fieldset>

	<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Firmantes Financieros</legend>
			<table>
				<tr>
					<td class="label">
						<label for="lblGerenteGral">Gerente General: </label>
					</td>
					<td>
				         <form:input id="gerenteGeneral" name="gerenteGeneral" path="gerenteGeneral" onBlur=" ponerMayusculas(this)" size="40"
				         				 tabindex="74"/>
				    </td>
				    <td class="separador"></td>
					<td class="label">
						<label for="lblPresidenteConsejo">Presidente del Consejo: </label>
					</td>
					<td>
					 <form:input id="presidenteConsejo" name="presidenteConsejo" path="presidenteConsejo" onBlur=" ponerMayusculas(this)" size="40" tabindex="75"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lblJefeContabilidad">Jefe de Contabilidad: </label>
					</td>
					<td>
					 <form:input id="jefeContabilidad" name="jefeContabilidad" path="jefeContabilidad" onBlur=" ponerMayusculas(this)" size="40" tabindex="76"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="directorFinanzas">Director de Finanzas: </label>
					</td>
					<td>
					 <form:input id="directorFinanzas" name="directorFinanzas" path="directorFinanzas" onBlur=" ponerMayusculas(this)" size="40" tabindex="77" maxlength="100"/>
					</td>
				</tr>
			</table>
		</fieldset>
	<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Cuentas Capital Contable </legend>
		<table >
				<tr>
		     		<td class="label">
			         	<label for="lblcuentasCapConta">Cuentas Cap. Contable: </label>
			     	</td>
			     	<td>
			            <form:input id="cuentasCapConta" name="cuentasCapConta" path="cuentasCapConta" size="40" tabindex="78"/>
			     	</td>
		 		</tr>
		 		<tr>
		     		<td class="label">
		         		<label for="lblvalidaCapitalConta">Valida Capital Contable: </label>
		     		</td>
			     	<td>
						<form:select id="validaCapitalConta" name="validaCapitalConta" path="validaCapitalConta" tabindex="79" >
							<form:option value="S">SI</form:option>
							<form:option value="N">NO</form:option>
						</form:select>
						<a href="javaScript:" onClick="ayudaPorcentajeCapitalNeto();">
							<img src="images/help-icon.gif" >
						</a>
			     	</td>
			     	<td class="separador"></td>
			     	<td class="label">
			         	<label for="porMaximoDeposito">Porcentaje Max. Dep&oacute;sito: </label>
			     	</td>
			     	<td>
			         	<form:input id="porMaximoDeposito" name="porMaximoDeposito" path="porMaximoDeposito" size="10" tabindex="80"   esMoneda= "true" maxlength="6"/>
						 <label> %</label>
			     	</td>
		 		</tr>
	</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Indicadores Fiscales</legend>
		<table>
				<tr>
		     		<td class="label">
			         	<label for="lblsalMinDF">Valor de la Unidad de Medida y Actualizaci&oacute;n (UMA): </label>
			     	</td>
			     	<td>
			         	<form:input id="salMinDF" name="salMinDF" path="salMinDF" size="15" tabindex="90"   esMoneda= "true" maxlength="16"/>
			     	</td>
		     		<td class="separador"></td>
			     	<td class="label">
			         	<label for="salMinDFReal">Salario M&iacute;nimo DF: </label>
			     	</td>
			     	<td>
			         	<form:input id="salMinDFReal" name="salMinDFReal" path="salMinDFReal" size="15" tabindex="91"   esMoneda= "true" maxlength="16"/>
			     	</td>
		 		</tr>
	</table>
	</fieldset>
	<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Operaciones Vulnerables</legend>
		<table>
				<tr>
		     		<td class="label">
			         	<label for="lblsalMinDF">Veces el Salario Mínimo Vigente:</label>
			     	</td>
			     	<td>
			         	<form:input id="vecesSalMinVig" name="vecesSalMinVig" path="vecesSalMinVig" size="15" tabindex="92"   esMoneda= "false"/>
			     	</td>
		 		</tr>
	</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Seguro Ayuda</legend>
			<table>
			<tr>
				  <td class="label">
			    	<label for="lblMontoSeguroAyuda">Monto Seguro Ayuda: </label>
			   	 </td>
			    <td>
		     	<form:input id="montoSegAyuda" name="montoSegAyuda" path="montoSegAyuda" size="15"  tabindex="93" esMoneda="true"/>
			  	</td>
				 <td class="separador"></td>
				<td class="label">
			    	<label for="lblMontoPolizaSeguroAyuda">Monto P&oacute;liza: </label>
				 </td>
			    <td>
			<form:input id="montoPolizaSegA" name="montoPolizaSegA" path="montoPolizaSegA" size="15"  tabindex="94" esMoneda="true"/>
				 </td>

			</tr>
			<tr>
				<td class="label">
			    	<label for="lblDvencSeguro">D&iacute;as de Vencimiento de Seguro: </label>
				 </td>
			    <td>
					<form:input id="vigDiasSeguro" name="vigDiasSeguro" path="vigDiasSeguro" size="15"  tabindex="95" />
				 </td>
				<td class="separador"></td>
				<td class="label" nowrap="nowrap">
			    	<label for="lblMontoPolizaSeguroAyuda">Vencimiento Autom&aacute;tico  de Seguro: </label>
				 </td>
			    <td>
					<form:select id="vencimAutoSeg" name="vencimAutoSeg" path="vencimAutoSeg" tabindex="96">
						<form:option value="S">Si</form:option>
				     	<form:option value="N">No</form:option>
					</form:select>
				 </td>
			</tr>
		</table>
	</fieldset>


		<br>

		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Caja</legend>
			<table>
				<tr>
					<td class="label">
						<label for="lbllonMinPagRemesa">Longitud M&iacute;nima F&oacute;lio Remesa: </label>
					</td>
					<td>
						<form:input id="lonMinPagRemesa" name="lonMinPagRemesa" path="lonMinPagRemesa" maxlength = "2" size="15"  tabindex="86" esMoneda="false"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lbllonMaxPagRemesa"> Longitud M&aacute;xima F&oacute;lio Remesa: </label>
					</td>
					<td>
						<form:input id="lonMaxPagRemesa" name="lonMaxPagRemesa" path="lonMaxPagRemesa" maxlength = "2"  size="15"  tabindex="87" esMoneda="false"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lbllonMinPagOport">Longitud M&iacute;nima Referencia pago Oportunidades: </label>
					</td>
					<td>
						<form:input id="lonMinPagOport" name="lonMinPagOport" path="lonMinPagOport" maxlength = "2" size="15"  tabindex="88" esMoneda="false"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lbllonMaxPagOport">Longitud M&aacute;xima Referencia pago Oportunidades: </label>
					</td>
					<td>
						<form:input id="lonMaxPagOport" name="lonMaxPagOport" path="lonMaxPagOport"  maxlength = "2" size="15"  tabindex="89" esMoneda="false"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lblImpSaldoCred">Imprimir&nbsp;Saldo&nbsp;Cr&eacute;dito&nbsp;despu&eacute;s&nbsp;de&nbsp;Pago: </label>
					</td>
					<td>
						<form:radiobutton id="impSaldoCred1" name="impSaldoCred"  path="impSaldoCred" value="S" tabindex="90" checked="checked" />
						<label for="lblImpSaldoCred1">Si</label>
						<form:radiobutton id="impSaldoCred2" name="impSaldoCred"  path="impSaldoCred" value="N" tabindex="91"/>
						<label for="lblImpSaldoCred2">No</label>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lblImpSaldoCta">Imprimir&nbsp;Saldo&nbsp;Cuenta&nbsp;despu&eacute;s&nbsp;de&nbsp;Abonar: </label>
					</td>
					<td>
						<form:radiobutton id="impSaldoCta1" name="impSaldoCta"  path="impSaldoCta" value="S" tabindex="92" checked="checked" />
						<label for="lblImpSaldoCta1">Si</label>
						<form:radiobutton id="impSaldoCta2" name="impSaldoCta"  path="impSaldoCta" value="N" tabindex="93"/>
						<label for="lblImpSaldoCta2">No</label>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lblMostrarSalDispCta">Mostrar Saldo Disp. Y SBC de Cta. En Pantalla:</label>
					</td>
					<td>
						<form:radiobutton id="mostrarSaldDispCta1" name="mostrarSaldDisCtaYSbc" path="mostrarSaldDisCtaYSbc" value="S" tabindex="94" checked="checked"/>
						<label for="lblMostrarSaldDispCta1">Si</label>
						<form:radiobutton id="mostrarSaldDispCta2" name="mostrarSaldDisCtaYSbc" path="mostrarSaldDisCtaYSbc" value="N" tabindex="95" />
						<label for="lblMostrarSaldDispCta2">No</label>
					</td>
					<td></td>
					<td>
						<label class="label">No. Tipo Documento Firma:</label>
					</td>
					<td>
						<form:input id="tipoDocumentoID" name="tipoDocumentoID" tabindex="96"  type="text" value="" size="10" path="tipoDocumentoID" />
						<form:input id="descripcionDoc" name="descripcionDoc"   type="text" value="" size="30" readonly="true" disabled="true" path="descripcionDoc" />
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="aplicaGarAdiPagoCre">Aplica Garantía Adicional en Pago de Crédito:</label>
					</td>
					<td>
						<form:radiobutton id="aplicaGarAdiPagoCre1" name="aplicaGarAdiPagoCre" path="aplicaGarAdiPagoCre" value="S" tabindex="97" checked="checked"/>
						<label for="aplicaGarAdiPagoCre1">Si</label>
						<form:radiobutton id="aplicaGarAdiPagoCre2" name="aplicaGarAdiPagoCre" path="aplicaGarAdiPagoCre" value="N" tabindex="97" />
						<label for="aplicaGarAdiPagoCre2">No</label>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for=mostrarBtnResumen>Mostrar Bot&oacute;n Imp. Resumen:</label>
					</td>
					<td>
						<form:input type="radio" id="mostrarBtnResumenSI" name="mostrarBtnResumen" path="mostrarBtnResumen" value="S" tabindex="97" checked="checked"/>
						<label >Si</label>
						<form:input type="radio" id="mostrarBtnResumenNO" name="mostrarBtnResumen" path="mostrarBtnResumen" value="N" tabindex="97"/>
						<label >No</label>
					</td>
				</tr>
			</table>
		</fieldset>
		<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Faltantes y Sobrantes Ventanilla</legend>
			<table>
			<tr>
				  <td class="label">
			    	<label for="lblCtaContaSobrantes">Cta. Contable Sobrante: </label>
			   	 </td>
			    <td>
					<form:input id="ctaContaSobrante" name="ctaContaSobrante" path="ctaContaSobrante" maxlength="25" size="20"
							tabindex="119" />
					<input type="text" id="descripCtaContaSobrante" name="descripCtaContaSobrante" size="50"
								readOnly="true" />
			  	</td>
				 <td class="separador"></td>
			</tr>
			<tr>

				<td class="label">
			    	<label for="lblCtaContaFaltante">Cta. Contable Faltante: </label>
				 </td>
			    <td>
				<form:input id="ctaContaFaltante" name="ctaContaFaltante" path="ctaContaFaltante" maxlength="25"  size="20"
						  tabindex="120" />
				  <input type="text" id="descripCtaContaFaltante" name="descripCtaContaFaltante" size="50"
						readOnly="true" />
				 </td>

			</tr>
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Cheques</legend>
			<table>
			<tr>
				  <td class="label">
			    	<label for="lblAfectaContaRecepcion ">Afectaci&oacute;n Contable Recepci&oacute;n SBC: </label>
			   	 </td>
			    <td>
					<form:radiobutton id="afectaContaRecSBC1" name="afectaContaRecSBC"  path="afectaContaRecSBC"
				 		value="S" tabindex="121"/>
						<label for="lblSIAfectaContaSBC">Si</label>
					<form:radiobutton id="afectaContaRecSBC2" name="afectaContaRecSBC"  path="afectaContaRecSBC"
						value="N" tabindex="122" checked="checked"/>
					<label for="lblNOAfectaContaSBC">No</label>
			  	</td>
				 <td class="separador"></td>
			</tr>
			<tr id="trSBCCOD" style="display:none">
				<td class="label">
			    	<label for="lblCtaContaSBCCOD">Cta. Contable Salvo Buen Cobro COD: </label>
				 </td>
			    <td>
				<form:input id="ctaContaDocSBCD" name="ctaContaDocSBCD" path="ctaContaDocSBCD" maxlength="25"  size="20"
						  tabindex="123" />
				  <input type="text" id="descripCtaSBCCOD" name="descripCtaSBCCOD" size="50"
						readOnly="true" />
				 </td>

			</tr>
			<tr id="trSBCCOA" style="display:none">
				<td class="label">
			    	<label for="lblCtaContaSBCCOA">Cta. Contable Salvo Buen Cobro COA: </label>
				 </td>
			    <td>
				<form:input id="ctaContaDocSBCA" name="ctaContaDocSBCA" path="ctaContaDocSBCA" maxlength="25"  size="20"
						  tabindex="124" />
				  <input type="text" id="descripCtaSBCCOA" name="descripCtaSBCCOA" size="50"
						readOnly="true" />
				 </td>

			</tr>
			<tr id="centroCostos" style="display:none" >
				<td class="label">
			   		<label for="lblcenCostosChequesSBC">Nomenclatura Centro Costo:</label>
				</td>
				<td >
					<input id="cenCostosChequesSBC" name="cenCostosChequesSBC"  size="30"  type="text" tabindex="125" maxlength="30" />
					 	<a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
						</a>
				</td>
			</tr>
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Correos</legend>
	<table>
		<tr>
			<td class="label">
		    	<label for="lblremitente">Remitente PLD: </label>
			 </td>
		    <td>
				<form:input id="remitente" name="remitente" path="remitente" size="40" tabindex="126" maxlength="50"/>
			 </td>
			 <td class="separador"></td>
			 <td class="label">
		    	<label for="lblusu">Usuario: </label>
		   	 </td>
		    <td>
		    <input type="text" id="usuarioCorreo" name="usuarioCorreo"  size="30"  tabindex="127" maxlength="50"/>
		   <label for="lblcontra">Contraseña: </label>
		     	<input type="password" id="contrasenia" name="contrasenia" autocomplete="new-password" size="10"  tabindex="128" maxlength="30"/>
		  	</td>

		</tr>
		<tr>
		  </tr>
		<tr>
			<td class="label">
		    	<label for="lblservidorCorreo">Servidor de Correo: </label>
		   </td>
		    <td>
		     	<form:input id="servidorCorreo" name="servidorCorreo" path="servidorCorreo" size="20" tabindex="129" maxlength="30"/>
		    </td>
		  	<td class="separador"></td>
		  	<td class="label">
		    	<label for="lblpuerto">Puerto: </label>
		   	 </td>
		    <td>
		     	<form:input id="puerto" name="puerto" path="puerto" size="6"  tabindex="130" maxlength="10"/>
		  	</td>

		</tr>

		<tr>
			<td class="label">
				<label for="lblAlertaVerificacion">Remitente Cierre de Día: </label>
			</td>
			<td>
				<input id="remitenteCierreID" name="remitenteCierreID" tabindex="140" size="6" maxlength="10">
				<form:input id="correoRemitenteCierre" name="correoRemitenteCierre" path="correoRemitenteCierre" size="40" maxlength="100" />
			</td>
		</tr>


		<tr>
			<td class="label">
				<label for="lblAlertaVerificacion">Alerta Vencimiento Convenio: </label>
			</td>
			<td>
				<input type="radio" id="alerVerificaConvenio" name="alerVerificaConvenio" value="S" tabindex="141"/>
				<label>Sí</label>
				<input type="radio" id="alerVerificaConvenio1" name="alerVerificaConvenio" value="N" tabindex="142"/>
				<label>No</label>
			</td>
			<td class="separador"></td>
		</tr>

		<tr class="alertaVenConvenio">
			<td class="label">
				<label for="lblnoDiasAntEnvioCorreo">No. Días: </label>
			</td>
			<td>
				<form:input id="noDiasAntEnvioCorreo" name="noDiasAntEnvioCorreo" path="noDiasAntEnvioCorreo" size="8" tabindex="143" maxlength="8"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="lblAlertaVerificacion">Correo remitente: </label>
			</td>
			<td>
				<input id="remitenteID" name="remitenteID" tabindex="144" size="6" maxlength="10">
				<form:input id="correoRemitente" name="correoRemitente" path="correoRemitente" size="45" maxlength="100" />
			</td>
		</tr>

		<tr class="alertaVenConvenio">
			<td class="label">
				<label for="correoAdiDestino">Correo Adi. Destino</label>
			</td>
			<td>
    			<textarea id="correoAdiDestino" name="correoAdiDestino"  rows="4" maxlength="500" cols="50" tabindex="145"></textarea>
   			</td>
			<td class="separador"></td>
		</tr>




	</table>
	</fieldset>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Rutas de Acceso</legend>
	<table>
		<tr>
			<td class="label">
		    	<label for="rutaArchivos">Archivos: </label>
		   	 </td>
		    <td>
		     	<form:input id="rutaArchivos" name="rutaArchivos" path="rutaArchivos" size="70"  tabindex="146"/>
		  	</td>
		</tr>
		<tr>
			<td class="label">
		    	<label for="lblrutaArchivosPLD">Archivos PLD: </label>
		   	 </td>
		    <td>
		     	<input type="text" id="rutaArchivosPLD" name="rutaArchivosPLD"  size="70"  tabindex="147"/>
		  	</td>
		</tr>
	</table>
	</fieldset>
	<!--  Agregando fieldset Facturacion electronica -->
	<br>
	<table>
		<tr>
			<td>
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Facturaci&oacute;n Electr&oacute;nica</legend>
					<table>
						<tr>
							<td class="label">
								<label for="">RFC: </label>
		   					<form:input id="rfcEmpresa" name="rfcEmpresa" path="rfcEmpresa" onblur=" ponerMayusculas(this)" maxlength="12"
		   									 size="20" tabindex="148"/>
							</td>
						</tr>
						<tr>
							<td class="label">
		       				<label for="timbraEdoCta">Timbrar Estado de Cuenta: </label>
		   	 					<form:radiobutton id="timbraEdoCta1" name="timbraEdoCta"  path="timbraEdoCta" value="S" tabindex="149"  />
									<label for="timbraEdoCta1">Si</label>
									<form:radiobutton id="timbraEdoCta2" name="timbraEdoCta"  path="timbraEdoCta"
										value="N" tabindex="150"/>
									<label for="timbraEdoCta2">No</label>
							</td>
		   			</tr>
		   			<tr>
		   				<td class="label">
		    					<label for="generaCFDINoReg">CFDI Para Clientes No Registrados SAT: </label>

		   	 				<form:radiobutton id="generaCFDINoReg1" name="generaCFDINoReg"  path="generaCFDINoReg"
				 					value="S" tabindex="151" />
								<label for="generaCFDINoReg1">Si</label>
								<form:radiobutton id="generaCFDINoReg2" name="generaCFDINoReg"  path="generaCFDINoReg"
									value="N" tabindex="152"/>
								<label for="generaCFDINoReg2">No</label>
							</td>
		   			</tr>
		   			<tr>
							<td class="label">
		       				<label for="generaEdoCtaAuto">Generaci&oacute;n Autom&aacute;tica para Estado de Cuenta en Cierre de Mes: </label>
		   	 				<form:radiobutton id="generaEdoCtaAuto1" name="generaEdoCtaAuto"  path="generaEdoCtaAuto"
				 					value="S" tabindex="153"  />
								<label for="generaEdoCtaAuto1">Si</label>
								<form:radiobutton id="generaEdoCtaAuto2" name="generaEdoCtaAuto"  path="generaEdoCtaAuto"
									value="N" tabindex="154"/>
								<label for="generaEdoCtaAuto2">No</label>
							</td>
		   			</tr>
		   			<tr>
	   					<td class="label">
		       				<label for="generaEdoCtaAuto">Zona Horaria: </label>
		   	 				<form:select id="zonaHoraria" name="zonaHoraria" path="zonaHoraria" tabindex="155" >
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="-12:00">GMT-12</form:option>
								<form:option value="-11:00">GMT-11</form:option>
								<form:option value="-10:00">GMT-10</form:option>
								<form:option value="-09:00">GMT-9</form:option>
								<form:option value="-08:00">GMT-8</form:option>
								<form:option value="-07:00">GMT-7</form:option>
								<form:option value="-06:00">GMT-6</form:option>
								<form:option value="-05:00">GMT-5</form:option>
								<form:option value="-04:00">GMT-4</form:option>
								<form:option value="-03:00">GMT-3</form:option>
								<form:option value="-02:00">GMT-2</form:option>
								<form:option value="-01:00">GMT-1</form:option>
								<form:option value="-00:00">GMT 0</form:option>
								<form:option value="+01:00">GMT+1</form:option>
								<form:option value="+02:00">GMT+2</form:option>
								<form:option value="+03:00">GMT+3</form:option>
								<form:option value="+04:00">GMT+4</form:option>
								<form:option value="+05:00">GMT+5</form:option>
								<form:option value="+06:00">GMT+6</form:option>
								<form:option value="+07:00">GMT+7</form:option>
								<form:option value="+08:00">GMT+8</form:option>
								<form:option value="+09:00">GMT+9</form:option>
								<form:option value="+10:00">GMT+10</form:option>
								<form:option value="+11:00">GMT+11</form:option>
								<form:option value="+12:00">GMT+12</form:option>
							</form:select>
						</td>

		   			</tr>
		   			<tr>
		   			<td colspan="2">
		   			<br>
		   				<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend>Direcci&oacute;n Fiscal</legend>
								<table>
									<tr>
     									<td class="label">
	         							<label for="estadoEmpresa">Entidad Federativa: </label>
	    								</td>
	    								<td>
	         							<form:input id="estadoEmpresa" name="estadoEmpresa" path="estadoEmpresa" size="6" tabindex="156" onblur="consultaDirecCompleta()" />
								         <input type="text" id="nombreEstadoEmpresa" name="nombreEstadoEmpresa" size="35"  readonly="true"/>
										</td>
										<td class="separador"></td>
		 								<td class="label">
			 								<label for="municipioEmpresa">Municipio: </label>
										</td>
		  								<td nowrap="nowrap">
	         							<form:input id="municipioEmpresa" name="municipioEmpresa" path="municipioEmpresa" size="6" tabindex="157" onblur="consultaDirecCompleta()"/>
	         							<input type="text" id="nombreMunicipioEmpresa" name="nombreMunicipioEmpresa" size="35"
	          								readonly="true"/>
	     								</td>
	     							</tr>
	     							<tr>
	     								<td class="label">
	          							<label for="localidadEmpresa">Localidad: </label>
	     								</td>
	     								<td nowrap="nowrap">
	         							<form:input id="localidadEmpresa" name="localidadEmpresa" path="localidadEmpresa" size="6" tabindex="158" onblur="consultaDirecCompleta()" />
	         							<input type="text" id="nombreLocalidadEmpresa" name="nombreLocalidadEmpresa" size="35" onBlur=" ponerMayusculas(this)"
	          									readonly="true"/>
	     								</td>
	      							<td class="separador"></td>
										<td class="label">
	          							<label for="coloniaEmpresa">Colonia: </label>
	     								</td>
	     								<td nowrap="nowrap">
	         							<form:input id="coloniaEmpresa" name="coloniaEmpresa" path="coloniaEmpresa" size="6" tabindex="159" onblur="consultaDirecCompleta()" />
	         							<input type="text" id="nombreColoniaEmpresa" name="nombreColoniaEmpresa" size="60" readonly="true"/>
	     								</td>
									</tr>
									<tr>
			 							<td class="label">
		    								<label for="calleEmpresa">Calle: </label>
			 							</td>
		    							<td nowrap="nowrap">
													<form:input id="calleEmpresa" name="calleEmpresa" path="calleEmpresa" size="50" tabindex="160" onBlur=" ponerMayusculas(this); consultaDirecCompleta();"/>
			    						</td>
			    						<td class="separador"></td>
			  							<td class="label">
		      							<label for="numIntEmpresa">N&uacute;mero: </label>
		      						</td>
		   	  						<td nowrap="nowrap">
		     	  							<form:input id="numIntEmpresa" name="numIntEmpresa" path="numIntEmpresa" size="6" tabindex="161" onBlur=" ponerMayusculas(this); consultaDirecCompleta();"/>
		     							</td>
		    						</tr>
		    						<tr>
		   	 						<td class="label">
		     								<label for = "numExtEmpresa">N&uacute;mero Interior:</label>
		     							</td>
		      						<td nowrap="nowrap">
		      							<form:input id="numExtEmpresa" name="numExtEmpresa" path="numExtEmpresa" size="6" tabindex="162" onBlur=" ponerMayusculas(this); consultaDirecCompleta();"/>
		     							</td>
		   							<td class="separador"></td>
	  	    							<td class="label">
											<label for="CPEmpresa">CP:</label>
										</td>
										<td nowrap="nowrap">
											<form:input id="CPEmpresa" name="CPEmpresa" path="CPEmpresa" size="6" tabindex="163" onblur="consultaDirecCompleta()"/>
										</td>
									</tr>
									<tr>
										<td>
											<label for="">Direcci&oacute;n Fiscal Completa:</label>
										</td>
										<td>
		   								<textarea id="dirFiscal" name="dirFiscal" path="dirFiscal"  rows="3" cols="35" tabindex="164" onBlur=" ponerMayusculas(this)">
											</textarea>
										</td>
										<td class="separador"></td>
									</tr>
								</table>
							</fieldset>
		   			</td>
		   		</tr>

				</table>
			</fieldset>
		</td>
		</tr>
	</table>
	<br>
	<!-- Seccion de Validacion de Facturas -->
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Validaci&oacute;n de Facturas </legend>
		<table border="0">
			<tr>
				<td class="label" >
		    		<label for="validaFacturaSI">CFDI Validaci&oacute;n SAT: </label>
		   		</td>
		   	<td>
		   	 	<input type="radio" id="validaFacturaSI" name="validaFacturaSI" value="S" tabindex="165" checked="checked"/>
				<label >Si</label>
				<input type="radio" id="validaFacturaNO" name="validaFacturaNO" value="N" tabindex="166" checked="checked"/>
				<label >No</label>
				<form:input type="hidden" id="validaFactura" name="validaFactura" path="validaFactura"/>
			</td>
			</tr>
			<tr>
				<td class="label">
					<label>URL Servicio SAT: </label>
				</td>
				<td>
					<input type="text" id="validaFacturaUrl" name="validaFacturaUrl" size="100" maxlength="150" tabindex="167" disabled="disabled"/>
					<form:input type="hidden" id="validaFacturaURL" name="validaFacturaURL" path="validaFacturaURL" />
				</td>
			</tr>
			<tr>
				<td class="label" nowrap="nowrap">
					<label>Tiempo de Espera WS(milisegundos): </label>
				</td>
				<td>
					<input type="text" id="tiempoEspera" name="tiempoEspera" size="15" maxlength="50" tabindex="168" disabled="disabled"/>
					<form:input type="hidden" id="tiempoEsperaWS" name="tiempoEsperaWS" path="tiempoEsperaWS" />
				</td>
			</tr>
		</table>
	</fieldset>
	<!-- Fin de Seccion de Validacion de Facturas -->
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Procesos Autom&aacute;ticos </legend>
	<table>
		<tr>
			<td class="label" colspan="2">
		    	<label for="generaCFDINoReg">Aplica Cobros Pendientes en Cierre D&iacute;a: </label>
		   	</td>
		   	<td>
		   	 	<input type="radio" id="aplCobPenCieDia1" name="aplCobPenCieDia1" value="S" tabindex="169" />
				<label >Si</label>
				<input type="radio" id="aplCobPenCieDia2" name="aplCobPenCieDia2" value="N" tabindex="170"/>
				<label >No</label>
				<form:input type="hidden" id="aplCobPenCieDia" name="aplCobPenCieDia" path="aplCobPenCieDia" tabindex="171"/>
			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
		    	<label for="califAutoCliente">Califica <s:message code="safilocale.cliente"/> Autom&aacute;ticamente en Cierre D&iacute;a: </label>
		   	</td>
		   	<td>
		   	 	<form:radiobutton id="siCalifAutoCliente" name="califAutoCliente" path="califAutoCliente" value="S" tabindex="172" />
				<label >Si</label>
				<form:radiobutton id="noCalifAutoCliente" name="califAutoCliente" path="califAutoCliente" value="N" tabindex="173"/>
				<label >No</label>

			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
		    	<label for="cancelaAutMenor">Cancela Socio Menor en Cierre de D&iacute;a: </label>
		   	</td>
		   	<td>
		   	 	<form:radiobutton id="cancelaAutMenor1" name="cancelaAutMenor1" path="cancelaAutMenor" value="S" tabindex="174" />
				<label >Si</label>
				<form:radiobutton id="cancelaAutMenor2" name="cancelaAutMenor2" path="cancelaAutMenor" value="N" tabindex="175"/>
				<label >No</label>

			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
		    	<label for="cancelaAutSolCre">Cancelaci&oacute;n Autom&aacute;tica de Solicitudes de Cr&eacute;dito: </label>
		   	</td>
		   	<td>
		   	 	<form:radiobutton id="cancelaAutSolCre1" name="cancelaAutSolCre1" path="cancelaAutSolCre" value="S" tabindex="176" />
				<label >Si</label>
				<form:radiobutton id="cancelaAutSolCre2" name="cancelaAutSolCre2" path="cancelaAutSolCre" value="N" tabindex="177"/>
				<label >No</label>
			</td>
			  <td class="separador"></td>
			   	<td class="label" id="diasCancela">
			    	<label for="diasCancelaAutSolCre">No. D&iacute;as a Validar: </label>
				</td>
			<td>
				<form:input id="diasCancelaAutSolCre" name="diasCancelaAutSolCre" path="diasCancelaAutSolCre"
					size="6" tabindex="178" maxlength="7" onkeyPress="return validador(event);" />
			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
		    	<label for=cobranzaAutCie>Cobranza Autom&aacute;tica antes del Cierre: </label>
		   	</td>
		   	<td>
		   	 	<input type="radio" id="cobranzaAutCie1" name="cobranzaAutCie1" value="S" tabindex="179" />
				<label >Si</label>
				<input type="radio" id="cobranzaAutCie2" name="cobranzaAutCie2" value="N" tabindex="180"/>
				<label >No</label>
				<form:input type="hidden" id="cobranzaAutCie" name="cobranzaAutCie" path="cobranzaAutCie" tabindex="181"/>
			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
		    	<label for=cobroCompletoAut id="lblcobroCompletoAutTxt">Permitir Unicamente Cobro Completo en Cobranza Autom&aacute;tica: </label>
		   	</td>
		   	<td>
		   	 	<input type="radio" id="cobroCompletoAut1" name="cobroCompletoAut1" value="S" tabindex="182" />
				<label id="lblcobroCompletoAut1">Si</label>
				<input type="radio" id="cobroCompletoAut2" name="cobroCompletoAut2" value="N" tabindex="183"/>
				<label id="lblcobroCompletoAut2">No</label>
				<form:input type="hidden" id="cobroCompletoAut" name="cobroCompletoAut" path="cobroCompletoAut" tabindex="184"/>
			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
		    	<label for=camFuenFonGarFira>Cambio Fuente de Fondeo por Garant&iacute;a Fira:</label>
		   	</td>
		   	<td>
		   	 	<form:input type="radio" id="camFuenFonGarFiraSI" name="camFuenFonGarFira" path="camFuenFonGarFira" value="S" tabindex="185" />
				<label >Si</label>
				<form:input type="radio" id="camFuenFonGarFiraNO" name="camFuenFonGarFira" path="camFuenFonGarFira" value="N" tabindex="186"/>
				<label >No</label>
			</td>
		</tr>
		<tr>
			<td class="label" colspan="2">
				<label for=ejecDepreAmortiAut>Depreciaci&oacute;n y Amortizaci&oacute;n :</label>
			</td>
			<td>
				<form:input type="radio" id="ejecDepreAmortiAutSI" name="ejecDepreAmortiAut" path="ejecDepreAmortiAut" value="S" tabindex="187" />
				<label >Si</label>
				<form:input type="radio" id="ejecDepreAmortiAutNO" name="ejecDepreAmortiAut" path="ejecDepreAmortiAut" value="N" tabindex="188"/>
				<label >No</label>
			</td>
		</tr>
	</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Cartera </legend>
		<table>
		<tr>
						<td class="label">
						<label>Moratorios de Cartera Vigente en:</label>
						</td>

						<td>
								<form:radiobutton id="tipoContaMora" name="tipoContaMora" path="tipoContaMora" value="C" tabindex="195" />
								<label for="CtasOrden">Ctas. de Orden</label>
								<form:radiobutton id="tipoContaMora1" name="tipoContaMora1" path="tipoContaMora" value="I" tabindex="196" />
								<label for="Ingresos">Ingresos</label>
						</td>
					</tr>
					<tr>
						<td class="label">
						<label>Separar Ingresos e Intereses de Cartera Vencida y Vigente:</label>
						</td>

						<td>
								<form:radiobutton id="divideIngresoInteres" name="divideIngresoInteres" path="divideIngresoInteres" value="S" tabindex="197" />
								<label for="si">Si</label>
								<form:radiobutton id="divideIngresoInteres1" name="divideIngresoInteres1" path="divideIngresoInteres" value="N" tabindex="198" />
								<label for="no">No</label>
						</td>
					</tr>
					<tr>
						<td>
							<label>Imprimir Formatos Individuales: </label>
						</td>
						<td>
							<form:radiobutton id="impFomatosInd1" name="impFomatosInd" path="impFomatosInd" value="S" tabindex="199" />
							<label for="impFomatosInd1">Si</label>
							<form:radiobutton id="impFomatosInd2" name="impFomatosInd" path="impFomatosInd" value="N" tabindex="200" />
							<label for="impFomatosInd2">No</label>
						</td>
					</tr>
					<tr>
						<td>
							<label>Validar Créditos para Desembolsar: </label>
						</td>
						<td>
							<form:radiobutton id="reqValidaCred1" name="reqValidaCred" path="reqValidaCred" value="S" tabindex="201" />
							<label for="reqValidaCred1">Si</label>
							<form:radiobutton id="reqValidaCred2" name="reqValidaCred" path="reqValidaCred" value="N" tabindex="202" />
							<label for="reqValidaCred2">No</label>
						</td>
					</tr>
					<tr>
						<td>
							<label>Cobro de Seguro por Cuota: </label>
						</td>
						<td>
							<form:radiobutton id="cobraSeguroCuota1" name="cobraSeguroCuota" path="cobraSeguroCuota" value="S" tabindex="203" />
							<label for="cobraSeguroCuota1">Si</label>
							<form:radiobutton id="cobraSeguroCuota2" name="cobraSeguroCuota" path="cobraSeguroCuota" value="N" tabindex="204" />
							<label for="cobraSeguroCuota2">No</label>
						 	<a href="javaScript:" onClick="ayudaSeguroCuota();">
									  	<img src="images/help-icon.gif" >
							</a>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="validaRefSI">Validar Referencia por Pago de Instrumento:</label>
						</td>
						<td><form:radiobutton id="validaRefSI" name="validaRef" path="validaRef" value="S" tabindex="205" />
							<label for="validaRefSI">Si</label>
							<form:radiobutton id="validaRefNO" name="validaRef" path="validaRef" value="N" tabindex="206" />
							<label for="validaRefNO">No</label>
							<a href="javaScript:" onClick="ayudaValidaReferencia();">
									  	<img src="images/help-icon.gif" >
							</a>
						 </td>
					</tr>
					<tr>
						<td class="label">
							<label for="manejaCarAgroSI">Maneja Cartera Agro:</label>
						</td>
						<td>
						 	<form:radiobutton id="manejaCarAgroSI" name="manejaCarAgro" path="manejaCarAgro" value="S" tabindex="207" />
							<label for="manejaCarAgroSI">Si</label>
							<form:radiobutton id="manejaCarAgroNO" name="manejaCarAgro" path="manejaCarAgro" value="N" tabindex="208" />
							<label for="manejaCarAgroNO">No</label>
						 </td>
					</tr>
					<tr>
						<td class="label">
							<label for="evaluaRiesgoComun">Evalua Riesgo Com&uacute;n:</label>
						</td>
						<td>
						 	<form:radiobutton id="evaluaRiesgoComunSI" name="evaluaRiesgoComun" path="evaluaRiesgoComun" value="S" tabindex="209" />
							<label for="evaluaRiesgoComunSI">Si</label>
							<form:radiobutton id="evaluaRiesgoComunNO" name="evaluaRiesgoComun" path="evaluaRiesgoComun" value="N" tabindex="210" />
							<label for="evaluaRiesgoComunNO">No</label>
						 </td>

					</tr>
					<tr>
						<td class="label">
					    	<label for="capitalContNeto">Capital Contable Neto: </label>
						</td>
					    <td>
							<form:input id="capitalContNeto" name="capitalContNeto" path="capitalContNeto" size="15"  tabindex="211" esMoneda="true"/>
					 	</td>
					</tr>
					<tr>
						<td class="label">
							<label for="porcPersonaFisica">Porcentaje Capital Contable Persona F&iacute;sica:</label>
						</td>
						<td>
							<form:input id="porcPersonaFisica" name="porcPersonaFisica" path="porcPersonaFisica" tabindex="212" size="7" esMoneda="true"  style="text-align: right;"/>
							<label> %</label>
						 </td>
					</tr>

					<tr>



						<td class="label">
							<label for="porcPersonaMoral">Porcentaje Capital Contable Persona Moral:</label>
						</td>
						<td>
							<form:input id="porcPersonaMoral" name="porcPersonaMoral" path="porcPersonaMoral" tabindex="213" size="7" esMoneda="true"  style="text-align: right;"/>
							<label> %</label>
						 </td>
					</tr>

					<tr>
					<td class="label">
							<label for="permitirMultDisp">Permitir M&uacute;ltiples Dispersiones:</label>
						</td>
						<td>
						 	<form:radiobutton id="permitirMultDispSI" name="permitirMultDisp" path="permitirMultDisp" value="S" tabindex="214" />
							<label for="permitirMultDispSI">Si</label>
							<form:radiobutton id="permitirMultDispNO" name="permitirMultDisp" path="permitirMultDisp" value="N" tabindex="215" />
							<label for="permitirMultDisp">No</label>
						 </td>

					</tr>

					<tr>
						<td class="label">
							<label for="validarEtiqCambFond">Validar etiquetado en cambio de fuente de fondeo:</label>
						</td>
						<td>
						 	<form:radiobutton id="validarEtiqCambFondSI" name="validarEtiqCambFond" path="validarEtiqCambFond" value="S" tabindex="216" />
							<label for="validarEtiqCambFondSI">Si</label>
							<form:radiobutton id="validarEtiqCambFondNO" name="validarEtiqCambFond" path="validarEtiqCambFond" value="N" tabindex="217" />
							<label for="validarEtiqCambFondNO">No</label>
						 </td>

					</tr>
					<tr>
						<td class="label">
							<label for="restringeReporte">Restringe reportes</label>
						</td>
						<td>
						 	<form:radiobutton id="restringeReporteSI" name="restringeReporte" path="restringeReporte" value="S" tabindex="218" />
							<label for="restringeReporteSI">Si</label>
							<form:radiobutton id="restringeReporteNO" name="restringeReporte" path="restringeReporte" value="N" tabindex="219" />
							<label for="restringeReporteNO">No</label>
							<a href="javaScript:" onClick="ayudaRestringeReporte();">
									  	<img src="images/help-icon.gif" >
							</a>
						 </td>

					</tr>
					<tr>
						<td class="label">
							<label for="lblValidaCicloGrupo">Valida Ciclo Cr&eacute;ditos Grupales:</label>
						</td>
						<td>
						 	<form:radiobutton id="validaCicloGrupoSI" name="validaCicloGrupo" path="validaCicloGrupo" value="S" tabindex="190" />
							<label for="validaCicloGrupoSI">Si</label>
							<form:radiobutton id="validaCicloGrupoNO" name="validaCicloGrupo" path="validaCicloGrupo" value="N" tabindex="191" />
							<label for="validaCicloGrupoNO">No</label>
						 </td>
					</tr>

		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Inversiones en Garant&iacute;a </legend>
		<table>
			<tr>
				<td class="label">
				<label>Estatus Cr&eacute;ditos Permitidos:</label>
				</td>

				<td>
					<select multiple  id="estCreAltInvGar" name="estCreAltInvGar" path="estCreAltInvGar" tabindex="220"  size="4">
				    	<option value="I">INACTIVO</option>
				        <option value="V">VIGENTE</option>
				        <option value="P">PAGADO</option>
				        <option value="B">VENCIDO</option>
					</select>
				</td>
			</tr>
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>C&iacute;rculo y Bur&oacute; de Cr&eacute;dito </legend>
		<table>
			<tr>
				<td class="label">
			    	<label for=>D&iacute;as de Vigencia de la Consulta a Bur&oacute; Cr&eacute;dito:</label>
				</td>
			    <td>
			    	<form:input id="diasVigenciaBC" name="diasVigenciaBC" path="diasVigenciaBC" tabindex="221" size="6"/>
		   		</td>
			</tr>
			<tr>
				<td class="label">
					<label>Consulta Sugerida:</label>
				</td>
				<td>
					<input type="radio" id="conBuroCreDefautBuro" name="conBuroCreDefautBuro" value="B" tabindex="222" />
					<label for="si">Bur&oacute; Cr&eacute;dito</label>
					<input type="radio" id="conBuroCreDefautCirculo" name="conBuroCreDefautCirculo"  value="C" tabindex="223" />
					<label for="no">C&iacute;rculo Cr&eacute;dito</label>
					<form:input type="hidden" id="conBuroCreDefaut" name="conBuroCreDefaut" path="conBuroCreDefaut" tabindex="224" size="6"/>
				</td>
			</tr>
			<tr>
				<td class="label">
			    	<label for=>Clave para Firma C&iacute;rculo Cr&eacute;dito:</label>
				</td>
			    <td>
			    	<form:input id="abreviaturaCirculo" name="abreviaturaCirculo" path="abreviaturaCirculo" tabindex="225" size="6" maxlength="3"  onBlur=" ponerMayusculas(this)"/>
		   		</td>
			</tr>
			<tr>
				<td class="label">
					<label for="lbInstitucionCredito">Instituci&oacute;n C&iacute;rculo Cr&eacute;dito:</label>
				</td>
				<td>
					<form:input id="institucionCirculoCredito" name="institucionCirculoCredito" path="institucionCirculoCredito" tabindex="226" size="6" maxlength="10"  onBlur=" ponerMayusculas(this)"/>
					<input type="text" id="tipoInstitucionCirculoCredito" name="tipoInstitucionCirculoCredito" size="40" readonly="true"/>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="lbClaveEntidadCredito">Clave de Entidad de C&iacute;rculo Cr&eacute;dito:</label>
				</td>
				<td>
					<form:select id="claveEntidadCirculo" name="claveEntidadCirculo" path="claveEntidadCirculo" tabindex="227" >
						<form:option value="0">SELECCIONAR</form:option>
						<form:option value="1">ENTIDAD FINANCIERA</form:option>
						<form:option value="2">EMPRESA COMERCIAL</form:option>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="label">
					<label>Reportar Total Directivos y Avales:</label>
				</td>
				<td>
					<form:input type="radio" id="reportarTotalIntegrantesSI" name="reportarTotalIntegrantes" path="reportarTotalIntegrantes" value="S" tabindex="228" />
					<label for="si">SI</label>
					<form:input type="radio" id="reportarTotalIntegrantesNO" name="reportarTotalIntegrantes" path="reportarTotalIntegrantes" value="N" tabindex="229" />
					<label for="no">NO</label>
				</td>
			</tr>
		</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Solicitud de Cr&eacute;dito</legend>
		<table>
			<tr>
				<td class="label">
					<label>Se puede Cambiar Promotor:</label>
				</td>
				<td>
				 	<form:radiobutton id="siCambiaPromotor" name="siCambiaPromotor" path="cambiaPromotor" value="S" tabindex="230" />
					<label for="si">Si</label>
					<form:radiobutton id="noCambiaPromotor" name="noCambiaPromotor" path="cambiaPromotor" value="N" tabindex="231" />
					<label for="no">No</label>
				 </td>
			</tr>
			<tr>
				<td class="label">
					<label>Ocultar el botón Rechazar Solicitud:</label>
				</td>
				<td>
				 	<form:radiobutton id="siOcultaBtnRechazoSol" name="siOcultaBtnRechazoSol" path="ocultaBtnRechazoSol" value="S" tabindex="232" />
					<label for="si">Si</label>
					<form:radiobutton id="noOcultaBtnRechazoSol" name="noOcultaBtnRechazoSol" path="ocultaBtnRechazoSol" value="N" tabindex="233" />
					<label for="no">No</label>
					<a href="javaScript:" onClick="ayudaBloqueaBtonRechazar();">
						<img src="images/help-icon.gif" >
					</a>
				 </td>
			</tr>
			<tr>
				<td class="label">
					<label>Restringir liberación de solicitud:</label>
				</td>
				<td>
				 	<form:radiobutton id="siRestringebtnLiberacionSol" name="siRestringebtnLiberacionSol" path="restringebtnLiberacionSol" value="S" tabindex="234" />
					<label for="si">Si</label>
					<form:radiobutton id="noRestringebtnLiberacionSol" name="noRestringebtnLiberacionSol" path="restringebtnLiberacionSol" value="N" tabindex="235" />
					<label for="no">No</label>
					<a href="javaScript:" onClick="ayudaRestringeLiberacion();">
						<img src="images/help-icon.gif" >
					</a>
				</td>

			</tr>
			<tr>
				<td class="label">
						<label>Rol Autorizado:</label>
				</td>
				<td>
					<form:input id="primerRolFlujoSolID" name="primerRolFlujoSolID" path="primerRolFlujoSolID"
			        			 tabindex="208" size="6"/>
			        <input id="nombrePrimerRol" name="nombrePrimerRol" size="40" type="text" readOnly="true"
			        			disabled="true" />
				</td>
				<td>
					<form:input id="segundoRolFlujoSolID" name="segundoRolFlujoSolID" path="segundoRolFlujoSolID" tabindex="236" size="6" maxlength="10"  onBlur=" ponerMayusculas(this)"/>
					<input type="text" id="nombreSegundoRol" name="nombreSegundoRol" size="40" readonly="true"disabled="true" />
				</td>
			<tr>
		</table>
	</fieldset>


	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Renovaci&oacute;n y Reestructura de Cr&eacute;dito</legend>
		<table>
			<tr>
				<td class="label">
					<label for="numTratamienCre">Renovaciones Permitidas a un Cr&eacute;dito:</label>
				</td>
				<td>
				 	<form:input id="numTratamienCre" name="numTratamienCre" path="numTratamienCre" tabindex="237" size="10"/>
				 </td>
				 <td class="separador"></td>
				 <td class="separador"></td>
				<td class="label">
					<label for="numTratamienCre">Reestructuras Permitidas a un Cr&eacute;dito:</label>
				</td>
				<td>
				 	<form:input id="numTratamienCreRees" name="numTratamienCreRees" path="numTratamienCreRees" tabindex="238" size="10"/>
				 </td>
			</tr>
			<tr>
				 <td class="label">
					<label for="capitalCubierto">Capital del Cr&eacute;dito Cubierto para Renovaci&oacute;n o Reestructura:</label>
				</td>
				<td>
				 	<form:input id="capitalCubierto" name="capitalCubierto" path="capitalCubierto" tabindex="239" size="10" esMoneda="true"  style="text-align: right;"/>
				 	<label> %</label>
				 </td>
				 <td class="separador"></td>
				 <td class="separador"></td>
				<td class="label">
					<label for="pagoIntVertical">Pagar Total Exigible de Inter&eacute;s:</label>
				</td>
				<td>
				 	<form:radiobutton id="pagoIntVerticalSi" name="pagoIntVertical" path="pagoIntVertical" value="S" tabindex="240" />
					<label for="si">Si</label>
					<form:radiobutton id="pagoIntVerticalNo" name="pagoIntVertical" path="pagoIntVertical" value="N" tabindex="241" />
					<label for="no">No</label>
				 </td>
			</tr>
			<tr>
				 <td class="label">
					<label for="numMaxDiasMoraRes">N&uacute;mero M&aacute;ximo de D&iacute;as Mora:</label>
				</td>
				<td>
				 	<form:input id="numMaxDiasMora" name="numMaxDiasMora" path="numMaxDiasMora" tabindex="242" size="10" onkeyPress="return validador(event);" style="text-align: right;"/>
				 </td>
				 <td class="separador"></td>
				 <td class="separador"></td>
				<td class="label">
					<label for="reestCalendarioVen">Reestructurar con Plazo Vencido:</label>
				</td>
				<td>
				 	<form:radiobutton id="reestCalendarioVenSi" name="reestCalendarioVen" path="reestCalendarioVen" value="S" tabindex="243" />
					<label for="si">Si</label>
					<form:radiobutton id="reestCalendarioVenNo" name="reestCalendarioVen" path="reestCalendarioVen" value="N" tabindex="244" />
					<label for="no">No</label>
				 </td>
			</tr>
			<tr>
				<td class="label">
					<label id="lblValidaEstatusTxt" style="display:none;" for="validaEstatusRees">Validar Estatus:</label>
				</td>
				<td id="validaEstatus" >
				 	<form:radiobutton id="validaEstatusReesSi" style="display:none;" name="validaEstatusRees" path="validaEstatusRees" value="S" tabindex="245" />
					<label id="lblValidaEstatusSi" for="si" style="display:none;">Si</label>
					<form:radiobutton id="validaEstatusReesNo" style="display:none;" name="validaEstatusRees" path="validaEstatusRees" value="N" tabindex="246" />
					<label id="lblValidaEstatusNo" style="display:none;" for="no">No</label>
				</td>
				 <td class="separador"></td>
				 <td class="separador"></td>
			</tr>
		</table>
	</fieldset>

		<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Reacreditaci&oacute;n</legend>
		<table>
			<tr>
			<td class="label">
				<label for="capitalCubiertoReac">Capital del Cr&eacute;dito Cubierto para Reacreditaci&oacute;n:</label>
			</td>
			<td>
				<form:input id="capitalCubiertoReac" name="capitalCubiertoReac" path="capitalCubiertoReac" tabindex="247" size="10" esMoneda="true"  style="text-align: right;"/>
				<label> %</label>
			 </td>
			</tr>

		</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Cobranza</legend>
		<table>
			<tr>
				<td class="label">
					<label for="rutaNotifiCobranza">Ruta Notificaciones Cobranza:</label>
				</td>
				<td>
				 	<form:input id="rutaNotifiCobranza" name="rutaNotifiCobranza" path="rutaNotifiCobranza" tabindex="248" size="100" maxlength="100"/>
				</td>
			</tr>
		</table>
	</fieldset>

	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend>Bitácora de Acceso al SAFI</legend>
		<table>
			<tr>
				<td class="label">
					<label for="detRutaSAFI">Tipo Presentación Detalle Recursos:</label>
				</td>
				<td>
				 	<form:radiobutton id="detRutaSAFI" name="tipoDetRecursos" path="tipoDetRecursos" value="1" tabindex="249" />
					<label for="detRutaSAFI">Ruta SAFI</label>
					<form:radiobutton id="detRecurso" name="tipoDetRecursos" path="tipoDetRecursos" value="2" tabindex="250" />
					<label for="detRecurso">Recurso</label>
				 </td>
			</tr>
		</table>
	</fieldset>

	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>N&oacute;mina Afiliaci&oacute;n/Baja</legend>
		<table>
			<tr>
				<td class="label" nowrap="nowrap">
					<label for="clabeInstitBancaria">Clabe Bancaria Afiliaci&oacute;n: </label>
				</td>
				<td nowrap="nowrap">
					<form:input id="clabeInstitBancaria" name="clabeInstitBancaria" path="clabeInstitBancaria" tabindex="260" size="15" maxlength="10"/>
				</td>

			</tr>
		</table>
	</fieldset>

	<br>
	<div id="divConfigContra">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Configuraci&oacute;n de Contraseña</legend>
			<table>
				<tr>
					<td class="label">
						<label for="lbCaracterMinimo">Caracteres M&iacute;nimo:</label>
					</td>
					<td>
						<form:input id="caracterMinimo" name="caracterMinimo" path="caracterMinimo" tabindex="261" size="10" maxlength="100"/>
						<label>Caracteres.</label>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbReqCaracterMayus">Caracteres May&uacute;sculas:</label>
					</td>

					<td>
						<form:radiobutton id="reqCaracterMayusSI" name="reqCaracterMayus" path="reqCaracterMayus" value="S" tabindex="262" />
						<label for="reqCaracterMayusSI">Si</label>
						<form:radiobutton id="reqCaracterMayusNO" name="reqCaracterMayus" path="reqCaracterMayus" value="N" tabindex="263" />
						<label for="reqCaracterMayusNO">No</label>
					</td>

					<td class="label"  id="tdCaracterMayus">
						<label for="lbCaracterMayus">Cantidad:</label>
						<form:input id="caracterMayus" name="caracterMayus" path="caracterMayus" tabindex="264" size="10" maxlength="100"/>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbReqCaracterMinus">Caracteres Min&uacute;sculas:</label>
					</td>

					<td>
						<form:radiobutton id="reqCaracterMinusSI" name="reqCaracterMinus" path="reqCaracterMinus" value="S" tabindex="265" />
						<label for="reqCaracterMinusSI">Si</label>
						<form:radiobutton id="reqCaracterMinusNO" name="reqCaracterMinus" path="reqCaracterMinus" value="N" tabindex="266" />
						<label for="reqCaracterMinusNO">No</label>
					</td>

					<td class="label" id="tdCaracterMinus">
						<label for="lbCaracterMinus">Cantidad:</label>
						<form:input id="caracterMinus" name="caracterMinus" path="caracterMinus" tabindex="267" size="10" maxlength="100"/>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbReqCaracterNumerico">N&uacute;meros:</label>
					</td>

					<td>
						<form:radiobutton id="reqCaracterNumericoSI" name="reqCaracterNumerico" path="reqCaracterNumerico" value="S" tabindex="268" />
						<label for="reqCaracterNumericoSI">Si</label>
						<form:radiobutton id="reqCaracterNumericoNO" name="reqCaracterNumerico" path="reqCaracterNumerico" value="N" tabindex="269" />
						<label for="reqCaracterNumericoNO">No</label>
					</td>

					<td class="label" id="tdCaracterNumerico">
						<label for="lbCaracterNumerico">Cantidad:</label>
						<form:input id="caracterNumerico" name="caracterNumerico" path="caracterNumerico" tabindex="270" size="10" maxlength="100"/>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbReqCaracterEspecial">Caracteres Especiales:</label>
					</td>

					<td>
						<form:radiobutton id="reqCaracterEspecialSI" name="reqCaracterEspecial" path="reqCaracterEspecial" value="S" tabindex="271" />
						<label for="reqCaracterEspecialSI">Si</label>
						<form:radiobutton id="reqCaracterEspecialNO" name="reqCaracterEspecial" path="reqCaracterEspecial" value="N" tabindex="272" />
						<label for="reqCaracterEspecialNO">No</label>
					</td>

					<td class="label" id="tdCaracterEspecial">
						<label for="lbCaracterEspecial">Cantidad:</label>
						<form:input id="caracterEspecial" name="caracterEspecial" path="caracterEspecial" tabindex="273" size="10" maxlength="100"/>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbUltimasContra">&Uacute;ltimas Contraseñas no Permitidas:</label>
					</td>
					<td>
						<form:input id="ultimasContra" name="ultimasContra" path="ultimasContra" tabindex="274" size="10" maxlength="100"/>
						<label>Contraseñas.</label>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbDiaMaxCamContra">Tiempo M&aacute;x. Para Cambio de Contraseña:</label>
					</td>
					<td>
						<form:input id="diaMaxCamContra" name="diaMaxCamContra" path="diaMaxCamContra" tabindex="275" size="10" maxlength="100"/>
						<label>D&iacute;as.</label>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbDiaMaxInterSesion">Tiempo M&aacute;x. sin Interacci&oacute;n para Cierre de Sesi&oacute;n:</label>
					</td>
					<td>
						<form:input id="diaMaxInterSesion" name="diaMaxInterSesion" path="diaMaxInterSesion" tabindex="276" size="10" maxlength="100"/>
						<label>Minutos.</label>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbNumIntentos">N&uacute;mero de Intentos Fallidos Permitidos:</label>
					</td>
					<td>
						<form:input id="numIntentos" name="numIntentos" path="numIntentos" tabindex="278" size="10" maxlength="100"/>
						<label>Intentos.</label>
					</td>
				</tr>

				<tr>
					<td class="label">
						<label for="lbNumDiaBloq">N&uacute;mero de D&iacute;as para Bloqueo Aut. Usuarios:</label>
					</td>
					<td>
						<form:input id="numDiaBloq" name="numDiaBloq" path="numDiaBloq" tabindex="279" size="10" maxlength="100"/>
						<label>D&iacute;as.</label>
					</td>
				</tr>
			</table>
		</fieldset>
	</div>

	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar" tabindex="280"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>


			</td>
		</tr>
	</table>

</form:form>
</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"></div>
</div>

</body>
<div id="mensaje" style="display: none;"></div>
</html>