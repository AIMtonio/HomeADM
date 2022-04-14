var tipoInstitucion		= 0;
var opcionMenuRegBean ;
var menuGradoEst		= {};
var menuCargo			= {};
var menuManifest		= {};
var menuOrgano			= {};
var menuPermanente		= {};
var menuTipoMovimiento	= {};
var esTab				= true;
var enteroCero          = 0;
var numeroIndex			= 0; 

var objetoA1713Bean     = {
	paisID	: 484,
	estadoID: '',
	municipioID: '',
	localidadID: '',
	coloniaID : '', 
}

var catRegulatorioA1713 = { 
			'Excel'			: 1,		
			'Csv'			: 2,		
		};
 

var catMenuRegulatorio = { 
			'clasificaConta'	: 19,
			'tipoPercepcion'	: 18,
		};


var selectMenu = {
	clasificaConta : {},
	tipoPercepcion : {},
}


/*=======================================
=            Funciones Vista            =
=======================================*/



/**
 *
 * Función para cargar los menus del registro
 *
 */
function cargarMenus(){

	// Combo Profesion
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.tipoPercepcion,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(catMenuRegulatorio.tipoPercepcion,opcionMenuRegBean,function(catTipoPercepcion) {
					selectMenu.tipoPercepcion = catTipoPercepcion;


								//Combo Motivo de Baja
				opcionMenuRegBean = {
									'menuID' : catMenuRegulatorio.clasificaConta,
									'descripcion': ''
									};

				opcionesMenuRegServicio.listaCombo(catMenuRegulatorio.clasificaConta,opcionMenuRegBean,function(catClasificaConta) {
							selectMenu.clasificaConta = catClasificaConta;
						});




			});
	
	

}



/**
 *
 * Funcion para cargar la información default
 *
 */

function consultaRegistroRegulatorioC0922(){	
	var anio 	= $('#anio').val();
	var mes 	= $('#mes').val();
	
	var params 	= {
		tipoLista : 1,
		anio: anio,
		mes: mes
	};
	
	
	$.post("regulatorioC0922GridVista.htm", params, function(data){


		if(data.length >enteroCero) {
			$('#listaRegistroC0922').html(data);
			

			$('#listaRegistroC0922').show();
			
			if(consultaFilas() > enteroCero){
				habilitaBoton('grabar');
			}else{
				agregarRegistro();
				deshabilitaBoton('grabar');
			}


			for (var i = 1; i <= consultaFilas(); i++) {
				cargaMenusVista(i);	
				seleccionaOpcionMenuReg(i);
			}

			

		}else{				
			$('#listaRegistroC0922').html("");
			$('#listaRegistroC0922').hide(); 
		}

		agregaFormatoMoneda('formaGenerica');
		actualizaFormatoMoneda('formaGenerica');
	});

}

function consultaFilas(){
	var totales=enteroCero;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}


function cargaMenusVista(registroID){
	var tipoPercep = 'tipoPercepcion'+registroID;
	var clasConta =  'clasfContable'+registroID;
	

	dwr.util.removeAllOptions(tipoPercep);
	dwr.util.addOptions(tipoPercep, {'':'SELECCIONAR'}); 
	dwr.util.addOptions(tipoPercep, selectMenu.tipoPercepcion, 'codigoOpcion', 'descripcion');
						

	dwr.util.removeAllOptions(clasConta);
	dwr.util.addOptions(clasConta, {'':'SELECCIONAR'}); 
	dwr.util.addOptions(clasConta, selectMenu.clasificaConta, 'codigoOpcion', 'descripcion');

}

function seleccionaOpcionMenuReg(registroID){
	$('#tipoPercepcion'+registroID).val($('#valTipoPercepcion'+registroID).val())
	$('#clasfContable'+registroID).val($('#valorClasfContable'+registroID).val());
}


function soloAlfanumericos(par_cadena) {
	
   
    var jqNumero = eval("'#" + par_cadena + "'");
	var valr= $(jqNumero).val();	
	
	 if( /[^a-zA-Z0-9ñÑ\s]/.test( $(jqNumero).val() ) ) {
     
  	    var s= valr.substr(0,valr.length-1);
  	    $(jqNumero).val(s);
       return false;
    }
    return true;
}

/**
 *
 * Funcion de exito
 *
 */
 function funcionExito(){
 	
 	consultaRegistroRegulatorioC0922();
 	


 	deshabilitaBoton('agrega');
 	deshabilitaBoton('modifica');
	deshabilitaBoton('elimina');
 }

 function funcionError(){
 		agregaFormatoMoneda('formaGenerica');
		actualizaFormatoMoneda('formaGenerica');
 }


function generaReporte(tipoReporte){
		   var anio = $('#anio').val();		   
		   var mes = $('#mes').val();		   
		   var url = `reporteRegulatorioC0922.htm?tipoReporte=${tipoReporte}&anio=${anio}&mes=${mes}&tipoEntidad=${tipoInstitucion}`;
		   window.open(url);
		   
};


/*=====  End of Funciones Vista  ======*/

function llenaComboAnios(fechaActual){
	   var anioActual 	= fechaActual.substring(0, 4);
	   var mesActual 	= parseInt(fechaActual.substring(5, 7));
	   var numOption 	= 4;
	  
	   for(var i=0; i<numOption; i++){
		   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
		   anioActual = parseInt(anioActual) - 1;
	   }
	   
	   $("#mes option[value="+ mesActual +"]").attr("selected",true);
}




function agregarRegistro(){	
	var numeroFila=consultaFilas();
	
	var nuevaFila = parseInt(numeroFila) + 1;	



	var renglonN = `

		<tr id="renglon${nuevaFila}" name="renglon">
															
		<td>
		<input type="hidden" id="registroID${nuevaFila}" name="registroID" size="6" 
					value="${nuevaFila}" />												
		<input type="hidden" id="valorClasfContable${nuevaFila}"   name="valorClasfContable"  size="10"/>
		<select tabindex="${numeroIndex++}" name="listClasfContable" id="clasfContable${nuevaFila}" required="" >	</select>	
		</td>
		
		<td>
		<input tabindex="${numeroIndex++}" type="text" id="nombre${nuevaFila}" maxlength="250" name="listNombre" required=""   size="60"  onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" value=""/>
		</td>
		
		
		<td>
		<input  tabindex="${numeroIndex++}" type="text" id="puesto${nuevaFila}" maxlength="60" name="listPuesto" required=""  onblur="ponerMayusculas(this);"  onkeyup="return soloAlfanumericos(this.id);"  size="40" value=""/>
		</td>
		
								
		<td>
		<input  type="hidden" id="valTipoPercepcion${nuevaFila}"  name="tipoPercepcion" size="20" value=""/>
			<select   tabindex="${numeroIndex++}" name="listTipoPercepcion" id="tipoPercepcion${nuevaFila}"  required="" >
			</select>
		</td>
		
		<td>
		<input  tabindex="${numeroIndex++}" type="text" id="descripcion${nuevaFila}" maxlength="60" name="listDescripcion" required=""   onkeyup="return soloAlfanumericos(this.id);" onblur="ponerMayusculas(this);" size="30" value=""/>
		</td>
		
		
		<td nowrap="nowrap">
		<input tabindex="${numeroIndex++}"  type="text" id="dato${nuevaFila}" maxlength="18"  required=""  esMoneda="true"   name="listDato" size="21" value=""/>
		</td>
										
		<td nowrap="nowrap">
	  		<input  tabindex="${numeroIndex++}" type="button" name="eliminar" id="${nuevaFila}"  value="" class="btnElimina" onclick="eliminarRegistro(this.id)" />
	  		 <input tabindex="${numeroIndex++}" type="button" name="agrega" id="agrega${nuevaFila}"  value="" class="btnAgrega" onclick="agregarRegistro()"/>
	  	</td>
		
	  						
	</tr>

	`;
		
		$("#miTabla").append(renglonN);

		cargaMenusVista(nuevaFila);
		
		$('#clasfContable'+nuevaFila).focus();
		
		habilitaBoton('grabar');

		agregaFormatoMoneda('formaGenerica');


		return false;		
	}



	function eliminarRegistro(control){	
		var contador = enteroCero ;
		var numeroID = control;
		
		var jqRenglon 		= eval("'#renglon" + numeroID + "'");
		
		// se elimina la fila seleccionada
		$(jqRenglon).remove();

		
		//Reordenamiento de Controles
		contador = 1;
		var numero= enteroCero;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);					
			$('#regnlon'+numero).attr('id','renglon'+contador);
			$('#registroID'+numero).attr('id','registroID'+contador);
			$('#valorClasfContable'+numero).attr('id','valorClasfContable'+contador);
			$('#clasfContable'+numero).attr('id','clasfContable'+contador);
			$('#nombre'+numero).attr('id','nombre'+contador);
			$('#puesto'+numero).attr('id','puesto'+contador);
			$('#valTipoPercepcion'+numero).attr('id','valTipoPercepcion'+contador);
			$('#tipoPercepcion'+numero).attr('id','tipoPercepcion'+contador);
			$('#descripcion'+numero).attr('id','descripcion'+contador);
			$('#dato'+numero).attr('id','dato'+contador);
			$('#agrega'+numero).attr('id','agrega'+contador);

			contador = parseInt(contador + 1);	
			
		});

		
	}




$(document).ready(function() {
	parametros = consultaParametrosSession();
	esTab = true;
	$('#excel').click();
	deshabilitaBoton('agrega');
 	deshabilitaBoton('modifica');
 	deshabilitaBoton('elimina');

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	var paramSesion = consultaParametrosSession();
	var fechaDeSistema = paramSesion.fechaSucursal;
	$('#fecha').val(fechaDeSistema);


	llenaComboAnios(parametroBean.fechaAplicacion);

	cargarMenus(); 
	
	$('#anio').focus();	

	$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
				

			});

	$(':text').focus(function() {
		esTab = false;
		
	});


	/*=============================================
	=            Funciones de Registro            =
	=============================================*/

	$('#reporteD0842').click(function(event){
		
		setTimeout(function(){
			$('#excel').click();
		},30);
	});

	$('#registroD0842').click(function(event){
		setTimeout(function(){
			// COnsultar el Primer Registro
				consultaRegistroRegulatorioC0922();
		},30);
		
	})

	
	/*=====  End of Funciones de Registro  ======*/
	
	

	/*============================================
	=            Asignación de Listas            =
	============================================*/
	
	
	
	/*=====  End of Asignación de Listas  ======*/
	



	$('#mes').blur(function() {
			if($('#capturaInfo').is(':visible')){
				
				$('#registroID').focus();
			}else{
				$('#excel').focus();
			}
			  
	});
			
			

	$('#mes').change(function (){
		// Cambio el form		
		consultaRegistroRegulatorioC0922();	
	});

	$('#anio').change(function (){
		// Cambio el form		
		consultaRegistroRegulatorioC0922();	
	});



	$('#agrega').click(function(event){
		$('#tipoTransaccion').val(1);
		$('#tipoInstitID').val(3);

	});


	$('#generar').click(function(event){
		if($('#excel').is(':checked')){
				generaReporte(catRegulatorioA1713.Excel);
		}
		if($('#csv').is(':checked')){
				generaReporte(catRegulatorioA1713.Csv);
		}		
	});
	

	

	//------------ Validaciones de Controles -------------------------------------
	
	$.validator.setDefaults({
	    submitHandler: function(event) {
    
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','registroID','funcionExito','funcionError');
					//Si la respuesta es éxitosa se habilita el botón generar	


	    }
	 });

	$('#formaGenerica').validate({
		rules: {
			anio:{
				required: true,
			} ,
			mes:{
				required: true,
			},
					
		},		
		messages: {
			anio:{
				required: 'Seleccione un año',
			},
			mes: {
				required: 'Seleccione un mes',
			},
					
		}		
	});



	   



	$.validator.addMethod("alfanumerico", function(value, element) {
        return this.optional(element) || /^[a-z0-9\s]+$/i.test(value);
    }, "Ingrese solo letras");

    $.validator.addMethod("rfc", function(value, element) {
        return this.optional(element) || /^[a-z0-9]+$/i.test(value);
    }, "Ingrese un rfc válido");

    $.validator.addMethod("curp", function(value, element) {
        return this.optional(element) || /^[a-z0-9]+$/i.test(value);
    }, "Ingrese un rfc válido");

});// cerrar














