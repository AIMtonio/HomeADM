<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all"  rel="stylesheet" type="text/css">
		<link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
		<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>
		<script type="text/javascript" src="js/jquery.lightbox-0.5.pack.js"></script>
		<script type="text/javascript" src="dwr/interface/regulatorioA1713Servicio.js"></script>
		<script type="text/javascript" src="js/regulatorios/regulatorioA1713Sofipo.js"></script>
		<script>
			$(function() {
				$("#tabs" ).tabs();
			});
   		</script>
	</head>
<body>
<div id="contenedorForma" style="
    width: 100%;
">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="regulatorioA1713">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend><label style="
						    width: 150px;
						    font-size: .80em;
						    color: #999999;
						">Periodo:</label></legend>
		 	<table border="0" cellpadding="0" cellspacing="0" width="">
				<tr>
					<td  class="label">
						<label for="lblFecha">Fecha: </label>
					</td>
					<td >
						<input  id="fecha" name="fecha" path="fecha" size="12"
		         			tabindex="1" type="text"  esCalendario="true" />

					</td>

				</tr>

			</table>
		</fieldset>
		<br>


		<div id="tabs">
			<ul>
				<li ><a id="reporteD0842" href="#_reporte">Reporte</a></li>
				<li ><a id="registroD0842" href="#_registro">Registro </a></li>
			</ul>
					<div id="_reporte">
						<table id="reporte" width="100%">
							<tr>
							<td>
						 		<table width="100%" >
											<tr>
											<td class="label" >
											<fieldset class="ui-widget ui-widget-content ui-corner-all">
												<legend><label>Presentaci&oacute;n</label></legend>
												<table>
													<tbody>

														<tr>
														<td><input type="radio" id="excel" name="presentacion" selected="true" tabindex="2" ></td><td>
																<label> Excel </label>	</td>

														</tr>
														<tr>
															<td><input type="radio" id="csv" name="presentacion" tabindex="3" ></td><td>
																<label> Csv </label>	</td>


														</tr>
													</tbody>
												</table>
											</fieldset>
											</td>
										</tr>
								</table>
							<br>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td >
											<table align="right" border='0'>
												<tr>
													<td align="right"">
															<input type="button" id="generar" name="generar" class="submit"
																 tabindex="4" value="Generar" />
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
							</tr>
						</table>
					</div>


		<div id="_registro">
			<table id="capturaInfo" width="100%">
					<tr>
						<td>
							<table >
								<tr>
									<td class="label">
										<label for="registroID"><span style="color: #fff">__</span>Número de Registro:</label>
									</td>
									<td>
										<input type="text" name="registroID" id="registroID" size="10" maxlength="100" tabindex="5">
									</td>
									<td class="separador"></td>
									<td class="label">
											<label for="tipoMovimientoID">Tipo de Movimiento:</label>
										</td>
										<td>
											<select name="tipoMovimientoID" id="tipoMovimientoID" tabindex="6">
												<option value="">SELECCIONAR</option>
											</select>
									</td>
								</tr>
							</table>
						</td>

					</tr>
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend ><label>Información del Funcionario</label></legend>
								<table width="100%">
									<tr>

										<td class="label">
											<label for="lblNumeroIden">Nombre:</label>
										</td>
										<td >
											<input type="text" onBlur=" ponerMayusculas(this)" name="nombreFuncionario" id="nombreFuncionario" size="60" maxlength="250" tabindex="7">
										</td>

										 <td class="separador"></td>

										 <td class="label">
											<label for="lblTipoPrestamista">RFC:</label>
										</td>
										<td>
											<input type="text" onBlur=" ponerMayusculas(this)" name="rfcFuncionario" id="rfcFuncionario" size="24" maxlength="13" tabindex="8">
										</td>

									</tr>
									<tr>
										<td class="label">
											<label for="lblPaisExtranjero">CURP:</label>
										</td>
										<td>
											<input type="text" onBlur=" ponerMayusculas(this)" name="curpFuncionario" id="curpFuncionario" size="24" maxlength="18" tabindex="9">
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="tituloPofID">Título o Profesión:</label>
										</td>
										<td>
											<select name="tituloPofID" id="tituloPofID" class="" tabindex="10">
												<option value="">SELECCIONAR</option>
											</select>

										</td>

									</tr>

									<tr>

										<td class="label">
											<label for="telefono">Teléfono:</label>
										</td>
										<td>
											<input type="text" name="telefono" id="telefono" size="24" maxlength="60" tabindex="11">
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="correoElectronico"> Correo Electrónico:</label>
										</td>
										<td>
											<input type="text" name="correoElectronico" id="correoElectronico" size="45" maxlength="30" tabindex="12">
										</td>

									</tr>

								</table>
							</fieldset>
						</td>
						</tr>
						<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend ><label>Dirección del Funcionario</label></legend>
								<table width="100%">

									<tr>
										<td class="label">
											<label for="paisID"> Pais:</label>
										</td>
										<td>
											<input type="text" name="paisID" id="paisID" size="10" tabindex="13" readonly="" disabled="">
											<input type="text" name="nombrePais" id="nombrePais" size="45" readonly="" disabled="" tabindex="14">
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="estadoID">Estado:</label>
										</td>
										<td>
											<input type="text" class="paisID " name="estadoID" id="estadoID" size="12" tabindex="15">
											<input type="text" class="paisID " name="nombreEstado" id="nombreEstado" size="45"  readonly="" disabled="" tabindex="16">
										</td>


									</tr>

									<tr>

										<td class="label">
											<label for="municipioID"> Municipio:</label>
										</td>
										<td>
											<input type="text" class="paisID estadoID " name="municipioID" id="municipioID" size="10" tabindex="17">
											<input type="text" class="paisID estadoID " name="nombreMunicipio" id="nombreMunicipio" size="45"  readonly="" disabled="" tabindex="18">
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="localidadID">Localidad:</label>
										</td>
										<td>
											<input type="text" class="paisID estadoID municipioID " name="localidadID" id="localidadID" size="12" tabindex="19">
											<input type="text" class="paisID estadoID municipioID " name="nombreLocalidad" id="nombreLocalidad" size="45"  readonly="" disabled="" tabindex="20">
										</td>


									</tr>

									<tr>
										<td class="label">
											<label for="coloniaID">Colonia:</label>
										</td>
										<td>
											<input type="text" class="paisID estadoID municipioID " name="coloniaID" id="coloniaID" size="10" tabindex="21">
											<input type="text" class="paisID estadoID municipioID " name="nombreColonia" id="nombreColonia" size="45"  readonly="" disabled="" tabindex="22">
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="codigoPostal"> Código Postal:</label>
										</td>
										<td>
											<input type="text" class="paisID estadoID municipioID "  name="codigoPostal" id="codigoPostal" size="10" tabindex="23" readonly="" disabled="">
										</td>

									</tr>

									<tr>

										<td class="label">
											<label for="calle">Calle:</label>
										</td>
										<td>
											<input type="text" onBlur=" ponerMayusculas(this)" name="calle" id="calle" size="56" tabindex="24">
										</td>
										<td class="separador"></td>

										<td class="label">
											<label for="numeroExt">Número Ext:</label>
										</td>

										<td>
											<input type="text" onBlur=" ponerMayusculas(this)" name="numeroExt" id="numeroExt" size="10" tabindex="25">
										</td>



									</tr>

									<tr>
										<td class="label">
											<label for="numeroInt">Número Int:</label>
										</td>
										<td>
											<input type="text" onBlur=" ponerMayusculas(this)" name="numeroInt" id="numeroInt" size="10" tabindex="26">
										</td>

									</tr>






								</table>
							</fieldset>
						</td>
						</tr>
						<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
								<legend ><label>Información de la Gestión</label></legend>
								<table width="100%">



									<tr>
										<td class="label">
											<label for="fechaMovimiento">Fecha Movimiento:</label>
										</td>
										<td>
											<input type="text" name="fechaMovimiento" id="fechaMovimiento" size="16" maxlength="10" esCalendario="true" tabindex="27">
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="inicioGestion"> Inicio de Gestión:</label>
										</td>
										<td>
											<input type="text" name="inicioGestion" id="inicioGestion" size="16" maxlength="10" esCalendario="true" tabindex="28">
										</td>

									</tr>


									<tr>
										<td class="label">
											<label for="conclusionGestion">Conclusión de Gestion:</label>
										</td>
										<td>
											<input type="text" name="conclusionGestion" id="conclusionGestion" size="16" maxlength="10" esCalendario="true" tabindex="29">
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="organoID"> Organo al que Pertenece:</label>
										</td>
										<td>
											<select name="organoID" id="organoID" tabindex="30">
												<option value="">SELECCIONAR</option>
											</select>
										</td>

									</tr>


									<tr>
										<td class="label">
											<label for="cargoID">Cargo:</label>
										</td>
										<td>
											<select name="cargoID" id="cargoID" tabindex="31">
												<option value="">SELECCIONAR</option>
											</select>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="permanenteSupID"> Permanente o Suplente:</label>
										</td>
										<td>
											<select name="permanenteSupID" id="permanenteSupID" tabindex="32">
												<option value="">SELECCIONAR</option>
											</select>
										</td>

									</tr>


									<tr>
										<td class="label">
											<label for="causaBajaID">Motivo Baja:</label>
										</td>
										<td>
											<select name="causaBajaID" id="causaBajaID" tabindex="33">
												<option value="">SELECCIONAR</option>
											</select>
										</td>
										<td class="separador"></td>
										<td class="label">
											<label for="manifestacionID"> Manifestación del Cumplimiento:</label>
										</td>
										<td>
											<select name="manifestacionID" id="manifestacionID" tabindex="34" readonly="" >
												<option value="">SELECCIONAR</option>
											</select>
										</td>

									</tr>

								</table>
							</fieldset>
							<br>
							<table width="100%">
									<tr>
										<td align="right">
											<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar"  tabindex="99"/>
											<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="100"/>
											<button id="elimina" name="elimina" class="submit"  tabindex="101" style="font-size: 1.1em;"> Eliminar</button>
											<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
											<input type="hidden" id="tipoInstitID" name="tipoInstitID"/>

										</td>
									</tr>
							</table>
					</td>
				</tr>
			</table>
	</fieldset>
</div>



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
