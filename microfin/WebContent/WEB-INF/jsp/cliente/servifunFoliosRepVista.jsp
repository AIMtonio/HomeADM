<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
 <%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>   
<html>
	<head>           		     				
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
      	<script type="text/javascript" src="js/cliente/servifunFoliosRep.js"></script>  				
	</head>      
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="castigosCarteraBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">SERVIFUN</legend>
		
			<table border="0" cellpadding="0" cellspacing="0" >
			 <tr> <td> 
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Parámetros</label></legend>         
	         		 <table  border="0" ">
						<tr>
							<td class="label">
								<label for="lblFechaInicio">Fecha de Inicio: </label>
							</td>
							<td colspan="4">
								<input id="fechaInicio" name="fechaInicio" path="fechaInicio" size="12" 
				         			tabindex="1" type="text"  esCalendario="true" />	
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
										
						</tr>
						<tr>			
							<td class="label">
								<label for="creditoID">Fecha de Fin: </label> 
							</td>
							<td colspan="4">
								<input id="fechaFin" name="fechaFin" path="fechaFin" size="12" 
				         			tabindex="2" type="text" esCalendario="true"/>				
							</td>	
							<td class="separador"></td>
							<td class="separador"></td>									
						</tr>
				
						<tr>
							<td>
								<label>Sucursal <s:message code="safilocale.cliente"/>:</label>
							</td>
							<td colspan="4">
							<select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="3" >
						         <option value="0">Todas</option>
							      </select>									 
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
									
						</tr>
						<tr>
							<td>
								<label>Estatus Folio:</label> 
							</td>
							<td colspan="4">
							<select id="estatus" name="estatus" path="estatus"  tabindex="5" >
						         <option value="">TODOS</option>
						         <option value="A">AUTORIZADO</option>
						         <option value="C">CAPTURADO</option>
						         <option value="P">PAGADO</option>
						         <option value="R">RECHAZADO</option>
							      </select>									 
							</td>
							<td class="separador"></td>
							<td class="separador"></td>
																			
						</tr>
				  </table>
		 </fieldset>  
	</td> 
    </tr>
    <tr>
    	<td>
    		<br>
    		<table width="200px">
				 <tr>							
					<td class="label" >
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n</label></legend>
											<input type="radio" id="pdf" name="generaRpt" value="pdf" />
							<label> PDF </label>
				            <br>
							<input type="radio" id="excel" name="generaRpt" value="excel">
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
			<td colspan="4">
				<table align="right" border='0'>
					<tr>
						<td align="right">
					
						<a id="ligaGenerar" href="reporteServifunFolios.htm" target="_blank" >  		 
							 <input type="button" id="generar" name="generar" class="submit" 
									 tabIndex = "48" value="Generar" />
						</a>
						
						</td>
					</tr>
					
				</table>		
			</td>
		</tr>					
	</table>

</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>