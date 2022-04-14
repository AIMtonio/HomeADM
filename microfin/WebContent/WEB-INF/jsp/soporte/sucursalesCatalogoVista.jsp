<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/plazasServicio.js"></script>
     	<script type="text/javascript" src="dwr/interface/centroServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
        <script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/coloniaRepubServicio.js"></script>

        <script type="text/javascript" src="js/soporte/mascara.js"></script>
        <script type="text/javascript" src="js/soporte/sucursalesCatalogo.js"></script>
	</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Sucursales</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="sucursal">

	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td class="label">
				<label for="numero">N&uacute;mero: </label>
			</td>
			<td >
				<form:input id="sucursalID" name="sucursalID" path="sucursalID" size="15" tabindex="1" iniForma="false"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="nombre">Nombre:</label>
			</td>
			<td>
				<form:input id="nombreSucurs" name="nombreSucurs" path="nombreSucurs" tabindex="2" size="35" onBlur=" ponerMayusculas(this)" maxlength="50" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="tipoSucursal">Tipo de Sucursal</label>
			</td>
			<td >
				<form:select id="tipoSucursal" name="tipoSucursal" path="tipoSucursal" tabindex="3" >
					<form:option value="">SELECCIONAR</form:option>
					<form:option value="C">CORPORATIVA</form:option>
				 	<form:option value="A">ATENCI&Oacute;N A <s:message code="safilocale.clienteM"/></form:option>
				</form:select>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="plaza">Plaza: </label>
			</td>
			<td >
				<form:input id="plazaID" name="plazaID" path="plazaID" size="7" tabindex="4" />
				<input type="text" id="nomPlaza" name="nomPlaza"  size="35" readOnly="true" disabled = true onBlur=" ponerMayusculas(this)" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="centroCostoID">Centro de Costo:</label>
			</td>
			<td>
				<form:input id="centroCostoID" name="centroCostoID" path="centroCostoID" tabindex="6" size="7"/>
				<input type="text" id="descripcionCC" name="descripcionCC"  size="35"  readOnly="true" disabled = true onBlur=" ponerMayusculas(this)" iniForma ="true"/>
			</td>
			<td class="separador"></td>
			<td class="label">
				<label for="iva">IVA: </label>
			</td>
			<td >
				<form:input id="IVA" name="IVA" path="IVA" size="7" tabindex="8" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="isr">Tasa ISR:</label>
			</td>
			<td>
				<form:input id="tasaISR" name="tasaISR" path="tasaISR" tabindex="9" size="7"/>
			</td>
			<td class="separador"></td>
			<td class="label" name="td-claveCNBV">
				<label for="claveSucCNBV">Clave Sucursal CNBV: </label>
			</td>
			<td name="td-claveCNBV">
				<form:input id="claveSucCNBV" name="claveSucCNBV" path="claveSucCNBV" size="7" tabindex="10" maxlength="8" />
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="titulo">T&iacute;tulo Gerente:</label>
			</td>
			<td>
				<form:select id="tituloGte" name="tituloGte" path="tituloGte" tabindex="11">
						<form:option value="SR."></form:option>
				     	<form:option value="SRA."></form:option>
				     	<form:option value="SRITA."></form:option>
					   	<form:option value="LIC."></form:option>
					  	<form:option value="DR."></form:option>
						<form:option value="ING."></form:option>
						<form:option value="PROF."></form:option>
						<form:option value="C. P."></form:option>
				</form:select>
			</td>

			<td class="separador"></td>
			<td class="label">
				<label for="nombreGerente">Gerente: </label>
			</td>
			<td >
				<form:input id="nombreGerente" name="nombreGerente" path="nombreGerente" size="7" tabindex="12" />
				<input type="text"  id="nombGerente" name="nombGerente"  size="35"  readOnly="true" disabled = "true" iniForma ="true"/>
			</td>
		</tr>

		<tr>
	 		<td class="label">
					<label for="poderNotar">Poder Notarial Gerente: </label>
			</td>
			<td class="label">
				<form:radiobutton id="poderNotarial1" name="poderNotarial1"  path="poderNotarial"
			 		value="S" tabindex="13"  />
				<label for="pn">SI</label>&nbsp;&nbsp;
				<form:radiobutton id="poderNotarial2" name="poderNotarial2"  path="poderNotarial"
					value="N" tabindex="14" checked="checked" />
				<label for="pn">NO</label>
			</td>

			<td class="separador"></td>
			<td class="label" id="png1">
					<label for="poderNotarial">Poder Notarial: </label>
			</td>
	 		<td id="png">
				<form:textarea  type="text"  name="poderNotarial" id="PoderNotarial" path="poder" COLS="60" ROWS="3" maxlength="500"
					tabindex="15" onBlur=" ponerMayusculas(this)"/>
			</td>
		</tr>

		<tr>
			<td class="label">
				<label for="tituloSub">T&iacute;tulo SubGerente:</label>
			</td>
			<td>
				<form:select id="tituloSubGte" name="tituloSubGte" path="tituloSubGte" tabindex="16">
						<form:option value="SR."></form:option>
				     	<form:option value="SRA."></form:option>
				     	<form:option value="SRITA."></form:option>
					   	<form:option value="LIC."></form:option>
					  	<form:option value="DR."></form:option>
						<form:option value="ING."></form:option>
						<form:option value="PROF."></form:option>
						<form:option value="C. P."></form:option>
				</form:select>
			</td>

			<td class="separador"></td>
			<td class="label">
				<label for="subgerente">SubGerente:</label>
			</td>
			<td>
				<form:input id="subGerente" name="subGerente" path="subGerente" tabindex="17" size="7"/>
				<input type="text"  id="nomSubGerente" name="nomSubGerente"  size="35"  readOnly="true" disabled="true" iniForma ="true"/>
			</td>
		</tr>

		<tr>
			<td class="label">
				<label for="entidadFederativa">Entidad Federativa:</label>
			</td>
			<td>
				<form:input id="estadoID" name="estadoID" path="estadoID" size="7" tabindex="18" />
	         	<input type="text" id="nombreEstado" name="nombreEstado" size="35"
	          		readOnly="true" disabled = "true"/>
			</td>

			<td class="separador"></td>
			<td class="label">
	        	<label for="municipio">Municipio: </label>
	     	</td>
	     	<td>
	        	<form:input id="municipioID" name="municipioID" path="municipioID" size="7" tabindex="19" />
	         	<input type="text" id="nombreMuni" name="nombreMuni" size="35" readOnly="true" disabled="true"/>
	     	</td>
	     </tr>

	     <tr>
	     		<td class="label"><label>Localidad:</label></td>
				<td><input type="text" id="localidadID" name="localidadID" path="localidadID" size="7" tabindex="20" />
				<input type="text" id="nombrelocalidad" name="nombrelocalidad" size="40" readonly="true" disabled="true" /></td>

	     </tr>

	     <tr>



			<td class="label">
	    		 <label for="calle">Calle: </label>
	     	</td>
	     	<td>
	        	 <form:input id="calle" name="calle" path="calle" size="50" tabindex="21"  onBlur=" ponerMayusculas(this)" maxlength="100" />
	     	</td>

			<td class="separador"></td>
	     	<td class="label">
	       		<label for="numero">N&uacute;mero: </label>
	     	</td>
	     	<td>
	        	<form:input type="text" id="numero" name="numero" path="numero" size="5" tabindex="22"  onBlur=" ponerMayusculas(this)" maxlength="10" />
	    	</td>
		</tr>

		<tr>
	       	<td class="label">
	        	<label for="colonia">Colonia: </label>
	     	</td>
	     	<td>
	     		<form:input id="coloniaID" name="coloniaID" path="coloniaID" size="7" tabindex="23" />
	        	<form:input type="text" id="colonia" name="colonia" path="colonia" size="45" tabindex=""  readOnly="true" disabled="true" onBlur=" ponerMayusculas(this)" maxlength="45" />
	     	</td>
	       	<td class="separador"></td>
	     	<td class="label">
	       		<label for="CP">C&oacute;digo Postal: </label>
	   		</td>
	  	 	<td>
	       		<form:input type="text" id="CP" name="CP" path="CP" size="15" tabindex="24" maxlength="5" />
		   	</td>
		</tr>

		<tr>
	       	<td class="label">
	        	<label for="latitud">Latitud: </label>
	     	</td>
	     	<td>
	        	<form:input type="text" id="latitud" name="latitud" path="latitud" size="11" tabindex="25"  onBlur=" ponerMayusculas(this)" maxlength="10" />
	     	</td>
	       	<td class="separador"></td>
	     	<td class="label">
	       		<label for="longitud">Longitud: </label>
	   		</td>
	  	 	<td>
	       		<form:input type="text" id="longitud" name="longitud" path="longitud" size="11" tabindex="26" maxlength="11" />
		   	</td>
		</tr>

		<tr>
	       	<td class="label">
	        	<label for="horaInicioOper">Hora Inicio Operaciones: </label>
	     	</td>
	     	<td>
	        	<form:input type="text" id="horaInicioOper" name="horaInicioOper" path="horaInicioOper" size="11" tabindex="27"  maxlength="10" />
	     	</td>
	       	<td class="separador"></td>
	     	<td class="label">
	       		<label for="horaFinOper">Hora Fin de Operaciones: </label>
	   		</td>
	  	 	<td>
	       		<form:input type="text" id="horaFinOper" name="horaFinOper" path="horaFinOper" size="11" tabindex="28" maxlength="11" />
		   	</td>
		</tr>


		<tr>
			<td class="label">
				<label for="telefono">Tel&eacute;fono:</label>
			</td>
			<td>
				<form:input type="text"  id="telefono" name="telefono" path="telefono" tabindex="29" size="15" maxlength="10" />
				<label for="lblExt">Ext.:</label>
				<form:input path="extTelefonoPart" id="extTelefonoPart" name="extTelefonoPart" tabindex="30" size="10" maxlength="6" />
			</td>
			<td class="separador"></td>
			<td class="label">
	       		<label for="difhorMat">Diferencia Horaria Matriz: </label>
	   	</td>
	  	 	<td>
	      	<form:input type="text"  id="difHorarMatriz" name="difHorarMatriz" path="difHorarMatriz" size="15" tabindex="31" />
	   	</td>
		</tr>
		<tr>
			<td class="label">
				<label>Fecha Apertura:</label>
			</td>
			<td>
				<form:input type="text"  name="fechaSucursal" id="fechaSucursal" path="fechaSucursal"
					tabindex="32" iniforma="false" readOnly="true" disabled="true" />
		 	</td>
			<td class="separador"></td>
			<td class="label promotorcap">
				<label>Ejecutivo de Captaci&oacute;n:</label>
			</td>

			<td class="promotorcap">
				<input type="text" id="promotorCaptaID" name="promotorCaptaID" tabindex="33" size="7" />
				<input type="text" id="descEjecutivoCapta" name="descEjecutivoCapta" size="35" readonly="true" disabled="true" />
			</td>
			<input type="hidden" id="muestraEjec" name="muestraEjec" readonly="true" />
		</tr>
 		<tr>
			<td colspan="2">
				<form:textarea id="direcCompleta" name="direcCompleta" path="direcCompleta" COLS="60" ROWS="3" tabindex="34"
					readOnly="true" onBlur=" ponerMayusculas(this)" maxlength="250" />
			</td>
	 	</tr>

	 	<tr>

	</table>

<br>

	<fieldset class="ui-widget ui-widget-content ui-corner-all" name="td-claveCNBV">
			<legend>Regulatorios</legend>
			<table border="0" >

				<tr>
					<td class="label">
						<label for="claveSucOpeCred">Clave Suc. Opera el Crédito:</label>
					</td>
					<td>
						<form:input id="claveSucOpeCred" name="claveSucOpeCred" path="claveSucOpeCred" tabindex="35" maxlength ="10"/>
					</td>

					<td class="separador"></td>

				</tr>
			</table>
	</fieldset>

	<table border="0" width="100%" >

				<tr>
					<td colspan="5" align="right">
						<br>
						<input type="submit" id="agrega" name="agrega" class="submit" value="Agregar" tabindex="36" />
						<input type="submit" id="modifica" name="modifica" class="submit"  value="Modificar" tabindex="37" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					</td>

				</tr>
		</table>


	</form:form>
	</fieldset>
</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>
