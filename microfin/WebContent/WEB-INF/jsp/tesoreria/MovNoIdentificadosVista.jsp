<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>	
		<script type="text/javascript" src="dwr/engine.js"></script>
      	<script type="text/javascript" src="dwr/util.js"></script>     
		<script type="text/javascript" src="js/forma.js"></script>
		
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script> 
	   	
	<script type="text/javascript" src="js/tesoreria/movNoIdentificados.js"></script>
	
		<style>
			.cajatexto{
                border-width:0;
                border-color: #000000;
                font-size: 12px;
            }
		</style>
	   	
	<title>Mov. No Identificados</title>
	</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">                
		<legend class="ui-widget ui-widget-header ui-corner-all">Movimientos no identificados</legend>
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="movNoIdentificadosBean"> 
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
					   	<td class="label"> 
					         <label for="lblinstitucionID">Instituci&oacute;n:</label> 
						</td>
					    <td> 
			         		<form:input id="institucionID" name="institucionID" path="institucionID" size="15"  tabindex="1" />
			         	</td> 
			         	<td colspan="3"> 			         	
			         		<input id="nombreInstitucion" name="nombreInstitucion" size="40" tabindex="4" disabled="true" readonly="true" />
					    </td>
					</tr> 						 
					<tr>  
						<td class="label"> 
							<label for="lblcueNumCtaInstit">Cuenta Bancaria:</label> 
						</td>
					    <td >
							<form:input id="cuentaAhoID" name="cuentaAhoID" path="cuentaAhoID"  size="20" tabindex="2" />
							<form:input type="hidden" name="numCtaInstit" id="numCtaInstit" path="numCtaInstit"/>
						</td>  	
					    <td colspan="3">
							<input id="nombreSucurs" name="nombreSucurs"  size="40"  tabindex="6" disabled="true" readonly="true" />
						</td> 
					</tr> 
					<tr>
				     	<td class="label"> 
				      		<label for="lblfecha">Fecha de Registro:</label> 
				     	</td> 
				      	<td>
					     	<form:input id="fechaMov" name="fechaMov" path="fechaMov" esCalendario="true" size="11" tabindex="3" /> 
					   </td>  	
					</tr>	
					<tr>
						<td class="separador" colspan="2">&nbsp;</td> 	
					</tr>	
				</table>
				
				</br>
				
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Agregar movimiento</legend>
						<table  border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label"><label for="lblDescripcion">Descripcion</label></td>
								<td class="label"><label for="lblReferencia">Referencia</label></td>
								<td class="label"><label for="lblNaturaleza">Naturaleza</label></td>
								<td class="label"><label for="lblFecha">Fecha Movimiento</label></td>
								<td class="label"><label for="lblCantidad">Cantidad</label></td>
							</tr>			
							<tr>
								<td><input type="text" name="desDescripcion" id="desDescripcion" tabindex="4" size="40"/></td>
								<td><input type="text" name="desReferencia" id="desReferencia" tabindex="4" size="10"/></td>
								<td><select name="tipMov" id="tipMov" tabindex="5">
										<option value="C">Cargo</option>
										<option value="A">Abono</option>
									</select></td>
								<td><input type="text" name="fechaDescripcion" id="fechaDescripcion" tabindex="6"/></td>
								<td><input type="text" name="montoDescripcion" id="montoDescripcion" esMoneda="true" tabindex="7"/></td>
							</tr>	
						</table>
				</fieldset>
				
				<fieldset class="ui-widget ui-widget-content ui-corner-all">
					<legend>Detalle de los movimiento</legend>
						<table name="detalleOperacion" id="detalleOperacion"  border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="label"><label for="lblnumero">N&uacute;m</label></td>
								<td class="label"><label for="lbldescripcion">Descripcion</label></td>
								<td class="label"><label for="lblreferencia">Referencia</label></td>
								<td class="label"><label for="lblnaturaleza">Naturaleza</label></td>
								<td width="10%">&nbsp;</td>
								<td class="label"><label for="lblfecha">Fecha Movimiento</label></td>
								<td width="10%">&nbsp;</td>
								<td class="label"><label for="lblcantidad">Cantidad</label></td>
							</tr>			
						</table>
				</fieldset>
				<input type="hidden" id="numeracion" name="numeracion" value="0"/>
				
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				
				<table border="0" cellpadding="0" cellspacing="0" width="100%"> 
						<tr>
							<td colspan="5">
								<table align="right">
									<tr>
										<td align="right">
											<input type="submit" id="grabar" name="grabar" class="submit" value="Guardar" />			
										</td>
									</tr>
								</table>		
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
