<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%> 
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html> 
<head> 
	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/estadosServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/municipiosServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/notariaServicio.js"></script>
      <script type="text/javascript" src="dwr/interface/escrituraServicio.js"></script>     
      <script type="text/javascript" src="js/cliente/escriturasCatalogo.js"></script> 

</head> 
<body> 
<div id="contenedorForma"> 
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="escrituraPubBean"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Escritura P&uacute;blica</legend>			
	<table border="0" width="100%">
		<tr>
    		<td class="label"> 
         		<label for="ClienteID">No. <s:message code="safilocale.cliente"/>: </label> 
     		</td>
     		<td>
         		<form:input id="clienteID" name="clienteID" path="clienteID" size="12" tabindex="1" iniforma='false' />  
         		<input type="text" id="nombreCliente" name="nombreCliente" size="50" tabindex="2" disabled= "true" readOnly="true"/>  
          	</td> 
       		<td class="separador"></td> 
       		<td class="label"> 
         		<label for="Consecutivo">N&uacute;mero: </label> 
     		</td> 
     		<td> 
         		<form:input id="consecutivoEsc" name="consecutivoEsc" path="consecutivo" size="10" tabindex="3" iniforma='false' />  
     		</td> 
      	</tr> 
		<tr> 
      		<td class="label"> 
         		<label for="tipo escritura">Tipo de Acta: </label> 
     		</td> 
     		<td> 
        		<form:select id="esc_Tipo" name="esc_Tipo" path="esc_Tipo" tabindex="4">
					<form:option value="-1">SELECCIONAR</form:option>
					<form:option value="C">CONSTITUTIVA</form:option>
					<form:option value="P">DE PODERES</form:option> 
				</form:select>
     		</td> 
          	<td class="separador"></td> 
          	<td class="label"> 
         		<label for="EscrituraPub">Escritura P&uacute;blica: </label> 
     		</td> 
     		<td> 
         		<form:input id="escrituraPub" name="escrituraPub" path="escrituraPub" size="15" tabindex="5" maxlength="50" onBlur=" ponerMayusculas(this)" /> 
     		</td> 
        </tr>   
        <tr> 
	     	<td class="label"> 
	        	<label for="LibroEscritura">Libro: </label> 
	     	</td> 
	     	<td> 
	        	<form:input id="libroEscritura" name="libroEscritura" path="libroEscritura" size="15" tabindex="6" maxlength="50" onBlur=" ponerMayusculas(this)" /> 
	     	</td> 
	        <td class="separador"></td> 
			<td class="label"> 
	        	<label for="volumenEsc">Volumen: </label> 
	     	</td> 
	     	<td> 
	        	<form:input id="volumenEsc" name="volumenEsc" path="volumenEsc" size="15" tabindex="7" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
	     	</td> 
 		</tr> 
 		<tr> 
    		<td class="label"> 
       			<label for="FechaEsc">Fecha: </label> 
     		</td> 
     		<td> 
         		<form:input id="fechaEsc" name="fechaEsc" path="fechaEsc" size="15" tabindex="8" esCalendario="true"/> 
    		 </td> 
          	<td class="separador"></td> 
			<td class="label" nowrap="nowrap"> 
         		<label for="estado">Entidad Federativa: </label> 
     		</td> 
     		<td> 
         		<form:input id="estadoIDEsc" name="estadoIDEsc" path="estadoIDEsc" size="7" tabindex="9" /> 
         		<input type="text" id="nombreEstadoEsc" name="nombreEstadoEsc" size="35"  disabled="true" readOnly="true"/>   
     		</td>  
 		</tr> 
		<tr>
			<td class="label"> 
         		<label for="LocalidadEsc">Localidad: </label> 
     		</td> 
     		<td> 
		        <form:input id="localidadEsc" name="localidadEsc" path="localidadEsc" size="6" tabindex="10" /> 
		        <input type="text" id="nombreMuniEsc" name="nombreMuniEsc" size="35"  disabled="true"
		          readOnly="true"/>   
     		</td>  
     		<td class="separador"></td> 
		    <td class="label"> 
		        <label for="Notaria">Notaria: </label> 
		    </td> 
		    <td> 
		        <form:input id="notaria" name="notaria" path="notaria" size="7" tabindex="11" /> 
		    </td> 
 		</tr> 
		<tr> 
      		<td class="label" nowrap="nowrap"> 
         		<label for="DirecNotaria">Direcci&oacute;n de Notaria: </label> 
     		</td> 
     		<td> 
         		<form:input id="direcNotaria" name="direcNotaria" path="direcNotaria" size="90" 
         			readOnly="true" /> 
     		</td> 
		     <td class="separador"></td>
		     <td class="label" nowrap="nowrap" 	> 
		         <label for="NomNotario">Nombre del Notario: </label> 
		     </td> 
		     <td> 
		         <form:input id="nomNotario" name="nomNotario" path="nomNotario" size="45" readOnly="true" /> 
		     </td> 
		</tr>  
 	</table>
</fieldset>  
 
<div id= "apoderados" style="display: none;"> 
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend>Información Apoderados</legend>	
	<table border="0" width="100%"> 		
 		<tr> 
      		<td class="label"> 
        		<label for="nomApoderado">Nombre del Apoderado: </label> 
     		</td> 
    		<td> 
         		<form:input id="nomApoderado" name="nomApoderado" path="nomApoderado" size="55" maxlength="150"
	          		tabindex="12" onBlur=" ponerMayusculas(this)" /> 
    	 	</td> 
			<td class="separador"></td> 
     		<td class="label"> 
         		<label for="RFCApoderado">RFC del Apoderado: </label> 
     		</td> 
		    <td> 
		         <form:input id="RFC_Apoderado" name="RFC_Apoderado" path="RFC_Apoderado" size="15" tabindex="13" maxlength="13"
		         onBlur=" ponerMayusculas(this)"/> 
		    </td> 
 		</tr> 
 		<tr> 
			<td class="label"> 
				<form:radiobutton id="estatusV" name="estatusV" path="estatus" value="V" tabindex="14" checked="checked" />
				<label for="fisica">Vigente</label>&nbsp;&nbsp;
				<form:radiobutton id="estatusR" name="estatusR" path="estatus" value="R" tabindex="15"/>
				<label for="fisica">Revocado</label> 	
 			</td> 
			<td class="separador"></td>
			<td class="separador"></td>  
	     	<td class="label"> 
         		<label for="Observaciones">Observaciones: </label> 
     		</td> 
     		<td> 
         		<form:textarea id="observaciones" name="observaciones" path="observaciones"  tabindex="16" COLS="30"
         				onBlur=" ponerMayusculas(this)" ROWS="3" maxlength="250"></form:textarea>  
     		</td>  
 		</tr> 
 	</table>
</fieldset>
</div>
 
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Registro P&uacute;blico</legend>	
<table border="0" width="100%"> 		
	<tr> 
		<td class="label"> 
        	<label for="RegistroPub">Registro P&uacute;blico: </label> 
     	</td> 
     	<td> 
         	<form:input id="registroPub" name="registroPub" path="registroPub" size="15" tabindex="17" onBlur=" ponerMayusculas(this)" maxlength="10"/> 
     	</td> 
		<td class="separador"></td> 
     	<td class="label"> 
			<label for="FolioRegPub">Folio: </label> 
     	</td> 
     	<td> 
         	<form:input id="folioRegPub" name="folioRegPub" path="folioRegPub" size="15" tabindex="18" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
     	</td> 
    </tr>  
    <tr> 
		<td class="label"> 
       		<label for="VolumenRegPub">Volumen: </label> 
     	</td> 
     	<td> 
        	<form:input id="volumenRegPub" name="volumenRegPub" path="volumenRegPub" size="15" tabindex="19" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
     	</td> 
		<td class="separador"></td>
     	<td class="label"> 
        	<label for="LibroRegPub">Libro: </label> 
     	</td> 
     	<td>  
        	<form:input id="libroRegPub" name="libroRegPub" path="libroRegPub" size="15" tabindex="20" maxlength="10" onBlur=" ponerMayusculas(this)"/> 
     	</td> 
   	</tr> 
	<tr> 
		<td class="label"> 
         	<label for="AuxiliarRegPub">Auxiliar: </label> 
     	</td> 
     	<td>  
        	<form:input id="auxiliarRegPub" name="auxiliarRegPub" path="auxiliarRegPub" size="15" tabindex="21" maxlength="20" onBlur=" ponerMayusculas(this)" /> 
     	</td>
		<td class="separador"></td> 
     	<td class="label"> 
         <label for="FechaRegPub">Fecha: </label> 
     	</td>  
    	<td> 
         <form:input id="fechaRegPub" name="fechaRegPub" path="fechaRegPub" size="15" tabindex="22" 
         	esCalendario="true"/> 
     	</td>      
   	</tr> 
	<tr>
		<td class="label"> 
         <label for="LocalidadEsc">Entidad Federativa: </label> 
     </td> 
     <td> 
         <form:input id="estadoIDReg" name="estadoIDReg" path="estadoIDReg" size="7" tabindex="23" /> 
         <input type="text" id="nombreEstadoReg" name="nombreEstadoReg" size="35" disabled="true"
          readOnly="true"/>   
     </td>  	
		<td class="separador"></td>	
		<td class="label"> 
         <label for="LocalidadRegPub">Localidad: </label> 
     	</td> 
     	<td>
     	<form:input id="localidadRegPub" name="localidadRegPub" path="localidadRegPub" size="7" tabindex="24" /> 
     	<input type="text" id="nombreMuniReg" name="nombreMuniReg" size="40" disabled="true"
          readOnly="true"/>   
     </td>  
   </tr> 
</table>


<table align="right">
	<tr>
		<td align="right">
			<input type="submit" id="agrega" name="agrega" class="submit" 
			 value="Agregar" tabindex="25" />
			<input type="submit" id="modifica" name="modifica" class="submit" 
			 value="Modificar" tabindex="26"/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
		</td>
	</tr>
</table>	  
   </fieldset>
</form:form> 
</div> 
<div id="cargando"style="display: none;"></div> 

<div id="cajaLista" style="display: none;" >
	<div id="elementoLista"></div>
</div>

<div id="cajaListaCte" style="display: none;overflow-y: scroll;height:200px;">
    <div id="elementoListaCte"></div>
</div>

</body>

<div id="mensaje" style="display: none;"></div>

</html>