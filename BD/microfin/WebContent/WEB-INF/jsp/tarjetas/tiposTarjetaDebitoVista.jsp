<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
<script type="text/javascript"	src="dwr/interface/catalogoBloqueoCancelacionTarDebitoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tipoTarjetaDebServicio.js"></script>
<script type="text/javascript" src="dwr/interface/tarjetaBinParamsServicio.js"></script>
<script type="text/javascript"	src="js/tarjetas/tipoTarjetaDebito.js"></script> 

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tipoTarjetaDebBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de Tarjeta</legend>
	<table border="0" width="100%">
		<tr>
			<td class="label" ><label for="lblTipoTarjeta">Tipo de Tarjeta:</label>
				</td>
			<td>
			    <input type="text" id="tipoTarjetaDebID" name="tipoTarjetaDebID" path="tipoTarjetaDebID" maxlength="20" size="20" tabindex="1" />
			</td>
		</tr>
		<tr>
			<td class="label">			
				<label>Maquilador: </label>
			</td>
			<td>
		 		<input type="radio" id="habilitadoISS" name="tipoMaquilador" value="1" tabIndex="2"/><label>ISS</label>
	    		<input type="radio" id="habilitadoTGS" name="tipoMaquilador" value="2" tabIndex="3" /><label>TGS</label>
	    	</td>
			<td class="separador"></td>
			<td class="label">			
				<label>Tipo: </label>
		   	</td>
		   	<td>
		  		<input type="radio" id="tipoTarjetaD" name="tipoTarjeta" value="D" tabIndex="4"/><label>Debito</label>
		   		<input type="radio" id="tipoTarjetaC" name="tipoTarjeta" value="C" tabIndex="5" /><label>Credito</label>
		   	</td>
		</tr>
		<tr id="BINtr">
			<td class="label" ><label for="lblBin">Bin Patrocinador:</label>
		   	</td>
			<td>
			 	<input type="text" id="tarBinParamsID" name="tarBinParamsID" path="tarBinParamsID" maxlength="6" size="5" tabindex="6" />
			 	<input type="text" id="numBIN" name="numBIN" path="numBIN" maxlength="6" size="5" disabled="disabled"/>
			</td>
			
			<td class="separador"></td>
		   	<td class="label" ><label for="lblBin">N&uacute;mero SubBin:</label>
		   	</td>
			<td>
			 	<input type="text" id="numSubBIN" name="numSubBIN" path="numSubBIN" maxlength="2" size="20" tabindex="7" onkeypress="return validadorNum(event);"/>
			</td>
		</tr>
		<tr id="Patroctr">
			<td class="label" ><label for="lblBin">Patrocinador:</label>
			<td>
				<select id="patroSubBIN" name="patrocinadorID" tabindex="15">
						<option value="">SELECCIONAR</option>
				</select>
			</td>
		</tr>
		<tr id="coretr">
			<td class="label">			
				<label >Tipo de Core: </label>
	    	</td>
			<td>
				<select id="tipoCore" name="tipoCore"  tabindex="9" >
					<option value="">SELECCIONAR</option>
			  		<option value="1">Core Externo</option>
			  		<option value="2">SAFI Externo</option>
			  		<option value="3">SAFI Interno</option>
				</select>
			</td>
			<td class="separador"></td>
			<td id="urlCoretd" class="label" ><label for="lblBin">Url WebService:</label>
		   	</td>
			<td id="urlCoretd2">
			 	<input type="text" id="urlCore" name="urlCore" path="urlCore" maxlength="80" size="30" tabindex="10"/>
			</td>
		</tr>
		
		<tr>
			<td class="label">
			  	<label for="descripcion">Descripci&oacute;n: </label>
		  	</td>
			<td>
				<input type="text" id="descripcion" name="descripcion"  onblur="ponerMayusculas(this)" maxlength="150"  size="30" tabindex="11" />
			</td>
			<td class="separador"></td>
			<td id="idprosa" class="label" ><label for="lblIDProducto">ID  producto PROSA:</label>
		   	</td>
			<td id="idprosa2">
			 	<input type="text" id="tipoProsaID" name="tipoProsaID" path="tipoProsaID" maxlength="4" size="20" tabindex="12" />
			</td>
		</tr>
		<tr>
			<td class="label">			
				<label>Operaciones POS En L&iacute;nea: </label>
			</td>
			<td>
		 		<input type="radio" id="opePosLineaSI" name="compraPOSLinea" value="S" tabIndex="13"/><label>Si</label>
	    		<input type="radio" id="opePosLineaNO" name="compraPOSLinea" value="N" tabIndex="14" /><label>No</label>
	    	</td>
			<td class="separador"></td>
			<td class="label" id="lblColorTar">
			  	<label for="color">Color de Tarjeta: </label>
		   	</td>
			<td id="selectColorTar">
				<select id="colorTarjeta" name="colorTarjeta"  tabindex="15" >
					<option value="">SELECCIONAR</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="label">			
				<label > Estatus: </label>
	    	</td>
			<td>
				<select id="estatus" name="estatus"  tabindex="16" >
					<option value="">SELECCIONAR</option>
			  		<option value="A">ACTIVA</option>
			  		<option value="C">CANCELADO</option>
				</select>
			</td>
			<td class="separador"></td>
			<td id="productoCred">
		      	<label>Producto Crédito: </label>
			</td>
			<td id="producCredito">
				<input type="text" id="productoCredID" name="productoCredito" maxlength="10" size="5"  tabindex="17"/>
		      	<input type="text" id="descripcionProd" name="descripcionProd" maxlength="40" size="40" readonly="true" />
			</td>			
		</tr>
		<tr>
			<td class="label">
				<label for="vigencia" id="vigencia">Vigencia en Meses de las Tarjetas: </label>
			</td>
			<td>
				<input id="vigenciaMeses" name="vigenciaMeses" path="vigenciaMeses" size="12" maxlength="5" tabindex="18" type="text" onkeyPress="return validadorNum(event);"/>	
			</td>
			<td class="separador"></td>
			<td id="identificacion" class="label">			
				<label > Identificaci&oacute;n <s:message code="safilocale.cliente"/>: </label>
	    	</td>
	    	<td id ="identificacionSoc">
	    		<input type="radio" id="identificaSocioS" name="identificacionSocio" value="S" tabIndex="19"/><label>Si</label>
	    		<input type="radio" id="identificaSocioN" name="identificacionSocio" value="N" tabIndex="20" /><label>No</label>
	    	</td>
		</tr>
	</table>
	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="condiciones">
		<legend>Condiciones</legend>
		<table>
		   	<tbody>
		   		<tr>
					<td class="label">
						<label for="tasaFija">Tasa Fija: </label>
				 	</td>
					<td>
						<input type="text" id="tasaFija" name="tasaFija" path="tasaFija" maxlength="8" size="16" tabindex="21" esTasa="true" onkeyPress="return validador(event);"/>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="montoAnual">Monto Anualidad: </label>
				 	</td>
					<td>
						<input type="text" id="montoAnual" name="montoAnual" path="montoAnual" maxlength="15" size="16" tabindex="22" onkeyPress="return validador(event);" esMoneda="true"/>
					</td>
			 	</tr>
			 	<tr>
					<td class="label">
						<label for="cobraMora">Cobra Mora: </label>
				 	</td>
					<td>
						<select id="cobraMora" name="cobraMora"  tabindex="21" >
							<option value="">SELECCIONAR</option>
				  			<option value="S">SI</option>
			  				<option value="N">NO</option>
						</select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="tipoMora">Tipo Cob. Mora: </label>
				 	</td>
					<td>
						<select id="tipoMora" name="tipoMora"  tabindex="22" >
							<option value="">SELECCIONAR</option>
				  			<option value="N">N VECES TASA ORDINARIA</option>
			  				<option value="T">TASA FIJA ANUALIZADA</option>
						</select>
						<input type="text" id="factorMora" maxlength="8" name="factorMora" size="15" esMoneda="true" tabindex="23" onkeyPress="return validador(event);">					
					</td>
			 	</tr>
			 	
			 	<tr>
					<td class="label">
						<label for="porcPagoMin">Porc. Pago Mínimo: </label>
				 	</td>
					<td>
						<input type="text" id="porcPagoMin" name="porcPagoMin" maxlength="8" size="16" tabindex="24" esTasa="true" onkeyPress="return validador(event);">					
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="montoCredito">Límite de Crédito: </label>
				 	</td>
					<td>
						<input type="text" id="montoCredito" name="montoCredito" maxlength="14" size="16" tabindex="25" esMoneda="true" onkeyPress="return validador(event);">					
					</td>
			 	</tr>
		   	</tbody>
		</table>
	</fieldset>
		<fieldset class="ui-widget ui-widget-content ui-corner-all" id="comisiones">
		<legend>Comisiones</legend>
		<table>
		   	<tbody>
		   		<tr>
					<td class="label">
						<label for="cobFaltaPago">Cobra Falta Pago: </label>
				 	</td>
					<td>
						<select id="cobFaltaPago" name="cobFaltaPago"  tabindex="26" >
							<option value="">SELECCIONAR</option>
				  			<option value="S">SI</option>
			  				<option value="N">NO</option>
						</select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="tipoFaltaPago">Tipo Cob. Fal. Pag: </label>
				 	</td>
					<td>
						<select id="tipoFaltaPago" name="tipoFaltaPago"  tabindex="27" >
							<option value="">SELECCIONAR</option>
				  			<option value="P">PORCENTAJE</option>
			  				<option value="M">MONTO FIJO</option>
						</select>
						<input type="text" id="facFaltaPago" name="facFaltaPago" maxlength="8" size="15"  tabindex="28" esMoneda="true" onkeyPress="return validador(event);">					
					</td>
			 	</tr>
		   		<tr>
					<td class="label">
						<label for="comiApertura">Comisi&oacute;n por apertura: </label>
				 	</td>
					<td>
						<select id="cobComisionAper" name="cobComisionAper"  tabindex="29" >
							<option value="">SELECCIONAR</option>
				  			<option value="S">SI</option>
			  				<option value="N">NO</option>
						</select>
					</td>
					<td class="separador"></td>
					<td class="label">
						<label for="tipoCobComAper">Tipo Cob. Com. Aper: </label>
				 	</td>
					<td>
						<select id="tipoCobComAper" name="tipoCobComAper"  tabindex="30" >
							<option value="">SELECCIONAR</option>
				  			<option value="P">PORCENTAJE</option>
			  				<option value="M">MONTO FIJO</option>
						</select>
						<input type="text" id="facComisionAper" name="facComisionAper" maxlength="8" size="15"  tabindex="31" esMoneda="true" onkeyPress="return validador(event);">
					</td>
			 	</tr>
		   	</tbody>
		</table>
	</fieldset>

		<div id="acciones" style=" height:100%; overflow: auto;" >

			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" tabindex="32" value="Agregar" />
						<input type="submit" id="modifica" name="modifica" class="submit" tabindex="33" value="Modificar" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
					</td>
				</tr>
			</table> 
	</div>

	<fieldset class="ui-widget ui-widget-content ui-corner-all" id="subbin">
		<div id="gridSubBIN" style=" height:100%; overflow: auto;" ></div>
		
			<input type="hidden" id="numSubBINs" name="numSubBINs" />
			<input type="hidden" id="numBINs" name="numBINs" />	
		
	</fieldset>
</fieldset>

</form:form>
</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>