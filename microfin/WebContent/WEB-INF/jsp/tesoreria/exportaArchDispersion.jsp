<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>	
		<script type="text/javascript" src="dwr/engine.js"></script>
      	<script type="text/javascript" src="dwr/util.js"></script>     
		<script type="text/javascript" src="js/forma.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
	   	
	   	
	   	<script type="text/javascript" src="js/tesoreria/exportarDispersion.js"></script>
	      
 
		
		 
	      
	</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
	<legend class="ui-widget ui-widget-header ui-corner-all">Exportar Archivo de Dispersi&oacute;n </legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operDispersion"> 
		<table border="0" cellpadding="0" cellspacing="0" width="100%" >
			<tr>
				<td class="label"> 
					<label for="lblpolizaID">Folio Dispersión: </label> 
		     	</td> 
		     	
		     	<td colspan="2"> 
		      		<form:input id="folioOperacion" name="folioOperacion" path="folioOperacion" size="20" tabindex="1" autocomplete="off" /> 
		     	</td> 
		     	
		     	<td class="separador"></td> 	
		     	
		     	<td class="label"> 
		      		<label for="lblfecha">Fecha de Dispersi&oacute;n:</label> 
		     	</td> 
		      	<td colspan="2">
			     	<form:input id="fechaActual" name="fechaActual" path="fechaOperacion"  size="15" tabindex="2"  disabled="true" /> 
			   </td>  	
			</tr>	
			<tr>
			   	<td class="label"> 
			         <label for="lblinstitucionID">Instituci&oacute;n:</label> 
				</td>
			    <td> 
	         		<form:input id="institucionID" name="institucionID"  disabled="true" path="institucionID" size="20"  tabindex="3" />
	         	</td> 
	         	<td colspan="1"> 			         	
	         		<input id="nombreInstitucion" name="nombreInstitucion" size="50" tabindex="4"  readonly="true" />
			    </td>
		     	<td class="separador"></td> 
		     	<td class="separador"></td> 
		     	<td class="separador"></td> 
			</tr> 						 
			<tr>  
				<td class="label"> 
					<label for="lblcueNumCtaInstit">Cuenta Bancaria:</label> 
				</td>
				<td>
					<input id="cuentaAhorro" name="cuentaAhorro"  readonly="readonly" size="20" tabindex="5" />
					<form:input type="hidden" name="numCtaInstit" id="numCtaInstit" path="numCtaInstit" /> 
				</td>  	
				<td colspan="1">
					<input id="nombreSucurs" name="nombreSucurs"  size="50"  tabindex="6"  readonly="true" />
					<input type="hidden" id="detalleDispersion" name="detalleDispersion" size="100" /> 
				</td> 
		     	<td class="separador"></td> 
		     	<td class="separador"></td> 
		     	<td class="separador"></td> 
			</tr> 
			<tr>  
				<td class="label"> 
					<label for="lblSaldo">Saldo:</label> 
				</td>
				<td colspan="6">
					<input id="saldo" name="saldo"  size="20" tabindex="5" esMoneda="true" readonly="readonly" style="text-align: right;" />
				</td> 
			</tr> 	
				
			 			
									
		</table>
		<table width="100%">	
			<tr>
				<td colspan="7">
					<input type="hidden" name="tipoAccion" id="tipoAccion" value="3"/>
					<c:set var="listaResultado"  value="${listaResultado[0]}"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				</td>
			</tr>
			<tr>  
				<td class="label"> 
					<label for="lblExporta"> </label> 
				</td>
				<td align="right">		
					<a id="enlaceExp" href="exportaDispercionTxt.htm" target="_blank">
						 <input type="button" class="submit" id="exportarArchivo" value="Exportar archivo" />
					</a>
					<a id="archOrdenPago" href="exportaDispercionTxt.htm" target="_blank">
						<input type="button" class="submit" id="exportarArchivoOrdenPago" value="Exportar archivo de Orden de Pago" />
				   </a>
				   <a id="archTransfer" href="exportaDispercionTxt.htm" target="_blank">
					<input type="button" class="submit" id="exportarArchivoTransfer" value="Exportar archivo de Transferencias" />
			   	  </a>		
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
<div id="mensaje" style="display: none;"></div>
</body>
</html>
