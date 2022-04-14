<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/tipoClavePresupServicio.js"></script>
		<script type="text/javascript" src="js/nomina/tipoClavePresup.js"></script>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="nomTipoClavePresupBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend class="ui-widget ui-widget-header ui-corner-all">Tipo de Clave Presupuestal</legend>
						<table border="0" >
							<tr>
								<td class="label" nowrap="nowrap">
									<label for="lbnomTipoClavePresupID">N&uacute;mero:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="nomTipoClavePresupID" name="nomTipoClavePresupID" size="20"  tabindex="1" autocomplete="off" />
								</td>

								<td class="label" nowrap="nowrap">
									<label for="descripcionEsquema">Descripci&oacute;n:</label>
								</td>
								<td nowrap="nowrap">
									<input type="text" id="descripcion" name="descripcion" size="60" maxlength="70" tabindex="2" autocomplete="off" onBlur="ponerMayusculas(this)"/>
								</td>
							</tr>

							<tr >
								<td class="label" nowrap="nowrap">
									<label  for="lbReqClave"> Requiere Clave: </label>
								</td>
								<td class="label" nowrap="nowrap">
									<input type="radio" id="reqClaveSI" name="reqClave" tabindex="3" value="S" />
									<label for="reqClaveSI">Si</label>
	
									<input type="radio" id="reqClaveNO" name="reqClave" tabindex="4" value="N" />
									 <label for="reqClaveNO">No</label>
								</td>
							</tr>
						</table>

						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
							<tr>
								<td align="right">
									<input type="submit" id="graba" name="graba" class="submit" value="Grabar"  tabindex="5"/>
									<input type="submit" id="modifica" name="modifica" class="submit" value="Modificar"  tabindex="6"/>
									<input type="submit" id="elimina" name="elimina" class="submit" value="Eliminar"  tabindex="7"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
								</td>
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
