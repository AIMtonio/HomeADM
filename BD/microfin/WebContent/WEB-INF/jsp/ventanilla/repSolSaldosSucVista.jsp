<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
		<script type="text/javascript" src="js/ventanilla/repSolSaldoSucursal.js"></script>   		     
	</head>
   
<body>
<div id="contenedorForma">													  
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solSaldoSucursalBean">

<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Solicitud de Saldos Por Sucursal</legend>
			<table border="0"  width="100%">    
			<tr>
      <td > 
      <fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend><label>Par&aacute;metros: </label> </legend> 
		<table border="0" width="100%">			
						
						<tr>
							<td class="label">
								<label for="fechaInicio">Fecha Inicial Solicitud: </label>
							</td>
							<td>
								<form:input type="text" id="fechaIni" name="fechaInicio" size="14" tabindex="1" autocomplete="off" path="fechaIni" esCalendario="true"/>
							</td>
						<td class="separador"> </td> 
						</tr>
						<tr>
							<td class="label">
								<label for="fechaFin">Fecha Final Solicitud: </label>
							</td>
							<td>
								<form:input type="text" id="fechaFin" name="fechaFin" size="14" tabindex="2" autocomplete="off" path="fechaFin" esCalendario="true"/>
							</td>
						</tr>
					
						<tr>
							<td class="label"> 
						         <label for="sucursalID">Sucursal Emisi&oacute;n: </label> 
						      </td>
						      <td>
						         <input type="text" id="sucursalID" name="sucursalID" size="12" tabindex="8" value="0" autocomplete="off"/> 
						          <input type="text" id="sucursalDes" name="sucursalDes" size="40" value="TODAS" readonly="true" disabled="disabled"/> 
						      </td> 
						</tr>
						
						</table>
</fieldset>
</td>
			<td>
				<table width="200px">   
			<tr>
						
						 <td class="label" style="position: absolute; top: 13%;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="9"  checked="checked" >
											<label> PDF </label>
											<br>
											<input type="radio" id="excel" name="pdf" value="excel" tabindex="10">
											<label> Excel </label>
										
							</fieldset>
							</td>	
							</tr>
		</table>
		</td>
		</tr>	
						
						<tr>
							<td colspan="5" align="right">	
								<input type="button" class="submit" id="generar" value="Generar" tabindex="5"/> 		
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