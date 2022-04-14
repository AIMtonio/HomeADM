<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
<script type="text/javascript" src="dwr/interface/tesoMovsServicio.js"></script>
<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>
<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script> 
<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
<script type="text/javascript" src="dwr/interface/depositosRefeServicio.js"></script>
<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
<script type="text/javascript" src="js/tesoreria/DepositosReferenciados.js"></script>
<title>Deposito Referenciado</title>
</head>
<body>
	<div id="contenedorForma">
		<form:form method="POST" commandName="depositosReferencia" enctype="multipart/form-data" name="formaGenerica" id="formaGenerica">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Archivo Dep&oacute;sito Referenciado</legend>
				<table border="0"  width="100%">
					<tr>
						<td>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0" width="100%">
								<tr>
								    <td class="label">
								        <label for="institucionID">Instituci&oacute;n: </label> 
								    </td>
								    <td >
								        <input type="text" id="institucionID" name="institucionID"  size="24" tabindex="1" autocomplete="off"/>
								        <input type="text" id="nombreInstitucion" name="nombreInstitucion" size="50" disabled="true" readOnly="true"/> 
								    </td>                                            
								</tr>         
								<tr>
								    <td class="label">
								        <label for="cuentaBancaria">Cuenta Bancaria: </label> 
								    </td>
								    <td>
								    	<input type="text" id="cuentaBancaria" name="cuentaBancaria"  size="24" tabindex="2" autocomplete="off"/>
								    	<input type="hidden" id="cuentaAhoID" name="cuentaAhoID"  size="20" value="s" />
								        <input type="text" id="nombreBanco" name="nombreBanco" size="50" disabled="true" readOnly="true"/> 
								    </td>
								</tr>
								<tr>
									<td class="label"> 
										<label for="radioFormatoEstandar">Formato:</label> 
								   	</td>
									<td class="label" colspan="3">
										<label for="radioFormatoBanco">Banco</label> 
										<input type="radio" id="radioFormatoBanco" name="formatoBanco" value="B" tabindex="3"  />
										&nbsp;&nbsp;
										<label for="radioFormatoEstandar">Est&aacute;ndar</label> 
										<input type="radio" id="radioFormatoEstandar" name="formatoEstandar" value="E" checked="checked" tabindex="4" />
										<a href="javaScript:" onClick="descripcionCampo('formatoBanco');">
											<img src="images/help-icon.gif" >
										</a>
									</td>
								</tr>
							</table>
							</fieldset>
						</td>
					</tr>			
					<tr>
						<td colspan="3">
						<br/>
							<fieldset id="fechas" class="ui-widget ui-widget-content ui-corner-all">
							<legend class="label"><label>Rango de Fechas:</label></legend>	
							<table border="0" width="100%">
								<tr> 
									<td class="label"> 
										<label for="fechaCargaInicial">Fecha Inicial:</label> 
								   	</td> 
									<td> 
										<form:input type="text" id="fechaCargaInicial" name="fechaCargaInicial"  size="14" tabindex="5" 
											    		path="fechaCargaInicial" esCalendario="true" autocomplete="off"/> 
									</td>
									<td class="separador"></td>
									<td class="label"> 
										<label for="fechaCargaFinal">Fecha Final:</label> 
									</td> 
									<td> 
									  	<form:input type="text" id="fechaCargaFinal" name="fechaCargaFinal"  size="14" tabindex="6" 
											path="fechaCargaFinal" esCalendario="true" autocomplete="off"/> 
								   </td> 
								</tr>
							</table>
							</fieldset>
						</td>	
					</tr>
					<tr>
						<td colspan="3" id="canales">
						<br/>
							<fieldset class="ui-widget ui-widget-content ui-corner-all">
							<table border="0"  width="100%">
								<tr>
									<td noWrap>
										<label for="lblResultados">Tipo Referencia:</label>
									</td>
									<td class="separador"></td>
									<td>	
										<input type="radio" id="tipoReferenciaCredito" name="tipoReferenciaCredito"
							 					value="1" tabindex="7" checked="checked" /><label for="tipoReferenciaCredito">Crédito</label>
							 		</td>
								</tr>	
								<tr>
									<td class="separador"></td>
									<td class="separador"></td>
									<td>	
										<input type="radio" id="tipoReferenciaCuenta" name="tipoReferenciaCuenta" 
							 					value="2" tabindex="8" /><label for="tipoReferenciaCuenta">Cuenta</label>
							 		</td>
								</tr>	
								<tr>
									<td class="separador"></td>
									<td class="separador"></td>
									<td>	
										<input type="radio" id="tipoReferenciaCliente" name="tipoReferenciaCliente"
							 					value="3" tabindex="9"  /><label for="tipoReferenciaCliente">Cliente</label>
							 		</td>
								</tr>
								<tr>
									<td>
										<label for="lblResultados">Moneda:</label>
									</td>
									<td class="separador"></td>
									<td>	
										<select id="tipoMoneda" name="tipoMoneda" disabled>
											<option value="1">PESOS</option>			
										</select> 
<!-- 											nota:esto solo es para mostrarlo en pantalla el valor verdadero esta en las clases correpondientes  -->
							 		</td>
								</tr>
								<tr>
									<td>
										<form:input type="hidden" id="tipoCanal" name="tipoCanal" path="tipoCanal" value="1" />
									</td>
								</tr>
							</table>
							</fieldset>
						</td>
					</tr>
					<tr>
						<td><div id="divRegreso"></div>
							<label for="lblResultadosDB">
									
							</label>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td id="tdVerDepositos"align="left" style="display:none;">
										<input type="button" id="verDeposito" name="verDeposito" class="submit" value="Ver Depósitos" tabindex="10" />								
									</td>
									<td align="right">									
										<input type="button" id="enviar" name="enviar" class="submit" value="Enviar Archivo" tabindex="11" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
										<input type="hidden" id="bancoEstandar" name="bancoEstandar" value="E" />
										<input type="hidden" id="numTranAnt" name="numTranAnt" value="0"/>
										<input type="hidden" id="cargaLayoutXLSDepRef" name="cargaLayoutXLSDepRef"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				
			<fieldset class="ui-widget ui-widget-content ui-corner-all" id="formaGrid" style="display: none;">                
		 	  <legend bgcolor="#81DAF5">Registros Por Cargar</legend>
		 	  <table>
		 	  		<tr>
		 	  			<td>
		 	  				<label for="lblTotalRegistros">Total Registros:</label>
		 	  			</td> 
		 	  			<td>
		 	  				<input id="totalRegistros" name="totalRegistros" size="5" readOnly="true" style='text-align:left;'/>
		 	  			</td> 
		 	  		</tr>
		 	  		<tr>
		 	  			<td>
		 	  				<label for="lblExitosos">Exitosos:</label> 
		 	  			</td>
		 	  			<td>
		 	  				<input id="totalExitosos" name="totalExitosos" size="5" readOnly="true"  style='text-align:left;'/>
		 	  			</td> 
		 	  		</tr>
		 	  		<tr>
		 	  			<td>
		 	  				<label for="lblFallidos">Fallidos:</label> 
		 	  			</td> 
		 	  			<td>
		 	  				<input id="totalFallidos" name="totalFallidos" size="5" readOnly="true"  style='text-align:left;'/>
		 	  			</td> 
		 	  		</tr>
		 	  	</table>

		 	  	<br>
				<div id="gridDepositoArchivo" style="display: none; width:100%; height:285px; overflow: scroll;"></div>
				<table align="right">
					<tr>
						<td id="tdBtnProcesar"align="left">
							<input type="submit" id="btnProcesar" name="btnProcesar" class="submit" value="Procesar" tabindex="13" />
							<input type="hidden" id="listaAplicaRef" name="listaAplicaRef" />
							<input type="hidden" id="fechaSistema" name="fechaSistema" val=""/>
						</td>
						
						<td id="tdBtnBorrarCarga"align="left" style="display:none;">
							<input type="submit" id="borrarCarga" name="borrarCarga" class="submit" value="Borrar Carga" tabindex="14" />
						</td>
						
					</tr>
				</table>
				</fieldset>
			</fieldset>
		</form:form>
	</div>
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"></div>
	</div>
</body>
<div id="mensaje" style="display: none;"></div>
	<div id="ContenedorAyuda" style="display: none;">
		<div id="elementoLista"/>
	</div>
</html>