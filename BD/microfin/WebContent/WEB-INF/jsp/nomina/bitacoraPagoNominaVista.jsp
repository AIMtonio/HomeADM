<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>    
<html>
<head>	
       	<script type="text/javascript" src="dwr/interface/pagoNominaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/institucionNominaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/bitacoraPagoNominaServicio.js"></script>
      	<script type="text/javascript" src="js/nomina/bitacoraPagoNomina.js"></script> 
      	
</head>
<body>

<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bitacoraPagoNominaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Carga de Archivo  Pagos de Cr&eacute;dito</legend>
		
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
	<td class="label"> 
	         <label for="lblInstitucion">Empresa N&oacute;mina:</label> 
		</td>
	    <td> 
	     <input type="text" id="institNominaID" name="institNominaID" size="10" tabindex="1" /> 
		</td>
		<td> 
	      <input type="text" id="nombreEmpresa" name="nombreEmpresa" size="77" tabindex="2" disabled= "true" 
	          readonly="true" iniforma='false'/> 
		</td>
	</tr> 
	<tr>
		<td class="label"> 
	         <label for="lblFechaInicio">Fecha Carga:</label> 
		</td>
		<td>
		<form:input id="fechaInicio" name="fechaInicio" tabindex="3" path="fechaInicio" readOnly="true" size="10" disabled="true" />
		</td>
	</tr>
	</table>
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr>
	<td class="label">
		<DIV class="label">
			<label> 
				<br>
					Este proceso Carga el Detalle de los Pagos de Cr&eacute;ditos de Nómina de sus empleados.
				<br>	    
				<br> 
				En caso de que el archivo cargado contenga errores en alguno de los registros, favor de
				<br> 
				   cargar nuevamente el archivo corrigiendo dichos errores para que se puedan realizar los 
				<br> 
				   pagos correspondientes.
				</label>
		</DIV>
	</td>
	</tr>
	 <br> 
	<tr>
		<td class="label" align="right">		
			<input type="button"id="consultar" name="consultar" class="submit" value="Consultar Formato del Archivo" tabindex="4" />
			<input type="button"id="adjuntar" name="adjuntar" class="submit" value="Subir Archivo" tabindex="5" />						
		</td>
	</tr>
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr>
			<td align="right">
				<input type="button" id="verBitacora" name="verBitacora" class="submit" value="Ver Fallidos" tabindex="6" />
				<input type="button" id="ocultar" name="ocultar" class="submit" value="Ocultar Fallidos" tabindex="7" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
			    <input type="hidden" id="folioCargaID" name="folioCargaID" size="10" tabindex="4" disabled= "true" />					
			</td>
		</tr>
		</table>
				
		<div id="gridBitacoraCargaArchivo" style="display:none">
     	</div>
</table> 
 </fieldset>
 
</form:form> 
<div id="ejemploArchivo" style="display:none">
</div>
<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>