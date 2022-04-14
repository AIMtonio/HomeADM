<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<c:set var="tipoLista" value="${listaResultado[0]}" />
<c:set var="listaTipoClavePresup" value="${listaResultado[1]}" />
<c:set var="listaClavePresupGrid" value="${listaResultado[2]}" />

<c:choose>
	<c:when test="${tipoLista == '1'}">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend>Alta Claves Presupuestales </legend>
			<input type="button" id="agregaClavePresup" name="agregaClavePresup" value="Agregar" class="botonGral" tabIndex="2" onClick="agregaClavePresupuestal()"/>
			<table id="miTabla">
                <thead>
                    <tr>
						<td class="label"> 
							<label for="lblClavePresupID">N&uacute;mero: </label>
						</td>
						<td class="label">
							<label for="lblTipoClavePresupID">Tipo Clave Presupuestal: </label>
						</td>
						<td class="label">
							<label for="lblClave">Clave: </label>
						</td>
						<td class="label">
							<label for="lblDescripcion">Descripci&oacute;n: </label>
						</td>
					</tr>
                </thead>
				<tbody>
					<c:forEach items="${listaClavePresupGrid}" var="clavePresup" varStatus="statusClave">
						<tr id="renglonClave${statusClave.count}" name="renglonClave">
							<td>
								<input type="hidden" id="nomClavePresupID${statusClave.count}" name="nomClavePresupID" size="6"  value="${clavePresup.nomClavePresupID}"/>
								<input type="hidden" id="nomClasifClavPresupID${statusClave.count}" name="nomClasifClavPresupID" size="6"  value="${clavePresup.nomClasifClavPresupID}"/>
								<input type="text" id="consecutivoID${statusClave.count}" name="consecutivoID" size="6" value="${statusClave.count}" readOnly="true" />
							</td>

							<td>
								<select id="tipoClavePresupID${statusClave.count}" name="tipoClavePresupID"  onBlur="consultaTipoClavePresup('tipoClavePresupID${statusClave.count}')" onChange="registraClavePresupModificada(this.id.substring(17))">
									<c:forEach items="${listaTipoClavePresup}" var="tipoClavePresup"  >

									<option value="${tipoClavePresup.nomTipoClavePresupID}" 
										${clavePresup.tipoClavePresupID == tipoClavePresup.nomTipoClavePresupID ? 'selected':'' }>
										${tipoClavePresup.descripcion}
									</option>
									</c:forEach>
								</select>
							</td>

							<td>
								<input type="hidden" id="reqClave${statusClave.count}" name="reqClave" size="10" value="" />
								<input type="text" id="clave${statusClave.count}" name="clave" size="10" value="${clavePresup.clave}"  tabindex="2" onBlur="validaClave('clave${statusClave.count}')" onChange="registraClavePresupModificada(this.id.substring(5))"/>
							</td>

							<td>
								<input type="text"  id="descripcion${statusClave.count}" name="descripcion" size="50" value="${clavePresup.descripcion}"  onBlur="ponerMayusculas(this)" tabindex="3" onChange="registraClavePresupModificada(this.id.substring(11))"/>
							</td>

							<td>
								<input type="button" name="elimina" id="elimina${statusClave.count}" value="" class="btnElimina" onclick="eliminarClavePresup(this.id)" tabindex="4"/>
							</td>
							<td >
                                <input type="button" name="agrega" id="agrega${statusClave.count}" value="" class="btnAgrega add" tabindex="5"/>
							</td>
						</tr>
						<c:set var="numeroFilas" value="${statusClave.count}" />
					</c:forEach>
				</tbody>
					<input type="hidden" value="${numeroFilas}" name="numero" id="numero" />
			</table>
            
            <table id="miPage" border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
			</table>
            
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="right">
				<tr>
					<td align="right" id="grabar">
						<input type="submit" id="graba" name="graba" class="submit" value="Grabar"  tabindex="5" onclick="grabarTransacion()"/>
					</td>
				</tr>
			</table>
		</fieldset>
	</c:when>

</c:choose>



<script type="text/javascript">
	habilitaDeshabilitaClave();
	deshabilitaBoton('graba','submit');
	/**
	* Metodo para visualizar
	*/
	function clavePresup(pageValor){
		var params = {};
		params['tipoLista'] = 1;
		params['page'] 	= pageValor ;
		$.post("clavePresupGridVista.htm",params,function(data) {
			if(data.length >0 || data != null) { 
				$('#gridAltaClavePresup').html(data);
				agregaFormatoControles('formaGenerica');
				$('#gridAltaClavePresup').show();
			}
		});
	} //fin metodo:

	function habilitaDeshabilitaClave(){
		var numCodig = $('#numero').val();

		for(var i = 1; i <= numCodig; i++){
			var jqIdClave = eval("'clave" + i+ "'");
			var clave = document.getElementById(jqIdClave).value;

			if( clave != "" ){
				document.getElementById(jqIdClave).disabled = false;
			}else{
				document.getElementById(jqIdClave).disabled = true;
			}
		}
	}

$.fn.pageMe = function(opts){
        var $this = this,
            defaults = {
                perPage: 7,
                showPrevNext: false,
                hidePageNumbers: false
            },
            settings = $.extend(defaults, opts);
        
        var listElement = $this.find('tbody');
        var perPage = settings.perPage; 
        var children = listElement.children();
        var pager = $('.pager');
        
        if (typeof settings.childSelector!="undefined") {
            children = listElement.find(settings.childSelector);
        }
        
        if (typeof settings.pagerSelector!="undefined") {
            pager = $(settings.pagerSelector);
        }
        
        var numItems = children.size();
        var numPages = Math.ceil(numItems/perPage);
    
        pager.data("curr",0);
        
        if (settings.showPrevNext){
            $('<div> <input href="#" type="button" id="anterior" class="btnAnterior prev_link left" /> <input href="#" type="button" id="siguiente" value="" class="btnSiguiente next_link right" /></div>').appendTo(pager);
        }

        var curr = 0;
        var totalPage = numPages;
        while(totalPage > curr && (settings.hidePageNumbers==false)){
            $('<li class="pagination" id="pag-${loop.count - 1}"><a href="#" style="float: right;" class="active cambioColor page_link">'+(totalPage)+'</a></li>').appendTo(pager);
            totalPage--;
        }

        pager.find('.page_link:first').addClass('active');
        pager.find('.prev_link').hide();
        if (numPages<=1) {
            pager.find('.next_link').hide();
        }
      	pager.children().eq(1).addClass("active");
        
        children.hide();
        children.slice(0, perPage).show();
        
        pager.find('li .page_link').click(function(){
            var clickedPage = $(this).html().valueOf()-1;
            goTo(clickedPage,perPage);
            return false;
        });
        pager.find('td .add').click(function(){
            var clickedPage = numPages-1;
            goTo(clickedPage,perPage);
            agregaClavePresupuestal();
            return false;
        });
        $("#miTabla").find('tr .add').click(function(){
            var clickedPage = numPages-1;
            goTo(clickedPage,perPage);
            agregaClavePresupuestal();
            return false;
        });
        pager.find('div .prev_link').click(function(){
            previous();
            return false;
        });
        pager.find('div .next_link').click(function(){
            next();
            return false;
        });
        
        function previous(){
            var goToPage = parseInt(pager.data("curr")) - 1;
            goTo(goToPage);
        }
         
        function next(){
            goToPage = parseInt(pager.data("curr")) + 1;
            goTo(goToPage);
        }
        
        function goTo(page){
        	listElement = $this.find('tbody');
        	children = listElement.children();
        	numItems = children.size();
        	numPages = Math.ceil(numItems/perPage);
        	var totalPage

        		
            var startAt = page * perPage,
                endOn = startAt + perPage;
            children.css('display','none').slice(startAt, endOn).show();
            
            if (page>=1) {
                pager.find('.prev_link').show();
            }
            else {
                pager.find('.prev_link').hide();
            }
            
            if (page<(numPages-1)) {
                pager.find('.next_link').show();
            }
            else {
                pager.find('.next_link').hide();
            }
            
            pager.data("curr",page);
          	pager.children().removeClass("active");
            pager.children().eq(page+1).addClass("active");
        
        }
    };
    
</script>


<style>
	li.pagination {
		display: inline-block;
		padding: 0;
		margin: 0;
	}

	li.pagination {display: inline ;}

	li.pagination a {
		color: black;
		float: left;
		padding: 2px 4px;
		text-decoration: none;
		border-radius: 5px;
	}

	li.pagination a.cambioColor:hover {
		background-color: powderblue;
		transition: background-color .5s;
	}

	li.pagination a.active {
		background-color: white;
		color: black;
		border-radius: 4px;
		cursor: pointer;
		white-space:nowrap;

	}

	div.alinear {
		float: right;
	}
	
	.left {
     float: left;
     width: 35px;
     text-align: right;
     margin: 2px 0px;
     display: inline;
    }

    .right {
        float: left;
        text-align: left;
        width: 35px;
        margin: 2px 0px;
        display: inline;
    }

</style>
