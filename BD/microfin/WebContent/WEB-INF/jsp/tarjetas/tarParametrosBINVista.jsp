<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
	<script type="text/javascript" src="dwr/interface/tarjetaBinParamsServicio.js"></script>
	<script type="text/javascript" src="js/tarjetas/tarParametrosBINs.js"></script>
</head>
<body>
<div id="contenedorForma">
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tarBinParamsBean">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Alta de Bin</legend>
			<table border="0" width="100%">
			<tr>
				<td class="label" ><label for="lblBin">N&uacute;mero:</label>
			   	</td>
				<td>
				 	<input type="text" id="tarBinParamsID" name="tarBinParamsID" path="tarBinParamsID" maxlength="6" size="10" tabindex="1" />
				</td>
			</tr>
			<tr>
				<td class="label" ><label for="lblBin">N&uacute;mero Bin:</label>
			   	</td>
				<td>
				 	<input type="text" id="numBIN" name="numBIN" path="numBIN" maxlength="6" size="20" tabindex="2" onkeypress="return validaSoloNumero(event,this);"/>
				</td>
				<td class="separador"></td>
				<td class="label" ><label for="lblBin">Marca del Bin:</label>
			   	</td>
				<td>
				 	<select id="catMarcaTarjetaID" name="catMarcaTarjetaID"  path="catMarcaTarjetaID" tabindex="3">
						<option value="">SELECCIONAR</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label">			
					<label>Acepta SubBin: </label>
			   	</td>
			   	<td>
			  		<input type="radio" id="esSubBinS" name="esSubBin" value="S" tabIndex="4"/><label>SI</label>
			   		<input type="radio" id="esSubBinN" name="esSubBin" value="N" tabIndex="5" /><label>NO</label>
			   	</td>
			</tr>
			<tr id="esmultibase">
			   	<td class="label">			
					<label>Activa Bin Multiempresa: </label>
			   	</td>
			   	<td>
			  		<input type="checkbox" id="esBinMulEmpS" name="esBinMulEmp" value="S" tabIndex="7"/><label>Activar</label>
			   	</td>
			</tr>
	</table>
<table align="right">
	<tr>
		<td align="right">
			<input type="submit" id="agrega" name="agrega" class="submit" tabindex="20" value="Agregar" />
			<input type="submit" id="modifica" name="modifica" class="submit" tabindex="21" value="Modificar" />
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
		</td>
	</tr>
</table>
</fieldset>

<div id="gridBINs" style=" height:100%; overflow: auto;" ></div>

</form:form>
</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>