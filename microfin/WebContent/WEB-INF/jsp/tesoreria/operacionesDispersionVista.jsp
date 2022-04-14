<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<html>
	<head>	
		<link href="css/redmond/jquery-ui-1.8.16.custom.css" media="all" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="dwr/interface/parametrosSpeiServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/cuentaNostroServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/periodoContableServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/chequesEmitidosServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/parametrosSisServicio.js"></script>
 		
 		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/conceptoDispersionServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/diaFestivoServicio.js"></script>

	   	<script type="text/javascript" src="js/tesoreria/operacionesDispersion.js"></script>
	   	<script type="text/javascript" src="js/tesoreria/opeDispersionGrid.js"></script>
	    <script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
		<script type='text/javascript' src='js/jquery.ui.tabs.js'></script>
		<script>
			$(function() {
				$("#tabs").tabs();
			});
		</script>
		<style>
			.cajatexto{
                border-width:0;
                border-color: #000000;
                font-size: 12px;
            }
		</style>
	</head>
<body>
<div id="contenedorForma">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
	<legend class="ui-widget ui-widget-header ui-corner-all">Operaciones Dispersi&oacute;n de Recursos</legend>
	<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="operDispersion">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" >
			<tr>
				<td class="label">
					<label for="lblpolizaID">Folio de Dispersi&oacute;n: </label>
		     	</td>

		     	<td colspan="3">

		      		<form:input id="folioOperacion" name="folioOperacion" path="folioOperacion" size="20" tabindex="1" autocomplete="off" />
		      		<input type="hidden" id="estatusFolio" name="estatusFolio" value=""/>

		     	</td>

		     	<td class="separador"></td>

		     	<td class="label">
		      		<label for="lblfecha">Fecha de Dispersi&oacute;n:</label>
		     	</td>
		      	<td colspan="2">
			     	<form:input id="fechaActual" name="fechaActual" path="fechaOperacion"  size="10" tabindex="2"  esCalendario="true" />
			   </td>
			</tr>
			<tr>
			   	<td class="label">
			         <label for="lblinstitucionID">Instituci&oacute;n:</label>
				</td>
			    <td>
	         		<form:input id="institucionID" name="institucionID" path="institucionID" size="20"  tabindex="3" />
	         	</td>
	         	<td colspan="1">
	         		<input id="nombreInstitucion" name="nombreInstitucion" size="50" readonly="true" />
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
					<input id="cuentaAhorro"  type="text" name="cuentaAhorro"  size="20" tabindex="5" />
					<form:input type="hidden" name="numCtaInstit" id="numCtaInstit" path="numCtaInstit" />
				</td>
				<td colspan="1">
					<input id="nombreSucurs" name="nombreSucurs"  size="50"   readonly="true" />
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
					<input id="saldo" name="saldo"  size="20" tabindex="5"  readonly="readonly" style="text-align: right;" />
					<input id="sobregirarSaldo" name="sobregirarSaldo" path="sobregirarSaldo" type="hidden" />
				</td>
			</tr>
			<tr>
				<td colspan="7">&nbsp;</td>
			</tr>
			<tr>
				<td class="label" colspan="3" align="right">
					<label for="lblcueNumCtaInstit"> Importar Desembolsos de Crédito:</label>
				</td>
				<td colspan="3">
					<input type="submit" id="importarMov" class="submit" name="importarMov" value="Importar" tabindex="7"/>
				</td>
			</tr>
			<tr>
				<td class="label" colspan="3" align="right">
					<label for="lblcueNumCtaInstit"> Importar Requisiciones de Gastos:</label>
				</td>
				<td colspan="2">
					<input type="submit" id="importarMovReq" class="submit" name="importarMovReq" value="Importar" tabindex="8"/>
				</td>

		      	<td nowrap= "nowrap" id= "tdceldaFechaCons" type="hidden">
		      		<label for="lblfechaCons" id="lblfechaConsulta">Fecha de Consulta:</label>
			     	<form:input id="fechaConsulta"  name="fechaConsulta" path="fechaConsulta"  size="10" esCalendario="true" tabindex="9" />
			   </td>
			</tr>
			<tr>
				<td class="label" colspan="3" align="right">
					<label for="lblcueNumCtaInstit"> Importar Pagos de Servicios:</label>
				</td>
				<td colspan="3">
					<input type="submit" id="importarPagoServ" class="submit" name="importarPagoServ" value="Importar" tabindex="10"/>
				</td>
			</tr>
			<tr>
				<td class="label" colspan="3" align="right">
					<label for="lblcueNumCtaInstit"> Importar Bonificaciones:</label>
				</td>
				<td colspan="3">
					<input type="submit" id="importarBonificaciones" class="submit" name="importarBonificaciones" value="Importar" tabindex="11"/>
				</td>
			</tr>
			<tr>
				<td class="label" colspan="3" align="right">
					<label for="lblcueNumCtaInstit"> Importar Anticipos:</label>
				</td>
				<td colspan="3">
					<input type="submit" id="importarAnticipos" class="submit" name="importarAnticipos" value="Importar" tabindex="12"/>
					<input type="hidden" id="estatusRequisicion" name="estatusRequisicion"></input>
				</td>
			</tr>
			<tr id="trAportaciones" style="display: none;">
				<td class="label" colspan="3" align="right">
					<label for="lblcueNumCtaInstit"> Importar Aportaciones:</label>
				</td>
				<td colspan="3">
					<input type="submit" id="importarAportaciones" class="submit" name="importarAnticipos" value="Importar"/>
				</td>
			</tr>
			<tr>
				<td colspan="7">
					<br></br>
				</td>
			</tr>
		</table>
		<table width="100%">
			<tr>
				<td colspan="7">
					<input type="hidden" name="tipoAccion" id="tipoAccion" value="1"/>
					<div id="tabs">
						<ul style="font-size:80%">
							<li><a href="#verificar" id="verifica">Verificar</a></li>
							<li><a href="#autorizar" id="autoriza">Autorizar</a></li>

						</ul>

						<div id="verificar">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<input type="button" id="agregar" name="agregar" class="submit" value="Agregar"/>
						<legend>Verifica y/o Agrega Dispersiones</legend>
							<div id="tableCon">

							</div>
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
						</div>

						<div id="autorizar">
						<fieldset class="ui-widget ui-widget-content ui-corner-all">
						<legend>Autoriza Dispersión</legend>
							<div id="tablaAutoriza"></div>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td colspan="5">
										<table align="right">
											<tr>
												<td align="right">
													<input type="submit" id="autorizaBoton" name="autorizaBoton" class="submit" value="Procesar" />
													<a id="enlaceOrdenPago">
                									<button type="button" class="submit" id="reimprimeOrdenPago" style="display:none"> Reimprimir Orden de Pago</button>
               										</a>
               										<a id="enlaceProtecOrdenPago">
                									<button type="button" class="submit" id="protecOrdenPagoB" style="display:none"> Generar Archivo de Protecci&oacute;n</button>
               										</a>
													<a id="enlace" href="poliza.htm" target="_blank">
                									<button type="button" class="submit" id="impPoliza" style="display:none"> Imprimir P&oacute;liza</button>
               										</a>
               										<a id="enlaceCheque">
               										<button type="button" class="submit" id="imprimeCheque" style="display:none"  >Imprimir Cheque</button>
               										<button type="button" class="submit" id="reimprimirCheque" style="display:none" >Reimprimir Cheque</button>

													</a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</fieldset>
						</div>


					</div>
					<br></br>
					<c:set var="listaResultado"  value="${listaResultado[0]}"/>
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
					<input type="hidden" id="numCheque" name="numCheque"></input>
					<input type="hidden" id="estatusDisper" name="estatusDisper"></input>
					<input type="hidden" id="manejaChequera" name="manejaChequera"></input>
					<input type="hidden" id="protecOrdenPago" name="protecOrdenPago"></input>
					
					<input type="hidden" id="complemento" name="complemento"></input>
					<input type="hidden" id="tipoRef" name="tipoRef"></input>
					<input type="hidden" id="fechaVen" name="fechaVen"></input>
					<input type="hidden" id="permiteVer" name="permiteVer"></input>
					
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