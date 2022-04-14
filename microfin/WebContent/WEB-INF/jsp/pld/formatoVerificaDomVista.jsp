<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
	
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
		<script type="text/javascript" src="js/pld/formatoVerificaDom.js"></script>
	</head>

	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="formatoVerificaDomBean">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
				<legend class="ui-widget ui-widget-header ui-corner-all">Formato Verificación de Domicilio</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="650px">
						<tr> 
							<td> 
								<fieldset class="ui-widget ui-widget-content ui-corner-all">                
									<legend><label>Parámetros</label></legend>         
				          			<table  border="0"  width="610px">		
										<tr>		
											<td class="label"> 
										       	<label for="clientelb">No. <s:message code="safilocale.cliente"/>: </label> 
										    </td> 	
										   	<td nowrap= "nowrap"> 
											    <input id="clienteID" name="clienteID"  size="11" /> 
										        <input type="text" id="nombreCliente" name="nombreCliente" size="50" readOnly="true"/>    
										  	</td>
										  	<td class="label"> 
										       	<label for="clientelb">Estatus: </label> 
										    </td>
										    <td nowrap= "nowrap"> 
										        <input type="text" id="estatusCliente" name="estatusCliente"  size="11" readOnly="true"/>   
										  	</td>
										  	 					
										</tr>
										
										<tr>		
											<td class="label"> 
										       	<label for="sucursallb">Num. Sucursal <s:message code="safilocale.cliente"/>: </label>  
										    </td> 	
										   	<td nowrap= "nowrap"> 
											    <input id="sucursalID" name="sucursalID" size="11" readOnly="true"/> 
										        <input type="text" id="nombreSucursal" name="nombreSucursal" size="50" readOnly="true"/>   
										  	</td>
			  								<input id="valCliente" name="valCliente" size="10" type="hidden" value="<s:message code="safilocale.cliente"/>" /> 					
										</tr>
										
									</table>
								</fieldset>
							</td>
						</tr>  
								
						<tr>
							<td align="right">
								<input type="hidden" id="tipoReporte" name="tipoReporte" class="submit" />
								<a id="ligaGeneraRep"  target="_blank" >  		 
									 <input type="button" id="generar" name="generar" class="submit" 
											 tabIndex = "48" value="Generar" />
								</a>
							</td>
						</tr>
						
						<tr>
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