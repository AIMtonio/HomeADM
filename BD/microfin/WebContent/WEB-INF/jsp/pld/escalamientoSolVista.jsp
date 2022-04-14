<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
<script type="text/javascript" src="dwr/interface/escalaSolServicio.js"></script>
<script type="text/javascript" src="dwr/interface/rolesServicio.js"></script>
<script type="text/javascript" src="js/pld/escalamientoSol.js"></script>

</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST"
			commandName="escalaSol">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Escalamiento
					de Solicitudes</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">

					<tr>
						<td class="label"><label for="leyend">Se requiere
								Escalamiento cuando:</label> <br> <br></td>
					</tr>

					<tr>
						<td class="label"><label for="lbFolio">Folio:</label></td>
						<td><input id="folioID" name="folioID" size="4" tabindex="1" />
						</td>
					</tr>
					
					<tr>
						<td class="label"><label for="1"></label> <br></td>
					</tr>
					
					<tr>
						<td class="label"><label for="fechaVigencia">Fecha
								Inicio Vigencia: </label></td>
						<td><input id="fechaVigencia" name="fechaVigencia"
							tabindex="2" disabled="disabled" type="text" value="" size="12">
						</td>
					</tr>
					
					<tr>
						<td class="label"><label for="1"></label> <br></td>
					</tr>

					<tr>
						<td class="label"><label for="nivelRiesgoID">Nivel de
								Riesgo:</label></td>
						<td><form:select id="nivelRiesgoID" name="nivelRiesgoID"
								path="nivelRiesgoID" tabindex="3">
								<form:option value="0">SELECCIONAR</form:option>
								<form:option value="1">ALTO</form:option>
								<form:option value="2">BAJO</form:option>
							</form:select></td>
					</tr>
					<tr>
						<td class="label"><label for="1"></label> <br></td>
					</tr>


					<tr>
						<td class="label"><label for="peps">PEP's: </label></td>

						<td class="label"><form:radiobutton id="peps" name="peps"
								path="peps" value="S" tabindex="4" checked="checked" /> <label
							for="si">Si</label>&nbsp&nbsp; <form:radiobutton id="peps2"
								name="peps2" path="peps" value="N" tabindex="5" /> <label
							for="no">No</label></td>
					</tr>
					<tr>
						<td class="label"><label for="2"></label> <br></td>
					</tr>

					<tr>
						<td class="label"><label for="actuaCuenTer">Actua por
								Cuenta <br> de Tercero sin Declarar
						</label></td>

						<td class="label"><form:radiobutton id="actuaCuenTer"
								name="actuaCuenTer" path="actuaCuenTer" value="S" tabindex="6"
								checked="checked" /> <label for="si">Si</label>&nbsp&nbsp; <form:radiobutton
								id="actuaCuenTer2" name="actuaCuenTer2" path="actuaCuenTer"
								value="N" tabindex="7" /> <label for="no">No</label></td>
					</tr>
					<tr>
						<td class="label"><label for="3"></label> <br></td>
					</tr>

					<tr>
						<td class="label"><label for="dudasAutDoc">Dudas de
								Autenticidad de<br> Documentos o Documentos <br> base
								del perfil transaccional
						</label></td>

						<td class="label"><form:radiobutton id="dudasAutDoc"
								name="dudasAutDoc" path="dudasAutDoc" value="S" tabindex="8"
								checked="checked" /> <label for="si">Si</label>&nbsp&nbsp; <form:radiobutton
								id="dudasAutDoc2" name="dudasAutDoc2" path="dudasAutDoc"
								value="N" tabindex="9" /> <label for="no">No</label></td>
					</tr>
					<tr>
						<td class="label"><label for="4"></label> <br></td>
					</tr>
					<tr>
						<td class="label"><label for="rolTitular">Puesto
								Titular:</label></td>
						<td><form:input id="rolTitular" name="rolTitular"
								path="rolTitular" size="4" tabindex="10" /> <input type="text"
							id="descripcion" name="descripcion" size="35" tabindex="11"
							disabled="true" /></td>

					</tr>
					<tr>
						<td class="label"><label for="5"></label> <br></td>
					</tr>

					<tr>
						<td class="label"><label for="rolSuplente">Puesto
								Suplente:</label></td>
						<td><form:input id="rolSuplente" name="rolSuplente"
								path="rolSuplente" size="4" tabindex="12" /> <input type="text"
							id="descripcionSuplente" name="descripcion" size="35"
							tabindex="13" disabled="true" /></td>
					</tr>
					
					<tr>
						<td class="label"><label for="1"></label> <br></td>
					</tr>
					
					<tr>										
										<td class="label">
											<label for="estatus">Estatus:</label>
										</td>
										<td>
						         			<select id="estatus" name="estatus" tabindex="14" disabled="true">
						         				<option value="">SELECCIONAR</option>
												<option value="V">VIGENTE</option>
												<option value="B">BAJA</option>		
											<select>  
			    			 			</td> 
					</tr>
				</table>
			</fieldset>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right"><input type="submit" id="grabar"
									name="grabar" class="submit" value="Grabar" tabindex="15" /> 
									<input type="submit" id="modifica" name="modifica" class="submit"
									value="Modificar" tabindex="16" /> 
									<input type="submit" id="baja" name="baja" class="submit"
									value="Baja" tabindex="17" /> 
									<input type="hidden" id="historico" name="historico" class="submit"
									value="Hist&oacute;rico" tabindex="18" />
									<input type="hidden"
									id="tipoTransaccion" name="tipoTransaccion" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form:form>
	</div>


	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
