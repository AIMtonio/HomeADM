<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 
//Nueva instalacion a kubo 1.1-->

<c:set var="lado" value="${listaResultado[0]}"/>
<c:set var="listaMenu" value="${listaResultado[1]}"/>


<div>
	
		<div id="listaCompleta">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">	
			<ul id="listaMenu" > 
				<c:forEach items="${listaMenu.menus}" var="menu" >
					<li><a href="javascript:">${menu.desplegado}</a>
					<c:choose>
						<c:when test="${empty listaMenu.gruposMenu[fn:trim(menu.numero)]}">
							</li>
						</c:when>
						<c:otherwise> 
      					<ul>
	      			</c:otherwise>
	  				</c:choose>	

					<c:forEach items="${listaMenu.gruposMenu[fn:trim(menu.numero)]}" var="grupo" >
						<li ><a href="javascript:">&nbsp;${grupo.desplegado}</a>
						<c:choose> 
							<c:when test="${empty listaMenu.opcionesMenu[fn:trim(grupo.numero)]}">
								</li>
							</c:when>
							<c:otherwise>
	      					<ul>
		      			</c:otherwise>
		  				</c:choose>
		  	 
						<c:forEach items="${listaMenu.opcionesMenu[fn:trim(grupo.numero)]}" var="opcion" >
							<li id="lisOp" name="lisOp"> 
							  <input  type="text"  style="border: none;"  size="1" id="${lado}${opcion.numero}" value="${opcion.numero}" name="menuID" readOnly="true"/>
							  <input class="check" type="checkbox" id="${lado}Chk${opcion.numero}" value="0" name="menuIDCheck" onClick="validaOpcion(${opcion.numero})" />
							  <input  type="text"  style="border: none;"  size="60" id="${lado}Desp${opcion.numero}" value="${opcion.desplegado}" name="opcionMenu" readOnly="true" />
													
							</li> 
						</c:forEach>
			
						<c:choose>
							<c:when test="${empty listaMenu.opcionesMenu[fn:trim(grupo.numero)]}">
							</c:when>
							<c:otherwise>
	      					</ul> 
								</li>
		      			</c:otherwise>
		  				</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${empty listaMenu.gruposMenu[fn:trim(menu.numero)]}">
						</c:when>
						<c:otherwise> 
      					</ul>
							</li>
	      			</c:otherwise>
	  				</c:choose>
				</c:forEach>
			</ul>
			
			</fieldset>	
		</div> 
		
	</div>
