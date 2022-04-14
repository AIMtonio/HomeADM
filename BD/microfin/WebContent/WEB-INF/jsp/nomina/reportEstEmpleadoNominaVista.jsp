<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 

<html>
<head>	
	<script type="text/javascript" src="dwr/interface/bitacoraPagoNominaServicio.js"></script>
     <script type="text/javascript" src="dwr/interface/nominaServicio.js"></script>
    <script type="text/javascript" src="js/nomina/reportEstEmpleadoNomina.js"></script> 
    <script type="text/javascript" src="dwr/interface/institucionNominaServicio.js"></script>
    <script type="text/javascript" src="dwr/interface/actualizaEstatusEmpServicio.js"></script>
        
</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="estatusEmpleadoNomina">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Cambio de Estatus Empleado</legend>

		
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr> 
		<td> 
		<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend><label>Par&aacute;metros</label></legend>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr id="divEmpresa">
			
				<td class="label" >
				
			         <label for="lblEmpresa">Empresa N&oacute;mina:</label> 
				</td>		
			    <td> 
			        <input type="text" id="institNominaID" name="institNominaID" size="10" tabindex="1"/> 
			        <input type="text" id="nombreEmpresa" name="nombreEmpresa" size="77" tabindex="2" disabled= "true" 
			          readonly="true" iniforma='true'/>
				</td>
			
			
			</tr>
			
			<tr>
			
				<td class="label" >
				
			         <label for="lblEmpleado">Cliente:</label> 
				</td>		
			    <td> 
			        <input type="text" id="clienteID" name="ClienteID" size="10" tabindex="3"/> 
			        <input type="text" id="nombreCompleto" name="nombreCompleto" size="77" tabindex="4" disabled= "true" 
			          readonly="true" iniforma='true'/>
				</td>
			
			
			</tr>
				<tr>
						<td class="label"><label for="lblestatus">Estatus: </label></td>
						<td>  <select id="estatusEmp" name="estatusEmp"  path="estatusEmp" tabindex="5" iniForma= "false">
						      <option value="0">TODOS</option>
						      <option value="A">ACTIVO</option>
						      <option value="I">INCAPACIDAD</option>
						      <option value="B">BAJA</option>
							 </select>
						      
					  	</td>
		   </tr>  
			<tr>
				<td class="label"> 
				
			         <label for="lblFechaInicio">Fecha Inicial:</label> 
				</td>
				<td>
				<input type="text" id="fechaInicio" name="fechaInicio" esCalendario="true" tabindex="6" />
				</td>
			</tr>
			<tr>
				<td class="label"> 
			         <label for="lblFechaFin">Fecha Final:</label> 
				</td>
				<td>
				<input type="text" id="fechaFin" name="fechaFin" esCalendario="true" tabindex="7" />
				
				</td>
			</tr>
			</table>
	</td>
	<td>
		<br>
		<table width="200px" style="height: 100%" > 
			<tr>
				<td class="label" style="position:absolute;top:10%;" >
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend><label>Presentaci&oacute;n</label></legend>
					<input type="radio" id="exel" name="exel" value="exel" tabindex="5"/>
				<label>Excel</label>
				<br>
								 	
				</fieldset>
					<input type="hidden" name="reporte" id="reporte" />
				</td>      
			</tr>
		</table>
	 </td>
 </tr>		
</table>  
<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr>
		<td align="right">
			 <a id="ligaGenerar" href="/reporteCambioEstatus.htm" target="_blank" > 
			<input type="button" id="consultar" name="consultar" class="submit" value="Generar" tabindex="8"/>
			</a>
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
<div id="Contenedor" style="display: none;"></div>
<div id="mensaje" style="display: none;"></div>
</html>

  