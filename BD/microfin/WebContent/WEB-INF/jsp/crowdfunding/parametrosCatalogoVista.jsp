<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosCRWServicio.js"></script>
		<script type="text/javascript" src="js/crowdfunding/parametros.js"></script>
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="parametrosCRWBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Par&aacute;metros de Fondeo</legend>

			<table border="0" width="100%">
				<tr>
					<td class="label">
						<label for="lblFormulaRetencion">Habilita Fondeo: </label>
					</td>
					<td colspan="5">
						<input type="radio" id="habilitaFondeoSi" name="habilitaFondeo" tabindex="1" value="S" /> <label for="habilitaFondeoSi">Si</label>
						<input type="radio" id="habilitaFondeoNo" name="habilitaFondeo" tabindex="1" value="N" checked="checked"/> <label for="habilitaFondeoNo">No</label>
					</td>
				</tr>
				<tr class="tdhabilitaFondeo" >
					<td class="label"><label for="productoCreditoID">Producto Cr&eacute;dito: </label></td>
					<td nowrap="nowrap" colspan="5">
						<input type="text" id="productoCreditoID" name="productoCreditoID" size="12" tabindex="2" />
						<input type="text" id="descripcion" name="descripcion" size="40" rows="3" tabindex="-1" />
					</td>
				</tr>
				<tr class="tdhabilitaFondeo">
					<td class="label">
						<label for="lblFormulaRetencion">F&oacute;rmula de Retenci&oacute;n: </label>
				   </td>
				   <td>
						<form:select id="formulaRetencion" name="formulaRetencion" path="formulaRetencion" tabindex="3" >
						<form:option value="">SELECCIONAR</form:option>
						<form:option value="T">TASA DE ISR SOBRE EL CAPITAL</form:option>
						<form:option value="P">PORCENTAJE DIRECTO SOBRE RENDIMIENTO</form:option>
						</form:select>
				   </td>
				   <td class="separador"></td>
				   <td class="label">
						<label for="lblTasaISR">Tasa de ISR: </label>
					</td>
					<td>
						<form:input id="tasaISR" name="tasaISR" path="tasaISR" size="8" tabindex="4" esTasa="true" style="text-align: right;"/>
						<label for="lblPorcentaje">% </label>
					</td>
				</tr>
				<tr class="tdhabilitaFondeo">
					<td class="label">
					<label for="lblPorISRMor">Porcentaje o Tasa de ISR Aplicable los Moratorios Pagados al Cliente: </label>
				   </td>
				   <td>
					  <form:input id="porcISRMoratorio" name="porcISRMoratorio" path="porcISRMoratorio" size="8" tabindex="5"  esTasa="true" style="text-align: right;"/>
					  <label for="lblPorcentaje">% </label>
				   </td>
					<td class="separador"></td>
					<td class="label">
					<label for="lblPorISRCom">Porcentaje o Tasa de ISR Aplicable las Comisiones Pagadas al Cliente: </label>
					</td>
					<td>
						<form:input id="porcISRComision" name="porcISRComision" path="porcISRComision" size="8" tabindex="6" esTasa="true" style="text-align: right;"/>
						<label for="lblPorcentaje">% </label>
					</td>
				</tr>
				<tr class="tdhabilitaFondeo">
					<td class="label">
					<label for="lblMinPorFonPr">M&iacute;nimo Porcentaje de Fondeo Propio: </label>
				   </td>
				   <td>
					  <form:input id="minPorcFonProp" name="minPorcFonProp" path="minPorcFonProp" size="8" tabindex="7" esMoneda="true" style="text-align: right;"/>
					  <label for="lblPorcentaje">% </label>
				   </td>
					<td class="separador"></td>
					<td class="label">
					<label for="lblMaxPorSal">M&aacute;ximo Porcentaje de Saldo Pagado del Crédito: </label>
					</td>
					<td>
					 <form:input id="maxPorcPagCre" name="maxPorcPagCre" path="maxPorcPagCre" size="8" tabindex="8" esMoneda="true" style="text-align: right;"/>
					 <label for="lblPorcentaje">% </label>
					</td>
				</tr>
				<tr class="tdhabilitaFondeo">
					<td class="label">
					<label for="lblMaxDiasAtrasCre">N&uacute;mero M&aacute;ximo de D&iacute;as de Atraso Permitidos para Fondear el Cr&eacute;dito:</label>
					</td>
					<td>
					 <form:input id="maxDiasAtraso" name="maxDiasAtraso" path="maxDiasAtraso" size="8" tabindex="9" style="text-align: right;"/>
					 <label for="lblPorcentaje"> </label>
					</td>
					<td class="separador"></td>
					<td class="label">
					<label for="lblfMinDiasGraVen">N&uacute;mero M&iacute;nimo de D&iacute;as de Gracia para el 1er Vencimiento: </label>
					</td>
					<td>
					 <form:input id="diasGraciaPrimVen" name="diasGraciaPrimVen" path="diasGraciaPrimVen" size="12" tabindex="10" style="text-align: right;" />

					</td>
				</tr>
			 </table>
				<table border="0" cellpadding="0" cellspacing="0"  width="100%">
				<tr>
					<td colspan="5">
						<table align="right">
							<tr>
								<td align="right">
									<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="11"/>
									<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
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
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>