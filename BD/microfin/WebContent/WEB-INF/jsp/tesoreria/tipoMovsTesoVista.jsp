<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
      <script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 
	  <script type="text/javascript" src="dwr/interface/TiposMovTesoServicioScript.js"></script> 
      <script type="text/javascript" src="js/tesoreria/tiposMovTesoreria.js"></script>
     </head>
<body>

<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Tipos de Movimientos de Tesorer&iacute;a</legend>
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="tiposMovTeso"> 	            
<table border="0" cellpadding="0" cellspacing="0" width="100%">     
	<tr>
		<td class="label"> 
	    	<label for="lblinstitucionID">Concepto:</label> 
	   	</td>
	    <td> 
        	<form:input id="tipoMovTesoID" name="tipoMovTesoID" path="tipoMovTesoID"  size="11" tabindex="1" /> 		   	
	   	</td> 
	</tr>
	<tr>	
		<td class="label"> 
	    	<label for="lblnumCtaAhorro">Descripci&oacute;n:</label> 
	  	</td> 
	    <td>
	    	<form:textarea id="descripcion" rows="2"  tabindex="2" style="margin-left: 1.05556px; margin-right: 1.05556px; width: 586px;" name="descripcion" path="descripcion"
	    					onBlur="ponerMayusculas(this)" />
	    </td>   		 
	<tr>	
	     <td >
	          <label for="lblnumCtaClabe">Editable:</label> 
	     </td>
	     <td>
	          <input type="checkbox" id="cuentaEditableChek" name="cuentaEditableChek"   path="cuentaEditableChek"   /> 
                     	  <form:input type="hidden" id="cuentaEditable" name="cuentaEditable"   path="cuentaEditable" value="N" /> 
         </td>
		</tr> 
	     		
		<tr id="trCtaContable">
	  
	   	<td class="label"> 
	         <label for="lblcuentaCompleta">Cuenta Contable:</label> 
	     	</td>
	     	<td> 
        		
        		<form:input id="cuentaContable" name="cuentaContable" path="cuentaContable" size="25" tabindex="3" />		         	
        		<input id="descripcionCta" name="descripcionCta" size="80" tabindex="8" disabled="true"  >
				
	     	</td>	    				    			     		
	   </tr> 
       <tr>
                 
                       	 
	    <tr id="trCtaMayor">	
	     	 
                <td >
	          <label for="lblnumCtaClabe">Cuenta Mayor:</label> 
	          </td>
	          <td>
                     <form:input  id="cuentaMayor" name="cuentaMayor" path="cuentaMayor" value="" maxlength="4"  tabindex="4" /> 
                  </td>
		</tr> 
                    
	 
</table>
<table>
 <tr>
	<td>
	<br> <br>
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend><label>Naturaleza Contable:</label></legend>
							<input type="radio" id="naturaContableCargo" name="nat" path="naturaContable" value="C" />
			<label> Cargo </label>
            <br>
			<input type="radio" id="naturaContableAbono" name="nat" path="naturaContable" value="A">
				<form:input type="hidden" id="naturaContable" name="naturaContable" path="naturaContable" value="" />
		<label> Abono </label>
	 	
		</fieldset>
	</td>      
	</tr>
	    
	</table>
	
           <br>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
		<tr>
			<td align="right">
	      	<input type="submit" id="agrega" name="agrega" class="submit" value="Agrega"/>
			<input type="submit" id="modifica" name="modifica" class="submit"  value="Modifica"/>
			<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
                 
			</td>
		</tr>
	</table>				
</form:form> 
</fieldset>
</div>

<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"> </div>
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	

</body>
</html>