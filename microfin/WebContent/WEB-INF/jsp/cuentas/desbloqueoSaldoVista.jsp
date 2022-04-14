<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
	<head>	
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/tiposCuentaServicio.js"></script>   
 	   	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
 	   	<script type="text/javascript" src="dwr/interface/monedasServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/bloqueoSaldoServicio.js"></script> 
	   	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/huellaDigitalServicio.js"></script>
		<script type="text/javascript" src="js/soporte/ServerHuella.js"></script>	
		<!--script type="text/javascript" src="js/cuentas/bloqueoSaldoPet.js"></script-->     

        <script type="text/javascript" src="js/cuentas/desbloqueoSaldoPre.js"></script>     
	</head>
	<body>
		<div id="contenedorForma">
			<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="bloqueoSaldoPet">
				<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend class="ui-widget ui-widget-header ui-corner-all">Desbloqueo Manual de Saldo</legend>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr> 
				    		<td class="label"> 
				    	     	<label for="lblClienteID"><s:message code="safilocale.cliente"/>: </label> 
				     		</td> 
				     		<td> 
				        	 	<form:input type="text"  id="clienteID"  name="clienteID" path="clienteID" size="11" tabindex="1" />
				         		<input id="nombreCte"  name="nombreCte"size="70" type="text"  
				         				readOnly="true" disabled = "true" iniForma = 'false'/>
				     		</td> 
				         	<td class="separador"></td> 				
						   	<td class="label"> 
						   		<label for="lblSucursalID">Fecha: </label> 
						   	</td> 
						   	<td> 
						      	<form:input id="fechaMov" name="fechaMov" path="fechaMov" size="12" readOnly="true"/>						     
							</td>						   
						</tr> 
			 			<tr>
                   			<td></td>				 		
				 		</tr>
				 	</table>	
					<br>
				 	<div id="gridAhoCte"></div>
				 	<br>
				 	<div id="contenedorBloqueos"></div>
				 	<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
				 	<table align="right">
						<tr>
							<td align="right">
								<input type="submit" id="agregar" name="agregar" class="submit" value="Agrega" tabindex="8"/>
								<input type="hidden" id="operacion" value="2" name="operacion"/>	
								<input type="hidden" id="tipoTransaccion" value="2" name="tipoTransaccion"/>
								<input type="hidden" id="lisCuentas" value="" name="lisCuentas" size="500"/>
								<input type="hidden" id="lisDesc" value="" name="lisDesc" size="500"/>
								<input type="hidden" id="lisDesbloq" value="" name="lisDesbloq" size="500"/>										
								<input type="hidden" id="lisTipoD" value="" name="lisTipoD" size="500"/>
								<input type="hidden" id="lisMonto" value="" name="lisMonto" size="500"/>
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