<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>                                             
<script type="text/javascript"	src="dwr/interface/bitacoraEstatusTarDebServicio.js"></script>
<script type="text/javascript"	src="dwr/interface/tarjetaDebitoServicio.js"></script>
<script type="text/javascript"	src="dwr/interface/tarjetaCreditoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
<script type="text/javascript"	src="js/tarjetas/bitacoraEstatusTarDeb.js"></script>

</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bitacoraEstatusTarDeb">
<fieldset class="ui-widget ui-widget-content ui-corner-all">
<legend class="ui-widget ui-widget-header ui-corner-all">Consulta Bit&aacute;cora de Estatus de Tarjeta</legend>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<input type="hidden" name="tipoTarjeta" id="tipoTarjeta" value="1">
					
					<td class="label">
						<label> Tipo de Tarjeta</label>
						<input type="radio" id="tipoTarjetaDeb" name="tipoTarjetaDeb">
						<label> D&eacute;bito</label>
						<input type="radio" id="tipoTarjetaCred" name="tipoTarjetaCred">
						<label> Cr&eacute;dito </label>
					</td>
				</tr>
				<tr>
					<td class="label" colspan="2" >
						<label for="lblNumeroTarjeta">N&uacute;mero Tarjeta:</label>
						<input  type="text" id="tarjetaDebID" name="tarjetaDebID" path="tarjetaDebID" maxlength="16" tabindex="1" size="20"   />
			        </td>
					<td class="separador"></td> 	
					<td class="label">
					  	<label for="lblEstatus">Estatus: </label>
				   </td>
					<td>
						<input type="text" id="estatus" name="estatus"  readOnly="true" size="40"  />	
					</td>
				</tr>	
		</table> 
			<div> 
			<br>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Datos Tarjeta</legend>
					<table>
		     			 <tr>
							 <td class="label">
					  			<label for="lblCliente">Tarjetahabiente: </label>
							 </td>
							 <td >
								<input type="text" id="clienteID" name="clienteID" readOnly="true" size="15"  />
					
								<input type="text" id="nombreCompleto" name="nombreCompleto"  readOnly="true" size="50"  />	
							</td>
			  			</tr>
			  			<tr id="cteCorpTr">
							 <td class="label">
					  			<label for="lblCteCorporativo">Corporativo (Contrato): </label>
							 </td>
							 <td >
								<input type="text" id="coorporativo" name="coorporativo" readOnly="true" size="15"  />
								<input type="text" id="nombreCoorp" name="nombreCoorp"  readOnly="true" size="50"  />	
							</td>
			  			</tr>
			  			<tr id="cuentaAhorro">
							<td class="label" >
								<label for="lblNumeroCuenta" id="ctaDebito">Cuenta Asociada:</label>
			               </td >
			 		       <td >
		       		 	         <input  type="text" id="cuentaAho" name="cuentaAho" path="cuentaAho" readOnly="true"  size="15"  />
					  	       	<label for="tipoCuenta"  id="tipoCuenta">Tipo Cuenta: </label> 
						     	 <input type="text" id="nombreTipoCuenta" name="nombreTipoCuenta"  readOnly="true" size="30"  />	
					       </td>
			  			</tr>
			  			<tr id="lineaCredito">
							<td class="label" >
								<label for="lblLineaCuenta" id="lineaCred">Producto:</label>
			               </td >
			 		       <td >
		       		 	         <input  type="text" id="productoID" name="productoID" path="productoID" readOnly="true"  size="15"  />
						      	 <input type="text" id="descripcionProd" name="descripcionProd" readOnly="true" size="50"  />		
					       </td>
			  			</tr>
			  			<tr>
							 <td class="label">
					  			<label for="lblTipoTarjeta">Tipo Tarjeta: </label>
							 </td>
							 <td >
								<input type="text" id="tipotarjetaID" name="tipoTarjetaDebID" readOnly="true" size="15"/>
								<input type="text" id="nombreTarjeta" name="nombreTarjeta"  readOnly="true" size="50"  />	
							</td>
			  			</tr>
		     		</table>
		     	</fieldset>
		     	<br>
		     </div>	
		<table align="right">
				<tr>
					<td align="right">
					<button type="button" class="submit"  id="consultar" tabindex="2" >Consultar</button> 								
					</td>
				</tr>
		</table>
		<br>
		<br>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			   <tr>	
					<td colspan="20">
					 <div id="gridBitEstatusTarDeb" style="display: none;" />							
					</td>
				</tr>
				<tr>
					<td align="right">
						<a id="ligaGenerar" href="ReporteBitacoraEstatusTarDeb.htm" target="_blank" > 
						<button type="button" class="submit" id="generar" style="display: none" tabindex="3">Exportar PDF</button> 	
						</a>
													
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