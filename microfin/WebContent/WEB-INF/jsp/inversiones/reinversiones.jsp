<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="js/date.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/inversionServicioScript.js"></script>
	<script type="text/javascript" src="dwr/interface/tipoInversionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tasasInversionServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/direccionesClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/tiposIdentiServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paisesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/ocupacionesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/parentescosServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/beneficiariosInverServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/identifiClienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/cuentasFirmaServicio.js"></script>
    <script type="text/javascript" src="js/soporte/mascara.js"></script>
	<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>
	<script type="text/javascript" src="js/inversiones/reinversiones.js"></script>
	<script type="text/javascript" src="js/inversiones/beneficiariosInver.js"></script>
    <script type="text/javascript" src="js/general.js"></script>
    <script type="text/javascript" src="js/generarRFC.js"></script>

<title>Reinversion</title>
</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reinversiones</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="POST" action = "/microfin/generaReinversion.htm" commandName="inversionBean" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend >Datos Generales</legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td><label>Inversi&oacute;n:</label></td>
					<td><form:input type="text" name="inversionID" id="inversionID" path="inversionID"
										  size="11" tabIndex = "1" autocomplete="off"/>
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td><label>No. <s:message code="safilocale.cliente"/>:</label></td>
					<td colspan="3"><input type="text" name="clienteID" id="clienteID" size="11" autocomplete="off"
								 readonly="true" />
						<input type="text" name="nombreCompleto" id="nombreCompleto" size="50"
								 readonly="true" />
					</td>
				</tr>
				<tr >
					<td><label>Direcci&oacute;n:</label></td>
					<td nowrap="nowrap" colspan="3"><textarea rows="3" cols="70" name="direccion" id="direccion" readonly="true"></textarea>
						<label>Tel&eacute;fono:</label>
						<input type="text" name="telefono" id="telefono" size="15" readonly="true" />
					</td>
				</tr>
				<tr><td colspan='4'>&nbsp;</td></tr>
				<tr>
					<td><label>Cuenta Cobro:</label></td>
					<td><form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID" size="13" autocomplete="off" readonly="true"/>
					</td>
					<td class="separador"></td>
					<td>
						<label>Saldo&nbsp;</label>
						<input type="text" id="totalCuenta" name="totalCuenta" style="text-align: right;" size="15"  readonly="true"  esMoneda="true" />
						<input type="hidden" name="monedaID" id="monedaID" />
						<label id="tipoMoneda"></label>
					</td>
				</tr>
				<tr>
					<td><label>Tipo de Inversi&oacute;n:</label></td>
					<td colspan="3">
						<form:input id="tipoInversionID" name="tipoInversionID" path="tipoInversionID"
										size="9" autocomplete="off"  readonly="true"/>
						<input type="text" id="descripcion" name="descripcion" size="26" readonly="true" />
						<label id="tipoMonedaInversion"></label>
					</td>
				</tr>
				<tr>
					<td><label>Monto Invertido:</label>
					<td>
						<input type="text" id="montoConsulta" name="montoConsulta" readonly="true" style="text-align: right;"
							   size="18" esMoneda="true" />
					</td>
					<td class="separador"></td>
					<td>
						<label>Inter&eacute;s a Recibir:</label>
						<input type="text" id="interesConsulta" name="interesConsulta" readonly="true" style="text-align: right;" size="18" esMoneda="true" />&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
				</tr>

				<tr>
					<td><label>Disponible a Invertir: &nbsp;&nbsp;</label></td>
					<td><input type="text" name="totalDisponible" id="totalDisponible" size="18" readonly="true"  esMoneda="true" />
					</td>
					<td class="separador"></td>
					<td>
						<label>Tipo de Reinversi&oacute;n Autom&aacute;tica:</label>
						<form:select id="tipoReinversion" name="tipoReinversion" path="reinvertir" tabIndex = "2"></form:select>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="beficiariolbl">Beneficiarios a Considerar:</label>
					</td>
					<td class="label" colspan="3">
						<form:radiobutton id="beneficiarioSocio" name="beneficiario" path="beneficiario" value="S" tabindex="51" checked="true"/>
						<label for="cuentaSocio">Cuenta <s:message code="safilocale.cliente"/></label>&nbsp;&nbsp;&nbsp;&nbsp;
						<form:radiobutton id="beneficiarioInver" name="beneficiario" path="beneficiario" value="I" tabindex="52"/>
						<label for="propioInversion">Propio de la Inversión</label>
					</td>
				</tr>
				<tr><td colspan='4' >&nbsp;</td></tr>
				<tr >
					<td colspan="4">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend >Condiciones Nueva Inversi&oacute;n</legend>
						<table border="0">
							<tr>
								<td><label>Monto:</label></td>
								<td><form:input type="text" name="monto" id="monto" size="18" path="monto" style="text-align: right;"
													  esMoneda="true" autocomplete="off" tabIndex = "3" />
									<label id="tipoMonedaInv"></label>
								</td>
								<td><label>Tasa Bruta</label></td>
								<td><form:input type="text" name="tasa" id="tasa" path="tasa" size="12" readonly="true"
									style="text-align: right;" esTasa="true"/><label>%</label></td>
								<td>&nbsp;&nbsp;</td>
								<td><label>Inter&eacute;s Generado</label></td>
								<td><form:input name="interesGenerado" id="interesGenerado" path="interesGenerado" readonly="true"
									style="text-align: right;" esMoneda="true" size="18"/></td>
							</tr>

							<tr>
								<td><label>Plazo:</label></td>
								<td>
									<form:input name="plazo" id="plazo" path="plazo" size="18" style="text-align: right;"
													tabIndex = "4" autocomplete="off"/>
								</td>
								<td><label>Tasa ISR</label></td>
								<td><form:input type="text" name="tasaISR" id="tasaISR" path="tasaISR" readonly="true" value="" size="12"
									esTasa="true" style="text-align: right;" /><label>%</label></td>
								<td>&nbsp;&nbsp;</td>
								<td><label>Inter&eacute;s Retener</label></td>
								<td><form:input name="interesRetener" id="interesRetener" path="interesRetener" readonly="true"
									 esMoneda="true" size="18" style="text-align: right;"/></td>

							</tr>
							<tr>
								<td><label>Fecha de<br>Inicio</label></td>
								<td>
									<form:input type="text" name="fechaInicio" id="fechaInicio" size="18"
											path="fechaInicio"  autocomplete="off" readonly="true"/>
								</td>
								<td><label>Tasa Neta</label></td>
								<td><form:input type="text" name="tasaNeta" id="tasaNeta" path="tasaNeta" size="12" readonly="true"
									style="text-align: right;" esTasa="true"  /><label>%</label></td>
								<td>&nbsp;&nbsp;</td>
								<td><label>Inter&eacute;s Recibir</label></td>
								<td><form:input name="interesRecibir" id="interesRecibir" path="interesRecibir" readonly="true"
									esMoneda="true" size="18" style="text-align: right;"/></td>
							</tr>
							<tr>
								<td><label>Fecha de<br>Vencimiento</label></td>
								<td>
									<form:input type="text" name="fechaVencimiento" id="fechaVencimiento" size="18"
											path="fechaVencimiento" esCalendario="true" autocomplete="off" tabIndex="5"/>
								</td>
								<td class="label">
										<label for="lbconsultaGAT">GAT Nominal: </label>
								</td>
								<td >
										<input type="text" name="valorGat" id="valorGat" path="valorGat" size="12"
												readonly="true" style="text-align: right;"/><label for="lbconsultaGAT" >%</label>
								</td>
								<td class="separador"/>
								<td class="label">
											<label for="valorGatReal">GAT Real: </label>
								</td>
								<td >
										<input type="text" name="valorGatReal" id="valorGatReal" path="valorGatReal" size="12"
												readonly="true" style="text-align: right;"/><label for="valorGatReal" >%</label>
								</td>
							</tr>
							<tr>
								<td><label>Etiqueta:</label>
								</td>
								<td colspan="5">
									<form:input id="etiqueta" name="etiqueta" path="etiqueta" onblur="ponerMayusculas(this)"
													tabIndex = "6" size="50"  autocomplete="off" />
								</td>
								<td align="right"><label>Total a Recibir:</label></td>
								<td><input type="text" name="granTotal" id="granTotal" readonly="true" esMoneda="true" size="18"
									style="text-align: right;"/></td>
							</tr>
						</table>
						</fieldset>
					</td>
				</tr>

				<tr><td colspan='4'>&nbsp;</td></tr>

			</table>
		</fieldset>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="separador">
							<span id="statusSrvHuella"></span>
						</td>
						<td colspan="4">
							<table align="right" boder='0'>
								<tr>
									<td align="right">
										<input type="submit" id="reinvertirBoton" name="reinvertirBoton"
												 class="submit" value="Reinvertir" tabIndex="7" />
										<input type="submit" id="cancelar" name="cancelar" class="submit"
												  value="No Reinvertir(Abonar Inversi&oacute;n)" tabIndex="8" />
										<a id="enlace" href="" target="_blank">
		                     		<button type="button" class="submit" id="imprime" name="imprime"
		                     				  tabIndex="9" >
		                              Imp.Pagare
		                      		</button>
										</a>
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
										<input type="hidden" id="estatus" name = "estatus" />
										<input type="hidden" id="tipoOperacion" name="tipoOperacion" value="3" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
		</form:form>

		<br>
<fieldset id ="personasRelacionadas" class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Beneficiarios Inversión</legend>
	<form:form id="formaGenerica2" name="formaGenerica2" method="POST" action = "/microfin/beneficiariosInver.htm"  commandName="beneficiariosInverBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all" id="fielsetBusqueda">
			<legend>B&uacute;squeda</legend>
			<table border="0" cellpadding="0" cellspacing="0"  width="100%">
			 	<tr>
			 	<td colspan="2">
			 		<input  type="button" id="heredarBen" name="hereda" class="submit"
			 		tabIndex = "199" value="Heredar Beneficiarios de la Última Inversión"/>
			 		</td>
			 	</tr>
			 	<tr>
					<td class="label">
			         <label for="lblBenefInverID">Beneficiario: </label>
			     	</td>
			     	<td>
			         <input id="beneInverID" name="beneInverID" path="beneInverID" size="11" maxlength="12"
			         	 tabindex="200" type="text" />
			     	</td>

			     	<td class="separador"></td>
			     	<td class="label">
						<label for="numero"><s:message code="safilocale.cliente"/>: </label>
					</td>
					<td>
						<input id="numeroCte" name="numeroCte" path="numeroCte" size="11" tabindex="201" type="text"/>
						<input id="nombreCompletoC" name="nombreCompletoC"size="60"
			         	type="text" disabled="true" tabindex="202" />
					</td>
				</tr>

			</table>
		</fieldset>


		 <fieldset id = "datosGeneralesFieldset" class="ui-widget ui-widget-content ui-corner-all">
			<legend>Datos Generales de la Persona</legend>
			<table border="0" cellpadding="0" cellspacing="0"  width="100%">
				<tr>
			    	<td class="label">
			         <label for="lblTitulo">Título: </label>
			     	</td>
			     	<td>
			         <select id="titulo" name="titulo" path="titulo" tabindex="210">
			         		<option value="SR.">SELECCIONAR </option>
							<option value="SR.">SR. </option>
					     	<option value="SRA.">SRA.</option>
					     	<option value="SRITA.">SRITA.</option>
						   	<option value="LIC.">LIC.</option>
						  	<option value="DR.">DR.</option>
							<option value="ING.">ING.</option>
							<option value="PROF.">PROF.</option>
							<option value="C. P.">C. P.</option>
						</select>
			     	</td>
				</tr>
				<tr>
					<td class="label">
				   		<label for="lblPrimerNombre">Primer Nombre: </label>
				   	</td>
		   			<td>
				     	<input id="primerNombre" type="text" name="primerNombre" path="primerNombre" size="25" maxlength="50"
				     		tabindex="211"  onBlur="ponerMayusculas(this);"/>
				  	</td>
			   		<td class="separador"></td>
			   		<td class="label">
			    		<label for="lblSegundoNombre">Segundo Nombre: </label>
			   		</td>
			   		<td>
			    		<input id="segundoNombre" type="text" name="segundoNombre" path="segundoNombre" size="25" maxlength="50"
			    			tabindex="212"  onBlur="ponerMayusculas(this);"/>
			   		</td>
				</tr>
				<tr>
					<td class="label">
						<label for="lblTercerNombre">Tercer Nombre: </label>
					</td>
				  	<td>
				  		<input id="tercerNombre" type="text" name="tercerNombre" path="tercerNombre" size="25" maxlength="50"
						tabindex="213" onBlur="ponerMayusculas(this);"/>
				  	</td>
				  	<td class="separador"></td>
				 	<td class="label">
				 		<label for="lblApellidoPaterno">Apellido Paterno: </label>
				  	</td>
					<td>
						<input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" maxlength="50"
						type="text" size="25" tabindex="214" onBlur="ponerMayusculas(this);"/>
					</td>
				</tr>
				<tr>
					<td class="label">
					    <label for="lblApellidoMaterno">Apellido Materno: </label>
					</td>
					<td>
					    <input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" size="25" maxlength="50"
					 		type="text" tabindex="215" onBlur="ponerMayusculas(this);" />
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lblFechaNac">Fecha de Nacimiento: </label>
					</td>
					<td>
						<input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="14"
								type="text" tabindex="216" esCalendario="true"/>
					</td>
				</tr>
				<tr>
					<td class="label">
					 	<label for="lblPaisID">Pa&iacute;s de Nacimiento: </label>
					</td>
					<td>
						<input id="paisID" name="paisID" path="paisID" size="4"  maxlength="5"
							type="text" tabindex="217" />

						<input id="paisNac" name="paisNac" path="paisNac" size="30"  tabindex="218"
							readOnly="true" disabled="true" type="text"/>
						</td>
					<td class="separador"></td>
					<td class="label">
					 	<label for="lblentidadfederativa">Entidad Federativa: </label>
					</td>
					<td>
						<input id="estadoID" name="estadoID" path="estadoID" size="4"  maxlength="11"
							type="text" tabindex="219" />
						<input id="nombreEstado" name="nombreEstado"   size="30"  tabindex="220"
							readOnly="true" disabled="true" type ="text"/>
					</td>
				</tr>
				<tr>
					<td class="label">
							<label for="lblEstadoCivil">Estado Civil: </label>
					</td>
					<td>
						<select id="estadoCivil" name="estadoCivil" path="estadoCivil" tabindex="221">
							<option value="S">SOLTERO(A)</option>
						   	<option value="C">CASADO(A)</option>
						   	<option value="V">VIUDO(A)</option>
						   	<option value="D">DIVORCIADO(A)</option>
						   	<option value="Z">SEPARADO(A)</option>
						   	<option value="U">UNIÓN LIBRE</option>
						</select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="lblSexo">Sexo: </label>
					</td>
					<td>
					 	<select id="sexo" name="sexo" path="sexo" tabindex="222" readOnly="true">
							<option value="M">MASCULINO</option>
					   		<option value="F">FEMENINO</option>
						</select>
					</td>
				</tr>
				<tr>

				   <td class="label">
				         <label for="lblCURP">CURP: </label>
				   </td>
				   <td>
				        <input type="text" id="curp" name="curp" path="curp" size="25" tabindex="223" maxlength="18" onBlur="ponerMayusculas(this);"/>
				        <input type="button" id="generarc" name="generarc" value="Calcular" class="submit" style="display: none;"  />
				   </td>
				   <td class="separador"></td>
				   <td class="label">
				   	<label for="lblRFC">RFC: </label>
				   </td>
				   <td>
				    	<input type="text" id="rfc" name="rfc" path="rfc"  size="18" tabindex="224" maxlength="13" onBlur="ponerMayusculas(this);"/>
				    	<button type="button" class="submit" id="generar" style="display: none;" >Calcular</button>
				   </td>
				</tr>
				<tr>
				   <td class="label">
				         <label for="lblOcupacionID">Ocupaci&oacute;n: </label>
				   </td>
				   <td>
				        <input type="text" id="ocupacionID" name="ocupacionID" path="ocupacionID" size="4" tabindex="225" maxlength="5" />
				        <input type="text" id="ocupacionC" name="ocupacionC"  size="50" readOnly="true" disabled="true"/>
				   </td>
			      <td class="separador"></td>
				   <td class="label">
				   	<label for="lblPuesto">Puesto: </label>
				   </td>
				   <td>
				    	<input type="text" id="clavePuestoID" name="clavePuestoID" path="clavePuestoID" size="20" tabindex="226" onBlur="ponerMayusculas(this);" maxlength="50"/>
				   </td>
				</tr>
			</table>
		</fieldset>

		<fieldset id="identificacionFieldset" class="ui-widget ui-widget-content ui-corner-all">
			<legend>Identificaci&oacute;n</legend>
				<table border="0" cellpadding="0" cellspacing="0"  width="100%">
					<tr>
					   <td class="label" >
					    	<label for="lblTipoIdentiID" >Se Identifica con: </label>
					   </td>
					   <td>
					      <select id="tipoIdentiID" name="tipoIdentiID" path="tipoIdentiID" tabindex="230">
								<option value="-1">SELECCIONAR</option>
							</select>
					   </td>
					   <td class="separador"></td>

					   <td class="label">
					    	<label for="lblOtraIdentifi" id="lbIOtradentificacion"  style="display: none;">Otra Identificaci&oacute;n: </label>
					   </td>
					   <td>
					    	<input type="text"  id="otraIdentifi" name="otraIdentifi" path="otraIdentifi" size="25" maxlength="20"
					    			tabindex="231"  style="display: none;"/>
					   </td>
					</tr>
					<tr>
					 	<td class="label">
					   	<label for="lblNumIdentific">No. de Identificaci&oacute;n: </label>
					   </td>
					   <td>
					    	<input type="text" id="numIdentific" name="numIdentific" path="numIdentific" size="25" maxlength="20"
					    			tabindex="232" />
					   </td>
					   <td class="separador"></td>

					   <td class="label">
					     	<label for="lblFecExIden">Fecha Expedici&oacute;n Identificaci&oacute;n: </label>
					   </td>
					   <td>
					     	<input type="text" id="fecExIden" name="fecExIden" path="fecExIden" size="14"
					     			tabindex="233" esCalendario="true" />
					   </td>
					</tr>
					<tr>
					   <td class="label">
					    	<label for="lblFecVenIden">Fecha Vencimiento Identificaci&oacute;n:</label>
					   </td>
					   <td>
					    	<input type="text" id="fecVenIden" name="fecVenIden" path="fecVenIden" size="14" tabindex="234" esCalendario="true"/>
					   </td>
					    <td class="separador"></td>
					   <td class="label">
					    	<label for="lblTelefonoCasa">Tel&eacute;fono Casa: </label>
					   </td>
					   <td>
					  		<input type="text" id="telefonoCasa" name="telefonoCasa" path="telefonoCasa" size="11" maxlength="20"
					  				tabindex="235" onBlur="ponerMayusculas(this);"/>
					   </td>
					</tr>
					<tr>
					   <td class="label">
					   	<label for="lblTelefonoCelular">Tel&eacute;fono Celular: </label>
					   </td>
					   <td>
					     	<input type="text" id="telefonoCelular" name="telefonoCelular" path="telefonoCelular" size="14" maxlength="20"
					     		tabindex="236" onBlur="ponerMayusculas(this);"/>
					   </td>
					    <td class="separador"></td>
					   <td class="label">
					   	<label for="lblCorreo">Correo: </label>
					   </td>
					   <td>
					  		<input type = "text" id="correo" name="correo" path="correo" size="35" tabindex="237" maxlength="50"/>
					   </td>
					</tr>
					<tr >
					   <td class="label">
					     	<label for="lblDomicilio">Domicilio: </label>
					   </td>
					   <td colspan="4">
					    	<textarea type="textarea"  id="domicilio" name="domicilio" path="domicilio" maxlength="200" cols="60" tabindex="238" onBlur="ponerMayusculas(this);"></textarea>
					   </td>
					</tr>
				</table>
		</fieldset>


		<div id="beneficiarios">
			<fieldset id="relacionesFieldset" class="ui-widget ui-widget-content ui-corner-all">
				<legend>Relaci&oacute;n</legend>
					<table border="0" cellpadding="0" cellspacing="0"  width="100%">
						<tr>
						   <td class="label">
						  		<label for="lblParentescoID">Parentesco: </label>
						   </td>
						   <td>
						   	<input type="text" id="parentescoID" name="parentescoID" path="parentescoID" maxlength="11" size="7"
 						   			tabindex="250"  />
						   	<input id="parentesco" name="parentesco" size="50" type="text" readOnly="true"
 						   			 disabled="true" tabindex="251"/>
 						   </td>
 						</tr>
 						<tr>
 						 	<td class="label">
 						   	<label for="lblPorcentaje">Porcentaje: </label>
 						   </td>
						   <td>
 						    	<input type="text" id="porcentaje" name="porcentaje" path="porcentaje" maxlength="12" size="7"
 						    			tabindex="252" /> <label for="lblPorcentajeSigno">%</label>
 						   </td>
 						   <td class="separador"></td>
 						</tr>
 					</table>
			</fieldset>
		</div>
		<table border="0" cellpadding="0" cellspacing="0"  width="100%" id="tablaBotones">
			<tr>
				<td colspan="5">
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="guardarBen" name="guardarBen" class="submit" value="Agregar" tabindex="253"  />
								<input type="submit" id="modificarBen" name="modificarBen" class="submit"  value="Modificar" tabindex="254" />
								<input type="submit" id="eliminarBen" name="eliminarBen" class="submit"  value="Eliminar" tabindex="255" />
								<input type="hidden" id="tipoTransaccion1" name="tipoTransaccion1"/>
								<input type="hidden" id="numeroCaracteres" name="numeroCaracteres"/>
								<input type="hidden" id="inversionIDBen" name=	"inversionIDBen" />
								<input type="hidden" id="clienteIDBen" name=	"clienteIDBen" />
								<input type="hidden" id="beneficiarioBen" name = "beneficiarioBen" />
								<input type="hidden" id="botonImprimir" name = "botonImprimir" />
								<input type="hidden" id="socioCliente" name="socioCliente" value="<s:message code="safilocale.cliente"/>"  />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

		</form:form>

</fieldset>
<form:form id="formaGenerica3" name="formaGenerica3" >
	<div  id="divGridBeneficiarios" style="display: none;" ></div>
</form:form>
		</fieldset>
	</div>

<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
<div id="mensaje" style="display: none;"/>
</body>
</html>