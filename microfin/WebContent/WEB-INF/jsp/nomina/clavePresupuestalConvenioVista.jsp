<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clavePresupServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clavePresupConvenioServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="js/nomina/clavePresupConvenio.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="nomClavesConvenioBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Asignaci&oacute;n de Claves por Convenios</legend>
						<table border="0" >
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbInstitNominaID"> Empresa N&oacute;mina :</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="institNominaID" name="institNominaID" size="20"  tabindex="1" autocomplete="off" />
									<input type="text" id="descripcion" name="descripcion" size="50" tabindex="2" autocomplete="off" onBlur="ponerMayusculas(this)" disabled="true"  readonly="true"/>
								</td>
							</tr>

							<tr >
								<td class="label" nowrap="nowrap">
									<label  for="lbConvenioID"> No. Convenio : </label>
								</td>
								<td>
									<select  id="convenioID" name="convenioID" tabindex="3" >
									</select>
								</td>
							</tr>
							
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbBuscar"> Buscar:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="buscar" name="descBuscar" size="50" tabindex="4" autocomplete="off"/>
								</td>
							</tr>
							
							<tr >
								<td class="label" colspan="3">
									<div id="gridClavePresup" style="display: none;" ></div>
								</td>
							</tr>
						</table>

						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
							<tr>
								<td align="right">
									<input type="submit" id="graba" name="graba" class="submit" value="Grabar"  tabindex="8"/>
									<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar"  tabindex="9"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
									<input type="hidden" id="clavesPresupuestales" name="clavesPresupuestales" value=""/>
									<input type="hidden" id="nomClaveConvenioID" name="nomClaveConvenioID" value="0"/>
								</td>
							</tr>
						</table>

						<br>
						<br>

						<table border="0" >
							<tr >
								<div id="gridClavePresupConv" style="display: none;" ></div>
							</tr>
						</table>

					</fieldset>
				</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
		<div id="mensaje" style="display: none;"> </div>
		<div id="ContenedorAyuda" style="display: none;">
			<div id="elementoLista"/>
		</div>
	</body>
</html>
