<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/estimacionPreventivaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/regulatorioInsServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramRegulatoriosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
		<script type="text/javascript" src="js/regulatorios/paramRegulatorios.js"></script>
		<script type="text/javascript" src="js/soporte/mascara.js"></script>
		<script type="text/javascript" src="js/general.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="paramRegulatoriosBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Parámetros Regulatorios</legend>
					<div id="tblRegulatorio">
						<table border="0" width="100%">
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Generales</label></legend>
										<table border="0" width="100%">
											<tr>
												<td class="label" >
													<label for="tipoRegulatorios">Formatos de Regulatorios: </label>
												</td>
												<td>
													<select id="tipoRegulatorios" name="tipoRegulatorios" tabindex="1">
														<option value="">SELECCIONAR</option>
													</select>
												</td>
												<td class="separador"></td>
												<td class="label" >
													<label for="claveEntidad">Clave CASFIM: </label>
												</td>
												<td>
													<form:input type="text" id="claveEntidad" name="claveEntidad" path="claveEntidad" size="15" maxlength="6" tabindex="2"/>
												</td>
											</tr>
											<tr>
												<td class="label" >
													<label for="nivelOperaciones">Nivel de Operaciones: </label>
												</td>
												<td>
													<select id="nivelOperaciones" name="nivelOperaciones" tabindex="3">
														<option value="">SELECCIONAR</option>
													</select>
												</td>
												<td class="separador"></td>
												<td class="label" >
													<label for="nivelPrudencial">Regulación Prudencial: </label>
												</td>
												<td>
													<select id="nivelPrudencial" name="nivelPrudencial" tabindex="4">
														<option value="">SELECCIONAR</option>
													</select>
												</td>
											</tr>
											<tr>
												<td class="label par_sofipo" >
													<label for="claveFederacion">Clave Federación: </label>
												</td>
												<td class="par_sofipo">
													 <form:input type="text" id="claveFederacion" name="claveFederacion" path="claveFederacion" size="10" maxlength="10" tabindex="5"/>
												</td>
												<td class="separador par_sofipo"></td>
											</tr>
										</table>
									</fieldset>
									<br/>
								</td>
							</tr>
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Serie R01 - Catálogo Mínimo</label></legend>
										<table border="0" >
											<tr>
												<td class="label" >
													<label for="ajuste">Redondear a Cero Decimales: </label>
												</td>
												<td>
													<select id="ajusteSaldo" name="ajusteSaldo" tabindex="6">
														<option value="">SELECCIONAR</option>
														<option value="S">SI</option>
														<option value="N">NO</option>
													</select>
												</td>
												<td class="separador"></td>
												<td class="label" >
													<label for="cuentaConta" id="cuentaConta">Cuenta Contable de Ajuste: </label>
												</td>
												<td>
													<form:input type="text" id="cuentaContableAjusteSaldo" name="cuentaContableAjusteSaldo" path="cuentaContableAjusteSaldo" size="15" tabindex="7" maxlength="16"/>
													<input type="text" id="descripcionCta" name="descripcionCta" size="30" readOnly="true"/>
												</td>
											</tr>
										</table>
									</fieldset>
									<br/>
								</td>
							</tr>
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Serie R04 - Cartera de Crédito</label></legend>
										<table border="0" >
											<tr>
												<td class="label" >
													<label for="cuentaEPRC">Cuenta EPRC: </label>
												</td>
												<td>
													<form:input type="text" id="cuentaEPRC" name="cuentaEPRC" path="cuentaEPRC" size="15" tabindex="8" maxlength="10"/>
												</td>
												<td class="separador"></td>
												<td class="label" >
													<label for="intCreditos">Suma Int. de Cred. Vencidos: </label>
												</td>
												<td>
													<select id="sumaIntCredVencidos" name="sumaIntCredVencidos" tabindex="9">
														<option value="">SELECCIONAR</option>
														<option value="S">SI</option>
														<option value="N">NO</option>
													</select>
												</td>
											</tr>
											<tr>
												<td class="label" >
													<label for="tipoRepActEco">(C0451) Actividad Destino de Recursos: </label>
												</td>
												<td>
													<select id="tipoRepActEco" name="tipoRepActEco" tabindex="10">
														<option value="">SELECCIONAR</option>
														<option value="C">ACTIVIDAD DEL CLIENTE</option>
														<option value="D">ACTIVIDAD POR DESTINO DE CREDITO</option>
													</select>
												</td>
												<td class="separador"></td>
											</tr>
										</table>
									</fieldset>
									<br/>
								</td>
							</tr>
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Serie R08 - Captación</label></legend>
										<table border="0" >
											<tr>
												<td class="label" >
													<label for="lblmostrarSucursalOrigen">Mostrar Sucursal Origen Cliente: </label>
												</td>
												<td>
													<select id="mostrarSucursalOrigen" name="mostrarSucursalOrigen" tabindex="11">
														<option value="">SELECCIONAR</option>
														<option value="S">SI</option>
														<option value="N">NO</option>
													</select>
												</td>
												<td class="separador"></td>
												<td class="label" >
													<label for="lblAjusteCargoAbono">Ajustar Movimientos de Cargos y Abonos: </label>
												</td>
												<td>
													<select id="ajusteCargoAbono" name="ajusteCargoAbono" tabindex="12">
														<option value="">SELECCIONAR</option>
														<option value="S">SI</option>
														<option value="N">NO</option>
													</select>
												</td>
											</tr>
											<tr>
												<td class="label" >
													<label for="lblajusteRFCMenor">Ajustar RFC <s:message code="safilocale.cliente"/> Menor: </label>
												</td>
												<td>
													<select id="ajusteRFCMenor" name="ajusteRFCMenor" tabindex="13">
														<option value="">SELECCIONAR</option>
														<option value="S">SI</option>
														<option value="N">NO</option>
													</select>
												</td>
											</tr>
										</table>
									</fieldset>
									<br/>
								</td>
							</tr>
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Serie R21 - Requerimientos de Capital</label></legend>
										<table border="0" >
											<tr>
												<td class="label" >
													<label for="ajusteResPreventiva">Ajuste Reserva Preventiva: </label>
												</td>
												<td>
													<form:select name="ajusteResPreventiva" id="ajusteResPreventiva" path="ajusteResPreventiva" tabindex="14">
														<form:option value="">SELECCIONAR</form:option>
														<form:option value="S">SI</form:option>
														<form:option value="N">NO</form:option>
													</form:select>
												</td>
											</tr>
										</table>
									</fieldset>
									<br/>
								</td>
							</tr>
							<tr>
								<td>
									<fieldset class="ui-widget ui-widget-content ui-corner-all">
										<legend><label>Serie R24 - Información Operativa</label></legend>
										<table border="0" >
											<tr>
												<td class="label" >
													<label for="muestraRegistros">(D-2441 Y D-2442) Generar: </label>
												</td>
												<td>
													<select name="muestraRegistros" id="muestraRegistros" tabindex="15">
														<option value="">SELECCIONAR</option>
														<option value="T">TODOS LOS REGISTROS</option>
														<option value="S">SOLO REGISTROS CON DATOS</option>
													</select>
												</td>
												<td class="separador"></td>
												<td>
													<label for="mostrarComoOtros">Cambiar Canal Sucursal por Otros</label>
												</td>
												<td>
													<select name="mostrarComoOtros" id="mostrarComoOtros" tabindex="16">
														<option value="">SELECCIONAR</option>
														<option value="S">SI</option>
														<option value="N">NO</option>
													</select>
												</td>
											</tr>
											<tr>
												<td>
													<label for="contarEmpleados">Contar Empleados:</label>
												</td>
												<td>
													<select name="contarEmpleados" id="contarEmpleados" tabindex="17">
														<option value="">SELECCIONAR</option>
														<option value="S">SISTEMA</option>
														<option value="M">MANUAL</option>
													</select>
												</td>
											</tr>
										</table>
									</fieldset>
									<br/>
								</td>
							</tr>
							<tr>
								<table border="0"  width="100%">
									<tr>
										<td colspan="2">
											<table align="right" border='0' width="100%">
												<tr>
													<td align="right">
														<input type="submit" id="modificar" name="modificar" class="submit" tabindex="18" value="Modificar" />
														<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" tabindex="19" />
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</tr>
						</table>
					</div>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;">
		</div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>