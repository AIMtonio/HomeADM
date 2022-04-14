<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>

	<head>	
	  <script type="text/javascript" src="dwr/interface/solBuroCredServicio.js"></script> 
      <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
       <script type="text/javascript" src="dwr/interface/localidadRepubServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
 	  <script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>  
		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/circuloCreTipConServicio.js"></script>
      <script type="text/javascript" src="js/buroCredito/reporteBC.js"></script> 
	</head>
<body>

<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solBuroCreditoBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend class="ui-widget ui-widget-header ui-corner-all">Reporte de Buró Crédito </legend>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		
	<legend >Tipo de Consulta: </legend>			
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
		 		<td class="label">
		 			<label for="lblSolicitud">Consulta a Bur&oacute; de Crédito</label>
		 		</td>
		 		<td>
		 			<input type="radio" id="consultaBC" tabindex="1" onclick="limpiaformulario2();" >
		 		</td>
		 		<td class="separador"></td>
		 		
		 		<td class="label">
		 			<label for="lblSolicitud">Consulta a Círculo de Crédito</label>
		 		</td>
		 		<td>
		 			<input type="radio" id="consultaCC" tabindex="2"  onclick="limpiaformulario2();">
		 		</td>
			</tr>
		</table>
	</fieldset>
	<br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">		

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
	 		<td class="label"> 
	         <label for=lblFolio>Folio de Consulta: </label> 
	     	</td>
	     	<td>
	         <form:input id="folioConsulta" name="folioConsulta" path="folioConsulta" size="12" tabindex="8"  />   
			</td>
			<td class="separador"></td>
			<td class="label"> 
	         <label for=lblFechaCon>Fecha de Consulta: </label> 
	     	</td>
			<td>
	         <form:input id="fechaConsulta" name="fechaConsulta" path="fechaConsulta" size="20" tabindex="10" disabled="true" />   
			</td>
		</tr>
		<tr>
			<td class="label">
				<label for="primerNombre">Primer Nombre:</label>
			</td>
			<td>
				<form:input id="primerNombre" name="primerNombre" path="primerNombre" tabindex="1" onBlur=" ponerMayusculas(this)" disabled="true" />
			</td>		
			<td class="separador"></td>
			<td class="label">
				<label for="segundoNombre">Segundo Nombre: </label>
				</td>
				<td >
					<form:input id="segundoNombre" name="segundoNombre" path="segundoNombre" 
					 tabindex="2" onBlur=" ponerMayusculas(this)" disabled="true" />
				</td>
				<td class="separador"></td>
			</tr>
			<tr>
				<td class="label">
					<label for="tercerNombre">Tercer Nombre:</label>
				</td>
				<td>
					<form:input id="tercerNombre" name="tercerNombre" path="tercerNombre" tabindex="3" 
					onBlur=" ponerMayusculas(this)" disabled="true" />
				</td>				
				<td class="separador"></td>
				<td class="label">
					<label for="apellidoPaterno">Apellido Paterno:</label>
				</td>
				<td>
					<form:input id="apellidoPaterno" name="apellidoPaterno" path="apellidoPaterno" 
					tabindex="4" onBlur=" ponerMayusculas(this)" disabled="true" />
				</td>		
			</tr>
			<tr>
				<td class="label">
					<label for="apellidoMaterno">Apellido Materno:</label>
				</td>
				<td >
					<form:input id="apellidoMaterno" name="apellidoMaterno" path="apellidoMaterno" 
					tabindex="5" onBlur=" ponerMayusculas(this)" disabled="true" />
				</td>
				<td class="separador"></td>
				<td class="label"> 
		         <label for="lblfecha">Fecha de Nacimiento: </label> 
		     	</td> 
		     	<td> 
		          <form:input id="fechaNacimiento" name="fechaNacimiento" path="fechaNacimiento" size="12" 
		         	 tabindex="6" disabled="true" />  
		     	</td>
	 		</tr> 
	 		<tr>
	    	<td class="label"> 
	         <label for=lblRFC>RFC: </label> 
	     	</td>
	     	<td>
	         <form:input id="RFC" name="RFC" path="RFC" size="17" tabindex="7" disabled="true" />   
			</td>	
			<td class="separador"></td>
	      <td class="label"><label for=diasVigenciaBC>Días Restantes de Vigencia Consulta:</label></td>
	      	<td> 
	         <input type="text" id="diasVigencia" name="diasVigencia" size="4" disabled ="true" readOnly="true"/>
	         
	      	</td>
	   		</tr>
	   		
		</table>
	</fieldset>
	<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">		
		<legend >Dirección</legend>	
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
		 		<td class="label"> 
          			<label for="calle">Calle: </label> 
    			</td> 
    			<td> 
         			<form:input id="calle" name="calle" path="calle" size="45" tabindex="9" disabled="true" /> 
    			</td> 
    			<td class="separador"></td> 
				<td class="label"> 
         			<label for="numero">No. Exterior: </label> 
    			</td> 
     			<td nowrap="nowrap"> 
         			<form:input id="numeroExterior" name="numeroExterior" path="numeroExterior" size="5" tabindex="10" disabled="true" />
    				<label for="interior">Interior: </label>
          			<form:input id="numeroInterior" name="numeroInterior" path="numeroInterior" size="5" tabindex="11" disabled="true" />
          			<label for="piso">Piso: </label>
          			<form:input id="piso" name="piso" path="piso" size="5" tabindex="12" disabled="true" />
     			</td> 
     		</tr>
     		
     		<tr> 
     			<td class="label"> 
         			<label for="Lote">Lote: </label> 
     			</td> 
    			<td> 
         			<form:input id="lote" name="lote" path="lote" size="20" tabindex="13" disabled="true" /> 
     			</td> 
    			<td class="separador"></td> 
     			<td class="label"> 
         			<label for="Manzana">Manzana: </label> 
     			</td> 
     			<td> 
         			<form:input id="manzana" name="manzana" path="manzana" size="20" tabindex="14" disabled="true"/> 
     			</td> 
     		</tr>
     		<tr>
     			<td class="label" nowrap="nowrap"> 
         			<label for="estado">Entidad Federativa: </label> 
     			</td> 
    			<td> 
         			<form:input id="estadoID" name="estadoID" path="estadoID" size="6" tabindex="16" disabled="true" /> 
         			<input type="text" id="nombreEstado" name="nombreEstado" size="35" tabindex="17" disabled ="true" readOnly="true"/>   
     			</td> 
    			<td class="separador"></td> 
     			<td class="label"> 
         			<label for="municipio">Municipio: </label> 
     			</td> 
    			<td> 
         			<form:input id="municipioID" name="municipioID" path="municipioID" size="6" tabindex="18" disabled="true" /> 
         			<input type="text" id="nombreMuni" name="nombreMuni" size="35" tabindex="19" disabled="true" readOnly="true"/>   
     			</td>     			
     		</tr> 
     		<tr> 
	          	<td class="label"><label for="calle">Localidad: </label></td> 
	     		<td nowrap="nowrap"> 
	         		<form:input id="localidadID" name="localidadID" path="localidadID" size="6" tabindex="19"  disabled="true" readonly="true"  /> 
	     			<input type="text" id="nombreLocalidad" name="nombreLocalidad" size="35" tabindex="20" disabled="true" onBlur=" ponerMayusculas(this)" readonly="true"/>   
	     		</td>  
     			
     			<td class="separador"></td> 
     			<td class="label"><label for="calle">Colonia: </label></td> 
	     		<td nowrap="nowrap"> 
	    			<input type="text" id="nombreColonia" name="nombreColonia" size="35" tabindex="20" disabled="true"  onBlur=" ponerMayusculas(this)"  readonly="true"/>   
	     		</td> 
			</tr> 
			<tr>
				<td class="label"> 
        			<label for="CP">C.P.: </label> 
     			</td> 
     			<td> 
         			<form:input id="CP" name="CP" path="CP" size="15" tabindex="20" disabled="true" /> 
     			</td> 
			</tr>
 		 </table>	
 
  </fieldset>
		<table align="right">
			<tr>
				<td align="right">
				<a id="ligaPDF" target="_blank" >
				  <button type="button" class="submit" id="generar" style="">
				  Ver Reporte
				  </button> 
				 </a>	
				<input type="hidden" id="hora" name="hora" size="20"  /> 
					<input type="hidden" id="usuarioCirculo" name="usuarioCirculo"/>
					<input type="hidden" id="contrasenaCirculo" name="contrasenaCirculo"/>
					<input type="hidden" id="claveUsuario" >
					<input type="hidden" id="claveUsuariob">
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