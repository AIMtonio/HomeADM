<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>	
    	<script type="text/javascript" src="dwr/interface/lineaFonServicio.js"></script>  
	   	<script type="text/javascript" src="dwr/interface/fondeoServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/tiposLineaFonServicio.js"></script>
         <script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/actividadesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
 		<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
			   	
	   	<script type="text/javascript" src="js/fondeador/condicionesLineaFondeo.js"></script>
	
	</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Condiciones L&iacute;nea de Fondeo</legend>
		<form:form id="formaGenerica" name="formaGenerica" method="post" commandName="lineaFondeo">
		<table border="0" cellpadding="0" width="100%" >
			<tr>
				<td class="label">
					<label for="institucionFondeo">Instituci&oacute;n de Fondeo: </label>
				</td> 
			   	<td nowrap="nowrap">
					<form:input id="institutFondID" name="institutFondID" path="institutFondID" size="3" tabindex="1"/>
				 	<input type="text" id="nombreInstitFondeo" name="nombreInstitFondeo"  size="30" 
				 		disabled="true"/> 	 	
				</td>
				<td class="separador"></td>	
					<td class="label">
					 <label for="lineaCred">L&iacute;nea de Fondeo: </label>
				</td> 
			   <td nowrap="nowrap">
				 	<form:input type = "text" id="lineaFondeoID" name="lineaFondeoID" path="lineaFondeoID" size="12" tabindex="2"/>
				 	<textarea id="descripLinea" name="descripLinea" rows="2" cols="25"  onblur="ponerMayusculas(this)" readonly="readonly"
				 		 ></textarea>
				</td>				
			</tr>
			<tr>
				<td class="label">
					<label for="tipo">Tipo de L&iacute;nea: </label> 
				</td>
	   			<td nowrap="nowrap">
		 			<form:input id="tipoLinFondeaID" name="tipoLinFondeaID" path="tipoLinFondeaID" size="3"  readonly="true" />
					<textarea id="desTipoLinFondea" name="desTipoLinFondea" rows="2" cols="30"  
		        		onblur="ponerMayusculas(this)" readonly="readonly"></textarea>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="monto">Monto Otorgado: </label> 
				</td>
	   			<td >
		 			<form:input id="montoOtorgado" name="montoOtorgado" path="montoOtorgado" onkeypress="return IsNumber1(event)" size="15"   readonly="true"
		 				esMoneda="true" style="text-align: right;" />
				</td>
			</tr>
			<tr>
				<td class="label">
					<label for="tipo">Saldo: </label> 
				</td>
	   			<td>
		 			<form:input id="saldoLinea" name="saldoLinea" path="saldoLinea" size="15" readonly="true"
		 	 			esMoneda="true" disabled="true" style="text-align: right;"/>
				</td>
				<td class="separador"></td>
				<td class="label">
					<label for="monto">Monto Aumentar: </label> 
				</td>
	   			<td>
		 			<form:input id="montoAumentar" name="montoAumentar" path="montoAumentar" size="15" tabindex="3" 
		 	 			esMoneda="true"  style="text-align: right;"/>
				</td>
			</tr>
			</table>
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend >Ventana de Disposición</legend>
			<table border="0" cellpadding="0" >
				<tr>
					<td class="label">
						<label for="FechaInc">Fecha de Inicio: </label>
					</td> 
					<td>
						<form:input id="fechInicLinea" name="fechInicLinea" path="fechInicLinea" size="15" tabindex="4" esCalendario="true"/>
						</td>		
					<td class="separador"></td>		
					<td class="label" nowrap="nowrap">
						<label for="FechaFin">Fecha de Fin: </label> 
					</td>
					<td nowrap="nowrap">
						<form:input id="fechaFinLinea" name="fechaFinLinea" path="fechaFinLinea" size="15" tabindex="5" esCalendario="true"/>
					</td>
				</tr>
				<tr>
					<td class="label">
						<label for="FechaMax">Fecha Max. Vencimientos: </label>
					</td> 
					<td>
						<form:input id="fechaMaxVenci" name="fechaMaxVenci" path="fechaMaxVenci" size="15" tabindex="6" esCalendario="true"/>
					</td>
					<td class="separador"></td>
					<td class="separador"></td>
					<td class="separador"></td>
				</tr>
			</table>
		</fieldset>
		<table border="0" cellpadding="0" width="100%"> 
			<tr>
				<td colspan="5" align="right">
					<input type="submit" id="modifica" name="modifica" class="submit" value="Modifica" tabindex="7"/>
					
					<a id="enlace" href="poliza.htm" target="_blank">
						<button type="button" class="submit" id="impPoliza" style="display:none" tabindex="8"> Ver P&oacute;liza</button>
	                </a>
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
<html>
	

