<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>

	</head>
	<body>
		</br>
		<c:set var="ciclo" value="1"/>
		<form id="gridCajasSucursal" name="gridCajasSucursal">		
			<fieldset class="ui-widget ui-widget-content ui-corner-all">	
					<legend>Distribuci&oacute;n Chequera</legend>	
			<input type="button" id="agregaDetalle" value="Agregar" class="submit" tabindex="8" onclick="agregaNuevoDetalle()"/>		
			<table id="miTabla" border="0" cellspacing="10">
				<tbody>
					<tr>
						<td class="label">
							<label for="sucursalID">Sucursal</label>
						</td>						
						<td class="label">
							<label for="lbTipoCaja"></label>
						</td>				
						<td class="label">
							<label for="cajaID">Caja</label>
						</td>
						<td class="label">
							<label for="lbTipoCaja"></label>
						</td>
						<td class="label">
							<label for="folioCheqInicial">Folio Inicial</label>
						</td>
						<td class="label">
							<label for="folioCheqFinal">Folio Final</label>
						</td>
					</tr>
					<c:set var="numRows" scope="session" value="${fn:length(asignaChequeCajas)}"/>
					<c:if test="${numRows == 0}">
   					<tr id="renglon1" name="renglon">
						<td style="display:none;"> 
							<input type="hidden" id="consecutivoID1"  name="consecutivoID" size="5"  
									value="1" readonly="true" disabled="true"/> 
					  	</td>
						<td nowrap>
							<input type="text" size="4" name="sucursalID" id="sucursalID1" value="" autofocus
							onkeypress="listaSucursales('sucursalID1');"onblur="consultaSucursalTR(this.id,'nombreSucursal1');"/>
						</td>
						<td>
							<input type="text" size="30" name="nombreSucursal" id="nombreSucursal1" value="" readOnly="true" disabled="true"/>
						</td>
						<td nowrap>
							<input type="text" size="4" name="cajaID" id="cajaID1" value=""
							onkeypress="listarCajas(this.id,'sucursalID1');" onblur="consultaCaja(this.id,'descripcionCaja1','sucursalID1');" />
						</td>
						<td>
							<input type="text" size="25" name="descripcionCaja" id="descripcionCaja1" value="" readOnly="true" disabled="true"/>
						</td>
						<td nowrap>
							<input type="text" size="12" name="folioCheqInicial" id="folioCheqInicial1" value="" onblur="asignaFolioInicial(this);validaFolioInicial(this.id)"/>
						</td>
						<td nowrap>
							<input type="text" size="12" name="folioCheqFinal" id="folioCheqFinal1" value="" onblur="cambiaFolioFinal(this);validaFolioFinal(this.id)"/>
						</td>
						<td nowrap>
							<input type="hidden" size="12" name="estatus" id="estatus1" value="A"/>
						</td>
						<td><input type="button" name="elimina" id="1" value="" class="btnElimina" onclick="eliminaDetalle(this.id)"/></td>
						<td><input type="button" name="agrega" id="agrega1" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>					
						<td>													 												
							<input type="hidden" size="3" name="noCoinci" id="noCoinci" value="1" readOnly="true"/>
						</td>
					</tr>
					</c:if>
					<c:forEach items="${asignaChequeCajas}" var="ChequeCajas" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
						<td style="display:none;"> 
							<input type="hidden" id="consecutivoID${status.count}"  name="consecutivoID" size="5"  
									value="${status.count}" readonly="true" disabled="true"/> 
					  	</td>
						<td nowrap>
							<input type="text" size="4" name="sucursalID" id="sucursalID${status.count}" value="${ChequeCajas.sucursalID}"
							onkeypress="listaSucursales('sucursalID${status.count}');"onblur="consultaSucursalTR(this.id,'nombreSucursal${status.count}');"/>
						</td>
						<td>
							<input type="text" size="30" name="nombreSucursal" id="nombreSucursal${status.count}" value="${ChequeCajas.nombreSucursal}" readOnly="true" disabled="true"/>
						</td>
						<td nowrap>
							<input type="text" size="4" name="cajaID" id="cajaID${status.count}" value="${ChequeCajas.cajaID}"
							onkeypress="listarCajas(this.id,'sucursalID${status.count}');" onblur="consultaCaja(this.id,'descripcionCaja${status.count}','sucursalID${status.count}');" />
						</td>
						<td>
							<input type="text" size="25" name="descripcionCaja" id="descripcionCaja${status.count}" value="${ChequeCajas.descripcionCaja}" readOnly="true" disabled="true"/>
						</td>
						<td nowrap>
							<input type="text" size="12" name="folioCheqInicial" id="folioCheqInicial${status.count}" value="${ChequeCajas.folioCheqInicial}" onblur="asignaFolioInicial(this);validaFolioIni(this.id)"/>
						</td>
						<td nowrap>
							<input type="text" size="12" name="folioCheqFinal" id="folioCheqFinal${status.count}" value="${ChequeCajas.folioCheqFinal}" onblur="cambiaFolioFinal(this);validaFolioFin(this.id)"/>
						</td>
						<td nowrap>
							<input type="hidden" size="12" name="estatus" id="estatus${status.count}" value="${ChequeCajas.estatus}"/>
							<input type="hidden" size="12" name="folioUtilizar" id="folioUtilizar${status.count}" value="${ChequeCajas.folioUtilizar}"/>
						</td>
						<td><input type="button" name="elimina" id="${status.count}" value="" class="btnElimina" onclick="eliminaDetalle(this.id)"/></td>
						<td><input type="button" name="agrega" id="agrega${status.count}" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>					
						<td>													 												
							<input type="hidden" size="3" name="noCoinci" id="noCoinci" value="1" readOnly="true"/>
						</td>
					</tr>
				</c:forEach> 	 			
				</tbody>
			</table>
			<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />
			</fieldset>
		</form>
	</body>
</html>