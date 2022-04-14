<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<html>
<head>	
		<script type="text/javascript" src="dwr/interface/bitacoraPagoNominaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/nominaServicio.js"></script>
      	<script type="text/javascript" src="js/nomina/descuentosNomina.js"></script> 
      	<script type="text/javascript" src="dwr/interface/institucionNominaServicio.js"></script>
        
</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="descuentosNominaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Descuentos N&oacute;mina</legend>
		
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend><label>Par&aacute;metros</label></legend>
				<table  border="0"  width="100%">
					<tr id="divEmpresa">
					<td class="label" >
					         <label for="lblEmpresa">Empresa N&oacute;mina:</label> 
						</td>		
					    <td> 
					        <input type="text" id="institNominaID" name="institNominaID" size="10" tabindex="1"/> 
						<input type="text" id="nombreEmpresa" name="nombreEmpresa" size="77"  disabled= "true" 
					          readonly="true" iniforma='true'/> 		
				
						</td>
						
						 
					</tr>
					<tr>
						<td class="label"> 
					         <label for="lblFechaInicio" style="display: none;">Fecha Actual:</label> 
						</td>
						<td>
						<input style="display: none;" type="text" id="fechaInicio" name="fechaInicio"disabled= "true" readonly="true" iniforma='true'/>
						</td>
					</tr>
				</table>
			</fieldset>
		</td>
	</tr>
</table>
<br>
 <table width="200px"> 
	<tr>
		<td class="label" >
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend><label>Presentaci&oacute;n</label></legend>
			<input type="radio" id="exel" name="exel" value="exel" tabindex="2"/>
		<label>Excel </label>
		<br>
					 	
		</fieldset>
			<input type="hidden" name="reporte" id="reporte" />
		</td>      
	</tr>
</table>
<table>
	<tr>
	<td class="label">
		<DIV class="label">
			<label> 
				<br>
					Reporte para consultar los Cr&eacute;ditos de N&oacute;mina de los Empleados.
				<br>
				    Incluye los montos y pr&oacute;ximas fechas de pago.
				</label>
		</DIV>
	</td>
	</tr>	 
</table>
	  
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td align="right">
			<input type="button" id="consultar" name="consultar" class="submit" value="Generar" tabindex="3"/>
		</td>
	</tr> 
 </table> 
 <br>

 </fieldset>
<div id="mapDiv" style="display: none;"></div>
 
</form:form> 

</div> 
<div id="cargando" style="display: none;"></div>	
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>

  