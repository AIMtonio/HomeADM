<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
	<head>

		<script type="text/javascript" src="dwr/interface/tiposAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/montosAportacionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasBaseServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tipoCuentaSucursalServicioAport.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tasasAportacionesServicio.js"></script>
		<script type="text/javascript" src="js/aportaciones/tasasAportaciones.js"></script>
		<script type="text/javascript" src="js/aportaciones/tasasAportacionesSucursal.js"></script>

		<title>Tasas de Aportaciones</title>
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tasasBean" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all" >
					<legend class="ui-widget ui-widget-header ui-corner-all">Tasas de Aportaciones</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<label>Tipo de Aportaci&oacute;n: </label>
							</td>
							<td>
								<input type="text" id="tipoAportacionID" name="tipoAportacionID"  tabIndex="1" size="10" iniForma="false"/>
								<input type="text" id="descripcionTipo" name="descripcionTipo" readOnly="true" size="50" iniForma="false"/>

							</td>
						</tr>
						<tr>
							<td>
								<label>N&uacute;m. de Tasa:</label>
							</td>
							<td>
								<input type="text" id="tasaAportacionID" name="tasaAportacionID" tabIndex="2" size="10" iniForma="false"/>
							</td>

							<td class="separador">
							<td>
								<label>Plazos:</label>
							</td>
							<td>
								<form:select id="plazoID" name="plazoID" path="plazoID" tabIndex="3">
									<form:option value="-1">SELECCIONAR</form:option>
								</form:select>
							</td>
						</tr>
						<tr>
							<td>
								<label>Montos:</label>
							</td>
							<td>
								<form:select id="montoID" name="montoID" path="montoID" tabIndex="4">
								<form:option value="-1" >SELECCIONAR</form:option>
								</form:select>
							</td>
							<td class="separador">
		     			   	<td class="label" id="calificalbl2">
				 				<label id="lblCal" for="califica">Calificaci&oacute;n:</label>
				 		   	</td>
		     			  	 <td>
				 				<select id="calificacion"  name="calificacion" tabIndex="5">
				 					<option value="">SELECCIONAR</option>
									<option value="N">NO ASIGNADA</option>
									<option value="A">EXCELENTE</option>
									<option value="B">BUENA</option>
									<option value="C">REGULAR</option>
								</select>
				 			</td>
						</tr>
					</table>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Filtros</legend>
						<table>
							<tr>
								<td class="label">
							        <label for="tipoCuentaID">Sucursal:</label>
							    </td>
						    	<td>
						         	<input type="text" id="sucursalID" name="sucursalID" size="10" tabindex="20" />
						     	</td>
							    <td>
							        <input type="text" id="sucursalIDDes" name="sucursalIDDes"  size="50" readonly="true" />
							        <font size="2"><label>0 = Todas</label></font>
							    </td>
					     		<td class="separador"></td>
								<td>
							        <input type="checkbox" id="excSucursal" name="excSucursal" tabindex="21" />
							        <label for="excSucursal">Excepci&oacute;n</label>
							    </td>
					     		<td class="separador"></td>
					     		<td  align="center">
									<input type="button" id="agregaSucursal" class="btnAgrega" value="" tabindex="22"/>
								</td>
					    		<td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							</tr>
							<tr>
								<td class="label">
							        <label for="tipoCuentaID">Estado:</label>
							    </td>
							    <td>
					        		<input type="text" id="estadoID" name="estadoID" size="10" tabindex="32" />
					    		</td>
					    		<td>
					        		<input type="text" id="estadoIDDes" name="estadoIDDes"  size="50" readonly="true"/>
					        		<font size="2"><label>0 = Todos</label></font>
					     		</td>
							    <td class="separador"></td>
								<td>
						         	<input type="checkbox" id="excEstado" name="excEstado" tabindex="33" />
						         	<label for="excEstado">Excepci&oacute;n</label>
					     		</td>
							    <td class="separador"></td>
							    <td  align="center">
									<input type="button" id="agregaEstado" class="btnAgrega" value="" tabindex="34"/>
								</td>
								<td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							    <td class="separador"></td>
							</tr>
						</table>
						<br>
						<!-- Seccion de Grid Resultado -->
						<div id="divGridSucursales" style="width: 1000px; height: 380px; overflow-y: scroll; display: none; "></div>
					</fieldset>
					<table>
						<tr id ="lblTasaAnualizada">
							<td>
								<label>Tasa Anualizada:</label>
							</td>
							<td>
								<form:input id="tasaFija" name="tasaFija" path="tasaFija" size="5" autocomplete="off" tabIndex="35"/>
							<label id="lblPorci">%</label>
							</td>
				     	</tr>
				  	    <tr>
				 			<td class="label">
				 				<label id="lblTasaBase" for="lblTasaBase">Tasa Base:</label>
				 			</td>
				 			<td nowrap="nowrap">
				 				<form:input id="tasaBase" name="tasaBase" path="tasaBase" size="8" tabIndex="36" onkeyPress="return validador(event);"/>
				 				<input id="descripcionTasaBaseID" name="descripcionTasaBaseID" size="45" readonly="true">
				 			</td>
					 		<td class="separador">
					 		<td>
					 				<label id="lblCalculoInteres" for="lblCalculointeres">C&aacute;lculo de Inter&eacute;s</label>
					 		</td>
					 		<td nowrap="nowrap">
					 			<form:select id="calculoInteres" name="calculoInteres" path="calculoInteres"  tabIndex="37">
					 				<form:option value="1">SELECCIONA</form:option>
							    	<form:option value="2">TASA DE INICIO DE MES + PUNTOS</form:option>
							    	<form:option value="5">TASA DE INICIO DE MES + PUNTOS CON PISO Y TECHO</form:option>
									<form:option value="3">TASA APERTURA + PUNTOS</form:option>
									<form:option value="6">TASA APERTURA + PUNTOS CON PISO Y TECHO</form:option>
									<form:option value="4">TASA PROMEDIO DEL MES + PUNTOS</form:option>
									<form:option value="7">TASA PROMEDIO DEL MES + PUNTOS CON PISO Y TECHO</form:option>
								</form:select>
					 		</td>
					 	</tr>
					 	<tr>
					 		<td id="tdSobreTasa" class="label" >
					 			<label id="lblSobreTasa" for="sobreTasa">Sobre Tasa:</label>
					 		</td>
					 		<td>
					 			<form:input id="sobreTasa" name="sobreTasa" path="sobreTasa" size="8" tabIndex="38" onkeyPress="return validadorConPunto(event);"/>
					 		</td>
					 		<td class="separador">
				 			<td class="label">
				 				<label id="lblPisoTasa" for="pisoTasa">Piso Tasa:</label>
				 			</td>
				 			<td>
				 				<form:input id="pisoTasa" name="pisoTasa" path="pisoTasa" size="8" tabIndex="39" onkeyPress="return validadorConPunto(event);"/>
				 			</td>
					 	</tr>
				 		<tr id="lblTechoTasa">
				 			<td class="label">
				 				<label for="techoTasa">Techo Tasa:</label>
				 			</td>
				 			<td>
				 				<form:input id="techoTasa" name="techoTasa" path="techoTasa" size="8" tabIndex="40" onkeyPress="return validadorConPunto(event);"/>
				 			</td>
				 		</tr>
					</table>
			 		<div id="tasasAportacionesGrid" name="tasasAportacionesGrid" style="display: none;">
					</div>
					<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabIndex="50" />
								<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabIndex="51"/>
								<input type="submit" id="eliminar" name="eliminar" class="submit"  value="Eliminar" tabIndex="52"/>
								<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
								<input type="hidden" id="tasaFV" name="tasaFV"/>
								<input type="hidden" id="montoInferior" name="montoInferior"/>
								<input type="hidden" id="montoSuperior" name="montoSuperior"/>
								<input type="hidden" id="plazoInferior" name="plazoInferior"/>
								<input type="hidden" id="plazoSuperior" name="plazoSuperior"/>

							</td>
						</tr>
					</table>
				</fieldset>
			</form:form>
		</div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/>
		</div>
		<div id="mensaje" style="display: none;"/>
	</body>
</html>