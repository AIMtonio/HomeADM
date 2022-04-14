<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<c:set var="listaEvaluacion" value="${listaResultado}"/>

<fieldset class="ui-widget ui-widget-content ui-corner-all" >
                  <legend class="label">Resultados de la Evaluaci&oacute;n</var></legend>

   <table id="tablaMovs" border="0" cellpadding="1px" cellspacing="1px" width="100%">
      <thead id="encabezadoLista">
         <tr style="font-size: 0.9em">
            <td class="text-center" style="padding: 0.3%">No.</td>
            <td class="text-center">Concepto</td>
            <td class="text-center">Descripci&oacute;n</td>
            <td class="text-center">Ponderado</td>
            <td class="text-center">Cumple Criterio</td>
            <td class="text-center">Puntaje Obtenido</td>
         </tr>
      </thead>
      <tbody>
         <c:if test="${fn:length(listaEvaluacion) < 1}">
            <tr>
               <td colspan="6" class="text-center">No se Obtuvieron Resultados</td>
            </tr>
         </c:if>
         <c:forEach items="${listaEvaluacion}" begin="0" var="linea">
            <c:choose>
               <c:when test="${linea.conceptoMatrizID == 1}">
                  <tr style="font-size: 0.9em">
                     <td colspan="6" bgcolor="#e0e0e0">Variables de  Usuario</td>
                  </tr>
               </c:when>
               <c:when test="${linea.conceptoMatrizID == 8}">
                  <tr style="font-size: 0.9em">
                     <td colspan="6" bgcolor="#e0e0e0">Destino y Recursos</td>
                  </tr>
               </c:when>
               <c:when test="${linea.conceptoMatrizID == 10}">
                  <tr style="font-size: 0.9em">
                     <td colspan="6" bgcolor="#e0e0e0">Comportamiento Transaccional</td>
                  </tr>
               </c:when>
            </c:choose>
            <c:choose>

            <c:when test="${linea.limiteValida == 0}">
             <c:set var="limiteValidacion" value=" "/>
               </c:when>
               <c:otherwise>
                     <c:set var="limiteValidacion" value="${linea.limiteValida}"/>
               </c:otherwise>
               </c:choose>
            <c:if test="${ linea.conceptoMatrizID < 900}">
               <tr>
                  <td  class="label" align="left"><label>${linea.conceptoMatrizID}</label></td>
                  <td  class="label" align="left">
                     <label id="concepto${linea.conceptoMatrizID}">${linea.concepto}</label>
                  </td>
                  <td  class="label" align="left">
                     <label >${linea.descripcion} ${limiteValidacion}</label>
                  </td>
                  <td class="label" align="left"><input readOnly="true" value="${linea.puntajeTotal}" size="10"></input></td>
                  <td class="label" align="center">
                     <c:choose>
                        <c:when test="${linea.cumple == 'S'}">
                           <label>Si</label>
                        </c:when>
                        <c:when test="${linea.cumple == 'N'}">
                           <label>No</label>
                        </c:when>
                        <c:otherwise>
                           <label>${linea.cumple}</label>
                        </c:otherwise>
                     </c:choose>
                  </td>
                  <td class="label" align="left"><input readonly="true" value="${linea.puntajeObtenido}" size="10"></input></td>
               </tr>
            </c:if>
            <c:choose>
               <c:when test="${linea.conceptoMatrizID == 901}">
                  </br>
               <tr>
               <td colspan="6"><hr></td>
               </tr>
              <tr>
                     <td></td>
                     <td></td>
                     <td class="label" align="right"><label>Total Ponderado: </label></td>
                     <td><input value="${linea.puntajeObtenido}" size="10" readonly="true"/></td>
               </c:when>
               <c:when test="${linea.conceptoMatrizID == 902}">
               <td class="label"><label>Puntaje Obtenido:</label> </td>
               <td><input value="${linea.puntajeObtenido}" size="10" readonly="true"/> </td>
               </tr>
               </c:when>
               <c:when test="${linea.conceptoMatrizID == 903}">
                  <tr>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td class="label"><label>Porcentaje:</label> </td>
                     <td><input value="${linea.puntajeObtenido} %" size="10" readonly="true"/></td>
                  </tr>
               </c:when>
               <c:when test="${linea.conceptoMatrizID == 904}">
                  <tr>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td class="label"><label>Nivel de Riesgo:</label></td>
                     <td><input value="${linea.puntajeObtenido} " size="10" readonly="true"/></td>
                  </tr>
               </c:when>
            </c:choose>
         </c:forEach>
      </tbody>
   </table>
</fieldset>