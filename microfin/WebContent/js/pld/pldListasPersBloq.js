var esTab = false;
var habilitaBotonesCurpRfc = 'N';
var varTipoPersona  = 'F';
var catTipoPersona = {  
  	'fisica'		:'F',
  	'moral'	  		:'M'
};
$(document).ready(function() {
	//Definicion de Constantes y Enums  
	var catTipoTranListasPersBloq = {  
  		'alta'			:'1',
  		'modificacion'	:'2'	  		
  	};
	
	var parametrosBean =  consultaParametrosSession();
	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	
	 deshabilitaBoton('guardar', 'submit'); 
	 deshabilitaBoton('modificar', 'submit');
	 agregaFormatoControles('formaGenerica');
	muestraDatosTipoPersona(catTipoPersona.fisica);

	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#personaBloqID').focus();

	$.validator.setDefaults({
        submitHandler: function(event) { 
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','personaBloqID', 'exito', 'fallo');
        }
    });
			      	     	        
    $('#guardar').click(function() {
		$('#tipoTransaccion').val(catTipoTranListasPersBloq.alta);
	});
        	
  	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTranListasPersBloq.modificacion);  								
	});
  	
  	$('#personaBloqID').blur(function() {
		consultaListaPB(this.id);
	});
  	
  	$('#personaBloqID').bind('keyup',function(e) {  		  
		lista('personaBloqID', '2', '1', 'primerNombre',$('#personaBloqID').val(),'listaPersBLista.htm');
	});
  	$('#paisID').bind('keyup',function(e) { 
		lista('paisID', '1', '1', 'nombre', $('#paisID').val(),'listaPaises.htm');
	});

	$('#paisID').blur(function() {
		consultaPais(this.id);
	});
	
  	$('#estadoID').bind('keyup',function(e) {  		  
		lista('estadoID', '2', '1', 'nombre',$('#estadoID').val(),'listaEstados.htm');
	});
	$('#estadoID').blur('keyup',function(e) {  		  
		consultaEstado(this.id);
	});

	$('input[name=tipoPersona]').change(function() {
    	muestraDatosTipoPersona(this.value);
    });

	$('#fechaNacimiento').change(function(){
		if($('#fechaNacimiento').val() > parametrosBean.fechaAplicacion){
			mensajeSis('La Fecha de Nacimiento no Puede ser Mayor a la Fecha del Sistema');
			$('#fechaNacimiento').val(parametrosBean.fechaAplicacion);
		}
	});

	$('#generar').click(function() {
		if ($('#fechaNacimiento').val()!=''){
			formaRFC();
			$('#RFC').focus();
			$('#RFC').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
			$('#fechaNacimiento').focus();
		}
	});
  	//------------ Validaciones de la Forma -------------------------------------		
	$('#formaGenerica').validate({					
		rules: {				
			personaBloqID: {
				required: true,
			},		
			primerNombre: {
				required: function (){
					return $('#primerNombre').is(':visible');
				}
			},
			razonSocial: {
				required: function (){
					return $('#razonSocial').is(':visible');
				}
			},
			fechaNacimiento: {
				date:true
			},	
			paisID: {
				required: true,			
			},
			estatus: {
				required: true
			},
			tipoLista: {
				required: true
			}
		},		
		messages: {
			personaBloqID: {
				required: 'Especifique.',
			},	
			primerNombre: {
				required: 'Especifique el Primer Nombre.',
			},
			razonSocial: {
				required: 'Especifique la Razón Social.',
			},			
			fechaNacimiento: {
				date: 'Fecha Incorrecta',			
			},
			paisID: {
				required: 'Especifique el País',			
			},
			estatus: {
				required: 'El Estatus es Requerido'
			},
			tipoLista: {
				required: 'El Tipo de Lista es Requerido'
			}
			
			
		}
	});
	// --------------------metodos------------------------ 
	function consultaListaPB(idControl) {
		var jqLista  = eval("'#" + idControl + "'");
		var valorListaPB = $(jqLista).val();
	
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoCon = 1;
		var parametrosListaPB = {
				'personaBloqID'	:valorListaPB
		};
		if (valorListaPB != '' && !isNaN(valorListaPB) && esTab) {
			if (valorListaPB == '0') {
				limpiaFormaCompleta('formaGenerica', true, [ 'personaBloqID', 'persFisica', 'persMoral' ]);
				muestraDatosTipoPersona(catTipoPersona.fisica);
				deshabilitaBoton('modificar', 'submit');
				habilitaBoton('guardar', 'submit');
			} else {
				pldListasPersBloqServicio.consulta(tipoCon,parametrosListaPB,function(data) {
					if (data != null) {						
						dwr.util.setValues(data);
						muestraDatosTipoPersona(data.tipoPersona);
						consultaPais('paisID');
						consultaEstado('estadoID');
						consultaTipoLista('tipoLista');
						habilitaBoton('modificar','submit');
						deshabilitaBoton('guardar','submit');	
						
					} else {
						mensajeSis("La Persona no Existe en la Lista de Personas Bloqueadas.");
						limpiaFormaCompleta('formaGenerica', true, ['persFisica', 'persMoral' ]);
						deshabilitaBoton('modificar','submit');			
						deshabilitaBoton('guardar','submit');		
						$('#personaBloqID').focus();
						$('#personaBloqID').select();
					}
				});
			}
		}
	}
	
	function consultaPais(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais,function(pais) {
				if (pais != null) {	
					$('#estadoID').attr('readonly',false);
					$('#nombrePais').val(pais.nombre);				
					if (pais.paisID != 700) {
						$('#estadoID').hide(0);
						$('#lblEstado').hide();
						$('#nombreEstado').hide();
						$('#nombreEstado').val("");
						$('#estadoID').val("");
						
					}else if(pais.paisID == 700){
						$('#estadoID').show(0);
						$('#lblEstado').show();
						$('#nombreEstado').show();						
					}
				} else {
					mensajeSis("No Existe el País");
				}
			});
		}
	}

	function consultaEstado(idControl) {		
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado)) {
			estadosServicio.consulta(tipConForanea, numEstado,function(estado) {
				if (estado != null) {
					var p = $('#lugarNacimiento').val();
					if (p == 700 && estado.estadoID == 0 && esTab) {
						mensajeSis("No Existe el Estado");
					}
					$('#nombreEstado').val(estado.nombre)
					$('#nombreEstado').val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado");
				}
			});
		}
	}

	function formaRFC() {
		var pn = $('#primerNombre').val();
		var sn = $('#segundoNombre').val();
		var tn = $('#tercerNombre').val();
		var nc = pn + ' ' + sn + ' ' + tn;

		var rfcBean = {
			'primerNombre' : nc,
			'apellidoPaterno' : $('#apellidoPaterno').val(),
			'apellidoMaterno' : $('#apellidoMaterno').val(),
			'fechaNacimiento' : $('#fechaNacimiento').val()
		};
		clienteServicio.formaRFC(rfcBean, function(cliente) {
			if (cliente != null) {
				$('#RFC').val(cliente.RFC);
			}
		});
	}
	
	$('#tipoLista').bind('keyup',function(e) { 
		lista('tipoLista', '1', '1', 'descripcion', $('#tipoLista').val(), 'catTipoListaPLDLista.htm');
	});
	
	$('#tipoLista').blur(function(e) {  		  
		var tipoLista = $('#tipoLista').val().length;
		if (tipoLista > 0) {
			consultaTipoLista(this.id);
		} else {
			$('#tipoListaDes').val("");
		}
	});
}); //cerrar
	
function limpiaPersFisica(){
	$('#primerNombre').val('');
	$('#segundoNombre').val('');
	$('#tercerNombre').val('');
	$('#apellidoPaterno').val('');
	$('#apellidoMaterno').val('');
	$('#fechaNacimiento').val('');
	$('#RFC').val('');
	$('#nombresConocidos').val('');
}

function limpiaPersMoral(){
	$('#razonSocial').val('');
	$('#RFCm').val('');
}
	
// Funcion que setea y oculta campos dependiendo del tipo de persona
function muestraDatosTipoPersona(tipoPersona){
	varTipoPersona = tipoPersona;
	$('input:radio[name="tipoPersona"]').filter('[value='+tipoPersona+']').attr('checked', true).focus();
	if(tipoPersona==catTipoPersona.fisica){
		$('tr[name=personaFisica]').show();
		$('tr[name=personaMoral]').hide();
		limpiaPersMoral();
	} else if(tipoPersona==catTipoPersona.moral){
		$('tr[name=personaFisica]').hide();
		$('tr[name=personaMoral]').show();
		limpiaPersFisica();
	}
}

function exito(){
	muestraDatosTipoPersona(varTipoPersona);
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('guardar', 'submit');
	limpiaFormaCompleta('formaGenerica', true, [ 'personaBloqID', 'persFisica', 'persMoral' ]);
}

function fallo(){
	
}
function consultaTipoLista(idControl){
	var jqLista= eval("'#" + idControl + "'");
	var tipoLista = $(jqLista).val();
	var principal = 1;
	var catTipoListaPLDBean = {
		'tipoListaID' : tipoLista
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (tipoLista != '') {
		catTipoListaPLDServicio.consulta(principal, catTipoListaPLDBean, function(bean) {
			if (bean != null) {
				$('#tipoListaDes').val(bean.descripcion);
			} else {
				$('#tipoLista').val('');
				$('#tipoListaDes').val('');
			}
		});
	} else {
		$('#tipoLista').val('');
		$('#tipoListaDes').val('');
	}
}