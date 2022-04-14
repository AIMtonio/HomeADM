<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="listaResultado"  value="${listaResultado}"/>
<%! int numFilas = 0; %>
<%! int counter = 4; %>
<table border="0" width="100%">
	<tr>
		<td>
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend>Referencias</legend>
				<table id="tbParametrizacion" border="0" width="100%">
					<tbody>
					<tr>
						<td style="width: 10px">
							<input type="button" class="submit" value="Agregar" id="btnAgregar" tabindex="3" onclick="agregarDetalle(this.id)"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label>Origen</label>
						</td>						
						<td class="label">
							<label>Instituci&oacute;n</label>
						</td>				
						<td class="label">
							<label></label>
						</td>
						<td class="label">
							<label>Referencia</label>
						</td>
						<td class="label">
						</td>
					</tr>
					<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
					<% numFilas=numFilas+1; %>
					<% counter++; %>
					<tr id="tr${status.count}" name="tr">
						<td>
							<c:choose>
								<c:when test="${detalle.origen == '1'}">
		       						<select id="origen${status.count}" name="origen" tabindex="<%=counter %>" readonly="readonly" disabled="true">
										<option value="">SELECCIONAR</option>
										<option selected="selected" value="1" >INSTITUCI&Oacute;N</option>
		       						</select> 
		 						</c:when>
							</c:choose>
						</td>
						<td>
							<input type="text" id="institucionID${status.count}" tabindex="<%=counter %>" name="institucionID" size="9" value="${detalle.institucionID}" maxlength="10" onblur="consultaInstitucion(this.id,'nombInstitucion${status.count}','origen${status.count}')" onkeypress="listaInstituciones(this.id,'origen${status.count}')" onchange="verificaSeleccionado(this.id)" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="text" id="nombInstitucion${status.count}" name="nombInstitucion" size="22" value="${detalle.nombInstitucion}" maxlength="100" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="text" id="referencia${status.count}" tabindex="<%=counter %>" name="referencia" size="45" value="${detalle.referencia}" maxlength="45" onblur="ponerMayusculas(this),limpiaCaract(this.id),seRepiteRef(this.id,'institucionID${status.count}')" readonly="readonly" disabled="true" />
							<input type="hidden" id="tipoReferencia${status.count}" name="lisTipoReferencia" size="22" value="${detalle.tipoReferencia}" readonly="readonly" disabled="true"/>
						</td>
						<td>
							<input type="button" id="eliminar${status.count}" name="eliminar" value="" class="btnElimina" onclick="eliminarParam('tr${status.count}')" tabindex="<%=counter %>"/>
							<input type="button" id="agrega${status.count}" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="<%=counter %>"/>
						</td>
						<td>
							<input type="button" class="submit" value="Calcular" id="calcular${status.count}" tabindex="<%=counter %>" onclick="calculaReferencia(${status.count})"/>
							<input type="hidden" id="calculoRefere${status.count}" name="lisCalculoRefere" size="22" value="S" readonly="readonly" disabled="true"/>
						</td>
					</tr>
					</c:forEach>
					</tbody>        
					
				</table>
			</fieldset>
		</td>
	</tr>
</table>
<script type="text/javascript" >
	$('#btnAgregar').focus();
	if(Number(getRenglones()) == 0){
		deshabilitaBoton('grabar', 'submit');
		$('#generar').hide();
	} else {
		habilitaBoton('grabar', 'submit');
		$('#generar').show();
	}
</script>
<input type="hidden" id="numTab" value="<%=counter %>"/>
<input type="hidden" id="numeroFila" value="<%=numFilas %>"/>
<% numFilas=0; %>
<% counter=4; %>