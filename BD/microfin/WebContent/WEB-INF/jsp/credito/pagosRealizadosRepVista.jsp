<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conveniosNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>

        
		<script type="text/javascript" src="js/credito/repPagosRealizados.js"></script>

	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Pagos de Crédito</legend>

			<table border="0" cellpadding="0" cellspacing="0" width="960px">
			<tr> <td>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Par&aacute;metros</label></legend>
          <table  border="0"  width="560px">
				<tr>
					<td class="label">
						<label for="creditoID">Fecha Inicio: </label>
					</td>
					<td >
						<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12"
		         			type="text"  esCalendario="true" />
					</td>
					<td class="separador"></td>
				</tr>
				<tr>
					<td class="label">
						<label for="creditoID">Fecha Fin: </label>
					</td>
					<td >
						<input id="fechaVencimien" name="fechaVencimien" path="fechaVencimien" size="12"
		         			type="text"  esCalendario="true" />
					</td>
					<td class="separador"></td>
				</tr>
				<tr>
					<td>
						<label>Sucursal:</label>
					</td>
					<td><select id="sucursal" name="sucursal" path="sucursal" >
				         <option value="0">TODAS</option>
					      </select>
					</td>
				</tr>
				<tr>
					<td>
						<label>Moneda:</label>
					</td>
					<td><select name="monedaID" id="monedaID" path="monedaID" >
						<option value="0">TODAS</option>
							</select>

					</td>
				</tr>
				<tr>
					<td>
						<label>Producto de cr&eacute;dito:</label>
					</td>
					<td><select id="producCreditoID" name="producCreditoID" path="producCreditoID"  >
				         <option value="0">TODOS</option>
					      </select>
					</td>


				</tr>
				<tr class="datosNominaE">
					<td id="lblnomina" class="label" nowrap="nowrap">
						<label for="lblCalif">Empresa N&oacute;mina: </label>
					</td>
					<td id="institNominaID" nowrap="nowrap">
						<input type="text" id="institucionNominaID" name="institucionNominaID"  size="11" />
						<input type="text" id="nombreInstit" name="nombreInstit"  disabled="disabled" size="39" />
					</td>
		 		</tr>
		 		<tr class="datosNominaC">
		 			<td id="lblnomina" class="label" nowrap="nowrap">
						<label for="lblCalif">Convenio: </label>
					</td>
					<td>
						<input type="text" id="convenioNominaID" name="convenioNominaID" size="11"/>
						<input type="text" id="desConvenio" name="desConvenio"   disabled="disabled" size="39" />
					</td>
		 		</tr>

				<tr>
					<td>
						<label>Modalidad de pago:</label>
					</td>
					<td><select id="modalidadPagoID" name="modalidadPagoID" path="modalidadPagoID"  >
				         <option value="0">TODAS</option>
				         <option value="E">EFECTIVO</option>
						 <option value="C">CARGO A CUENTA</option>
						 <option value="S">SPEI</option>
					      </select>
					</td>

				</tr>

				<tr>
				<td class="label">
					<label for="promotorInicial">Promotor:</label>
				</td>
				<td >
					<form:input id="promotorID" name="promotorID" path="promotorID"
					size="6" tabindex="5"/>
					<input type="text"id="nombrePromotorI" name="nombrePromotorI" size="39"
					 disabled= "true" readOnly="true" />

				</td>

				</tr>
				<tr>
			<td class="label">
				<label for="sexo"> G&eacute;nero:</label>
			</td>
			<td>
				<form:select id="sexo" name="sexo" path="sexo" >
				<form:option value="0">TODOS</form:option>
				<form:option value="M">MASCULINO</form:option>
		     	<form:option value="F">FEMENINO</form:option>
				</form:select>
			</td>

		</tr>
		<tr>
		<td class="label">
         <label for="estado">Estado: </label>
     </td>
     <td>
         <form:input id="estadoID" name="estadoID" path="estadoID" size="6" />
         <input type="text" id="nombreEstado" name="nombreEstado" size="39"   disabled ="true"
           readOnly="true"/>
     </td>
 	</tr>

	<tr>
     <td class="label">
         <label for="municipio">Municipio: </label>
     </td>
     <td>
         <form:input id="municipioID" name="municipioID" path="municipioID" size="6" />
         <input type="text" id="nombreMuni" name="nombreMuni" size="39"  disabled="true"
          readOnly="true"/>
     </td>
     </tr>
  </table> </fieldset>  </td>

<td> <table width="200px"> <tr>

					<td class="label" style="position:absolute;top:8%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Presentaci&oacute;n</label></legend>
											<input type="radio" id="pdf" name="generaRpt" value="pdf" />
							<label> PDF </label>
				            <br>
							<input type="radio" id="excel" name="generaRpt" value="excel">
						<label> Excel </label>

						</fieldset>
					</td>
					</tr>


					<tr>

					<td class="label" id="tdPresenacion" style="position:absolute;top:40%;">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend><label>Nivel de Detalle</label></legend>
							<input type="radio" id="detallado" name="presentacion" value="detallado" />
							<label> Detallado </label>
				            <br>
							<input type="radio" id="sumarizado" name="presentacion" value="sumarizado">
						<label> Sumarizado</label>

						</fieldset>
					</td>

					</tr>

	</table> </td>

    </tr>

	</table>
				<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
				<input type="hidden" id="tipoLista" name="tipoLista" />
				<input type="hidden" id="manejaConvenio" name="manejaConvenio" />
				<input type="hidden" id="esproducNomina" name="esproducNomina" />
				<table border="0" cellpadding="0" cellspacing="0" width="100%">

					<tr>
						<td colspan="4">
							<table align="right" border='0'>
								<tr>
									<td align="right">

									<a id="ligaGenerar" href="PagosRealizadosReporte.htm" target="_blank" >
										 <input type="button" id="generar" name="generar" class="submit"
												  value="Generar" />
									</a>

									</td>
								</tr>

							</table>
						</td>
					</tr>
				</table>

</fieldset>
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