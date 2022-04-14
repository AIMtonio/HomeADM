<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page pageEncoding="UTF-8"%>
<html>
  <body>
	<br>
	<c:set var="ciclo" value="1"/>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<legend>Datos de Operación</legend>			
			<table id="tablaProrrateo" border="0" cellsPacing="10">
				<tbody>
					<tr>
						<td class="label">
							<label for="nombrePersona">Nombre</label>
						</td>
						<td class="label">
							<label for="fechayHora">Fecha y Hora</label>
						</td>
						<td class="label">
							<label for="montoOperacion:">Monto Operación</label>
						</td>
						<td class="label">
							<label for="efectivo">Efectivo</label>
						</td>
						<td class="label">
							<label for="cambio">Cambio</label>
						</td>
					</tr>					
					<c:set var="numRows" scope="session" value="${fn:length(reimpresionTicket)}"/>
					<c:if test="${numRows == 0}">
						<tr id="renglon${status.count}" name="renglon">
							<td nowrap class="label" colspan="12" align="center">																			
								<label><b>No se encontraron coincidencias.</b></label>
							</td>
						</tr>
					</c:if>
					<c:forEach items="${reimpresionTicket}" var="reimpresion" varStatus="status">										
						<tr id="renglon${status.count}" name="renglon">							
								<td>
									<input type="text" id="nombrePersona${status.count}" name="nombrePersona" 
														value="${reimpresion.nombrePersona}" readOnly="readOnly" 
														 size="50"/>
								</td>
								<td>
									<input type="text" id="fechayHora${status.count}" name="fechayHora" 
														value="${reimpresion.fecha} ${reimpresion.hora}" readOnly="readOnly" size="20"/>
								</td>
								<td>
									<input type="text" id="montoOperacion${status.count}" name="montoOperacion" 
														value="${reimpresion.montoOperacion}" readOnly="readOnly" 
														style="text-align: right;" size="12" esMoneda=true/>
								</td>
								<td>
									<input type="text" id="efectivo${status.count}" name="efectivo" style="text-align: right;" 
														value="${reimpresion.efectivo}" readOnly="readOnly" size="12" esMoneda=true/>
								</td>								
								<td>
									<input type="text" id="cambio${status.count}" name="cambio" style="text-align: right;"
														value="${reimpresion.cambio}" size="12" readOnly="readOnly" esMoneda=true/>														
								</td>
								<td>
									<input type="hidden" id="transaccionID${status.count}" name="transaccionID" value="${reimpresion.transaccionID}"/>
									<input type="hidden" id="tipoOperacionID${status.count}" name="tipoOperacionID" value="${reimpresion.tipoOpera}"/>
									<input type="hidden" id="sucursalID${status.count}" name="sucursalID" value="${reimpresion.sucursalID}"/>
									<input type="hidden" id="cajaID${status.count}" name="cajaID" value="${reimpresion.cajaID}"/>
									<input type="hidden" id="usuarioID${status.count}" name="usuarioID" value="${reimpresion.usuarioID}"/>
									<input type="hidden" id="fecha${status.count}" name="fecha" value="${reimpresion.fecha}"/>
									<input type="hidden" id="hora${status.count}" name="hora" value="${reimpresion.hora}"/>
									<input type="hidden" id="opcionCajaID${status.count}" name="opcionCajaID" value="${reimpresion.opcionCajaID}"/>
									<input type="hidden" id="descripcion${status.count}" name="descripcion" value="${reimpresion.descripcion}"/>
									<input type="hidden" id="montoOperacion${status.count}" name="montoOperacion" value="${reimpresion.montoOperacion}"/>
									<input type="hidden" id="nombreBenefi${status.count}" name="nombreBenefi" value="${reimpresion.nombreBeneficiario}"/>																	
									<input type="hidden" id="clienteID${status.count}" name="clienteID" value="${reimpresion.clienteID}"/>
									<input type="hidden" id="prospectoID${status.count}" name="prospectoID" value="${reimpresion.prospectoID}"/>
									<input type="hidden" id="empleadoID${status.count}" name="empleadoID" value="${reimpresion.empleadoID}"/>
									<input type="hidden" id="nombreEmpleado${status.count}" name="nombreEmpleado" value="${reimpresion.nombreEmpleado}"/>
									<input type="hidden" id="cuentaIDRetiro${status.count}" name="cuentaIDRetiro" value="${reimpresion.cuentaIDRetiro}"/>
									<input type="hidden" id="cuentaIDDeposito${status.count}" name="cuentaIDDeposito" value="${reimpresion.cuentaIDDeposito}"/>
									<input type="hidden" id="etiquetaCtaRetiro${status.count}" name="etiquetaCtaRetiro" value="${reimpresion.etiquetaCtaRetiro}"/>
									<input type="hidden" id="etiquetaCtaDepo${status.count}" name="etiquetaCtaDepo" value="${reimpresion.etiquetaCtaDepo}"/>									
									<input type="hidden" id="desTipoCuenta${status.count}" name="desTipoCuenta" value="${reimpresion.desTipoCuenta}"/>
									<input type="hidden" id="desTipoCtaDepo${status.count}" name="desTipoCtaDepo" value="${reimpresion.desTipoCtaDepo}"/>
									<input type="hidden" id="saldoActualCta${status.count}" name="saldoActualCta" value="${reimpresion.saldoActualCta}"/>
									<input type="hidden" id="referencia${status.count}" name="referencia" value="${reimpresion.referencia}"/>
									<input type="hidden" id="formaPagoCobro${status.count}" name="formaPagoCobro" value="${reimpresion.formaPagoCobro}"/>
									<input type="hidden" id="creditoID${status.count}" name="creditoID" value="${reimpresion.creditoID}"/>
									<input type="hidden" id="producCreditoID${status.count}" name="producCreditoID" value="${reimpresion.producCreditoID}"/>
									<input type="hidden" id="nombreProdCred${status.count}" name="nombreProdCred" value="${reimpresion.nombreProdCred}"/>																	
									<input type="hidden" id="montoCredito${status.count}" name="montoCredito" value="${reimpresion.montoCredito}"/>
									<input type="hidden" id="montoPorDesem${status.count}" name="montoPorDesem" value="${reimpresion.montoPorDesem}"/>
									<input type="hidden" id="montoDesemb${status.count}" name="montoDesemb" value="${reimpresion.montoDesemb}"/>
									<input type="hidden" id="grupoID${status.count}" name="grupoID" value="${reimpresion.grupoID}"/>
									<input type="hidden" id="nombreGrupo${status.count}" name="nombreGrupo" value="${reimpresion.nombreGrupo}"/>
									<input type="hidden" id="cicloActual${status.count}" name="cicloActual" value="${reimpresion.cicloActual}"/>
									<input type="hidden" id="montoProximoPago${status.count}" name="montoProximoPago" value="${reimpresion.montoProximoPago}"/>
									<input type="hidden" id="fechaProximoPago${status.count}" name="fechaProximoPago" value="${reimpresion.fechaProximoPago}"/>
									<input type="hidden" id="totalAdeudo${status.count}" name="totalAdeudo" value="${reimpresion.totalAdeudo}"/>
									<input type="hidden" id="capital${status.count}" name="capital" value="${reimpresion.capital}"/>
									<input type="hidden" id="interes${status.count}" name="interes" value="${reimpresion.interes}"/>
									<input type="hidden" id="moratorios${status.count}" name="moratorios" value="${reimpresion.moratorios}"/>
									<input type="hidden" id="comision${status.count}" name="comision" value="${reimpresion.comision}"/>
									<input type="hidden" id="comisionAdmon${status.count}" name="comisionAdmon" value="${reimpresion.comisionAdmon}"/>
									<input type="hidden" id="iVA${status.count}" name="iVA" value="${reimpresion.iVA}"/>
									<input type="hidden" id="garantiaAdicional${status.count}" name="garantiaAdicional" value="${reimpresion.garantiaAdicional}"/>
									<input type="hidden" id="institucionID${status.count}" name="institucionID" value="${reimpresion.institucionID}"/>
									<input type="hidden" id="numCtaInstit${status.count}" name="numCtaInstit" value="${reimpresion.numCtaInstit}"/>
									<input type="hidden" id="numCheque${status.count}" name="numCheque" value="${reimpresion.numCheque}"/>
									<input type="hidden" id="nombreInstit${status.count}" name="nombreInstit" value="${reimpresion.nombreInstitucion}"/>
									<input type="hidden" id="polizaID${status.count}" name="polizaID" value="${reimpresion.polizaID}"/>
									<input type="hidden" id="telefono${status.count}" name="telefono" value="${reimpresion.telefono}"/>
									<input type="hidden" id="identificacion${status.count}" name="identificacion" value="${reimpresion.identificacion}"/>
									<input type="hidden" id="folioIdentificacion${status.count}" name="folioIdentificacion" value="${reimpresion.folioIdentificacion}"/>
									<input type="hidden" id="folioPago${status.count}" name="folioPago" value="${reimpresion.folioPago}"/>
									<input type="hidden" id="catalogoServID${status.count}" name="catalogoServID" value="${reimpresion.catalogoServID}"/>
									<input type="hidden" id="nombreCatalServ${status.count}" name="nombreCatalServ" value="${reimpresion.nombreCatalServ}"/>
									<input type="hidden" id="montoServicio${status.count}" name="montoServicio" value="${reimpresion.montoServicio}"/>
									<input type="hidden" id="iVAServicio${status.count}" name="iVAServicio" value="${reimpresion.iVAServicio}"/>
									<input type="hidden" id="origenServicio${status.count}" name="origenServicio" value="${reimpresion.origenServicio}"/>									
									<input type="hidden" id="montoComision${status.count}" name="montoComision" value="${reimpresion.montoComision}"/>
									<input type="hidden" id="totalCastigado${status.count}" name="totalCastigado" value="${reimpresion.totalCastigado}"/>
									<input type="hidden" id="totalRecuperado${status.count}" name="totalRecuperado" value="${reimpresion.totalRecuperado}"/>
									<input type="hidden" id="monto_PorRecuperar${status.count}" name="monto_PorRecuperar" value="${reimpresion.monto_PorRecuperar}"/>
									<input type="hidden" id="tipoServServifun${status.count}" name="tipoServServifun" value="${reimpresion.tipoServServifun}"/>
									<input type="hidden" id="cobraSeguroCuota${status.count}" name="cobraSeguroCuota" value="${reimpresion.cobraSeguroCuota}"/>
									<input type="hidden" id="montoSeguroCuota${status.count}" name="montoSeguroCuota" value="${reimpresion.montoSeguroCuota}"/>									
									<input type="hidden" id="iVASeguroCuota${status.count}" name="iVASeguroCuota" value="${reimpresion.iVASeguroCuota}"/>
									<input type="hidden" id="arrendaID${status.count}" name="arrendaID" value="${reimpresion.arrendaID}"/>
									<input type="hidden" id="prodArrendaID${status.count}" name="prodArrendaID" value="${reimpresion.prodArrendaID}"/>
									<input type="hidden" id="nomProdArrendaID${status.count}" name="nomProdArrendaID" value="${reimpresion.nomProdArrendaID}"/>
									<input type="hidden" id="seguroVida${status.count}" name="seguroVida" value="${reimpresion.seguroVida}"/>
									<input type="hidden" id="seguro${status.count}" name="seguro" value="${reimpresion.seguro}"/>
									<input type="hidden" id="iVASeguroVida${status.count}" name="iVASeguroVida" value="${reimpresion.iVASeguroVida}"/>
									<input type="hidden" id="iVASeguro${status.count}" name="iVASeguro" value="${reimpresion.iVASeguro}"/>
									<input type="hidden" id="iVACapital${status.count}" name="iVACapital" value="${reimpresion.iVACapital}"/>
									<input type="hidden" id="iVAInteres${status.count}" name="iVAInteres" value="${reimpresion.iVAInteres}"/>
									<input type="hidden" id="iVAMora${status.count}" name="iVAMora" value="${reimpresion.iVAMora}"/>
									<input type="hidden" id="iVAOtrasComi${status.count}" name="iVAOtrasComi" value="${reimpresion.iVAOtrasComi}"/>
									<input type="hidden" id="iVAComFaltaPag${status.count}" name="iVAComFaltaPag" value="${reimpresion.iVAComFaltaPag}"/>
									<input type="hidden" id="accesorioID${status.count}" name="accesorioID" value="${reimpresion.accesorioID}">
								</td>								
						</tr>
					</c:forEach>
				</tbody>						
			</table>
		</fieldset>		
	
  </body>
</html>
<script type="text/javascript">
</script>