<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="listaResultado" value="${listaResultado[0]}" />

<fieldset class="ui-widget ui-widget-content ui-corner-all">		

	<table style="border: 0;" width="100%" cellspacing="5px" id="tbl_listaCred">

	
		<tr>
			<td class="label" align="left">
				<label for="">Num. Cliente</label>
			</td>
			<td class="label" align="left">
				<label for="">Nombre</label>
			</td>
			<td class="label" align="left">
				<label for="">Crédito</label>
			</td>
			<td class="label" align="left">
				<label for="">Monto</label>
			</td>
			<td class="label" align="left">
				<label for="">Fecha Ministrado</label>
			</td>
			<td class="label" align="center">
				<label for="">FEGA</label>
			</td>
			<td class="label" align="center">
				<label for="">FONAGA</label>
			</td>
			<td class="label" align="center">
				<label for="">CANCELAR</label>
			</td>
			
		</tr>
			
				
		<c:forEach items="${listaResultado}" var="detalle" varStatus="status">
			<tr id="creditoID_${status.count}" class="renglon">
				<td>
					<input id="clienteID_${status.count}" name="lisClienteID" type="text" 
							size="12" readonly="true"  value="${detalle.clienteID}">
				</td>
				<td>
					<input id="nombreCliente_${status.count}" name="lisNombreCliente" type="text" 
							size="50" tabindex="66"  readonly="true" disabled="disabled" 
							value="${detalle.nombreCliente}" >
				</td>
				<td>
					<input id="creditoID_${status.count}" name="lisCreditoID" type="text" 
							size="11" readonly="true" value="${detalle.creditoID}">
				</td>
				<td>
					<input id="montoCredito_${status.count}" name="lisMontoCredito" type="text" 
							size="20" readonly="true"  esMoneda="true" value="${detalle.montoCredito}">
				</td>
				<td>
					<input id="fechaMinistrado_${status.count}" name="lisFechaMinistrado" type="text"
							size="18" readonly="true"  value="${detalle.fechaMinistrado}">
				</td>
				<td style=" width: 60px;
							text-align: center;">
					<input id="fega_${status.count}" name="lisFega" type="checkbox" value="S" class="cl_fega" 
							onclick="creditosSinFondeoObj.activaProcesarCancelar(this.id,'fega')">
				</td>
				<td  style=" width: 60px;
							text-align: center;">
					<input id="fonaga_${status.count}" name="lisFonaga" type="checkbox" value="S" class="cl_fonaga" 
							onclick="creditosSinFondeoObj.activaProcesarCancelar(this.id,'fonaga')">
				</td>	
				<td  style=" width: 60px;
							text-align: center;">
					<input id="cancelado_${status.count}" name="lisCancelado" type="checkbox" value="S" class="cl_cancelado" 
							onclick="creditosSinFondeoObj.activaProcesarCancelar(this.id,'cancelado')">
					<input type="hidden" id="tipoGarantia_${status.count}" name="lisTipoGarantiaID" value ="" />
				</td>					
			
			</tr>





		</c:forEach>
		
	

	</table>

</fieldset>

<input type="hidden" id="num_creditos" value="${fn:length(listaResultado)}"  />

<c:if test="${fn:length(listaResultado) > 0}">
<table style="border: 0;padding: 0px 15px;" width="100%" cellspacing="5px" align="right">
		<tr>
			<td class="label" align="left" colspan="4">
				
			</td>
			<td class="label" align="right">
				<label for="">Seleccionar Todos</label>
			</td>
			<td class="label" align="center"  style=" width: 60px;
							text-align: center;" >
				<input type="checkbox" id="todos_fega" onclick="creditosSinFondeoObj.seleccionarTodos(this.id,'fega')" />
			</td>
			<td class="label" align="center"  style=" width: 60px;
							text-align: center;" >
				<input type="checkbox"  id="todos_fonaga" onclick="creditosSinFondeoObj.seleccionarTodos(this.id,'fonaga')"/>
			</td>
			<td class="label" align="center"  style=" width: 70px;
							text-align: center;" >
				<input type="checkbox"  id="todos_cancelado" onclick="creditosSinFondeoObj.seleccionarTodos(this.id,'cancelado')"/>
			</td>
			
		</tr>

</table>
</c:if>

<table style="border: 0;padding: 0px 15px;" width="100%" cellspacing="5px" align="right">

		<tr>
			<td colspan="5"></td>
			<td class="label" align="center"  style=" width: 60px;
							text-align: center;">
				<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="36"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="1"/>	
			</td>

		</tr>
</table>
