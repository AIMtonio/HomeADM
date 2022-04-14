<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	
		<head>	
			<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	 		<script type="text/javascript" src="js/cliente/reporteApoyoEscolarSol.js"></script>		
		</head>
	<body>
			
			<div id="contenedorForma">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="reporteApoyoEscolarSolBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Apoyos Escolares</legend>	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend >Par&aacute;metros</legend>		
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
						         <label for="estatusSolicitud">Estatus Solicitud: </label> 
						    	</td>
						      <td>
						         <select id="estatus" name="estatus" tabindex="3" >
						         	<option value=''>TODOS</option>
						         	<option value='P'>PAGADO</option>
						         	<option value='X'>RECHAZADO</option>
						         	<option value='A'>AUTORIZADO</option>
						         	<option value='R'>REGISTRADO</option>
						         </select>
						      </td> 
						      <td class="separador"></td>   
						 	</tr> 
						 	<tr>
						      <td class="label"> 
						         <label for="sucursalRegistroID">Sucursal Solicitud: </label> 
						      </td>
						      <td>
						         <input type="text" id="sucursalRegistroID" name="sucursalRegistroID" size="12" tabindex="4" value="0"/> 
						          <input type="text" id="sucursalRegistroDes" name="sucursalRegistroDes" size="40" tabindex="5" value="TODAS" readonly="true"/> 
						      </td> 
						      <td class="separador"></td>   
						 	</tr> 	
						 </table>	
				</fieldset>		
						 
							 <table align="left" >   
								<tr>	
									<td class="label" >
										<fieldset class="ui-widget ui-widget-content ui-corner-all"> 
										 <legend >Presentaci&oacute;n</legend>	
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
									<a id="ligaGenerar" href="/reporteApoyoEscolar.htm" target="_blank" >  		 
										<input type="button" id="generar" name="generar" class="submit" tabIndex="8" value="Generar" />
									</a>
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