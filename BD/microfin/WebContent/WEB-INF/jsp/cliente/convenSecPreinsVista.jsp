<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>

		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/convencionSeccionalServicio.js"></script> 
 	   	<script type="text/javascript" src="dwr/interface/tarjetaDebitoServicio.js"></script> 
 	   	<script type="text/javascript" src="dwr/interface/convenSecPreinsServicio.js"></script>  
		<script type="text/javascript" src="js/cliente/convenSecPreinsVista.js"></script> 
</head>
<body>

<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Registro Asambleas</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="convenSecPreinsBean">  	
			<fieldset class="ui-widget ui-widget-content ui-corner-all">                
			<legend>Datos del Socio</legend>

				<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
				     <td class="label"> 
				         <label for="lbltipoRegistro">Tipo Registro:</label> 
				     </td>
				     <td> 
				         <form:select id="tipoRegistro" name="tipoRegistro" path="tipoRegistro" tabindex="1">
								<form:option value="">SELECCIONAR</form:option>
								<form:option value="PAS">PREINSCRIPCI&Oacute;N SECCIONAL</form:option>
								<form:option value="PAG">PREINSCRIPCI&Oacute;N GENERAL</form:option>
								<form:option value="IAS">REGISTRO SECCIONAL</form:option>
								<form:option value="IAG">REGISTRO GENERAL</form:option>
							</form:select>  
				     </td>
		     		<td class="label">
				     	<label id="lblcantDis" for="lblcantDis">Disponibles:</label>
				     </td>
				     <td >
				      	<input id="cantDis" name="cantDis"  size="5" readonly="true" /> 
					 </td>
					 <td class="label">
				     	<label   id="lblcantOcupa" for="lblcantOcupa">Ocupados:</label>
				     </td>
				     <td >
				      	<input id="cantOcupa" name="cantOcupa"  size="5" readonly="true" /> 
					 </td>
					 
					<td class="label">
				     	<label id="lblcantPre" for="lblcantPre">Preinscritos:</label>
				     </td>
				     <td >
				      	<input id="cantPre" name="cantPre"  size="5" readonly="true" /> 
					 </td>
					 <td class="label">
				     	<label   id="lblcantIns" for="lblcantIns">Inscritos:</label>
				     </td>
				     <td >
				      	<input id="cantIns" name="cantIns"  size="5" readonly="true" /> 
					 </td>
				     
				 	</tr> 	
				 	<tr>
				     <td class="label"> 
				         <label for="lblfecha">Fechas:</label> 
				     </td>
				     
				     <td> 
				         <form:select id="fecha" name="fecha" path="fecha" tabindex="2" >
								<form:option value="">SELECCIONAR</form:option>
							</form:select>  
				     </td> 
				 	</tr> 	
				  	<tr>
				     <td class="label"> 
				         <label for="lblsucursalID">Sucursal:</label> 
				     </td>
				     
				     <td> 
				         <form:select id="sucursalID" name="sucursalID" path="sucursalID" tabindex="3" >
								<form:option value="">SELECCIONAR</form:option>
							</form:select>  
				     </td> 
				 	</tr> 
				 	<tr>
				     <td class="label"> 
				         <label for="lblnoTarjeta">N&uacute;mero de Tarjeta:</label> 
				     </td> 
				     <td>
				      	<form:input id="noTarjeta" name="noTarjeta" path="noTarjeta" size="20" tabindex="3" type="text"/> 
						<input id="idCtePorTarjeta" name="idCtePorTarjeta" size="20" type="hidden" />
						<input id="nomTarjetaHabiente" name="nomTarjetaHabiente" size="20" type="hidden" />
					 </td>
				 	</tr> 
				  <tr>
				     <td class="label"> 
				         <label for="lblnoSocio">Socio:</label> 
				     </td> 
				     <td>
				      	<form:input id="noSocio" name="noSocio" path="noSocio" size="11" tabindex="4" /> 
					</td>
					</tr>
					<tr>
					<td></td>
					<td>
				      	<form:input id="nombreCompleto" name="nombreCompleto" path="nombreCompleto" size ="60" tabindex="5" readOnly="true"/> 
					 </td>
				 	</tr> 	
			 		<tr>
					<td colspan="5" align="right">
						<input type="submit" id="agrega" name="agrega" class="submit" value="Registrar"  tabindex="6" />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>				
					</td>
				</tr>
				</table>
		</fieldset>
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

<script language="javascript">

</script>
</html>