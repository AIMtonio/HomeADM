<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	
		<head>	
			<script type="text/javascript" src="dwr/interface/repConvenSecServicio.js"></script>
	 		<script type="text/javascript" src="js/cliente/repConvenSec.js"></script>		
		</head>
	<body>
			
			<div id="contenedorForma">
				<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repConvenSecBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">		
				<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Registro de Asambleas</legend>	
					<fieldset class="ui-widget ui-widget-content ui-corner-all">		
					<legend >Par&aacute;metros</legend>		
						<table border="0" cellpadding="0" cellspacing="0" width="100%">

							<tr>
						      <td class="label"> 
						         <label for="tipoRep">Tipo: </label> 
						    	</td>
						      <td>
						         <select id="tipoRep" name="tipoRep" tabindex="1" >
						         	<option value=''>SELECCIONAR</option>
						         	<option value='1'>PREINSCRIPCION</option>
						         	<option value='2'>INSCRIPCION</option>
						         	<option value='3'>PROSPECTOS</option>
						         </select>
						      </td> 
						      <td class="separador"></td>   
						 	</tr> 
						 								<tr>
							      <td class="label"id="lfecIni"> 
							         <label for="fechaInicio">Fecha Inicio: </label> 
							      </td>
							      <td class="label"id="lfec"> 
							         <label for="fechaInicio">Fecha: </label> 
							      </td>
							      <td>
							         <form:input type="text" id="fechaInicio" name="fechaInicio" path="fechaInicio" size="14" autocomplete="off" esCalendario="true" tabindex="2" />  
							      </td> 
							      <td class="separador"></td> 	
						 	</tr> 
							<tr>
						      <td class="label" id="lfecFin"> 
						         <label for="fechaFinal">Fecha Final: </label> 
						    	</td>
						      <td id="fecFin">
						         <form:input type="text" id="fechaFin" name="fechaFin" path="fechaFin" autocomplete="off" esCalendario="true" size="14" tabindex="3" />    
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
											<input type="radio" id="excel" name="tipoReporte" tabindex="4"/>
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
									<input type="hidden" id="tipoLista" name="tipoLista" />
									<a id="ligaGenerar" href="/RepConvencionSeccional" target="_blank" >  		 
										<input type="button" id="generar" name="generar" class="submit" tabIndex="5" value="Generar" />
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