<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tipoLista"  value="${listaResultado[0]}"/>
<c:set var="listaResultado" value="${listaResultado[1]}"/>

	<c:choose>
        	<c:when test="${tipoLista == '1'}">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend>Cr&eacute;ditos</legend>	
						<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
							<tbody>	
									<tr>
									      <td class="label">
										      <label for="lblNumero">No.</label>
									      </td> 
									      <td class="label">
										      <label for="lblSeleccion">Selecci&oacute;n</label>
									      </td> 
									      <td class="label">
										      <label for="lblCredito">Cr&eacute;dito</label>
									      </td> 
									      <td class="label">
										      <label for="lblCliente">Cliente</label>
									      </td>
									      <td class="label">
										      <label for="lblFechaIn">Fecha Inicio</label>
									      </td>
									      <td class="label">
										      <label for="lblFechaVen">Fecha Ven.</label>
									      </td>
									      <td class="label">
										      <label for="lblMontoCre">Monto Cred.</label>
									      </td>
									      <td class="label">
										      <label for="lblSaldoCap">Saldo Capital</label>
									      </td>				
									      <td class="label">
										      <label for="lblProdCred">Prod. Cred.</label>
									      </td>		
									      <td class="label">
										      <label for="lblTipoPersona">T.Persona</label>
									      </td>
									      <td class="label">
										      <label for="lblsexo">Sexo</label>
									      </td>
									      <td class="label">
										      <label for="lblestadoCivil">Estado Civil</label>
									      </td>
									      <td class="label">
										      <label for="lbldestino">Destino Credito</label>
									      </td>
									      <td class="label">
										      <label for="lblactDescripcion">ActividadBMX</label>
									      </td>		
									      <td class="label">
										      <label for="lblDirCompOfic">Direcci&oacute;n Completa Oficial</label>
									      </td>
								      </tr>
								
								<c:forEach items="${listaResultado}" var="CredFonAsigGrid"   varStatus="status">
								<tr id="renglon${status.count}" name= "renglon">
									<td> 
										<input id="consecutivoID${status.count}"  name="consecutivoID" size="4"  value="${status.count}" readOnly="true"/> 
									</td> 
									<td>
									<c:choose>
										<c:when test="${CredFonAsigGrid.formaSeleccion=='A'}">
											<input type ="text"  id="formaSeleccion${status.count}" name="listaSeleccion" size="12" readOnly="true" value="AUTOMATICO" /> 
										</c:when>
										<c:when test="${CredFonAsigGrid.formaSeleccion=='M'}">
											<input  type ="text" id="formaSeleccion${status.count}" name="listaSeleccion" size="12"  readOnly="true" value="MANUAL" /> 
										</c:when>
									</c:choose>									</td> 
									<td>
										<input type = "text" id="creditoID${status.count}" name="listaCreditoID"  size="10"   value="${CredFonAsigGrid.creditoID}" readOnly="true"/>
									</td> 
									<td>
										<input type = "text" id="nombreCliente${status.count}" value="${CredFonAsigGrid.nombreCompleto}" name="nombreCliente" size="35" readOnly="true"/>
									</td> 
									<td>
										<input type = "text" id="fechaAsignacion${status.count}" value="${CredFonAsigGrid.fechaInicio}" name="fechaAsignacion" size="9"  readOnly="true" />
									</td> 		
									<td>
										<input type = "text" id="fechaVen${status.count}" value="${CredFonAsigGrid.fechaVencimien}" name="fechaVen" size="9"   readOnly="true" />
									</td> 		
									<td>
										<input type = "text" id="montoCredito${status.count}" value="${CredFonAsigGrid.montoCredito}" name="listaMontoCredito"  size="10"  style="text-align: right;" readOnly="true"  esMoneda="true"/>
									</td> 		
									<td>
										<input type = "text" id="saldoCapCre${status.count}"   value="${CredFonAsigGrid.saldoCapital}" name="listaSaldoCapCre" size="10"   style="text-align: right;" readOnly="true"  esMoneda="true"/>
									</td> 
									<td>
										<input type = "text" id="prodCred${status.count}" value="${CredFonAsigGrid.descripcion}" name="prodCred" size="30" readOnly="true"/>
									</td> 
									<td>
										<input type = "text" id="tipoPersona${status.count}" value="${CredFonAsigGrid.tipoPersona}" name="tipoPersona" size="5" readOnly="true"/>
									</td> 
									<td>
										<input type = "text" id="sexo${status.count}" value="${CredFonAsigGrid.sexo}" name="sexo" size="8" readOnly="true"/>
									</td>
									<td>
										<input type = "text" id="estadoCivil${status.count}" value="${CredFonAsigGrid.estadoCivil}" name="estadoCivil" size="25" readOnly="true"/>
									</td>
									<td>
										<input type = "text" id="destino${status.count}" value="${CredFonAsigGrid.destino}" name="destino" size="25" readOnly="true"/>
									</td>
									<td>
										<input type = "text" id="actDescrip${status.count}" value="${CredFonAsigGrid.actDescrip}" name="actDescrip" size="25" readOnly="true"/>
									</td>		
									<td>
										<textarea id="direccion${status.count}" name="direccion"  rows="2" cols="23" readOnly="true">${CredFonAsigGrid.direccionCompleta}</textarea>
									</td>
									<td>
										<input type="button" name="elimina" id="elimina${status.count}"  class="btnElimina" onclick="eliminaFila(this.id);recalTot();"/>
									</td>  
									<td>
										<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregarNuevaFila()"/>
									</td>
									<c:set var="numeroDetalleCreRedesCue"  value="${status.count}"/>
								</tr>
    						     	<c:set var="varTotal" value="${varTotal+CredFonAsigGrid.saldoCapital}"/>	
								</c:forEach>
							  </tbody>
						</table>
						<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
					</fieldset>
					<table id="miTabla2" border="0" cellpadding="0" cellspacing="5" width="100%">
					<tbody>
					<tr>
					   <td class="separador"></td>
					   <td class="separador"></td>
					   <td class="separador"></td>
					   <td class="separador"></td>
					   <td class="separador"></td>
					   <td class="separador"></td>
					   <td class="separador"></td>
					   <td class="separador"></td>	
		            	<td class="label" align="right"> 
							<label for="lblTotal"><b> Total:</b></label>  
					    </td>
   						<td>
						<input  type ="text" id="sumaSaldoCapital"  name="sumaSaldoCapital" size="12"  value="${varTotal}"  align="right" style="text-align: right;" readOnly="true" esMoneda="true"/>  
						</td>
				    </tr>
				    </tbody>
					</table>
					<input type="hidden" id="sumaTot" name="sumaTot"/>
				</c:when>
				<c:when test="${tipoLista == '2'}">
					<fieldset class="ui-widget ui-widget-content ui-corner-all">                
					<legend>Cr&eacute;ditos</legend>	
						<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">
							<tbody>	
									<tr>
									      <td class="label">
										      <label for="lblNumero">No.</label>
									      </td> 
									      <td class="label">
										      <label for="lblSeleccion">Selecci&oacute;n</label>
									      </td> 
									      <td class="label">
										      <label for="lblCredito">Cr&eacute;dito</label>
									      </td> 
									      <td class="label">
										      <label for="lblCliente">Cliente</label>
									      </td>
									      <td class="label">
										      <label for="lblFechaIn">Fecha Inicio</label>
									      </td>
									      <td class="label">
										      <label for="lblFechaVen">Fecha Ven.</label>
									      </td>
									      <td class="label">
										      <label for="lblMontoCre">Monto Cred.</label>
									      </td>
									      <td class="label">
										      <label for="lblSaldoCap">Saldo Capital</label>
									      </td>				
									      <td class="label">
										      <label for="lblProdCred">Prod. Cred.</label>
									      </td>		
									      <td class="label">
										      <label for="lblTipoPersona">T.Persona</label>
									      </td>		
									      <td class="label">
										      <label for="lblDirCompOfic">Direcci&oacute;n Completa Oficial</label>
									      </td>
								      </tr>
								
								<c:forEach items="${listaResultado}" var="CredFonAsigGrid"   varStatus="status">
								<tr id="renglon${status.count}" name= "renglon">
									<td> 
										<input id="consecutivoID${status.count}"  name="consecutivoID" size="4"  value="${status.count}" readOnly="true" /> 
									</td> 
									<td>
									<c:choose>
										<c:when test="${CredFonAsigGrid.formaSeleccion=='A'}">
											<input type ="text"  id="formaSeleccion${status.count}" name="listaSeleccion" size="12" value="AUTOMATICO" readonly="true" /> 
										</c:when>
										<c:when test="${CredFonAsigGrid.formaSeleccion=='M'}">
											<input  type ="text" id="formaSeleccion${status.count}" name="listaSeleccion" size="12" value="MANUAL" readonly="true" /> 
										</c:when>
									</c:choose>
									</td> 
									<td>
										<input type = "text" id="creditoID${status.count}" name="listaCreditoID"  size="10"   readonly="true" value="${CredFonAsigGrid.creditoID}"/>
									</td> 
									<td>
										<input type = "text" id="nombreCliente${status.count}" value="${CredFonAsigGrid.nombreCompleto}" name="nombreCliente" size="35"  readonly="true"/>
									</td> 
									<td>
										<input type = "text" id="fechaAsignacion${status.count}" value="${CredFonAsigGrid.fechaInicio}" name="fechaAsignacion" size="9"  readonly="true" />
									</td> 		
									<td>
										<input type = "text" id="fechaVen${status.count}" value="${CredFonAsigGrid.fechaVencimien}" name="fechaVen" size="9"  readonly="true" />
									</td> 		
									<td>
										<input type = "text" id="montoCredito${status.count}" value="${CredFonAsigGrid.montoCredito}" name="listaMontoCredito"  size="10"  readonly="true"  esMoneda="true"/>
									</td> 		
									<td>
										<input type = "text" id="saldoCapCre${status.count}"   value="${CredFonAsigGrid.saldoCapital}" name="listaSaldoCapCre" size="10"  readonly="true" esMoneda="true"/>
									</td> 
									<td>
										<input type = "text" id="prodCred${status.count}" value="${CredFonAsigGrid.descripcion}" name="prodCred" size="30"  readonly="true"/>
									</td> 
									<td>
										<input type = "text" id="tipoPersona${status.count}" value="${CredFonAsigGrid.tipoPersona}" name="tipoPersona" size="5"  readonly="true"/>
									</td> 		
									<td>
										<textarea id="direccion${status.count}" name="direccion"  rows="2" cols="25" readonly="readonly">${CredFonAsigGrid.direccionCompleta}</textarea>
									</td>
									<td>
										<input type="button" name="elimina" id="elimina${status.count}"  class="btnElimina" onclick="eliminaFila(this.id)"/>
									</td>  
									<td>
										<input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregarNuevaFila()"/>
									</td>
									<c:set var="numeroDetalleCreRedesCue"  value="${status.count}"/>
								</tr>
								   	<c:set var="varTotal" value="${varTotal+CredFonAsigGrid.saldoCapital}"/>	
								</c:forEach>
							  </tbody>
						</table>
						<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
					</fieldset>
					<table id="miTabla2" border="0" cellpadding="0" cellspacing="0" width="100%">
					<tbody>
					<tr>
					    <td class="label"> 
							<label for="lblTotal"><b> Total:</b></label>  
					    </td> 
						<td>
						<input  type ="text" id="sumaSaldoCapital"  name="sumaSaldoCapital" size="10"  value="${varTotal}" readonly="true" style="text-align: right;" esMoneda="true"/>  
						</td>
				    </tr>
				    </tbody>
					</table>
				</c:when>
	</c:choose>

	<script type="text/javascript">
	agregaFormatoControles('gridCredFonAsig'); 
	
	function formato(idCtrl){
	var jqMonto = eval("'#" + idCtrl + "'");
	var monto = $(jqMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});;
	$(jqLocalidad).val(monto);

}
</script>