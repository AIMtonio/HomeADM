<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="listaMenu" value="${listaResultado}"/>

<div>
	
		<div id="listaCompleta">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<ul id="listaMenu" > 
				<c:forEach items="${listaMenu}" var="menu" varStatus="loopPrin">
					<li><a href="javascript:">${menu.key}</a>

					<ul>
					<c:forEach items="${menu.value}" var="opcion" varStatus="loop">
						<li id="lisOp" name="lisOp">
						
						  <input type="hidden" id="profileOption${opcion.profileOptionNumber}" value="${opcion.profileOptionNumber}" name="profileOptionNumber" readOnly="true"/>
						  <input type="hidden" id="menuOption${opcion.menuOptionNumber}" value="${opcion.menuOptionNumber}" name="menuOptionNumber" readOnly="true"/>
						  <input type="hidden" id="profileNumber${opcion.profileNumber}" value="${opcion.profileNumber}" name="profileNumber" readOnly="true"/>
						  
						  <c:choose>
							  <c:when test="${opcion.enabled eq 'S'}">
							     <input type="hidden" id="tipoModificacion${opcion.profileOptionNumber}_${loopPrin.index}_${loop.index}" value="A" name="tipoModificacion" readOnly="true"/>
							  </c:when>
							  <c:otherwise>
							      <input type="hidden" id="tipoModificacion${opcion.profileOptionNumber}_${loopPrin.index}_${loop.index}" value="B" name="tipoModificacion" readOnly="true"/>
							  </c:otherwise>
						  </c:choose>
						
						  <input type="text"  style="border: none;"  size="1" id="${loop.index + 1}" value="${loop.index + 1}" name="menuID" readOnly="true"/>
						  <c:choose>
							  <c:when test="${opcion.enabled eq 'S'}">
							    <input checked tabindex="10" onchange="habilitaBoton('grabar', 'submit')" class="check" readonly="readonly" type="checkbox" id="ckeck${opcion.profileOptionNumber}_${loopPrin.index}_${loop.index}" value="${opcion.enabled}" onclick="validaCampo(this.id, 'tipoModificacion${opcion.profileOptionNumber}_${loopPrin.index}_${loop.index}')" name="menuIDCheck" />  
							  </c:when>
							  <c:otherwise>
							     <input class="check" onchange="habilitaBoton('grabar', 'submit')" tabindex="10" readonly="readonly" type="checkbox" id="check${opcion.profileOptionNumber}_${loopPrin.index}_${loop.index}" value="${opcion.enabled}" onclick="validaCampo(this.id, 'tipoModificacion${opcion.profileOptionNumber}_${loopPrin.index}_${loop.index}')" name="menuIDCheck" /> 
							  </c:otherwise>
						  </c:choose>
						  <input type="text" tabindex="10" id="description${opcion.profileOptionNumber}_${loopPrin.index}_${loop.index}')" style="border: none;"  size="60" value="${opcion.menuOptionDescription}" name="opcionMenu" readOnly="true" />
						  
						</li> 
					</c:forEach>
					</ul>
					
				</c:forEach>
			</ul>
			
			</fieldset>	
		</div> 
		
	</div>
