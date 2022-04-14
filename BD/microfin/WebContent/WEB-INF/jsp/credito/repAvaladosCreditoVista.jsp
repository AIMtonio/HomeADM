<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="dwr/interface/avaladosCreditoRepServicio.js"></script>	
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/promotoresServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>  
	<script type="text/javascript" src="js/credito/repAvaladosCredito.js"></script>
</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all" >
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte Avales</legend>	
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="avaladosCreditoRepBean"  target="_blank">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			  <tr>
					<td class="label"> 
					<label><s:message code="safilocale.cliente"/> Inicio:</label>
					</td>
					<td>
					<form:input type="text" name="clienteInicial" id="clienteInicial" path="clienteInicial" autocomplete="off" size="12" tabindex="1" />	
					<input type="text" name="nombreClienteInicial" id="nombreClienteInicial" path="nombreClienteInicial" autocomplete="off" size="40" disabled="true"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
					<label><s:message code="safilocale.cliente"/> Final:</label>
					</td>
					<td>
					<form:input type="text" name="clienteFinal" id="clienteFinal" path="clienteFinal" autocomplete="off" size="12" tabindex="2" />	
					<input type="text" name="nombreClienteFinal" id="nombreClienteFinal"  path="nombreClienteFinal" autocomplete="off" size="40" disabled="true"/>
					</td>
				</tr>
				<tr>
					<td class="label"> 
					<label>Fecha Inicio: </label>
					</td>
					<td>
					<form:input type="text" name="fechaInicial" id="fechaInicial" path="fechaInicial" autocomplete="off" size="12" tabindex="3"  esCalendario="true"/>						
					</td>
					<td class="separador"></td>
					<td class="label"> 
					<label>Fecha Final: </label>
					</td>
					<td>
					<form:input type="text" name="fechaFinal" id="fechaFinal" path="fechaFinal" autocomplete="off" size="12" tabindex="4"  esCalendario="true"/>						
					</td>
				</tr>					
				<tr>
					<td class="label"> 
					<label>Promotor: </label>
					</td>
					<td>
					<form:input type="text" name="promotor" id="promotor" path="promotor" autocomplete="off" size="12" tabindex="5"/>						
					<input type="text" name="nombrePromotor" id="nombrePromotor" path="nombrePromotor" autocomplete="off" size="40" disabled="true"/>
					</td>
					<td class="separador"></td>
					<td class="label"> 
					<label>D&iacute;as de Mora: </label>
					</td>
					<td>
					<form:input type="text" name="diasMora" id="diasMora" path="diasMora" autocomplete="off" size="12" tabindex="6" />						
					</td>
				</tr>
				<tr>
					<td class="label"> 
					<label>Sucursal: </label>
					</td>
					<td>
						<form:select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="7">
							<form:option value="0">TODAS</form:option>
						</form:select>											
					</td>
					<td class="separador"></td>
					<td class="label" nowrap="nowrap"> 
					<label>Producto de Cr&eacute;dito: </label>
					</td>
					<td>
						<form:select id="producCreditoID" name="producCreditoID" path="producCreditoID"  tabindex="8" >
				         <form:option value="0">Todos</form:option>
					      </form:select>									 
					</td>
				</tr>
				<tr>
				<td class="label" nowrap="nowrap"> 
					<label>Estatus Cr&eacute;dito: </label>
				</td>
				<td>
					<form:select id="estatus" name="estatus" path="estatus"  tabindex="9" >
				         <form:option value="V">VIGENTE</form:option>
				         <form:option value="P">PAGADO</form:option>
				         <form:option value="B">VENCIDO</form:option>
				         <form:option value="K">CASTIGADO</form:option>
				         <form:option value="I">INACTIVO</form:option>
				         <form:option value="A">AUTORIZADO</form:option>
				         <form:option value="C">CANCELADO</form:option>
					     </form:select>
				</td>
				</tr>
				<tr>
					<td>
						<form:input type="hidden" name="nombreInstitucion" id="nombreInstitucion" path="nombreInstitucion" size="30" />
				   		<form:input type="hidden" name="nombreUsuario" id="nombreUsuario" path="nombreUsuario" size="30" />
				   		<form:input type="hidden" name="fechaSistema" id="fechaSistema" path="fechaSistema" size="12" />								 			 	  
					</td>
				</tr>
				<tr>
				<td class="label">
				<br>
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend><label>Presentaci&oacute;n: </label></legend>
							<input type="radio" id="excel" name="excel" /" tabindex="10">
							<label> Excel </label><br> 	
							<input type="radio" id="pdf" name="pdf" value="pdf" tabindex="11">
							<label> PDF </label>
						</fieldset>
					</td>
				</tr>		
					
				<tr>		
					<td colspan="5">
						</br>
						<table align="right" border='0'>
							<tr>
								<td width="350px">
									&nbsp;					
								</td>								
								<td align="right">
									<input type="button" id="generar" name="generar" class="submit" tabindex="12" value="Generar" />
									<input type="hidden" id="alertSocio" name="alertSocio" value="<s:message code="safilocale.cliente"/>"/>
								</td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</form:form>
	</fieldset>
</div>
				
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>

</body>
</html>