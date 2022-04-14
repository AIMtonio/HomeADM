<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/indiceNaPreConsumidorServicio.js"></script> 
		<script type="text/javascript" src="js/cliente/repInteresesPagados.js"></script>  
	</head>
	<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="repInteresesPagados">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Intereses Pagados </legend>
				<table border="0" width="340px">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
								<legend><label>Par&aacute;metros</label></legend>         
								<table border="0" width="300px">
									<tr> 
										<td class="label"> 
									    	<label for=fechaInicio>Fecha de Inicio:</label> 
										</td> 		     		
									    <td>
									    	<input  type="text" id="fechaInicio" name="fechaInicio" size="12" esCalendario="true" tabindex="1"/> 
									   	</td> 	
									</tr>
									<tr> 
										<td class="label"> 
									    	<label for=fechaInicio>Fecha de Fin:</label> 
										</td> 		     		
									    <td>
									    	<input  type="text" id="fechaFin" name="fechaFin"  esCalendario="true" tabindex="2" size="12"/> 
									   	</td> 	
									</tr>					
								</table>
							</fieldset>  
						</td>
					</tr>	
					<tr>
						<td>
							<table width="150px">
								 <tr>							
									<td class="label" >
										<fieldset class="ui-widget ui-widget-content ui-corner-all">                
										<legend><label>Presentaci&oacute;n</label></legend>
											<input type="radio" id="excel" name="tipoReporte" tabindex="4">
											<label> Excel </label>
										</fieldset>
									</td>      
								</tr>
							</table>
						</td>
					</tr>
					<table  width="335px">
						<tr>
							<td align="right">
								<a id="ligaGenerar" href="/RepBitacoraSol" target="_blank" >  		 
									<input type="button" id="generar" name="generar" class="submit" tabIndex="4" value="Generar" />
								</a>
								<input type="hidden" id="tipoLista" name="tipoLista" />

							</td>
						</tr>
					</table>
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