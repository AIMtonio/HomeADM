<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
	<script type="text/javascript" src="js/credito/reqtosCobranza.js"></script>
</head>
<body>


<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Requerimientos de Cobranza</legend>
	
		<form id="formaGenerica" name="formaGenerica" method="POST" commandName="creditosBean" target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<fieldset class="ui-widget ui-widget-content ui-corner-all">                
						<legend><label>Par&aacute;metros</label></legend>         
          				<table  border="0"  width="560px">
							<tr>
								<td>
									<label>Nivel de Requerimiento:</label>
								</td>
								<td><select id="requerimientoID" name="requerimientoID" tabindex="3" >
									  <option value="1">Primer Requerimiento</option>
									  <option value="2">Segundo Requerimiento</option>
									  <option value="3">Tercer Requerimiento</option>
									</select>			   										 
								</td>
								<td colspan="3"></td>
							</tr>	
							<tr>
								<td>
									<label><s:message code="safilocale.cliente"/>:</label>
								</td>
								<td>
									<input id="clienteID" name="clienteID" size="15" tabindex="1"/>
									<input id="nombreCliente" name="nombreCliente" size="50" tabindex="2" readOnly="true"/>
								</td>
								<td colspan="3"></td>
							</tr>			
						</table>
						</fieldset>  
					</td> 
					<td> 	
						<table width="200px"> 
							<tr>
						
							<td class="label" style="position:absolute;top:12%; display: none;">
							<fieldset class="ui-widget ui-widget-content ui-corner-all">                
							<legend><label>Presentaci&oacute;n</label></legend>
									<input type="radio" id="pdf" name="pdf" value="pdf" />
									<label> PDF </label>
						            <br>
									<input type="radio" id="pantalla" name="pantalla" value="pantalla">
								<label> Excel </label>				 	
								</fieldset>
								<input type="hidden" name="reporte" id="reporte" />
							</td>      
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>								
					<td align="right" colspan="4">
					<a id="ligaImp" href="ReqtosCobranzaReporte.htm" target="_blank" >
		             		<button type="button" class="submit" id="imprimir" style="">
		              		Generar
		             		</button> 
	            </a>					
					</td>
				</tr>
			</table>
		</form>
	</fieldset>
	
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>