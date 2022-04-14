<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	
		<head>	
			<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	 		<script type="text/javascript" src="js/cuentas/repCtasLimitesExced.js"></script>		
		</head>
	<body>
			
			<div id="contenedorForma">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repCtasLimitesExcedBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-header ui-corner-all">Cuentas con Límites Excedidos</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr> 
	 			<td> 	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend><label>Par&aacute;metros</label></legend>		
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
							      <td class="label"> 
							         <label for="fechaInicio">Fecha Inicio: </label> 
							      </td>
							      <td>
							         <input type="text" id="fechaInicio" name="fechaInicio" size="12" autocomplete="off" esCalendario="true" tabindex="1" />  
							      </td> 
							      <td class="separador"></td> 	
						 	</tr> 
							<tr>
						      <td class="label"> 
						         <label for=""fechaFinal"">Fecha Final: </label> 
						    	</td>
						      <td>
						         <input type="text" id="fechaFin" name="fechaFin" autocomplete="off" esCalendario="true" size="12" tabindex="2" />    
						      </td> 
						      <td class="separador"></td> 
						 	</tr> 
						 	<tr>
						      <td class="label"> 
						         <label for="sucursalRegistroID">Sucursal: </label> 
						      </td>
						      <td>
						         <input type="text" id="sucursalID" name="sucursalID" size="12" tabindex="4" value="0"/> 
						          <input type="text" id="sucursalDes" name="sucursalDes" size="40" tabindex="5" value="TODAS" readonly="true"/> 
						      </td> 
						      <td class="separador"></td>   
						 	</tr> 
						 		
						 	<tr>
						      <td class="label"> 
						         <label for="estatusSolicitud">Motivo: </label> 
						    	</td>
						      <td>
						         <select id="motivo" name="motivo" tabindex="3" >
						         	<option value=''>SELECCIONAR</option>
						         	<option value='0'>TODOS</option>
						         	<option value='3'>SUPERÓ EL LÍMITE DE ABONOS PERMITIDOS EN EL MES</option>
						         	<option value='4'>SUPERÓ EL SALDO MÁXIMO DE LA CUENTA</option>						  
						         </select>
						      </td> 
						      <td class="separador"></td>   
						 	</tr> 
						 	
						 </table>	
				</fieldset>		
						 
							 <table align="left" >   
								<tr>	
									<td class="label" >
										<fieldset class="ui-widget ui-widget-content ui-corner-all"> 
										 <legend ><label>Presentaci&oacute;n</label></legend>	
											<input type="radio" id="pdf" name="tipoReporte" value="1" tabindex="6"/>
											<label> PDF </label>
											<br>
											<input type="radio" id="excel" name="tipoReporte" value="2" tabindex="7"/>
											<label> EXCEL </label>
										</fieldset>
									</td>
								</tr>
							</table>
							 <br>
							 <br>
							 
						<table align="right">
							<tr>
								<td> 		 
									<input type="button" id="generar" name="generar" class="submit" tabIndex="8" value="Generar" />
								</td>
							</tr>
						</table>	
					</td>
					</tr>
					</table>
					</form:form> 
				</fieldset>
				
			</div> 
			
			<div id="cargando" style="display: none;"></div>
			<div id="cajaLista" style="display: none;">
			<div id="elementoLista"/> </div>
	</body>
	<div id="mensaje" style="display: none;"/>
</html>