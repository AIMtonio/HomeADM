<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>    
<html>
<head>	
       	<script type="text/javascript" src="dwr/interface/bitacoraPagoNominaServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/institucionNomServicio.js"></script>
      	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script> 
      	<script type="text/javascript" src="dwr/interface/pagoNominaServicio.js"></script> 
		 <script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>     	
      	<script type="text/javascript" src="js/nomina/aplicacionPagosCredNom.js"></script> 
      	
</head>
<body>

<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="pagoNominaBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Aplicaci&oacute;n de Pagos de Cr&eacute;dito N&oacute;mina</legend>
		
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
	<td class="label" nowrap="nowrap"><label for="lblInstitucion">Empresa N&oacute;mina:</label></td>
	<td nowrap="nowrap" colspan="4"> 
	   <form:input type="text" id="institNominaID" path="institNominaID" size="11" tabindex="1" iniforma="false"/>
	   <input type="text" id="nombreEmpresa" name="nombreEmpresa" size="77" tabindex="2" disabled= "true" readonly="true" iniforma='false'/>
	</td>
  </tr> 
  <tr>
    <td class="label"><label for="lblBanco">Banco:</label></td>
	<td colspan="4" nowrap="nowrap">
	   <input type="text" id="institucionID" name="institucionID" tabindex="3" path="institucionID" size="11" />
	   <input type="text" id="nombreInstitucion" name="nombreInstitucion" size="77" tabindex="4" disabled= "true" readonly="true" />  
	</td>
  </tr>
  <tr>
    <td class="label"><label for="lblBanco">Cuenta Depósito:</label></td>
	<td colspan="4">
	   <form:input id="numCuenta" tabindex="5" path="numCuenta" size="20" />
	   <input type="hidden" id="centroCostoID" name="centroCostoID">
	</td>
  </tr>
  <tr>
    <td nowrap="nowrap" class="label"><label for="lblFoliosPendientes">Folios Pendientes:</label></td>
	<td>
	   <select id="foliosPendientes" name="foliosPendientes" tabindex="6" path="foliosPendientes">
	   		<option>SELECCIONA</option>
	   </select>
	</td>
	<td class="separador"></td>
	<td class="label"><label for="lblMontoFP">Monto:</label></td>
	<td> 
	   <form:input  id="montoPagos" path="montoPagos"  size="10" tabindex="7" disabled= "true" readonly="true" style="text-align: right"/>  
    </td>
  </tr>
   <tr>
    <td colspan="5"><br></td>
  </tr>
  <tr> 
  	<td colspan="5" align="center" >
  	   <input type="button" id="verificaPagoBancos" name="verificaPagoBancos" class="submit" value="Verificar Depósito" tabindex="8" style="display:none" />
  	</td>
  </tr>
  <tr>
    <td colspan="5"><br></td>
  </tr>
  <tr>
    <td nowrap="nowrap" class="label"><label id="lbldepositoBancos" for="lblDepBancos" style="display:none">Depósito en Bancos:</label></td>
	<td colspan="4">
	   <select id="depositoBancos" name="depositoBancos" tabindex="9" path="depositoBancos" style="display:none">
	   		<option>SELECCIONA</option>
	   </select>
	</td>
  </tr>
  <tr>
    <td colspan="5"><br></td>
  </tr>
  <tr>
  	<td colspan="5">
  	<div id="gridPagosPendientes"  style="display:none" ></div>
  	</td>
  </tr>
</table>



<table border="0" cellpadding="2" cellspacing="0" width="98.5%">
  <tr>
    <td class="label"><label for="lblTotal">Total:</label></td>
	<td>
	   <input type="text" id="totalPagos" name="totalPagos" tabindex="10"  readOnly="true" size="12" disabled="true" style="text-align: right" />
	</td>
	<td class="label" align="right"><label>Seleccionar Todos</label></td>
	<td align="center"><input type="checkbox" id="seleccionaTodos" name="seleccionaTodos"  onclick="seleccionarTodos()"/>	
	</td>
  </tr>
  </table>
  <table border="0" cellpadding="2" cellspacing="0" width="100%">
  <tr>
    <td class="label"><label for="lblDepBancos">Motivo Cancelación:</label></td>
	<td>
	   <textArea type="text" id="motivoCancela" name="motivoCancela" tabindex="11" size="50" cols="47" rows="3"  maxlength = "100"  onblur="ponerMayusculas(this)" />
	</td>
  </tr>
</table>
		
  <table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr>
			<td align="right">
				<input type="submit" id="realizarPagos" name="realizarPagos" class="submit" value="Procesar" tabindex="12" />
				<input type="submit" id="cancelarPagos" name="cancelarPagos" class="submit" value="Cancelar" tabindex="13" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
				<input type="hidden" id="fechaAplica" name="fechaAplica" />
			</td>
		</tr>

  </table> 
 </fieldset>
</form:form> 
</div>
<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	</body>
	<div id="mensaje" style="display: none;"></div>
</html>