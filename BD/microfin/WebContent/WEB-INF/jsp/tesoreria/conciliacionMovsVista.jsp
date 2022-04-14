<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
	<head>	     
    	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
	   	<script type="text/javascript" src="js/tesoreria/conciliacionMovsVista.js"></script>
	</head>
<body>
<div id="contenedorForma">
<fieldset class="ui-widget ui-widget-content ui-corner-all">                
<legend class="ui-widget ui-widget-header ui-corner-all">Conciliaci&oacute;n Movimientos Cuenta Bancaria</legend>
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="Conciliacion">  	
	<fieldset class="ui-widget ui-widget-content ui-corner-all">           
	<table border="0" cellpadding="0" cellspacing="0" width="100%">     
		<tr>
			<td class="label"> 
		    	<label for="lblinstitucionID">Instituci&oacute;n:</label> 
		   	</td>
		    <td> 
         		<input type="text" id="institucionID" name="institucionID" size="18" tabindex="1" >
         	</td> 
         	<td> 			         	
         		<input type="text" id="nombreInstitucion" name="nombreInstitucion" size="50" tabindex="1" disabled="true" readonly="true">
			</td> 
		    <td class="separador"></td>
		    <td class="label"> 
		    	<label for="lblfecha">Fecha de Conciliaci&oacute;n:</label> 
		    </td>
		    <td >
		    	<input type="text" id="fechaActual" name="fechaActual"  size="11" tabindex="3" disabled="true" readonly="true"/> 
		   	</td>  	
		</tr> 						 
		<tr>  
	     	<td class="label"> 
	        	<label for="lblcueNumCtaInstit">Cuenta Bancaria:</label> 
	     	</td>
	     	<td>
	     		<input type="text" id="cuentaAhorroID" name="cuentaAhorroID"  size="18"  tabindex="2"  /> 
	     		<input type="hidden" id="numCtaInstit" name="numCtaInstit"  size="18"  value="s" />
	     	</td>  	
	     	<td>
	     		<input type="text" id="nombreSucurs" name="nombreSucurs"  size="50"  tabindex="2" disabled="true" readonly="true"/> 
	     	</td> 	
		</tr> 
		<tr>  
	    	<td class="label"> 
	        	<label for="lblcueNumCtaInstit">Monto Conciliado:</label> 
	     	</td>
	     	<td >
		    	<input type="text"  esMoneda="true" id="totalConciliadosVista" name="totalConciliados"  size="18"  tabindex="2" readOnly="true" style="text-align: right" /> 
	     		<input type="hidden"  id="totalConciliados" name="totalConciliados"  size="18"  tabindex="2" readOnly="true" /> 
	     	</td>  		
		</tr> 
		<tr>  
	    	<td class="label"> 
	        	<label for="lblcueNumCtaInstit">Monto No Conciliados:</label> 
	     	</td>
	     	<td >
	     		<input type="text" esMoneda="true" id="totalNoConciVista" name="totalNoConci"  size="18"  tabindex="2" readOnly="true" style="text-align: right" /> 
	     		<input type="hidden" id="totalNoConci" name="totalNoConci"  size="18"  tabindex="2" readOnly="true" /> 
	     	</td>  	
	     	
		</tr> 						
	</table>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
		<tr>  
			<td >
				<div id="contenedorMovs" style="display: none;"></div>
				<br>
			</td>
		</tr> 	
	</table>	
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">  
		<tr>
			<td align="right">
				<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar"  tabindex="4" />
				<input type="submit" id="cerrar" name="cerrar" class="submit" value="Cerrar Conciliacion Movs. Internos" style="display: none;" tabindex="5" iniForma="true"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id="listaFoliosMovs" name="listaFoliosMovs"/>
				<input type="hidden" id="tipoLista" name="tipoLista" value=""/>
			</td>
		</tr>
	</table>
	
	</fieldset>

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
	<div id="elementoLista"></div>
</div>	

</body>
</html>