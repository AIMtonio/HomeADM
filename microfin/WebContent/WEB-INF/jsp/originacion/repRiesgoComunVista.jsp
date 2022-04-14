<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
     	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>   
		<script type="text/javascript" src="dwr/interface/destinosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="js/originacion/repRiesgoComun.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repRiesgoComunBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Riesgo Com&uacute;n</legend>
		<table border="0" cellpadding="0" cellspacing="0">
         <tr> 
         	<td> 
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>P&aacute;rametros</label></legend>         
          			<table  >
				
						<tr> 
							<td class="label">
								<label for="clienteID">Cliente: </label>
							</td>
							<td colspan="4" >
								<form:input id="clienteID" name="clienteID" path="clienteID" tabindex="1"	size="12"/>
								<input type="text"id="nombreCliente" name="nombreCliente" size="39"  readOnly="true" />
							</td>
						</tr>	
						<tr> 
							<td class="label">
								<label for="sucursalSolCredID">Sucursal Sol. Cr&eacute;dito: </label>
							</td>
							<td colspan="4" >
								<form:input id="sucursalSolCredID" name="sucursalSolCredID" path="sucursalSolCredID" tabindex="2"	size="12"/>
								<input type="text"id="sucursalSolCredNombre" name="sucursalSolCredNombre" size="39"  readOnly="true" />
							</td>
						</tr>	
						<tr>
							<td class="label"> 
								<label for="estatus">Estatus: </label> 
							</td>
							<td>
								<select id="estatus" name="estatus" path="etatus" tabindex="3" >
									<option value=''>TODOS</option>
									<option value='P'>PENDIENTE</option>
									<option value='R'>REVISADO</option>					  
								</select>
							</td> 
						</tr>
						<tr>
							<td class="label"> 
								<label for="riesgoComun">Riesgo Com&uacute;n: </label> 
							</td>
							<td>
								<select id="riesgoComun" name="riesgoComun" path="riesgoComun" tabindex="4" >
									<option value=''>TODOS</option>
									<option value='S'>SI</option>
									<option value='N'>NO</option>
								</select>
							</td> 
						</tr>
						<tr>
							<td class="label"> 
								<label for="persRelacionada">Persona Relacionada: </label> 
							</td>
							<td>
								<select id="persRelacionada" name="persRelacionada" path="persRelacionada" tabindex="5" >
									<option value=''>TODOS</option>
									<option value='S'>SI</option>
									<option value='N'>NO</option>
								</select>
							</td> 
						</tr>
						<tr>
							<td class="label"> 
								<label for="procesado">Procesado: </label> 
							</td>
							<td>
								<select id="procesado" name="procesado" path="procesado" tabindex="6" >
									<option value=''>TODOS</option>
									<option value='S'>SI</option>
									<option value='N'>NO</option>
								</select>
							</td> 
						</tr>
  					</table> 
  				</fieldset> 
  			</td>  
      		<td>
				<table > 
					<tr>
						<td >
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
								<input type="radio" id="excel" name="generaRpt" value="excel" tabindex="7">
								<label> Excel </label>
						 	</fieldset>
						</td>      
					</tr>
				</table> 
			</td>
  		</tr>
	</table>
	<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
	<input type="hidden" id="tipoLista" name="tipoLista" />
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td colspan="4" align="right" border='0'>
				<a id="ligaGenerar" href="RepSaldosTotalesCredito.htm" target="_blank" >  		 
					<input type="button" id="generar" name="generar" class="submit" tabIndex = "8" value="Generar" />
				</a>
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