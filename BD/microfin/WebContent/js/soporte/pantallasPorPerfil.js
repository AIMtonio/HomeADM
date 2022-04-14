$(document).ready(function() { 
	$('#rolID').focus();
	esTab = true;
	//Nueva instalacion a kubo 1.1
	//Definicion de Constantes y Enums  
	var catTipoTransaccionRol = {  
			'agrega':'1',
			'modifica':'2'	};

	var catTipoConsultaRol = { 
			'principal'	: 1,
			'foranea'	: 2
	};	
	$('#descripcion').attr('disabled','true')
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('grabar', 'submit');


	$(':text').focus(function() {	
		esTab = false; 
	});


	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','rolID','recargaRoles','inicioForma');
		}
	});				

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	}); 

	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionRol.agrega);
	
	});



	$('#rolID').bind('keyup',function(e){ 
		lista('rolID', '2', '1', 'nombreRol', $('#rolID').val(), 'listaRoles.htm');
	});

	$('#rolID').blur(function() { 
		limpiaDivs();
		deshabilitaBoton('grabar', 'submit');
		if($('#rolID').val()!=''){
			consultaRol(this.id); 
			
		}

	});

	$('#agregar').click(function() {	 
		agregacheck(); 
	}); 
	$('#eliminar').click(function() {	
		eliminacheck();
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {

			rolID: { 
				required: true
			},


			descripcion: {  
				required: true
			},	
		},
		messages: {


			rolID: {
				required: 'Especificar No.'
			}, 


			descripcion: {
				required: 'Especificar Descripcion',
			}
		}		
	});

	//------------ Validaciones de Controles -------------------------------------


	
	
	function consultaRol(idControl) {
		var jqRol = eval("'#" + idControl + "'");
		var numRol = $(jqRol).val();
		var rolBeanCon = { 
				'rolID':numRol

		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		if(numRol != '' && !isNaN(numRol) ){

			rolesServicio.consultaRoles(catTipoConsultaRol.principal,rolBeanCon,function(rol) {
				if(rol!=null){
					$('#rolID').val(rol.rolID);
					$('#descripcion').val(rol.descripcion);	
					//consultaPantallas();	
					consultaPantallasDerecha();
																	
				}else{

					mensajeSis("No Existe el rol");
					inicializaForma('formaGenerica','rolID' )
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('grabar', 'submit');
					$('#rolID').focus();
					$('#rolID').select();	
					limpiaDivs();

				}
			});

		}

	}

	function consultaPantallas(){	 
		var params = {};
		params['clave'] = $('#clave').val();
		params['ladoLista'] = 'izq';

		$.post("gridPantallas.htm", params, function(data){
			if(data.length >0) {
				$('#gridPantallas').html(data);
				$('#gridPantallas').show(); 

			}else{
				$('#gridPantallas').html("");
				$('#gridPantallas').show();
			}
		});
	}	 

	function consultaPantallasDerecha(){	 
		var params = {};
		params['clave'] = $('#clave').val();
		params['ladoLista'] = 'der';
		$.post("gridPantallas.htm", params, function(data){
			if(data.length >0) {
				$('#gridPantallaSelec').html(data);
				$('#gridPantallaSelec').show(); 
				consultaPantallasRol();

			}else{
				$('#gridPantallaSelec').html("");
				$('#gridPantallaSelec').show();
			}
		});
	}	 


	function consultaPantallasRol(){	 
		var params = {};
		var opcionMenuChkDer;//input checked
		var opMenuID;

		params['rolID'] = $('#rolID').val();
		rolesServicio.listaOpcionesRol(1,params,function(data){
			if(data.length >0) {

				for(var i=0; i<data.length; i++){
					opMenuID	 = data[i].opcionMenuID *1;	
					opcionMenuChkDer = eval("'#derChk" + opMenuID + "'");
					
					$(opcionMenuChkDer).attr('checked','true');
					$(opcionMenuChkDer).val(opMenuID);					
					
				}			
			}
			habilitaBoton('grabar', 'submit');
		});
	}	

	function limpiaDivs(){
		var div2	= '<div id="gridPantallaSelec" style="display: none;"/>';	
		$('#gridPantallaSelec').replaceWith(div2);
	}

 $('#selecTodas').click(function() {	 
		
		$('input[name=menuID]').each(function() {		
			var menuID = eval("'#" + this.id + "'");	
			var numMenuID= $(menuID).val();
			var checked = eval("'#derChk" + numMenuID + "'");
         if( $('#selecTodas').is(":checked") ){
         	$(checked).attr('checked','true');
          	$(checked).val(numMenuID); 
         	}
         	else{
				   $(checked).removeAttr('checked');
          	$(checked).val(0);       		
         		}
		});
		
	}); 

});


function validaOpcion(numero){

	opcionMenuChkDer = eval("'#derChk" + numero + "'");

	if ($(opcionMenuChkDer).is(":checked")) {
		$(opcionMenuChkDer).val(numero);
	}	
	else
	{
		$(opcionMenuChkDer).val(0);
	}

}


// El filtro de acceso a recursos valida esta dirección para recargar los roles.
function recargaRoles(){
	deshabilitaBoton('grabar', 'submit');
	$.post( "activaPantallasRol.htm", function( data ) {
		  //Se Recargan los roles
	});
}

function inicioForma(){
	deshabilitaBoton('grabar', 'submit');
	$('#rolID').focus();
}