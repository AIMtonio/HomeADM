<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 		
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/asignarChequeSucurServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cajasVentanillaServicio.js"></script>
		<script type="text/javascript" src="js/tesoreria/asignarChequeSucur.js"></script>		 
	</head>
<body>
	<div id="contenedorForma">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend class="ui-widget ui-widget-header ui-corner-all">Asignar Chequera a Sucursal</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="asignarCheque">         
				<table border="0" cellpadding="0" cellspacing="0" width="83%">     
					<tr>
						<td class="label">
							<label for="lblinstitucionID">Instituci&oacute;n: </label> 
						</td>
					    <td> 
							<form:input type="text" id="institucionID" name="institucionID" path="institucionID" size="11" tabindex="1" autocomplete="off" maxlength="9"/> 		         	
							<input type="text"  id="nombreInstitucion" name="nombreInstitucion" size="50" tabindex="2" disabled="true" readonly="true"/>
						</td>
					</tr>
					<tr>	
						<td class="label">
				    		<label for="lblnumCtaBancaria">N&uacute;mero de Cuenta Bancaria: </label>
				    	</td> 
						<td>
							<form:input type="text" id="numCtaInstit" name="numCtaInstit" path="numCtaInstit" size="38" tabindex="3" maxlength="20" autocomplete="off"/>
							<form:input type="hidden" id="estatus" name="estatus" path="estatus" size="6"   /> 		 			
						</td>
					</tr>
					<tr>
						<td class="label"> 
					    	<label id="lbltipoChequera">Tipo Chequera:</label> 
						</td>
						<td>
			          		<form:select id="tipoChequera" name="tipoChequera" path="tipoChequera" tabindex="4" >
			          			<form:option value="">SELECCIONAR</form:option> 
			          			<form:option value="P">PROFORMA</form:option>
		 	          			<form:option value="E">CHEQUERA</form:option>
			          		</form:select>
			            </td>
					</tr>
				</table>
				<br>
				<div id="gridCajasSucursal" name="gridCajasSucursal" style="display: none;"></div>
				<br>
				<table border="0" cellpadding="0" cellspacing="0" width="850px">  
					<tr>
						<td align="right">
					    	<input type="submit" id="asigna" name="asigna" class="submit" value="Asignar" tabindex="20"/>
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
							<form:input type="hidden" id="listaCajas" name="listaCajas" path="listaCajas" value=""/>
							<form:input type="hidden" id="valorListaCajas" name="valorListaCajas" path="valorListaCajas" value=""/>
							
						</td>
					</tr>
				</table>
		 	</form:form> 
		</fieldset>
	</div>
	<div id="cargando" style="display: none;">	
	</div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
	<div id="mensaje" style="display: none;"> </div>
	<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"></div>
	</div>	
	</body>
</html>