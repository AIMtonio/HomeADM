<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>

<head>
<script type="text/javascript" src="dwr/interface/tesoMovsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
<script type="text/javascript" src="dwr/interface/TiposMovTesoServicioScript.js"></script> 
<script type="text/javascript" src="dwr/interface/centroServicio.js"></script> 

<script type="text/javascript" src="js/tesoreria/tesoMovsConciliaManualVista.js"></script>

</head>

<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="conciliacion" >
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Conciliaci&oacute;n Manual de Movimientos</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">			
					<tr>
					    <td class="label">
					        <label for="institucion">Instituci&oacute;n: </label> 
					    </td>
					    <td>
					        <form:input type="text" id="institucionID" name="institucionID"  size="24" path="institucionID" tabindex="1" />
					        <input type="text" id="nombreInstitucion" name="nombreInstitucion" size="50" disabled="true" readOnly="true"/> 
					    </td> 
					    <td class="separador"></td>
					    <td class="label">
					        <label for="lblfech">Fecha: </label> 
					    </td>
					    <td>
					    	<form:input type="text" id="fechaSistema" name="fechaSistema"  size="15"  path="fechaSistema" readOnly="true"/>
					    </td>                                           
					</tr>         
					<tr>
					    <td class="label">
					        <label for="cuentaBan">Cuenta Bancaria: </label> 
					    </td>
					    <td colspan="5">
					    	<form:input type="text" id="numCtaInstit" name="numCtaInstit"  size="24"  path="numCtaInstit" tabindex="2"/>
					    </td>
					</tr>
					</table>
					<table>
	 	    	<tr>	
					<td>
					  <div id="gridMovsConciliacionManual" style="overflow: scroll; width:auto; height:450px; display: none;"></div> 
					</td>		
				</tr> 	
	 		</table>
					
					<table align="right">
					<tr>
						<td colspan="5" align="right">									
						<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar"   />
							<input type="submit" id="cerrar" name="cerrar" class="submit" value="Cancelar Movs. de Conciliación" style="display: none;" />							
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"  />	
							<form:input type="hidden" id="existenMovsSelec" name="existenMovsSelec" value="existenMovsSelec" path="existenMovsSelec"/>
							<form:input type="hidden" id="tipoMovTesoDes" name="tipoMovTesoDes" value="tipoMovTesoDes"  path="tipoMovTesoDes"/>
							<input type="hidden" id="fechaseleccionada" name="fechaseleccionada"/>
							<input type="hidden" id="segfechaseleccionada" name="segfechaseleccionada"/>
							<input type="hidden" id="listaFoliosCarga" name="listaFoliosCarga"/>		
							<button type="button" class="submit" id="impPoliza" style="display:none">Ver Póliza</button>
							<input type="hidden" id="polizaID" name="polizaID" iniForma="false"/>
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
</body>
<div id="mensaje" style="display: none;"></div>
</html>