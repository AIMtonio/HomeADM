var contFilas = 0;
var catTipoConsultaInstituciones = {
		'principal':1, 
		'foranea':2
};
var catTipoConsultaCtaNostro = {
		'resumen' : 4
};
var con_Enum_TipoTransaccion = {
		'asignar' :  1		
};
var Cons_Enum_Estatus = {
		'Activo':	'A',
		'Inactivo': 'I',
		'ConChequera':'S',
		'SinChequera':'N'
};
var Cons_Enum_ConsultaChequeras = {
		'porSucursal':	7,
		'existenciaFolio':3
};
var Cons_Enum_Listas = {
		'listaPrincipal' :1,
		'listaCtasChequera':5,
		'listaPorSucursal':6
};

var idtipoChequera = document.getElementById("tipoChequera");
var valorChequera = '';
var params = {};

$(document).ready(function(){
	esTab = false;
	inicializaForma('formaGenerica');
	agregaFormatoControles('formaGenerica');
	$('#institucionID').focus();
	$('#tipoChequera').val('');
	$('#tipoChequera').val("").selected = true;
	$("#tipoChequera option[value='E']").hide();
	$("#tipoChequera option[value='P']").hide();
	$('#institucionID').focus();
	deshabilitaBoton('asigna', 'submit');	
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$.validator.setDefaults({
        submitHandler: function(event) {
        	if(creaListaChequeras())
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'numCtaInstit',
        											'exitoAsignarCheque','falloAsignarCheque');		   
        }
    });
	$('#formaGenerica').validate({
  		rules: {
  			institucionID: {
  				required: 	true
  			},
  			numCtaInstit: {
  				required:	true
  			},
  			tipoChequera:{
  				required: true
  			},
  		},  		
  		messages: {
  			institucionID: {
  				required: 	'La Institución es requerida.',
  				number: 	'Sólo Números.'
  			},			
  			numCtaInstit: {
  				required: 	'El Número de Cuenta Institucional es requerida.',
  				number	:	'Sólo Números.'
  			},
  			tipoChequera:{
  				required: 'El campo es requerido'
  			}
  		}		
  	});	
	
	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '1', Cons_Enum_Listas.listaPrincipal, 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});	
	$('#institucionID').blur(function() {		
		 if($('#institucionID').val()!="" && esTab){
		   	consultaInstitucion(this.id);		   	
		 }
	});
	
	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numCtaInstit";
		camposLista[1] = "institucionID";
		parametrosLista[0] = $('#numCtaInstit').val();
		parametrosLista[1] = $('#institucionID').val();
		listaAlfanumerica('numCtaInstit', '2', Cons_Enum_Listas.listaCtasChequera,camposLista,parametrosLista, 'ctaNostroLista.htm');	       
	});
	

   	$('#numCtaInstit').change(function(){
   			validaCtaNostroExiste('numCtaInstit','institucionID');   		
   	});
   	
   	$('#numCtaInstit').blur(function(){
   		if(esTab){
			validaCtaNostroExiste('numCtaInstit','institucionID');   			
   		}		
	});
	
   	$('#asigna').click(function(){
   		 $('#tipoTransaccion').val(con_Enum_TipoTransaccion.asignar);   		 
   	});
   	
	$('#tipoChequera').change(function () {
 			mostrarGrid(params);	 
	});

	//Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		$("#tipoChequera option[value='E']").hide();
		$("#tipoChequera option[value='P']").hide();
		$('#tipoChequera').val("");
		$('#gridCajasSucursal').html("");
		$('#gridCajasSucursal').hide(500);							
		deshabilitaBoton('asigna', 'submit');


		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
				if(instituto!=null){
					inicializaForma('formaGenerica','institucionID');
					$('#nombreInstitucion').val(instituto.nombre);					
				}else{
					mensajeSis("No existe la Institución"); 
					$('#institucionID').val('');
					$('#institucionID').focus();
					$('#nombreInstitucion').val("");
					inicializaForma('formaGenerica','institucionID');
				}    						
			});
		}else{
			$('#institucionID').val('');
			$('#nombreInstitucion').val('');					
		}
	}	
	// Funcion que valida la existencia de una cuenta nostro y que cuente con chequera
	// para llenar el grid
	function validaCtaNostroExiste(numCta,institID){
  		var jqNumCtaInstit = eval("'#" + numCta + "'");
  		var jqInstitucionID = eval("'#" + institID + "'");
  		var numCtaInstit = $(jqNumCtaInstit).val();
  		var institucionID = $(jqInstitucionID).val();
		$("#tipoChequera option[value='E']").hide();
		$("#tipoChequera option[value='P']").hide();
		$('#tipoChequera').val("");
		$('#gridCajasSucursal').html("");
		$('#gridCajasSucursal').hide(500);							
		deshabilitaBoton('asigna', 'submit');
		
	    setTimeout("$('#cajaLista').hide();", 200);
  		var CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit
  		};

		if(numCtaInstit != '' && !isNaN(numCtaInstit) && numCtaInstit>0){
  			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, { async: false, callback:function(ctaNostro){  				  			
  				if(ctaNostro!=null){   								
					if(ctaNostro.estatus ==Cons_Enum_Estatus.Activo){
						// consultar lista chequeras por sucursal
						if(ctaNostro.chequera==Cons_Enum_Estatus.ConChequera){
							if(ctaNostro.tipoChequera == 'A'){
								$("#tipoChequera option[value='E']").show();
								$("#tipoChequera option[value='P']").show();			

							}else if(ctaNostro.tipoChequera == 'E'){
								$("#tipoChequera option[value='P']").hide();
								$("#tipoChequera option[value='E']").show();
							}else if(ctaNostro.tipoChequera == 'P'){
								$("#tipoChequera option[value='E']").hide();
								$("#tipoChequera option[value='P']").show();
							}else if(ctaNostro.tipoChequera == ''){
								mensajeSis("La Chequera no cuenta con Tipo de Chequera.");
							}

 							valorChequera = $("#tipoChequera option:selected").val();
							params['tipoLista'] = Cons_Enum_ConsultaChequeras.porSucursal;
							params['institucionID'] = institucionID;
							params['numCtaInstit']  = numCtaInstit;
							params['tipoChequera']  = valorChequera;

						} else if(ctaNostro.chequera==Cons_Enum_Estatus.SinChequera){
							mensajeSis("El Número de Cuenta Bancaria No cuenta con Chequera.");
							deshabilitaBoton('asigna', 'submit');
							$('#gridCajasSucursal').hide(500);
							$('#numCtaInstit').focus();
						}
						
	  				} else if(ctaNostro.estatus ==Cons_Enum_Estatus.Inactivo){
						mensajeSis("El Número de Cuenta Bancaria está Inactiva.");
						deshabilitaBoton('asigna', 'submit');
						$('#gridCajasSucursal').hide(500);
						$('#numCtaInstit').focus();
	  				}
  				}
  				else{
  					mensajeSis("El Número de Cuenta Bancaria no Existe");
  					$('#numCtaInstit').val('');
  					$('#numCtaInstit').focus();
  					$('#gridCajasSucursal').hide(500);
  					deshabilitaBoton('asigna', 'submit');					
  				} 
  			}});
  		}else{
  			$('#numCtaInstit').val('');
  		}
  	}
	
	// Funcion que muestra el grid con los datos
	function mostrarGrid(params){	
		$('#gridCajasSucursal').html("");	
		$('#gridCajasSucursal').hide(500);
		deshabilitaBoton('asigna','submit');
		if($("#tipoChequera option:selected").val() != ''){
			params['tipoChequera']  = $("#tipoChequera option:selected").val();
			
			$.post("asignarChequeSucurGrid.htm", params,function(data){
				if (data.length > 0){
					$('#gridCajasSucursal').html(data);
					$('#gridCajasSucursal').show(500);

		 			$('#agregaDetalle').focus();
					habilitaBoton('asigna','submit');	
				}
			});			
		}
	}
});

// funcion que lista sucursales
function listaSucursales(idControl){
	var jq = eval("'#" + idControl + "'");
	
	$(jq).bind('keyup',function(e){
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();

		lista(idControl,'2',Cons_Enum_Listas.listaPrincipal,'nombreSucurs',num,'listaSucursales.htm');
	});
}

// Funcion que lista las cajas por sucursal
function listarCajas(idControl,idControlSuc){
	var jqCaja = eval("'#" + idControl + "'");
	var numCaja = $(jqCaja).val();
	var jqSucursal = eval("'#" + idControlSuc + "'");
	var numSuc = $(jqSucursal).val();
	
	$(jqCaja).bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "cajaID";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = numCaja;
		parametrosLista[1] = numSuc;
		lista(idControl, '1', Cons_Enum_Listas.listaPorSucursal, camposLista, parametrosLista, 'listaCajaVentanilla.htm');
	});

}

// Funcion que consulta el nombre de la sucursal usado
// en el Grid
function consultaSucursalTR(idControl,idControlDesc){
	var jqSucursal = eval("'#" + idControl + "'");
	var jqDescSuc = eval("'#" + idControlDesc + "'");
	var numSucursal = $(jqSucursal).val();	
	var conSucursal=2;
	setTimeout("$('#cajaLista').hide();", 200);		 
	if(numSucursal != '' && !isNaN(numSucursal) && esTab==true){
		sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
			if(sucursal!=null){
				$(jqDescSuc).val(sucursal.nombreSucurs);
			}else{
				mensajeSis("No Existe la Sucursal.");
				$(jqSucursal).val("");
				$(jqSucursal).focus();
				$(jqDescSuc).val("");
			}
		});
	}else{
		$(jqDescSuc).val('');
		$(jqSucursal).val('');
	}
}

// Funcion que consulta y valida que la caja
// pertenezca a una sucursal
function consultaCaja(idControl,idControlDesc,idControlSuc){
	var jqCaja = eval("'#" + idControl + "'");
	var jqDescCaja = eval("'#" + idControlDesc + "'");
	var jqSucursal = eval("'#" + idControlSuc + "'");
	var numCaja = $(jqCaja).asNumber();	
	var numSuc = $(jqSucursal).asNumber();	
	var consultaCajasTransfer = 1;
	var CajasBeanCon = {
		'cajaID': numCaja,
		'sucursalID' : numSuc
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numSuc > 0 && esTab==true){
		if(numCaja > 0){
			cajasVentanillaServicio.consulta(consultaCajasTransfer, CajasBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla!=null){
					if(cajasVentanilla.sucursalID==numSuc){
						$(jqDescCaja).val(cajasVentanilla.descripcionCaja);
					} else {
						mensajeSis("La Caja No Pertenece a la Sucursal.");
						$(jqCaja).val("");
						$(jqCaja).focus();
						$(jqDescCaja).val("");
					}
				
				}else{
					mensajeSis("No Existe la Caja.");
					$(jqCaja).val("");
					$(jqCaja).focus();
					$(jqDescCaja).val("");
				}
				
			});
		}else{
			$(jqCaja).val('');
			$(jqDescCaja).val('');
		}
	} else {
		$(jqCaja).val('');
		$(jqDescCaja).val('');
	}
}


//valida que la institucion, la cuenta ,la sucusalr y la caja no sean las mismas

function verificaRegistro(idControl,idCampo){ // cajaid,sucursalid

	var numeroControl= idControl.substr(6,idControl.length);
	var contador = 0;
	var nuevaSucursal=$('#'+idCampo).val();
	var nuevaCaja=$('#'+idControl).val();
	var folioInicial = $('#folioCheqInicial'+numeroControl).val();
	var folioFinal = $('#folioCheqFinal'+numeroControl).val();
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdSucursal = eval("'sucursalID" + numero+ "'");		
		var jqNuevaCaj = eval("'cajaID" + numero+ "'");	
		var jqfolioCheqInicial = eval("'folioCheqInicial" + numero+ "'");	
		var jqfolioCheqFinal = eval("'folioCheqFinal" + numero+ "'");
		var valorSucursal = $('#'+jqIdSucursal).val();
		var valorCaja = $('#'+jqNuevaCaj).val();
		var valorFolioCheqInicial = $('#'+jqfolioCheqInicial).val();
		var valorFolioCheqFinal = $('#'+jqfolioCheqFinal).val();
		
		if(jqIdSucursal != idCampo){//valida que no sea el mismo renglon a comparar
		
			if((valorSucursal == nuevaSucursal) && (valorCaja==nuevaCaja)){
				if(folioInicial >= valorFolioCheqInicial && folioInicial <= valorFolioCheqFinal){
					mensajeSis("El Folio Inicial ya existe en un Rango de Folios");
					$('#'+jqfolioCheqInicial).focus();
					$('#'+jqfolioCheqInicial).val("");
					$('#'+jqfolioCheqFinal).val("");
					contador = contador+1;			
					return false;
				}else if (folioFinal >= valorFolioCheqInicial && folioFinal <= valorFolioCheqFinal){
					mensajeSis("El Folio Final ya existe en un Rango de Folios");
					$('#'+jqfolioCheqFinal).focus();
					$('#'+jqfolioCheqFinal).val("");
					contador = contador+1;	
					return false;
				}
			}
		}
	});
	return contador;
}


// Funcion que regresa el num de renglones del grid
function getRenglones() {
	var numCols = $('#miTabla >tbody >tr[name="renglon"]').length;
	return numCols;
} 

// Funcion que asigna el numero consecutivo 
// para cuando se agregan nuevos renglones al grid
function asignaConsecutivos(){
	var numeroConsecutivo = 1;
  	$('input[name=consecutivoID]').each(function() {
		jqCargos = eval("'#" + this.id + "'");
		$(jqCargos).val(numeroConsecutivo);
		numeroConsecutivo++;
	});
}

// Funcion que valida los campos vacios del grid
function verificarvacios(){
	var esValido = true;
	var mensaje = "";
	var error = false;
	quitaFormatoControles('gridCajasSucursal');

	$("#miTabla tr[name=renglon]:visible").each(function (index){
		if(index>=0 && error==false){
			var idsucursal	=$(this).find("input[name=sucursalID]").val();
			var idcaja		=$(this).find("input[name=cajaID]").val();
			var folioinicial=$(this).find("input[name=folioCheqInicial]").asNumber();
			var foliofinal	=$(this).find("input[name=folioCheqFinal]").asNumber();

			if (idsucursal.trim() == '' || idsucursal < 0 || isNaN(idsucursal)) {
				$(this).find("input[name=sucursalID]").addClass("error");
				$(this).find("input[name=sucursalID]").focus();
				if (mensaje == "")
					mensaje = "Especifique una Sucursal.";
				esValido = false;
				error = true;
			} else if (idcaja.trim() == '' || idcaja < 0 || idcaja.length <= 0 || isNaN(idcaja)) {
				$(this).find("input[name=cajaID]").addClass("error");
				$(this).find("input[name=cajaID]").focus();
				if (mensaje == "")
					mensaje = "Especifique una Caja.";
				esValido = false;
				error = true;
			} else if (folioinicial <= 0) {
				$(this).find("input[name=folioCheqInicial]").addClass("error");
				$(this).find("input[name=folioCheqInicial]").focus();
				if (mensaje == "")
					mensaje = "Especifique Folio Inicial.";
				esValido = false;
				error = true;
			} else if (foliofinal <= 0) {
				$(this).find("input[name=folioCheqFinal]").addClass("error");
				$(this).find("input[name=folioCheqFinal]").focus();
				if (mensaje == "")
					mensaje = "Especifique Folio Final.";
				esValido = false;
				error = true;
			} else if (folioinicial>foliofinal){
				$(this).find("input[name=folioCheqInicial]").addClass("error");
				$(this).find("input[name=folioCheqInicial]").focus();
				if (mensaje == "")
					mensaje = "El Folio Inicial debe ser Menor que el Folio Final.";
				esValido = false;
				error = true;
			}
		}

	});
	agregaFormatoControles('gridCajasSucursal');
	if(mensaje!="")
		mensajeSis(mensaje);
	return esValido;
}

// Funcion de Exito
function exitoAsignarCheque(){
		deshabilitaBoton('asigna','submit');		
		$('#gridCajasSucursal').hide(500);	
		$('#gridCajasSucursal').val("");
		$('#listaCajas').val();
		$('#valorListaCajas').val();
		$('#nombreSucursal').val('');
		$('#tipoChequera').val('');
		$('#tipoChequera').val("").selected = true;
		$("#tipoChequera option[value='E']").hide();
		$("#tipoChequera option[value='P']").hide();
}

// Funcion de Fallo
function falloAsignarCheque(){
		$('#listaCajas').val();
		$('#valorListaCajas').val();
}

// Funcion que permite agregar un nuevo renglon al grid
function agregaNuevoDetalle(){

	contFilas = parseInt(getRenglones()) + 1;
  	var tds = '<tr id="renglon' + contFilas + '" name="renglon">';
 	 	  
	tds += '<td style="display:none;"><input type="text"  id="consecutivoID'+contFilas+'" name="consecutivoID" size="4" value="+contFilas+" autocomplete="off" readonly="true" disabled="true"/></td>';
	tds += '<td><input type="text"  id="sucursalID'+contFilas+'" name="sucursalID" size="4" value="" autocomplete="off" onkeypress="listaSucursales(\'sucursalID'+contFilas+'\');"onblur="consultaSucursalTR(this.id,\'nombreSucursal'+contFilas+'\');" /></td>';
	tds += '<td><input type="text"  id="nombreSucursal'+contFilas+'" name="nombreSucursal" size="30" value="" autocomplete="off" maxlength="10" readOnly="true" disabled="true"/></td>';
	tds += '<td><input type="text"  id="cajaID'+contFilas+'" name="cajaID" size="4" value="" onkeypress="listarCajas(this.id,\'sucursalID'+contFilas+'\');"   onblur="consultaCaja(this.id,\'descripcionCaja'+contFilas+'\',\'sucursalID'+contFilas+'\');"  maxlength="50"/></td>';	
	tds += '<td><input type="text"  id="descripcionCaja'+contFilas+'" name="descripcionCaja" size="25" value="" autocomplete="off" maxlength="20" readOnly="true" disabled="true"/></td>';
	tds += '<td><input type="text"  id="folioCheqInicial'+contFilas+'" name="folioCheqInicial" size="12" value="" autocomplete="off" maxlength="20" onblur="asignaFolioInicial(this);validaFolioIni(this.id)"/></td>';
	tds += '<td><input type="text"  id="folioCheqFinal'+contFilas+'" name="folioCheqFinal" size="12" value="" autocomplete="off" maxlength="20" onblur="cambiaFolioFinal(this);validaFolioFin(this.id)"/></td>';
	tds += '<td><input type="hidden"  id="estatus'+contFilas+'" name="estatus" size="12" value="A" autocomplete="off" maxlength="20" />';
	tds += '<input type="hidden"  id="folioUtilizar'+contFilas+'" name="folioUtilizar" size="12" value="0" autocomplete="off" maxlength="20" /></td>';
		 
	tds += '<td><input type="button" name="elimina" id="'+contFilas +'" value="" class="btnElimina" onclick="eliminaDetalle(this.id)"/></td>';
	tds += '<td><input type="button" name="agrega" id="agrega'+contFilas +'" value="" class="btnAgrega" onclick="agregaNuevoDetalle()"/></td>';
	tds += '</tr>';
	
	document.getElementById("numeroDetalle").value = contFilas;    	
	$("#miTabla").append(tds);	

	$("#sucursalID"+contFilas).focus();
	return false;		
}	

// Funcion que "elimina" un renglon del grid
function eliminaDetalle(trId){
	//$("#renglon" + trId).hide();
	$("#estatus" + trId).val('D');
	
	var contador = 0 ;
	var numeroID = trId;
	
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqNumero = eval("'#consecutivoID" + numeroID + "'");
	var jqTipoProveedorID = eval("'#sucursalID" + numeroID + "'");		
	var jqImpuestoID = eval("'#cajaID" + numeroID + "'");
	var jqDescripCorta=eval("'#folioCheqInicial" + numeroID + "'");
	var jqTasa = eval("'#folioCheqFinal" + numeroID + "'");
	var jqOrden=eval("'#estatus" + numeroID + "'");
	var jqAgrega=eval("'#agrega" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");
	
	
	// se elimina la fila seleccionada
	$(jqNumero).remove();
	$(jqTipoProveedorID).remove();
	$(jqImpuestoID).remove();
	$(jqElimina).remove();
	$(jqDescripCorta).remove();
	$(jqTasa).remove();
	$(jqOrden).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {		
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 = eval("'#renglon"+numero+"'");
		var jqNumero1 = eval("'#consecutivoID"+numero+"'");
		var jqTipoProveedorID1 = eval("'#sucursalID"+numero+"'");	
		var jqNombreSucursal = eval("'#nombreSucursal"+numero+"'");		
		var jqImpuestoID1= eval("'#cajaID"+numero+"'");
		var jqDescripcionCaja= eval("'#descripcionCaja"+numero+"'");
		var jqDescripCorta1=eval("'#folioCheqInicial"+ numero+"'");
		var jqTasa1=eval("'#folioCheqFinal"+ numero+"'");
		var jqOrden1=eval("'#estatus"+ numero+"'");
		var jqFolioUtilizar1=eval("'#folioUtilizar"+ numero+"'");
		var jqAgrega1=eval("'#agrega"+ numero+"'");
		var jqElimina1 = eval("'#"+numero+ "'");
	
		$(jqNumero1).attr('id','consecutivoID'+contador);
		$(jqTipoProveedorID1).attr('id','sucursalID'+contador);
		$(jqNombreSucursal).attr('id','nombreSucursal'+contador);
		$(jqImpuestoID1).attr('id','cajaID'+contador);
		$(jqDescripcionCaja).attr('id','descripcionCaja'+contador);
		$(jqDescripCorta1).attr('id','folioCheqInicial'+contador);
		$(jqTasa1).attr('id','folioCheqFinal'+contador);
		$(jqOrden1).attr('id','estatus'+contador);
		$(jqFolioUtilizar1).attr('id','folioUtilizar'+contador);
		$(jqAgrega1).attr('id','agrega'+contador);
		$(jqElimina1).attr('id',contador);
		$(jqRenglon1).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);	
		
	});
}

//Funcion de validacion para el Folio
function validaFolioIni(idControl){ //id campo folio inicial
	var numeroControl= idControl.substr(16,idControl.length);

	var folioInicial = $('#folioCheqInicial'+numeroControl).asNumber();
	var folioFinal = $('#folioCheqFinal'+numeroControl).asNumber();
	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqfolioCheqInicial = eval("'folioCheqInicial" + numero+ "'");	
		var jqfolioCheqFinal = eval("'folioCheqFinal" + numero+ "'");
		var valorFolioCheqInicial = $('#'+jqfolioCheqInicial).asNumber();
		var valorFolioCheqFinal = $('#'+jqfolioCheqFinal).asNumber();
		
		if(numeroControl != numero){//valida que no sea el mismo renglon a comparar
		
			if(folioInicial >= valorFolioCheqInicial && folioInicial <= valorFolioCheqFinal && valorFolioCheqInicial > 0 && valorFolioCheqFinal > 0 ){
				$('#'+idControl).focus();
				$('#'+idControl).val("");
				mensajeSis("El Folio Inicial ya existe en un Rango de Folios");
				return false;
			}			
		}
	});
	
	if(folioFinal > 0){
		if(folioInicial >= folioFinal && $('#folioCheqInicial'+numeroControl).val() != ''){
			mensajeSis("El Folio Inicial debe ser Menor al Folio Final");
		}
	}
}

//Funcion de validacion para el Folio
function validaFolioFin(idControl){ //id campo folio inicial
	var numeroControl= idControl.substr(14,idControl.length);

	var folioInicial = $('#folioCheqInicial'+numeroControl).asNumber();
	var folioFinal = $('#folioCheqFinal'+numeroControl).asNumber();
	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqfolioCheqInicial = eval("'folioCheqInicial" + numero+ "'");	
		var jqfolioCheqFinal = eval("'folioCheqFinal" + numero+ "'");
		var valorFolioCheqInicial = $('#'+jqfolioCheqInicial).asNumber();
		var valorFolioCheqFinal = $('#'+jqfolioCheqFinal).asNumber();
		
		if(numeroControl != numero){//valida que no sea el mismo renglon a comparar
		
			if(folioFinal >= valorFolioCheqInicial && folioFinal <= valorFolioCheqFinal && valorFolioCheqInicial > 0 && valorFolioCheqFinal > 0 ){
				$('#'+idControl).focus();
				$('#'+idControl).val("");
				mensajeSis("El Folio Final ya existe en un Rango de Folios");
				return false;
			}			
		}
	});
	
	if(folioInicial > 0){
		if(folioFinal <= folioInicial && $('#folioCheqFinal'+numeroControl).val() != ''){
			mensajeSis("El Folio Final debe ser Mayor al Folio Inicial");
		}
	}
}

//Funcion de validacion para el Folio Inicial
function validaFolioInicial(idControl){
	setTimeout("$('#cajaLista').hide();", 200);	
	var numeroID = parseInt(idControl.replace("folioCheqInicial",""));
	var jqFolioInicial = eval("'#" + idControl + "'");
	var jqinstitucionID = eval("'#institucionID'");
	var jqnumCtaInstit = eval("'#numCtaInstit'");
	var jqSucursal = eval("'#sucursalID" + numeroID + "'");
	var jqCaja = eval("'#cajaID" + numeroID + "'");
	var jqTipoChequera = eval("'#tipoChequera'");
	var numFolio = $(jqFolioInicial).val();
	var numInsit = $(jqinstitucionID).val();
	var numCtaInst = $(jqnumCtaInstit).val();
	var numSucursal = $(jqSucursal).val();
	var numCaja = $(jqCaja).val();
	var tipoChequera = $(jqTipoChequera).val();
	var SiExisteFolio='S';
	var asignarBeanCon = {
			'folioCheqInicial':numFolio,
			'institucionID':numInsit,
			'numCtaInstit':numCtaInst,
			'sucursalID':numSucursal,
			'cajaID':numCaja,
			'tipoChequera':tipoChequera
	};
	if(numFolio != '' && !isNaN(numFolio)){
		asignarChequeSucurServicio.consulta(Cons_Enum_ConsultaChequeras.existenciaFolio,asignarBeanCon,function(asignarCheques){//3
			if(asignarCheques!=null){				
				if(asignarCheques.existeFolio==SiExisteFolio){
					mensajeSis("El Folio Inicial ya está asignado a otra Chequera."); 
					$(jqFolioInicial).focus();
				}
			}
		});
	}
}

//Funcion de validacion para el Folio Final
function validaFolioFinal(idControl){
	setTimeout("$('#cajaLista').hide();", 200);	
	var numeroID = parseInt(idControl.replace("folioCheqFinal",""));
	var jqFolioFinal = eval("'#" + idControl + "'");
	var jqinstitucionID = eval("'#institucionID'");
	var jqnumCtaInstit = eval("'#numCtaInstit'");
	var jqSucursal = eval("'#sucursalID" + numeroID + "'");
	var jqCaja = eval("'#cajaID" + numeroID + "'");
	var jqTipoChequera = eval("'#tipoChequera" + numeroID + "'");
	var numFolio = $(jqFolioFinal).val();
	var numInsit = $(jqinstitucionID).val();
	var numCtaInst = $(jqnumCtaInstit).val();
	var numSucursal = $(jqSucursal).val();
	var numCaja = $(jqCaja).val();
	var tipoChequera = $(jqTipoChequera).val();
	var SiExisteFolio='S';
	var asignarBeanCon = {
			'folioCheqInicial':numFolio,
			'institucionID':numInsit,
			'numCtaInstit':numCtaInst,
			'sucursalID':numSucursal,
			'cajaID':numCaja,
			'tipoChequera':tipoChequera
	};
	if(numFolio != '' && !isNaN(numFolio)){
		asignarChequeSucurServicio.consulta(Cons_Enum_ConsultaChequeras.existenciaFolio,asignarBeanCon,function(asignarCheques){
			if(asignarCheques!=null){
				if(asignarCheques.existeFolio==SiExisteFolio){
					mensajeSis("El Folio Final ya está asignado a otra Chequera."); 
					$(jqFolioFinal).focus();
				}
			}
		});
	}
}

//Funcion que asigna un valor consecutivo al Folio Inicial
// dependiendo del renglon anterior
function asignaFolioInicial(control){
	var numeroID = control.id;
	var actualID = parseInt(numeroID.replace("folioCheqInicial",""));
	if(actualID!=1){
		var jqFolioActual = eval("'#" + control.id + "'");
		if($(jqFolioActual).val() == ''){
			var anteriorID = (parseInt(numeroID.replace("folioCheqInicial",""))-1);
			
			var jqFolioInicialAnt = eval("'#folioCheqFinal" + String(anteriorID) + "'");
			var folioAnterior = $(jqFolioInicialAnt).asNumber();
			var folioSig = (parseInt(folioAnterior)+1);
			if(folioAnterior>0){
				$(jqFolioActual).val(folioSig);
			}			
		}
	}	
}

//Funcion que asigna un valor consecutivo al Folio Final
//dependiendo del renglon anterior
function cambiaFolioFinal(control){
	var numeroID = control.id;		
	var siguienteID = (parseInt(numeroID.replace("folioCheqFinal",""))+1);
	var actualID = parseInt(numeroID.replace("folioCheqFinal",""));

	var jqFolioInicialSig = eval("'#folioCheqInicial" + String(siguienteID) + "'");
	var jqFolioFinalSig = eval("'#folioCheqFinal" + String(siguienteID) + "'");
	var jqFolioInicialActual = eval("'#folioCheqInicial" + String(actualID) + "'");
	
	//Valida el Folio Final no sea menor o igual al Inicial
	if (parseInt(control.value) <= parseInt($(jqFolioInicialActual).val()) ){
		mensajeSis("El Folio Final debe ser Mayor al Folio Inicial.");			
		control.select();	
		control.focus();
		return false;
	}

	if($(jqFolioInicialSig).val()!= undefined||parseInt($(jqFolioInicialActual).val())!=0) {
		if($(jqFolioFinalSig).asNumber() > 0){
			if(control.value >= $(jqFolioFinalSig).val()){
				mensajeSis("El Folio Final no puede ser mayor o igual al Folio Final Siguiente");
			}
		}else{
			$(jqFolioInicialSig).val(parseInt(control.value)+1);
		}
		
	}
}

function creaListaChequeras(){	
	var mandar = verificarvacios();
	if(mandar!=false){
		quitaFormatoControles('gridCajasSucursal');
		$('#listaCajas').val("");
		$("#miTabla tr[name=renglon]").each(function(index) {
			
			if (index >= 0) {
				var institucionID = $('#institucionID').val();
				var numCtaInstit = $('#numCtaInstit').val();
				var tipoChequera = $('#tipoChequera').val();
				var sucursalID = $(this).find("input[name=sucursalID]").val();
				var cajaID = $(this).find("input[name=cajaID]").val();
				var descripcionCaja = $(this).find("input[name=descripcionCaja]").val();
				var folioCheqInicial = $(this).find("input[name=folioCheqInicial]").val();
				var folioCheqFinal = $(this).find("input[name=folioCheqFinal]").val();
				var estatus = $(this).find("input[name=estatus]").val();
				var folioUtilizar = $(this).find("input[name=folioUtilizar]").val();
				
				if(sucursalID!=''||cajaID!=''||folioCheqInicial!=''||folioCheqFinal!=''){
					if (index == 0) {
						$('#listaCajas').val($('#listaCajas').val() 
								+ institucionID + ']' 
								+ numCtaInstit + ']' 
								+ sucursalID + ']'
								+ cajaID + ']'
								+ descripcionCaja + ']'
								+ folioCheqInicial + ']'
								+ folioCheqFinal + ']'
								+ estatus + ']'
								+ tipoChequera + ']'
								+ folioUtilizar + ']');
					} else {
						$('#listaCajas').val($('#listaCajas').val() + '[' 
								+ institucionID + ']' 
								+ numCtaInstit + ']' 
								+ sucursalID + ']'
								+ cajaID + ']'
								+ descripcionCaja + ']'
								+ folioCheqInicial + ']'
								+ folioCheqFinal + ']'
								+ estatus + ']'
								+ tipoChequera + ']'
								+ folioUtilizar + ']');
					}
				}
			}
		});
	} else {
		this.isDefaultPrevented = true;
	}
	return mandar; 
}